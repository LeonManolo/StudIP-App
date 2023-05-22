part of 'calendar_notifications_bloc.dart';

sealed class CalendarNotificationsState extends Equatable {
  const CalendarNotificationsState(this.notificationTime);

  final NotificationTime notificationTime;
}

final class CalendarNotificationsInitial extends CalendarNotificationsState {
  const CalendarNotificationsInitial({
    required NotificationTime notificationTime,
  }) : super(notificationTime);

  @override
  List<Object?> get props => [notificationTime];
}

final class CalendarNotificationsLoading extends CalendarNotificationsState {
  const CalendarNotificationsLoading({
    required NotificationTime notificationTime,
  }) : super(notificationTime);

  @override
  List<Object?> get props => [notificationTime];
}

final class CalendarNotificationsPopulated extends CalendarNotificationsState {
  const CalendarNotificationsPopulated({
    required this.courses,
    required this.totalNotifications,
    this.notificationsSaved = false,
    required NotificationTime notificationTime,
  }) : super(notificationTime);

  final bool notificationsSaved;
  final int totalNotifications;
  final List<CalendarNotificationsCourse> courses;

  @override
  List<Object?> get props => [courses, notificationsSaved, notificationTime];
}

final class CalendarNotificationsFailure extends CalendarNotificationsState {
  const CalendarNotificationsFailure({
    required NotificationTime notificationTime,
  }) : super(notificationTime);

  @override
  List<Object?> get props => [notificationTime];
}
