import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:studipadawan/calendar/bloc/calendar_event.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;

  CalendarBloc({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authenticationRepository,
  })
      : _calendarRepository = calendarRepository,
        _authenticationRepository = authenticationRepository,
        super(const CalendarInitial()) {
    on<CalendarRequested>(_onCalendarRequested);
    on<CalendarNextDayRequested>(_onCalendarNextDayRequested);
    on<CalendarPreviousDayRequested>(_onCalendarPreviousDayRequested);
    on<CalendarExactDayRequested>(_onCalendarExactDayRequested);
  }

  FutureOr<void> _onCalendarRequested(CalendarRequested event,
      Emitter<CalendarState> emit) async {
    final day = event.day;
    emit(const CalendarLoading());
    final calendar = await _fetchCalendar(day);
    emit(CalendarPopulated(calendarWeekData: calendar, currentDay: day));
  }

  FutureOr<void> _onCalendarNextDayRequested(CalendarNextDayRequested event,
      Emitter<CalendarState> emit) async {
    if (state is CalendarPopulated) {
      try {
        final nextDay = (state as CalendarPopulated)
            .currentDay
            .add(const Duration(days: 1));
        emit(const CalendarLoading());
        final calendar = await _fetchCalendar(nextDay);
        emit(
          CalendarPopulated(calendarWeekData: calendar, currentDay: nextDay),
        );
      } catch (e) {
        emit(CalendarFailure(failureMessage: e.toString()));
      }
    }
  }

  FutureOr<void> _onCalendarPreviousDayRequested(
      CalendarPreviousDayRequested event, Emitter<CalendarState> emit) async {
    if (state is CalendarPopulated) {
      try {
        final previous = (state as CalendarPopulated)
            .currentDay
            .subtract(const Duration(days: 1));
        emit(const CalendarLoading());
        final calendar = await _fetchCalendar(previous);
        emit(
          CalendarPopulated(calendarWeekData: calendar, currentDay: previous),
        );
      } catch (e) {
        emit(CalendarFailure(failureMessage: e.toString()));
      }
    }
  }

  Future<CalendarWeekData> _fetchCalendar(DateTime day) async {
    return await _calendarRepository.getCalenderSchedule(
      userId: _authenticationRepository.currentUser.id,
      dateTime: day,
    );
  }

  FutureOr<void> _onCalendarExactDayRequested(CalendarExactDayRequested event,
      Emitter<CalendarState> emit) async {
    final day = event.exactDay;
    emit(const CalendarLoading());
    final calendar = await _fetchCalendar(day);
    emit(CalendarPopulated(calendarWeekData: calendar, currentDay: day));
  }
}
