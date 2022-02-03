import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

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
}
