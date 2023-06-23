import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final class LocalNotification {
  LocalNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.topic,
    required this.payload,
  });

  LocalNotification.fromJson(
    Map<String, dynamic> payloadJson,
    PendingNotificationRequest pendingNotificationRequest,
  )   : topic = payloadJson['topic'] as String?,
        payload = payloadJson['payload'] as Map<String, dynamic>,
        id = pendingNotificationRequest.id,
        title = pendingNotificationRequest.title!,
        // Only available on Android
        subtitle = pendingNotificationRequest.body ?? '';
  final int id;
  final String? topic;
  final String title;
  final String subtitle;
  final Map<String, dynamic> payload;

  String toJson() {
    return jsonEncode({
      'topic': topic,
      'payload': payload,
    });
  }
}
