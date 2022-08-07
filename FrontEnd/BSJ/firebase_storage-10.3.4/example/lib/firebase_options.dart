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
    apiKey: 'AIzaSyC1TM6rrknwBZo3DisNBJtr7y_afZg4WWQ',
    appId: '1:189872052067:web:168d0d00bdc3d2c4e3e556',
    messagingSenderId: '189872052067',
    projectId: 'imagestorage-168a8',
    authDomain: 'imagestorage-168a8.firebaseapp.com',
    storageBucket: 'imagestorage-168a8.appspot.com',
    measurementId: 'G-JBQFCTJ4C6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKodPwkqSFcn6yyR1kjXdrpR3O9TVcjko',
    appId: '1:189872052067:android:c80fa49926fe9465e3e556',
    messagingSenderId: '189872052067',
    projectId: 'imagestorage-168a8',
    storageBucket: 'imagestorage-168a8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUyb1fkOJIX9NBiH5m0-fj6OSUnAIODPM',
    appId: '1:189872052067:ios:9629dad73cdd60d1e3e556',
    messagingSenderId: '189872052067',
    projectId: 'imagestorage-168a8',
    storageBucket: 'imagestorage-168a8.appspot.com',
    iosClientId: '189872052067-ccp3i5tvi9l1n2i3hpk7rjmcc7o7rng2.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.storage.example',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUyb1fkOJIX9NBiH5m0-fj6OSUnAIODPM',
    appId: '1:189872052067:ios:9629dad73cdd60d1e3e556',
    messagingSenderId: '189872052067',
    projectId: 'imagestorage-168a8',
    storageBucket: 'imagestorage-168a8.appspot.com',
    iosClientId: '189872052067-ccp3i5tvi9l1n2i3hpk7rjmcc7o7rng2.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.storage.example',
  );
}
