import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebaseProfile.dart';

abstract class BaseAuth {
  Future<String> signIn({@required String email, @required String password});

  Future<String> signUp({@required String email, @required String password});

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendVerification();

  Future<bool> isEmailVerified();

  Future<void> signOut();
}

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FireProfile _firebaseProfile = new FireProfile();
  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp({
    @required String email,
    @required String password,
  }) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<String> signIn({
    @required String email,
    @required String password,
  }) async {
    String ret;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      //add user details to db
      _firebaseProfile.createAccount(email: email, id: user.uid);
      return user.uid;
    } on PlatformException catch (error) {
      //create new account if log in successfully
      print(error);
      signUp(email: email, password: password).then((value) {
        signIn(email: email, password: password);
        ret = "login";
      });
    }
    return ret;
  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> sendVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }
}
