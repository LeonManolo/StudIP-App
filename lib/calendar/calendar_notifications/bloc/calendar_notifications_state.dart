import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course.dart';

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
  const CalendarNotificationsPopulated({ required this.courses});

  final List<CalendarNotificationsCourse> courses;

  @override
  List<Object?> get props => [courses];
}

final class CalendarNotificationsFailure extends CalendarNotificationsState {
  @override
  List<Object?> get props => [];
}