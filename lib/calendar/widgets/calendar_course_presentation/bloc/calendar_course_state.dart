part of 'calendar_course_bloc.dart';

sealed class CalendarCourseState extends Equatable {
  const CalendarCourseState();

  @override
  List<Object> get props => [];
}

class CalendarCourseStateLoading extends CalendarCourseState {}

class CalendarCourseStateCourseDidLoad extends CalendarCourseState {
  const CalendarCourseStateCourseDidLoad({required this.course});

  final Course course;
}

class CalendarCourseStateError extends CalendarCourseState {
  const CalendarCourseStateError({required this.errorMessage});

  final String errorMessage;
}
