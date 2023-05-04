import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails? notificationAppLaunchDetails;

Random rd = Random();

class LocalNotification {
  static const String _id = '_ID';
  static const String _channel = '_Channel';
  static const String _description = 'Description';

  static setup() async {
    //setup local notification
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          selectNotificationSubject.add(payload);
          flutterLocalNotificationsPlugin.cancel(id);
        });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse? payload) async {
      selectNotificationSubject.add(payload?.payload);
    });
  }

  static Future<void> showNotification(
      String? title, String? body, String? payload) async {
    if (title == null || body == null) return;
    var platformChannelSpecifics = const NotificationDetails(
      android: AndroidNotificationDetails(_id, _channel,
          channelDescription: _description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
        rd.nextInt(1000), title, body, platformChannelSpecifics,
        payload: payload);
  }
}
