import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:try_notification_2/config/firebase/firebaseAuth.dart';

import 'config/firebase/firebaseProfile.dart';
import 'main.dart';

FireAuth _fireAuth = new FireAuth();

// final MethodChannel platform = MethodChannel('samples.flutter.dev/ringtone');

Future<void> showOngoingNotification() async {
  // String alarmUri = await platform.invokeMethod("getRingtone");
  // final x = UriAndroidNotificationSound(alarmUri);
  // print(x);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      sound: RawResourceAndroidNotificationSound('test'),
      enableLights: true,
      enableVibration: true,
      // playSound: true,
      ongoing: true,
      autoCancel: false);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
      'ongoing notification body', platformChannelSpecifics);
}

Future<void> showPlainNotification(Map<String, dynamic> msg) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      0.toString(), msg["notification"]["title"], msg["notification"]["body"],
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    msg["notification"]["title"],
    msg["notification"]["body"],
    platformChannelSpecifics,
    payload: json.encode(msg),
  );
}

/// Schedules a notification that specifies a different icon, sound and vibration pattern
Future<void> scheduleNotification(Map<String, dynamic> msg) async {
  var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'app_icon',
      sound: RawResourceAndroidNotificationSound('test'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);
  var iOSPlatformChannelSpecifics =
      // IOSNotificationDetails(sound: 'slow_spring_board.aiff');
      IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      msg["notification"]["title"],
      msg["notification"]["body"],
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

Future<void> showBigTextNotification() async {
  var bigTextStyleInformation = BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      styleInformation: bigTextStyleInformation);
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, null);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<void> showPublicNotification(Map<String, dynamic> msg) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      0.toString(), msg["notification"]["title"], msg["notification"]["body"],
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      visibility: NotificationVisibility.Public);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    msg["notification"]["title"],
    msg["notification"]["body"],
    platformChannelSpecifics,
    payload: json.encode(msg),
  );
}

Future<void> login() async {
  await _fireAuth.signIn(
    email: "michaeltamekloe18.mt@gmail.com",
    password: "12345678",
  );
}

final Firestore _database = Firestore.instance;
Future<void> sendNotification({
  @required String title,
  @required String msg,
  @required String type,
  @required String screen,
}) async {
  if (firebaseUserId != null) {
    DocumentReference ref = await _database
        .collection("notifications")
        .document(firebaseUserId)
        .collection("noti")
        .add({
      "to": firebaseUserId,
      "from": firebaseUserId,
      "title": title,
      "msg": msg,
      "type": type,
      "screen": screen,
    });
    print(ref.documentID);
  } else {
    print("Log in");
  }
}
