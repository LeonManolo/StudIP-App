part of 'calendar_notifications_bloc.dart';

sealed class CalendarNotificationsState extends Equatable {
  const CalendarNotificationsState();
}

final class CalendarNotificationsInitial extends CalendarNotificationsState {
  const CalendarNotificationsInitial();

  @override
  List<Object?> get props => [];
}

final class CalendarNotificationsLoading extends CalendarNotificationsState {
  const CalendarNotificationsLoading();

  @override
  List<Object?> get props => [];
}

final class CalendarNotificationsPopulated extends CalendarNotificationsState {
  const CalendarNotificationsPopulated({
    required this.courses,
    required this.totalNotifications,
    this.notificationsSaved = false,
  });

  final bool notificationsSaved;
  final int totalNotifications;
  final List<CalendarNotificationsCourse> courses;

  @override
  List<Object?> get props => [courses, notificationsSaved];
}

final class CalendarNotificationsFailure extends CalendarNotificationsState {
  @override
  List<Object?> get props => [];
}
