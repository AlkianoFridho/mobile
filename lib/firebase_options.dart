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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD8MkID6Wt7wgoXA7dK5LcYHQhL78_L0ko',
    appId: '1:979684245593:web:0f82596110ea9a58d93148',
    messagingSenderId: '979684245593',
    projectId: 'mobile-27151',
    authDomain: 'mobile-27151.firebaseapp.com',
    storageBucket: 'mobile-27151.appspot.com',
    measurementId: 'G-YQBCYGSZNC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBncdUaz0OzaUuvD4fBFkVAvf4N5UdgPxA',
    appId: '1:979684245593:android:351ab862310d251dd93148',
    messagingSenderId: '979684245593',
    projectId: 'mobile-27151',
    storageBucket: 'mobile-27151.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeQc1Jnbqlcg7iwNBrkicE9vvf-lKiJWg',
    appId: '1:979684245593:ios:22835793314a9244d93148',
    messagingSenderId: '979684245593',
    projectId: 'mobile-27151',
    storageBucket: 'mobile-27151.appspot.com',
    iosBundleId: 'com.mobile.mobile',
  );
}
