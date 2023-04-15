
import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class CalendarRequested extends CalendarEvent {
  final DateTime day; //TODO: könnte man auch löschen

  const CalendarRequested({ required this.day});

  @override
  List<Object?> get props => [day];
}

class CalendarNextDayRequested extends CalendarEvent {

  const CalendarNextDayRequested();

  @override
  List<Object?> get props => [];
}

class CalendarPreviousDayRequested extends CalendarEvent {

  const CalendarPreviousDayRequested();

  @override
  List<Object?> get props => [];
}

//TODO: Pull to refresh? CalendarRefreshRequested

