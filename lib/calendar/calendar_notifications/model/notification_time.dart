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

  int toInt() {
    return switch (this) {
      fifteenMinutesEarly => 15,
      thirtyMinutesEarly => 30,
      sixtyMinutesEarly => 60,
    };
  }
}
