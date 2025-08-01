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
    apiKey: 'AIzaSyCLNKf0qQLehGwYtDwX-XdbWvGKsS-9ZgI',
    appId: '1:323758759320:web:1fad03a61cb509e9c41fed',
    messagingSenderId: '323758759320',
    projectId: 'corevo-c8ec7',
    authDomain: 'corevo-c8ec7.firebaseapp.com',
    storageBucket: 'corevo-c8ec7.firebasestorage.app',
    measurementId: 'G-E7JDJPNJQ9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8GsuLCN-5CLeklq95HBPw2lDGbkQCEGA',
    appId: '1:323758759320:android:fc0444d8c114fa60c41fed',
    messagingSenderId: '323758759320',
    projectId: 'corevo-c8ec7',
    storageBucket: 'corevo-c8ec7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsKKqdFCMXfMsgn2YTkUtvd7NTzP8UJ34',
    appId: '1:323758759320:ios:e799d6a7a935959ac41fed',
    messagingSenderId: '323758759320',
    projectId: 'corevo-c8ec7',
    storageBucket: 'corevo-c8ec7.firebasestorage.app',
    iosClientId:
    '323758759320-dprqueuudea38nq5t4er41orb54ikbb7.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDsKKqdFCMXfMsgn2YTkUtvd7NTzP8UJ34',
    appId: '1:323758759320:ios:e799d6a7a935959ac41fed',
    messagingSenderId: '323758759320',
    projectId: 'corevo-c8ec7',
    storageBucket: 'corevo-c8ec7.firebasestorage.app',
    iosClientId:
    '323758759320-dprqueuudea38nq5t4er41orb54ikbb7.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLNKf0qQLehGwYtDwX-XdbWvGKsS-9ZgI',
    appId: '1:323758759320:web:d5bfb1e93a0b5a3cc41fed',
    messagingSenderId: '323758759320',
    projectId: 'corevo-c8ec7',
    authDomain: 'corevo-c8ec7.firebaseapp.com',
    storageBucket: 'corevo-c8ec7.firebasestorage.app',
    measurementId: 'G-T4S3KFZS65',
  );
}