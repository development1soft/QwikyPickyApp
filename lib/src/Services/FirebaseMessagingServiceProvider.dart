import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingServiceProvider extends ChangeNotifier{

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  late String fcmToken;

  initializeNotificationsSettings() async{

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {

      print('User granted permission: ${settings.authorizationStatus}');

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {

      print('User granted provisional permission');

    } else {

      print('User declined or has not accepted permission');

    }

  }

  getUserToken() async {
    await firebaseMessaging.getToken().then((value) {

      print('token :${value.toString()}');

      fcmToken = value!;

      notifyListeners();

    });
  }

}