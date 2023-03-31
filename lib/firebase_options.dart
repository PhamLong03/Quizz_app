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
    apiKey: 'AIzaSyBiZBGHVlRTgIyZlZXCCv7aijM7BA2a2m4',
    appId: '1:969981645335:web:a92d9ffc1fee69f1900252',
    messagingSenderId: '969981645335',
    projectId: 'quiz-app-2eacb',
    authDomain: 'quiz-app-2eacb.firebaseapp.com',
    storageBucket: 'quiz-app-2eacb.appspot.com',
    measurementId: 'G-0ZDHGY0VJX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxyF4Z_MjhwjvLLbGOmVlwOhEcmGzoMHY',
    appId: '1:969981645335:android:fd70faa94ba2c143900252',
    messagingSenderId: '969981645335',
    projectId: 'quiz-app-2eacb',
    storageBucket: 'quiz-app-2eacb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1bQFYKzkPIJ-Kdh0WEqylShyFzGWqSZ4',
    appId: '1:969981645335:ios:75d687b5cac3f924900252',
    messagingSenderId: '969981645335',
    projectId: 'quiz-app-2eacb',
    storageBucket: 'quiz-app-2eacb.appspot.com',
    iosClientId: '969981645335-d58svqtt4uplm7182rk8o79hvgdhr6q3.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizApp',
  );
}
