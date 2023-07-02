part of 'calendar_course_bloc.dart';

abstract class CalendarCourseEvent extends Equatable {
  const CalendarCourseEvent();

  @override
  List<Object> get props => [];
}

final class CalendarCourseRequested extends CalendarCourseEvent {}
