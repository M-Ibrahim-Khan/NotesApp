import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// One thing not notified. We also put necessary setup in AndroidManifest.xml and Info.plist for iOS.
// for android: https://firebase.flutter.dev/docs/messaging/overview/#android-integration
// for iOS: https://firebase.flutter.dev/docs/messaging/overview/#ios-integration
// android directory: android/app/src/main/AndroidManifest.xml
// iOS directory: ios/Runner/Info.plist
// this is what was added in android manifest file:
// <meta-data
//            android:name="com.google.firebase.messaging.default_notification_channel_id"
//            android:value="high_importance_channel" />

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission for notifications');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted permission for provisional notifications');
    } else {
      // if you want to open notification page.
      // AppSettings.openNotificationSettings();
      debugPrint('User declined permission for notifications');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received a foreground message: ${message.messageId}');
      // Handle the message and show a notification if needed
    });

    // Handle background and terminated state messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked!: ${message.messageId}');
      // Navigate to a specific screen if needed
    });
  }

  void initializeLocalNotifications(BuildContext context, RemoteMessage message) async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
      //debugPrint('Notification clicked with payload: ${payload.payload}');
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Firebase Message Title: ${message.notification!.title}");
      debugPrint("Firebase Message Body: ${message.notification!.body}");
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(), // id
      'High Importance Notifications', // name
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =  AndroidNotificationDetails(
      channel.id.toString(), // id
      channel.name.toString(), 
      channelDescription: 'your channel description',// title
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails =  DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString() ,
      notificationDetails,
      //payload: 'Notification Payload',
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await _messaging.getToken();
    debugPrint("Firebase Messaging Token: $token");
    return token!;
  }

  void isTokenRefresh() async {
    _messaging.onTokenRefresh.listen((event) {
      debugPrint("Refreshed Token: $event");
    });
  }
}
