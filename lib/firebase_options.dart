// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtIle6RGrbRr5MEirKc-21j3Sec-tkauM',
    appId: '1:793185555376:android:cf90f0db6a4f575ee63c75',
    messagingSenderId: '793185555376',
    projectId: 'todoapp-92161',
    storageBucket: 'todoapp-92161.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzmat1DGnghGXbyNxR-Gwiq-IQgOXhKfI',
    appId: '1:793185555376:ios:308564759e04ffb9e63c75',
    messagingSenderId: '793185555376',
    projectId: 'todoapp-92161',
    storageBucket: 'todoapp-92161.appspot.com',
    iosClientId: '793185555376-la803psacja5ueeejpdv1gv3v18d0c8b.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoapp',
  );
}
