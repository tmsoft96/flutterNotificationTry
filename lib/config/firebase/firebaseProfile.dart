import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../sharePreference.dart';

String firebaseUserId;

abstract class BaseProfile {
  Future<void> createAccount({@required String email, @required String id});
}

class FireProfile implements BaseProfile {
  final Firestore _database = Firestore.instance;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  static List<String> users;

  @override
  Future<void> createAccount({String email, String id}) {
    // firebaseMessaging.getToken().then((token) {
    //   update(token, id);
    // });
    print("==========================$id=====================");
    saveStringShare(key: "firebaseUserId", data: id);
    firebaseUserId = id;
    return _database.collection("users").document(firebaseUserId).setData({
      "name": "Michael Tamakloe",
      "id": firebaseUserId,
      "email": email,
    });
  }

  saveDeviceToken() async {
    String fcmToken = await firebaseMessaging.getToken();
    print(fcmToken);

    if (fcmToken != null) {
      var tokens = _database.collection("tokens").document(firebaseUserId);

      await tokens.setData({
        "id": firebaseUserId,
        "token": fcmToken,
        "createdAt": FieldValue.serverTimestamp(),
        "platform": Platform.operatingSystem,
      });
    }
  }
}
