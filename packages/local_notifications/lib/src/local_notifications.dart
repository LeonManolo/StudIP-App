import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

import 'models/local_notification.dart';
import 'extensions/max_int.dart';

final class LocalNotifications {
  /// Samsung's implementation of Android has imposed a maximum of 500 alarms that can be scheduled via the Alarm Manager API
  static const maxPendingAndroidNotifications = 500;

  /// There is a limit imposed by iOS where it will only keep 64 notifications that will fire the soonest.
  static const maxPendingIOSNotifications = 64;

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

  static Future<void> scheduleNotification({
    required String title,
    required String subtitle,
    required DateTime showAt,
    String? topic,
    Map<String, dynamic> payload = const {},
    String? timezoneName,
  }) async {
    final timezone =
        timezoneName == null ? tz.local : tz.getLocation(timezoneName);

    final scheduledDate = tz.TZDateTime.from(showAt, timezone);


    final id = Random().nextInt(0x7fffffff); //await _notificationCount();
    final notification = LocalNotification(
      topic: topic,
      payload: payload,
      id: id,
      title: title,
      subtitle: subtitle,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.subtitle,
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        payload: notification.toJson(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<int> _notificationCount({String? topic}) async {
    return (await getNotifications(topic: topic)).length;
  }

  static Future<List<LocalNotification>> getNotifications({
    String? topic,
  }) async {
    var pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    final notifications = <LocalNotification>[];
    for (final pendingNotification in pendingNotificationRequests) {
      final payloadJson = jsonDecode(pendingNotification.payload ?? '{}');

      switch (payloadJson) {
        case {
              'topic': final String payloadTopic,
              'payload': final Map<String, dynamic> _,
            }
            when (payloadTopic == topic || topic == null) &&
                payloadJson is Map<String, dynamic>:
          final notification =
              LocalNotification.fromJson(payloadJson, pendingNotification);
          notifications.add(notification);
      }
    }

    return notifications;
  }

  static Future<void> cancelNotifications({String? topic}) async {
    if (topic != null) {
      final notifications = await getNotifications(topic: topic);
      for (var notification in notifications) {
        _flutterLocalNotificationsPlugin.cancel(
          notification.id
        );
      }
    } else {
      _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  static Future<({int totalNotifications, int availableNotifications})>
      totalNotificationsStatus({String? excludingTopic}) async {
    var totalNotifications = switch (Platform.isIOS) {
      true => maxPendingIOSNotifications,
      false => maxPendingAndroidNotifications,
    };

    var pendingNotificationsCount = await _notificationCount();
    final notificationsWithTopicCount =
        await _notificationCount(topic: excludingTopic);
    final totalNonTopicCount = pendingNotificationsCount - notificationsWithTopicCount;

    final availableNotifications =
        totalNotifications - pendingNotificationsCount;

    return (
      totalNotifications: totalNotifications - totalNonTopicCount,
      availableNotifications: availableNotifications
    );
  }
}
