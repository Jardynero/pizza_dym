import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static const String FCM_SERVER_KEY =
      'AAAA7D6jmhI:APA91bEcdeto4DLIdWiF1oJ_SQgwgQPNCWdw6XPr__kEU0pyyTZWOjxRKXzeXCCJIvVIaUAvdnU5kXNDr8Zyo_5Vdk4BNEp-X6XYTy5FdxNMjrSlTEcjpc35yZU4dlZUC5W5TbZqkmF6';
  static Future<String> getAdminToken() async {
    DocumentSnapshot adminToken = await FirebaseFirestore.instance
        .collection('deliveryMans')
        .doc('pizzadym.ru@yandex.ru')
        .get();
    String result = adminToken.get('token');
    return result;
  }

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'Пицца Дым',
          channelDescription: 'Статусы заказа',
          importance: Importance.max,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await notificationDetails(),
        payload: payload,
      );

  static Future<http.Response> sendPushToAdmin() async {
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "key=$FCM_SERVER_KEY"
      },
      body: jsonEncode(
        {
          "to": await getAdminToken(),
          "priority": "high",
          "notification": {
            "title": 'Пицца Дым курьер',
            "body": 'Пришел новый заказ',
            "mutable_content": true,
            "badge": '1',
            "sound": '1',
          },
        },
      ),
    );
  }

  Future<void> foregroundNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
              'Message also contained a notification: ${message.notification}');
        }
      },
    );
  }
}
