// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:@
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
    apiKey: 'AIzaSyAOuNQwwvq-Tak9giqKdDWpMh7oMy_nFIM',
    appId: '1:1038718084951:web:099fab74938e01faf94012',
    messagingSenderId: '1038718084951',
    projectId: 'mobil-uygulama-64f5c',
    authDomain: 'mobil-uygulama-64f5c.firebaseapp.com',
    storageBucket: 'mobil-uygulama-64f5c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlqFo35l_uGG2UQqBZ5-Oba0yYRtPsAtg',
    appId: '1:1038718084951:android:256fce9c90380801f94012',
    messagingSenderId: '1038718084951',
    projectId: 'mobil-uygulama-64f5c',
    storageBucket: 'mobil-uygulama-64f5c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA82sX5ymYnS9QxBMSSNUXmep6jseaJnqs',
    appId: '1:1038718084951:ios:1694a98c332a2b02f94012',
    messagingSenderId: '1038718084951',
    projectId: 'mobil-uygulama-64f5c',
    storageBucket: 'mobil-uygulama-64f5c.appspot.com',
    iosBundleId: 'com.example.mobilUygulama',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA82sX5ymYnS9QxBMSSNUXmep6jseaJnqs',
    appId: '1:1038718084951:ios:e50ff7096476f5b4f94012',
    messagingSenderId: '1038718084951',
    projectId: 'mobil-uygulama-64f5c',
    storageBucket: 'mobil-uygulama-64f5c.appspot.com',
    iosBundleId: 'com.example.mobilUygulama.RunnerTests',
  );
}
