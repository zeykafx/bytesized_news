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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCNCfZ6vMGlYx0PYc7YNLR9mHDo_5rV0uc',
    appId: '1:286405169123:web:12a7ab6b49cb6e3eb21ad6',
    messagingSenderId: '286405169123',
    projectId: 'bytesized-news',
    authDomain: 'bytesized-news.firebaseapp.com',
    storageBucket: 'bytesized-news.appspot.com',
    measurementId: 'G-DZ52GQ6G88',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUuN8jh3siOttcA26Gid-VgILXW-AX5tY',
    appId: '1:286405169123:android:4796eede57acedfab21ad6',
    messagingSenderId: '286405169123',
    projectId: 'bytesized-news',
    storageBucket: 'bytesized-news.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCNCfZ6vMGlYx0PYc7YNLR9mHDo_5rV0uc',
    appId: '1:286405169123:web:5ec8dd1c91512fefb21ad6',
    messagingSenderId: '286405169123',
    projectId: 'bytesized-news',
    authDomain: 'bytesized-news.firebaseapp.com',
    storageBucket: 'bytesized-news.appspot.com',
    measurementId: 'G-QK2NKEHM1J',
  );

}