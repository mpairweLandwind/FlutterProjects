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
    apiKey: 'AIzaSyD3tIfLg1ZyoMs3pc8-AG_gAs5xVgn-47w',
    appId: '1:989018014187:web:c01ceecf1fe69176e999ae',
    messagingSenderId: '989018014187',
    projectId: 'zalonidentalhub',
    authDomain: 'zalonidentalhub.firebaseapp.com',
    storageBucket: 'zalonidentalhub.appspot.com',
    measurementId: 'G-82DQJL0JKZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIeexhnwPLdCA9683lD4bfGiE6qmKT-2E',
    appId: '1:989018014187:android:151bb184194f99e4e999ae',
    messagingSenderId: '989018014187',
    projectId: 'zalonidentalhub',
    storageBucket: 'zalonidentalhub.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQUWIZG8Uxx_jCrD7vZid0FSluK2hW6G0',
    appId: '1:989018014187:ios:319a6d4c4c98d6efe999ae',
    messagingSenderId: '989018014187',
    projectId: 'zalonidentalhub',
    storageBucket: 'zalonidentalhub.appspot.com',
    iosBundleId: 'com.example.zalonidentalapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQUWIZG8Uxx_jCrD7vZid0FSluK2hW6G0',
    appId: '1:989018014187:ios:319a6d4c4c98d6efe999ae',
    messagingSenderId: '989018014187',
    projectId: 'zalonidentalhub',
    storageBucket: 'zalonidentalhub.appspot.com',
    iosBundleId: 'com.example.zalonidentalapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3-u8g5einn2SkaGPBwYzXLtfZZzFBhqY',
    appId: '1:989018014187:web:1cd08cf40f2d65b6e999ae',
    messagingSenderId: '989018014187',
    projectId: 'zalonidentalhub',
    authDomain: 'zalonidentalhub.firebaseapp.com',
    storageBucket: 'zalonidentalhub.appspot.com',
    measurementId: 'G-9GZ5JVNWYZ',
  );

}