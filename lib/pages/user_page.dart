import 'package:flutter_scrumboard/shared/shared.dart';

///Placeholder page.
///I didn't get aroudn to implementing this page.
///It was supposed to be a page where you could edit your profile.
class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'User Page',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
