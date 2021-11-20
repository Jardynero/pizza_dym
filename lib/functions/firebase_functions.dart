import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// request permission for notifications
Future initFirebaseMessaging(firebaseMessagingInstance) async {
  Future.delayed(Duration(milliseconds: 2000));
  NotificationSettings settings =
      await firebaseMessagingInstance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

// cloud messaging
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// Firebase AUTH
class FirebaseAuthInstance extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  String _verificationId = '';
  String _userPhoneNumber = '';

  String get getVerificationId => _verificationId;
  String get getUserPhoneNumber => _userPhoneNumber;

  void obtainVerificationId(verificationId) {
    _verificationId = verificationId;
  }

  void obtainUserPhoneNumber(userPhoneNumber) {
    _userPhoneNumber = userPhoneNumber;
  }

}

class CloudFirestore extends ChangeNotifier {
  // Cloud Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;
}
