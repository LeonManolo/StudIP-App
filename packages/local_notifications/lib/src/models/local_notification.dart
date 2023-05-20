import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final int id;
  final String? topic;
  final String title;
  final String subtitle;
  final Map<String, dynamic> payload;

  LocalNotification(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.topic,
      required this.payload});

  String toJson() {
    return jsonEncode({
      "topic": topic,
      "payload": jsonEncode(payload),
    });
  }

  LocalNotification.fromJson(Map<String, dynamic> payloadJson,
      PendingNotificationRequest pendingNotificationRequest)
      : topic = payloadJson["topic"],
        payload = payloadJson["payload"],
        id = pendingNotificationRequest.id,
        title = pendingNotificationRequest.title!,
        subtitle = pendingNotificationRequest.body!;
}
