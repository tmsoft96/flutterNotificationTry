import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:try_notification_2/config/locator.dart';
import 'package:try_notification_2/services/navigationService.dart';
import 'package:try_notification_2/widgets/router.dart';

import 'homepage.dart';
import 'notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationAppLaunchDetails notificationAppLaunchDetails;
final PushNotificationService _pushNotificationService =
    locator<PushNotificationService>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  setupLocator();
  _pushNotificationService.onNoticationSettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // AndroidIntent intent = AndroidIntent(
  //     action: 'android.intent.action.RUN',
  //     package: 'com.example.try_notification_2',
  //     componentName: 'com.example.try_notification_2.MainActivity',
  //     arguments: {'route': '/secondPage'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
    );
  }
}
