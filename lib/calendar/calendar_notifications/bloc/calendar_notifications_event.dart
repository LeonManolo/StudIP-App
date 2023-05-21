import 'package:equatable/equatable.dart';

//TODO: sealed machen
abstract class CalendarNotificationsEvent extends Equatable {
  const CalendarNotificationsEvent();
}

final class CalendarNotificationsRequested extends CalendarNotificationsEvent {
  const CalendarNotificationsRequested();

  @override
  List<Object?> get props => [];
}

final class CalendarNotificationsSelected extends CalendarNotificationsEvent {
  const CalendarNotificationsSelected(
      {required this.courseEventKey,
      required this.courseId,
      required this.notificationEnabled});

  final String courseEventKey;
  final String courseId;
  final bool notificationEnabled;

  @override
  List<Object?> get props => [courseId, courseEventKey];
}

final class CalendarNotificationsSaveAll extends CalendarNotificationsEvent {
  const CalendarNotificationsSaveAll();

  @override
  List<Object?> get props => [];
}
