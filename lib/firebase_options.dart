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
    apiKey: 'AIzaSyDS--Ebd_HKAII6ESkigh9VSvtzaiL4z64',
    appId: '1:586127359145:web:your-web-app-id', // TODO: Replace with actual web app ID from Firebase Console
    messagingSenderId: '586127359145',
    projectId: 'campus-navigation-ce8d4',
    authDomain: 'campus-navigation-ce8d4.firebaseapp.com',
    storageBucket: 'campus-navigation-ce8d4.firebasestorage.app',
    measurementId: null, // TODO: Add if Analytics enabled
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDS--Ebd_HKAII6ESkigh9VSvtzaiL4z64',
    appId: '1:586127359145:android:f4936a10fa45ef13987db8',
    messagingSenderId: '586127359145',
    projectId: 'campus-navigation-ce8d4',
    storageBucket: 'campus-navigation-ce8d4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDS--Ebd_HKAII6ESkigh9VSvtzaiL4z64',
    appId: '1:586127359145:ios:your-ios-app-id', // TODO: Replace with actual iOS app ID from Firebase Console
    messagingSenderId: '586127359145',
    projectId: 'campus-navigation-ce8d4',
    storageBucket: 'campus-navigation-ce8d4.firebasestorage.app',
    iosBundleId: 'com.example.campusnavigation',
  );
}