import 'package:calender_repository/calender_repository.dart';
import 'package:equatable/equatable.dart';

sealed class CalendarState extends Equatable {
  const CalendarState(this.layout);

  final CalendarBodyType layout;
}

class CalendarInitial extends CalendarState {
  const CalendarInitial({required CalendarBodyType layout}) : super(layout);

  @override
  List<Object?> get props => [layout];
}

class CalendarLoading extends CalendarState {
  const CalendarLoading({required CalendarBodyType layout}) : super(layout);

  @override
  List<Object?> get props => [layout];
}

class CalendarPopulated extends CalendarState {
  const CalendarPopulated({
    required this.calendarWeekData,
    required this.currentDay,
    required CalendarBodyType layout,
  }) : super(layout);

  final CalendarWeekData calendarWeekData;
  final DateTime currentDay;

  @override
  List<Object?> get props => [calendarWeekData, currentDay, layout];
}

class CalendarFailure extends CalendarState {
  const CalendarFailure({
    required this.failureMessage,
    required CalendarBodyType layout,
    required this.day,
  }) : super(layout);

  final String failureMessage;
  final DateTime day;

  @override
  List<Object?> get props => [failureMessage, layout, day];
}

enum CalendarBodyType {
  timeframes,
  list,
}
