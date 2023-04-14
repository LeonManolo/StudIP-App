import 'package:calender_repository/calender_repository.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();

  @override
  List<Object?> get props => [];
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();

  @override
  List<Object?> get props => [];
}

class CalendarPopulated extends CalendarState {
  final CalendarWeekData calendarWeekData;
  final DateTime currentDay;

  const CalendarPopulated({required this.calendarWeekData, required this.currentDay});

  @override
  List<Object?> get props => [calendarWeekData, currentDay];
}

class CalendarFailure extends CalendarState {
  final String failureMessage;

  const CalendarFailure({required this.failureMessage});

  @override
  List<Object?> get props => [failureMessage];
}
