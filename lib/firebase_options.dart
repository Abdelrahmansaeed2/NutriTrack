// File generated based on Firebase project: nutritrack-33797
// This file configures the Firebase SDK for the Flutter app.
// The project_id, client_id and api_key values must be filled in
// from your Firebase Console → Project Settings → General → Your Apps.
//
// IMPORTANT: After running `flutterfire configure --project=nutritrack-33797`
// this file will be auto-regenerated with correct values.
// Until then, the app will use the values below.
//
// To get these values:
// 1. Go to https://console.firebase.google.com/project/nutritrack-33797/settings/general
// 2. Under "Your apps", create an Android app and an iOS app
// 3. Run: flutterfire configure --project=nutritrack-33797
// OR manually copy the values from the downloaded google-services.json / GoogleService-Info.plist

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ⚠️ PLACEHOLDER — Replace these with real values from Firebase Console:
  // https://console.firebase.google.com/project/nutritrack-33797/settings/general
  //
  // Android: Download google-services.json → android/app/google-services.json
  // iOS: Download GoogleService-Info.plist → ios/Runner/GoogleService-Info.plist
  // Then run: flutterfire configure --project=nutritrack-33797

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_ANDROID_APP_ID',
    messagingSenderId: '100493049785525374837',
    projectId: 'nutritrack-33797',
    storageBucket: 'nutritrack-33797.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '100493049785525374837',
    projectId: 'nutritrack-33797',
    storageBucket: 'nutritrack-33797.firebasestorage.app',
    iosBundleId: 'com.example.nutritrack',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: 'REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '100493049785525374837',
    projectId: 'nutritrack-33797',
    storageBucket: 'nutritrack-33797.firebasestorage.app',
  );
}
