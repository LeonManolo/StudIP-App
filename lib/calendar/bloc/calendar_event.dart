
import 'package:equatable/equatable.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

final class CalendarRequested extends CalendarEvent {

  const CalendarRequested({ required this.day, required this.layout});
  final DateTime day;
  final CalendarBodyType layout;

  @override
  List<Object?> get props => [day, layout];
}

final class CalendarNextDayRequested extends CalendarEvent {

  const CalendarNextDayRequested();

  @override
  List<Object?> get props => [];
}

final class CalendarPreviousDayRequested extends CalendarEvent {

  const CalendarPreviousDayRequested();

  @override
  List<Object?> get props => [];
}

final class CalendarExactDayRequested extends CalendarEvent {

  const CalendarExactDayRequested({required this.exactDay});
  final DateTime exactDay;

  @override
  List<Object?> get props => [exactDay];
}

final class CalendarSwitchLayoutRequested extends CalendarEvent {

  const CalendarSwitchLayoutRequested();

  @override
  List<Object?> get props => [];
}


//TODO: Pull to refresh? CalendarRefreshRequested
