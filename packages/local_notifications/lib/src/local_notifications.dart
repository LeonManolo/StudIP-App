import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

import 'models/local_notification.dart';
import 'extensions/max_int.dart';

/// Provides local notification services using `FlutterLocalNotificationsPlugin`.
final class LocalNotifications {
  /// Samsung's implementation of Android has imposed a maximum of 500 alarms that can be scheduled via the Alarm Manager API
  static const maxPendingAndroidNotifications = 500;

  /// There is a limit imposed by iOS where it will only keep 64 notifications that will fire the soonest.
  static const maxPendingIOSNotifications = 64;

  static const androidDefaultChannelId = 'default';

  /// Is the ID of the notification channel. This is required for Android 8.0 and above.
  static late final String _androidChannelId;

  /// Is the name of the notification channel. This will be visible for the users in the system settings.
  static late final String _androidChannelName;

  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification plugin with specific settings for Android and iOS.
  /// Also sets the time zone to the given [timezoneName].
  static Future<void> initialize(
      {
        required String androidChannelId,
        required String androidChannelName,
        required String androidChannelDescription,
        String timezoneName = 'Europe/Berlin'}) async {
    // Android initialization
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

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

    _androidChannelId = androidChannelId;
    _androidChannelName = androidChannelName;
    AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
      _androidChannelId,
      _androidChannelName,
      description: androidChannelDescription,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  /// Schedule a notification to be shown at a specific date and time.
  /// You can also optionally set a [topic], [androidTopicDescription],
  /// [payload], and [timezoneName].
  static Future<void> scheduleNotification({
    required String title,
    required String subtitle,
    required DateTime showAt,
    String? topic,
    String? androidTopicDescription,
    Map<String, dynamic> payload = const {},
    String? timezoneName,
  }) async {
    final timezone =
        timezoneName == null ? tz.local : tz.getLocation(timezoneName);

    final scheduledDate = tz.TZDateTime.from(showAt, timezone);

    final id = Random().nextInt(10000); //await _notificationCount();
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
        _buildNotificationDetails(),
        payload: notification.toJson(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Returns a list of all pending notifications.
  /// If a [topic] is provided, only returns notifications for that topic.
  static Future<List<LocalNotification>> getNotifications({
    String? topic,
  }) async {
    var pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(pendingNotificationRequests);

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

  /// Cancels all pending notifications.
  /// If a [topic] is provided, only cancels notifications for that topic.
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

  /// Returns a record containing the total number of notifications and the number of available notifications.
  /// The [excludingTopic] parameter allows to exclude notifications of a specific topic from the count.
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

  /// Helper method that returns the total count of notifications.
  /// If a [topic] is provided, it returns the count of notifications for that specific topic.
  static Future<int> _notificationCount({String? topic}) async {
    return (await getNotifications(topic: topic)).length;
  }

  /// Builds and returns a `NotificationDetails` instance with specific details for Android and iOS platforms.
  static NotificationDetails _buildNotificationDetails(
      ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(_androidChannelId, _androidChannelName),
      iOS: DarwinNotificationDetails(),
    );
  }
}
