// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
        // using web config for linux platform
        return web;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcaoQoGDZm3h2TzrE9NINlYOzBGQULCNE',
    appId: '1:892296995692:web:67a9ee32bccb0178490949',
    messagingSenderId: '892296995692',
    projectId: 'clipboard-419514',
    authDomain: 'clipboard-419514.firebaseapp.com',
    storageBucket: 'clipboard-419514.appspot.com',
    measurementId: 'G-8LF9RP87DF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARs2mXcuR2O7aucYtvdKVgB-PFXmoV42I',
    appId: '1:892296995692:android:64012302abe55897490949',
    messagingSenderId: '892296995692',
    projectId: 'clipboard-419514',
    storageBucket: 'clipboard-419514.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDu5UXxIRpcUq1h680iS6mUtbEEsTNwsfA',
    appId: '1:892296995692:ios:4bf415b9b852d3af490949',
    messagingSenderId: '892296995692',
    projectId: 'clipboard-419514',
    storageBucket: 'clipboard-419514.appspot.com',
    iosBundleId: 'com.entilitystudio.CopyCat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDu5UXxIRpcUq1h680iS6mUtbEEsTNwsfA',
    appId: '1:892296995692:ios:4bf415b9b852d3af490949',
    messagingSenderId: '892296995692',
    projectId: 'clipboard-419514',
    storageBucket: 'clipboard-419514.appspot.com',
    iosBundleId: 'com.entilitystudio.CopyCat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcaoQoGDZm3h2TzrE9NINlYOzBGQULCNE',
    appId: '1:892296995692:web:fd01b423ca72c756490949',
    messagingSenderId: '892296995692',
    projectId: 'clipboard-419514',
    authDomain: 'clipboard-419514.firebaseapp.com',
    storageBucket: 'clipboard-419514.appspot.com',
    measurementId: 'G-TBGBJVH2GS',
  );

}