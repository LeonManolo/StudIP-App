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

  const CalendarPopulated({required this.calendarWeekData, required this.currentDay});
  final CalendarWeekData calendarWeekData;
  final DateTime currentDay;

  @override
  List<Object?> get props => [calendarWeekData, currentDay];
}

class CalendarFailure extends CalendarState {

  const CalendarFailure({required this.failureMessage});
  final String failureMessage;

  @override
  List<Object?> get props => [failureMessage];
}
