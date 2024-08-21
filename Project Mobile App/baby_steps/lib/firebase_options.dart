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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDju9BtEmIda_o7u-u-GtmMEYHJRvZUj0k',
    appId: '1:182227983806:android:4cb8fade3c70cc44b22def',
    messagingSenderId: '182227983806',
    projectId: 'baby-steps-36d59',
    storageBucket: 'baby-steps-36d59.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZMBrM_X23B8zvieZ2w8OPNlECxj68F3A',
    appId: '1:182227983806:ios:addb57e3c1a7c23eb22def',
    messagingSenderId: '182227983806',
    projectId: 'baby-steps-36d59',
    storageBucket: 'baby-steps-36d59.appspot.com',
    androidClientId: '182227983806-9enf6ppt6ebj931g3qjln3gr1i4nqsg6.apps.googleusercontent.com',
    iosClientId: '182227983806-jb45g0j8tuctuhob1elqi99iu4bnj2f4.apps.googleusercontent.com',
    iosBundleId: 'com.example.babySteps.RunnerTests',
  );

}