import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:try_notification_2/config/locator.dart';
import 'package:try_notification_2/constants/route_name.dart';
import 'package:try_notification_2/services/navigationService.dart';

import 'function.dart';
import 'main.dart';

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(" onBackgroundMessage notification called ${(message)}");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(" onBackgroundMessage data called ${(data)}");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(" onBackgroundMessage notification called ${(notification)}");
  }

  // Or do other work.
  return showPlainNotification(message);
}

class PushNotificationService {
  final NavigationService _navigationService = locator<NavigationService>();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  onNoticationSettings() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          print(body);
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
        // selectNotificationSubject.add(payload);
        _serialiseAndNavigate(json.decode(payload));
      }
    });

    _firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
        _serialiseAndNavigate(msg);
        return;
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
        // selectNotificationSubject.add(json.encode(msg["data"]));
        _serialiseAndNavigate(msg);
        return;
      },
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ${(msg)}");
        _onMessage(msg);
        return;
      },
    );
  }

  void _onMessage(Map<String, dynamic> msg) {
    String type = msg["data"]["type"].toString().toLowerCase();
    if (type != null) {
      if (type == "plain")
        showPlainNotification(msg);
      else if (type == "plainlockscreen")
        showPublicNotification(msg);
      else if (type == "schedule")
        scheduleNotification(msg);
      else if (type == "showbigtextnotification")
        showBigTextNotification();
      else if (type == "showongoingnotification") showOngoingNotification();
    } else {
      showPlainNotification(msg);
    }
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    //check screen
    String screen = message["data"]["screen"].toString().toLowerCase();
    print(screen);
    if (screen != null) {
      if (screen == "secondscreen") {
        _navigationService.navigateTo(SecondScreenViewRoute,
            arguments: message["data"]);
      }
    }
  }
}
