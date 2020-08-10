import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:try_notification_2/config/firebase/firebaseProfile.dart';
import 'package:try_notification_2/config/locator.dart';
import 'package:try_notification_2/secondScreen.dart';

import 'function.dart';
import 'main.dart';
import 'notification.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _pushNotificationService.onNoticationSettings();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    // onNoticationSettings();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    print(notificationAppLaunchDetails.didNotificationLaunchApp);
    // selectNotificationSubject.stream.listen((String payload) async {
    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    //   );
    // });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    // selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Tap on a notification when it appears to trigger navigation'),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Did notification launch app? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '${notificationAppLaunchDetails?.didNotificationLaunchApp ?? false}',
                      ),
                      if (notificationAppLaunchDetails
                              ?.didNotificationLaunchApp ??
                          false)
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Launch notification payload: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: notificationAppLaunchDetails.payload,
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                _buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FireProfile _fireProfile = FireProfile();
  Widget _buttons() {
    return Column(
      children: [
        RaisedButton(
          child: Text('Login to firebase'),
          onPressed: login,
        ),
        RaisedButton(
          child: Text('Save device token'),
          onPressed: () => _fireProfile.saveDeviceToken(),
        ),
        RaisedButton(
          child: Text('I like puppies'),
          onPressed: () => _fcm.subscribeToTopic("puppies"),
        ),
        RaisedButton(
          child: Text('I hate puppies'),
          onPressed: () => _fcm.unsubscribeFromTopic("puppies"),
        ),
        RaisedButton(
          child: Text('Send plain notification'),
          onPressed: () => sendNotification(
            msg: "Try correcting the name to the name of an existing getter",
            title: "libraries ",
            type: "plain",
            screen: "secondScreen",
          ),
        ),
        RaisedButton(
          child: Text('Show plain notification as public on every lockscreen'),
          onPressed: () => sendNotification(
            msg: "getNavigationBarColor() -855310",
            title: "InputMethodManager ",
            type: "plainLockscreen",
            screen: "secondScreen",
          ),
        ),
        RaisedButton(
          child: Text(
              'Schedule notification to appear in 5 seconds, custom sound, red colour, large icon, red LED'),
          onPressed: () => sendNotification(
            msg:
                "Schedule notification to appear in 5 seconds, custom sound, red colour, large icon, red LED",
            title: "Schedule",
            type: "schedule",
            screen: "secondScreen",
          ),
        ),
        RaisedButton(
          child: Text('showBigTextNotification'),
          onPressed: () => sendNotification(
            msg: "showBigTextNotification",
            title: "Schedule",
            type: "showBigTextNotification",
            screen: "secondScreen",
          ),
        ),
        RaisedButton(
          child: Text('showOngoingNotification'),
          onPressed: () => sendNotification(
            msg: "showOngoingNotification",
            title: "Schedule",
            type: "showOngoingNotification",
            screen: "secondScreen",
          ),
        ),
        RaisedButton(
          child: Text('showOngoingNotification'),
          // onPressed: () => sendNotification(
          //   msg: "createNotificationChannel",
          //   title: "Schedule",
          //   type: "showOngoingNotification",
          //   screen: "secondScreen",
          // ),
          onPressed: () => showOngoingNotification(),
        ),
      ],
    );
  }
}
