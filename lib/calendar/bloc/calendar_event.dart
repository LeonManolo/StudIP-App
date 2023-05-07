
import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class CalendarRequested extends CalendarEvent { //TODO: könnte man auch löschen

  const CalendarRequested({ required this.day});
  final DateTime day;

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

class CalendarExactDayRequested extends CalendarEvent {

  const CalendarExactDayRequested({required this.exactDay});
  final DateTime exactDay;

  @override
  List<Object?> get props => [exactDay];
}

//TODO: Pull to refresh? CalendarRefreshRequested
