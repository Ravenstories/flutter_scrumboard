// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCwwlBaAPw8AqcWrtVisWPydU4dIPT542o',
    appId: '1:533197642878:web:07643300bbe97b12c54c2f',
    messagingSenderId: '533197642878',
    projectId: 'flutter-scrumboard',
    authDomain: 'flutter-scrumboard.firebaseapp.com',
    storageBucket: 'flutter-scrumboard.appspot.com',
    measurementId: 'G-G0H3D1TRSK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwB1nFQJAUctCgqaBVpoX7CThoJayKZ_I',
    appId: '1:533197642878:android:19d2b951278ba94cc54c2f',
    messagingSenderId: '533197642878',
    projectId: 'flutter-scrumboard',
    storageBucket: 'flutter-scrumboard.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZiH0QvvgoNkBoTk4Cbf0_U1qAMN4g9LA',
    appId: '1:533197642878:ios:2ff0b5de4d894c1dc54c2f',
    messagingSenderId: '533197642878',
    projectId: 'flutter-scrumboard',
    storageBucket: 'flutter-scrumboard.appspot.com',
    iosClientId:
        '533197642878-fpntr27vt3s8p00pn8q2ajemqs0f399s.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterScrumboard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZiH0QvvgoNkBoTk4Cbf0_U1qAMN4g9LA',
    appId: '1:533197642878:ios:2ff0b5de4d894c1dc54c2f',
    messagingSenderId: '533197642878',
    projectId: 'flutter-scrumboard',
    storageBucket: 'flutter-scrumboard.appspot.com',
    iosClientId:
        '533197642878-fpntr27vt3s8p00pn8q2ajemqs0f399s.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterScrumboard',
  );
}