part of '../bloc/calendar_notifications_bloc.dart';

enum NotificationTime {
  fifteenMinutesEarly,
  thirtyMinutesEarly,
  sixtyMinutesEarly;

  static NotificationTime fromString(String notificationTimeString) {
    return NotificationTime.values.firstWhereOrNull(
          (notificationTime) =>
              notificationTime.toString() == notificationTimeString,
        ) ??
        NotificationTime.fifteenMinutesEarly;
  }

  int toInt() {
    return switch (this) {
      fifteenMinutesEarly => 15,
      thirtyMinutesEarly => 30,
      sixtyMinutesEarly => 60,
    };
  }
}
