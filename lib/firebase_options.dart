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
    apiKey: 'AIzaSyBZX08YI6uwpB9k9QgLoLPFYzKot7cH4SE',
    appId: '1:1010934675634:web:11fceb6cb0f08b0ab3b1ab',
    messagingSenderId: '1010934675634',
    projectId: 'flutterbankingapplication',
    authDomain: 'flutterbankingapplication.firebaseapp.com',
    storageBucket: 'flutterbankingapplication.appspot.com',
    measurementId: 'G-5HDW0TK30Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdnYJ5D97w_xAVgplP7WGTwgfBMKgCXmQ',
    appId: '1:1010934675634:android:df870e712511e451b3b1ab',
    messagingSenderId: '1010934675634',
    projectId: 'flutterbankingapplication',
    storageBucket: 'flutterbankingapplication.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnp0H8YE1cldgsA-OCrtn4bO0pruwm5ms',
    appId: '1:1010934675634:ios:dd79686ea465d3adb3b1ab',
    messagingSenderId: '1010934675634',
    projectId: 'flutterbankingapplication',
    storageBucket: 'flutterbankingapplication.appspot.com',
    iosBundleId: 'com.example.bankingApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnp0H8YE1cldgsA-OCrtn4bO0pruwm5ms',
    appId: '1:1010934675634:ios:ef5937952d92de07b3b1ab',
    messagingSenderId: '1010934675634',
    projectId: 'flutterbankingapplication',
    storageBucket: 'flutterbankingapplication.appspot.com',
    iosBundleId: 'com.example.bankingApplication.RunnerTests',
  );
}
