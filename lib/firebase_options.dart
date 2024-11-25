// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBYnA_9rjPHyzQQTlTcGWucQmtCG8VL3YM',
    appId: '1:850472822805:web:9073f21998ab6cf39b061c',
    messagingSenderId: '850472822805',
    projectId: 'loop-db-a7b33',
    authDomain: 'loop-db-a7b33.firebaseapp.com',
    storageBucket: 'loop-db-a7b33.appspot.com',
    measurementId: 'G-4N0RQPG69C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJspAuddRNBvMjygmUWxzLPJDD4Ry_C1o',
    appId: '1:850472822805:android:f2f4ca8eff69a7e19b061c',
    messagingSenderId: '850472822805',
    projectId: 'loop-db-a7b33',
    storageBucket: 'loop-db-a7b33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOFzbCDP4gfevHV4WPXLfQLgMvFUu_HR8',
    appId: '1:850472822805:ios:0445f2266bc1472a9b061c',
    messagingSenderId: '850472822805',
    projectId: 'loop-db-a7b33',
    storageBucket: 'loop-db-a7b33.appspot.com',
    iosBundleId: 'com.example.bluetooth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOFzbCDP4gfevHV4WPXLfQLgMvFUu_HR8',
    appId: '1:850472822805:ios:0445f2266bc1472a9b061c',
    messagingSenderId: '850472822805',
    projectId: 'loop-db-a7b33',
    storageBucket: 'loop-db-a7b33.appspot.com',
    iosBundleId: 'com.example.bluetooth',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBYnA_9rjPHyzQQTlTcGWucQmtCG8VL3YM',
    appId: '1:850472822805:web:7e3808e07bfc1b2d9b061c',
    messagingSenderId: '850472822805',
    projectId: 'loop-db-a7b33',
    authDomain: 'loop-db-a7b33.firebaseapp.com',
    storageBucket: 'loop-db-a7b33.appspot.com',
    measurementId: 'G-ZZN3LBHY7T',
  );
}
