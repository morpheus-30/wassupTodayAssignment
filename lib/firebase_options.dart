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
    apiKey: 'AIzaSyDlMdltdtL2Cer52s2Yfm3mGumg1O6gAZY',
    appId: '1:109245017909:web:81f532e1a170b83043667c',
    messagingSenderId: '109245017909',
    projectId: 'wassuptoday-2cd1c',
    authDomain: 'wassuptoday-2cd1c.firebaseapp.com',
    storageBucket: 'wassuptoday-2cd1c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNJm1eeLG9wsfXLdKRMfL_vVAwJkLyha8',
    appId: '1:109245017909:android:8fc259db07e0b7fb43667c',
    messagingSenderId: '109245017909',
    projectId: 'wassuptoday-2cd1c',
    storageBucket: 'wassuptoday-2cd1c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPNMcWV0pQeoCZNGktoIqW1f8V15I4HEw',
    appId: '1:109245017909:ios:0b566a887dffa2a443667c',
    messagingSenderId: '109245017909',
    projectId: 'wassuptoday-2cd1c',
    storageBucket: 'wassuptoday-2cd1c.appspot.com',
    androidClientId: '109245017909-f5ns7upkau856egegt10sc81405cpk72.apps.googleusercontent.com',
    iosClientId: '109245017909-nuktkrlc4ofvcicn63u93qrmr2743663.apps.googleusercontent.com',
    iosBundleId: 'com.example.wassuptoday',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPNMcWV0pQeoCZNGktoIqW1f8V15I4HEw',
    appId: '1:109245017909:ios:5b5f21e0e87dd68743667c',
    messagingSenderId: '109245017909',
    projectId: 'wassuptoday-2cd1c',
    storageBucket: 'wassuptoday-2cd1c.appspot.com',
    androidClientId: '109245017909-f5ns7upkau856egegt10sc81405cpk72.apps.googleusercontent.com',
    iosClientId: '109245017909-77aor25f8nt3f13ic4k48p7o5jg9kt8d.apps.googleusercontent.com',
    iosBundleId: 'com.example.wassuptoday.RunnerTests',
  );
}