import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'shared/shared.dart';
import 'shared/firebase_options.dart';

/// To-Do:
/// 1. Create a new Firebase project --DONE
/// 2. Add a new Android app to the project / Download the google-services.json file and place it in the android/app folder --DONE
/// 3. Create a Scrum/Agile board and connect it to firebase --DONE
/// 4. CRUD - Create: Check, Read: Check, Update, Delete
/// 5. Push Notifications
/// 6. Make new board
/// 7. Save some data to local storate // Maybe and error log
/// 8. Comment code and clean up -- Look into stateless and statefull widgets (Optimization)
/// 9. Explain Security issues in app

//Push Notifications Initialization
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //ignore: avoid_print
  print('Handling a background message ${message.messageId}');
}

void initializeInformation() {
  var androidInitialization =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSInitialization = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: androidInitialization, iOS: iOSInitialization);
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: ((NotificationResponse response) {
      //ignore: avoid_print
      print('Notification Response: ${response.payload}');
    }),
    onDidReceiveBackgroundNotificationResponse: notificationBackround,
  );

  FirebaseMessaging.onMessage.listen((message) async {
    //ignore: avoid_print
    print('Message received: ${message.messageId}');
    if (message.notification != null) {
      //ignore: avoid_print
      print('Message also contained a notification: ${message.notification}');
    }

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'MainChannel_ID',
      'MainChannel_Name',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
      playSound: true,
      enableVibration: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, platformChannelSpecifics,
        payload: message.data.toString());
  });
}

@pragma('vm:entry-point')
void notificationBackround(NotificationResponse response) {
  // ignore: avoid_print
  print('notification(${response.id}) action tapped: '
      '${response.actionId} with'
      ' payload: ${response.payload}');
  if (response.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${response.input}');
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeInformation();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Board Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _token;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    requestPermission();
    fetchToken();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        // ignore: avoid_print
        print("....... User granted permission....");
        break;
      case AuthorizationStatus.provisional:
        // ignore: avoid_print
        print("....... User granted provisional permission....");
        break;
      default:
        // ignore: avoid_print
        print("....... User denied permission....");
        break;
    }
  }

  Future<void> fetchToken() async {
    await FirebaseMessaging.instance
        .getToken()
        // ignore: avoid_print
        .then((token) => {_token = token, print("Token: $_token")});

    //save the token to Firebase live database
    String? modelInfo = await fetchModelInfo();

    FirebaseFirestore.instance
        .collection('UserTokens')
        .doc(_token)
        .set({'token': _token, 'modelInfo': modelInfo});
  }

  //Get model or operating system name
  Future<String?> fetchModelInfo() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return (await deviceInfoPlugin.iosInfo).model;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return (await deviceInfoPlugin.androidInfo).model;
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return (await deviceInfoPlugin.webBrowserInfo).platform;
    }
    throw Exception('Unsupported platform');
  }
}
