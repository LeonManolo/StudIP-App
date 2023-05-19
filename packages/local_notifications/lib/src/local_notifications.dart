import 'dart:ffi';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

typedef TestOr = String;

final class LocalNotifications {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(
      {String timezoneName = 'Europe/Berlin'}) async {
    // Android initialization
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS initialization
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timezoneName));

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification() async {
    const androidNotificationDetails = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const iOSNotificationDetails = DarwinNotificationDetails(
      subtitle: "iOS Subtitle",
    );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> scheduleNotification({String? timezoneName}) async {
    final timezone =
        timezoneName == null ? tz.local : tz.getLocation(timezoneName);

    final scheduledDate = tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 10)), timezone);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> getNotifications() async {
    final pendingNotificationRequests =
      await _flutterLocalNotificationsPlugin.pendingNotificationRequests();


    pendingNotificationRequests.first.payload;
  }



  static Future<void> _saveNotifications() async {

  }

  static Future<void> _retrieveSavedNotifications() async {

  }
}
