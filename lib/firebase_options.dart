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
    apiKey: 'AIzaSyArZv8FYB4S1es8fnTS6njvQ94Rtm9bHq4',
    appId: '1:126324417715:android:7b507f53db3a1d53007cc6',
    messagingSenderId: '126324417715',
    projectId: 'appgerenciadortarefas',
    databaseURL: 'https://appgerenciadortarefas-default-rtdb.firebaseio.com',
    storageBucket: 'appgerenciadortarefas.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeFHSQQrApSb4W_AV9SlisHPCKq2GTFns',
    appId: '1:126324417715:ios:9678c5280416dde0007cc6',
    messagingSenderId: '126324417715',
    projectId: 'appgerenciadortarefas',
    databaseURL: 'https://appgerenciadortarefas-default-rtdb.firebaseio.com',
    storageBucket: 'appgerenciadortarefas.firebasestorage.app',
    iosBundleId: 'com.prova.gerenciadorTarefas',
  );
}
