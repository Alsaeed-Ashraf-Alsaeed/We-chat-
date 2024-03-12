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
    apiKey: 'AIzaSyARX1UALgGfLxEgIo76Q2rwDl0GFo3T4RQ',
    appId: '1:37654456703:web:2a7babb9726a65de5f524a',
    messagingSenderId: '37654456703',
    projectId: 'chat-app-11406',
    authDomain: 'chat-app-11406.firebaseapp.com',
    storageBucket: 'chat-app-11406.appspot.com',
    measurementId: 'G-00V9YG5C9S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEHFY1LpDEC7VeG3f6kA_KTlwDMZ4SqLk',
    appId: '1:37654456703:android:ae711368223fc2295f524a',
    messagingSenderId: '37654456703',
    projectId: 'chat-app-11406',
    storageBucket: 'chat-app-11406.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDTBkTEJVPkrnHtAXFBLqfz4dRLs4lpQo',
    appId: '1:37654456703:ios:3568e709b9a1a4a25f524a',
    messagingSenderId: '37654456703',
    projectId: 'chat-app-11406',
    storageBucket: 'chat-app-11406.appspot.com',
    iosClientId: '37654456703-dnd02c5kejuu7ntes005m9kc2r8ll79g.apps.googleusercontent.com',
    iosBundleId: 'com.example.weChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDTBkTEJVPkrnHtAXFBLqfz4dRLs4lpQo',
    appId: '1:37654456703:ios:3568e709b9a1a4a25f524a',
    messagingSenderId: '37654456703',
    projectId: 'chat-app-11406',
    storageBucket: 'chat-app-11406.appspot.com',
    iosClientId: '37654456703-dnd02c5kejuu7ntes005m9kc2r8ll79g.apps.googleusercontent.com',
    iosBundleId: 'com.example.weChat',
  );
}