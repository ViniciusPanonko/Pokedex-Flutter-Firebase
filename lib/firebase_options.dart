import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCoDeNmzQN57lzsoGr8_N9Gx-_4J0XAj_Y',
    appId: '1:1045290250100:web:5d9a8a8fe0cc3b8c30c621',
    messagingSenderId: '1045290250100',
    projectId: 'pokedex-flutter-379af',
    authDomain: 'pokedex-flutter-379af.firebaseapp.com',
    storageBucket: 'pokedex-flutter-379af.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoDeNmzQN57lzsoGr8_N9Gx-_4J0XAj_Y',
    appId: '1:1045290250100:android:5d9a8a8fe0cc3b8c30c621',
    messagingSenderId: '1045290250100',
    projectId: 'pokedex-flutter-379af',
    storageBucket: 'pokedex-flutter-379af.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoDeNmzQN57lzsoGr8_N9Gx-_4J0XAj_Y',
    appId: '1:1045290250100:ios:5d9a8a8fe0cc3b8c30c621',
    messagingSenderId: '1045290250100',
    projectId: 'pokedex-flutter-379af',
    storageBucket: 'pokedex-flutter-379af.firebasestorage.app',
    iosBundleId: 'com.example.pokedex',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoDeNmzQN57lzsoGr8_N9Gx-_4J0XAj_Y',
    appId: '1:1045290250100:ios:5d9a8a8fe0cc3b8c30c621',
    messagingSenderId: '1045290250100',
    projectId: 'pokedex-flutter-379af',
    storageBucket: 'pokedex-flutter-379af.firebasestorage.app',
    iosBundleId: 'com.example.pokedex',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCoDeNmzQN57lzsoGr8_N9Gx-_4J0XAj_Y',
    appId: '1:1045290250100:web:5d9a8a8fe0cc3b8c30c621',
    messagingSenderId: '1045290250100',
    projectId: 'pokedex-flutter-379af',
    authDomain: 'pokedex-flutter-379af.firebaseapp.com',
    storageBucket: 'pokedex-flutter-379af.firebasestorage.app',
  );
}
