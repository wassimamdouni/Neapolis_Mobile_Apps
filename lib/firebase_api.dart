

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessaging(RemoteMessage message)async{
  //print("Title: ${message.notification?.title}");
  //print("Body: ${message.notification?.body}");
  //print("Payload: ${message.data}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    prefs.setString('Token',fCMToken??'');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
  }
}