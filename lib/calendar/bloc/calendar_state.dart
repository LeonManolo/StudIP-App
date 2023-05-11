import 'package:calender_repository/calender_repository.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState(this.layout);

  final CalendarLayout layout;
}

class CalendarInitial extends CalendarState {
  const CalendarInitial({required CalendarLayout layout}) : super(layout);

  @override
  List<Object?> get props => [layout];
}

class CalendarLoading extends CalendarState {
  const CalendarLoading({required CalendarLayout layout}) : super(layout);

  @override
  List<Object?> get props => [layout];
}

class CalendarPopulated extends CalendarState {
  const CalendarPopulated({
    required this.calendarWeekData,
    required this.currentDay,
    required CalendarLayout layout,
  }) : super(layout);

  final CalendarWeekData calendarWeekData;
  final DateTime currentDay;

  @override
  List<Object?> get props => [calendarWeekData, currentDay, layout];
}

class CalendarFailure extends CalendarState {
  const CalendarFailure({
    required this.failureMessage,
    required CalendarLayout layout,
  }) : super(layout);

  final String failureMessage;

  @override
  List<Object?> get props => [failureMessage];
}

enum CalendarLayout {
  withTimeIndicators,
  withoutTimeIndicators,
}
