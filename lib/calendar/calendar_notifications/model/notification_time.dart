part of '../bloc/calendar_notifications_bloc.dart';

enum NotificationTime {
  fifteenMinutesEarly,
  thirtyMinutesEarly,
  sixtyMinutesEarly;

  static NotificationTime fromString(String notificationTime) {
    return NotificationTime.values.firstWhereOrNull(
          (e) => e.toString() == notificationTime,
    ) ??
        NotificationTime.fifteenMinutesEarly;
  }
}
