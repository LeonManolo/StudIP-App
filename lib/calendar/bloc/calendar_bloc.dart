import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:studipadawan/calendar/bloc/calendar_event.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _calendarRepository = calendarRepository,
        _authenticationRepository = authenticationRepository,
        super(
          CalendarLoading(
            layout: CalendarBodyType.list,
            currentDay: DateTime.now(),
            calendarFormat: CalendarFormat.week,
          ),
        ) {
    on<CalendarRequested>(_onCalendarRequested);
    on<CalendarExactDayRequested>(_onCalendarExactDayRequested);
    on<CalendarSwitchLayoutRequested>(_onCalendarSwitchLayoutRequested);
    on<CalendarFormatChangeRequest>(_onCalendarFormatChangeRequest);
  }

  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    final day = event.day;

    emit(CalendarLoading.fromState(state.copyWith(currentDay: day)));

    try {
      final calendarSchedule = await _fetchCalendarSchedule(day);
      emit(
        CalendarPopulated(
          calendarWeekData: calendarSchedule,
          currentDay: day,
          layout: event.layout,
          calendarFormat: state.calendarFormat,
        ),
      );
    } catch (e) {
      emit(
        CalendarFailure.fromState(
          failureMessage: e.toString(),
          state: state,
        ),
      );
    }
  }

  Future<CalendarWeekData> _fetchCalendarSchedule(
    DateTime semesterDateTime,
  ) async {
    return _calendarRepository.getCalendarSchedule(
      userId: _authenticationRepository.currentUser.id,
      requestedSemester: semesterDateTime,
      currentDateTime: DateTime.now(),
    );
  }

  FutureOr<void> _onCalendarExactDayRequested(
    CalendarExactDayRequested event,
    Emitter<CalendarState> emit,
  ) async {
    final day = event.exactDay;
    emit(CalendarLoading.fromState(state.copyWith(currentDay: day)));

    try {
      final calendarSchedule = await _fetchCalendarSchedule(day);
      emit(
        CalendarPopulated(
          calendarWeekData: calendarSchedule,
          currentDay: day,
          layout: state.layout,
          calendarFormat: state.calendarFormat,
        ),
      );
    } catch (e) {
      emit(
        CalendarFailure.fromState(
          failureMessage: e.toString(),
          state: state,
        ),
      );
    }
  }

  FutureOr<void> _onCalendarSwitchLayoutRequested(
    CalendarSwitchLayoutRequested event,
    Emitter<CalendarState> emit,
  ) {
    final layout = state.layout == CalendarBodyType.list
        ? CalendarBodyType.timeframes
        : CalendarBodyType.list;

    emit(state.copyWith(layout: layout));
  }

  FutureOr<void> _onCalendarFormatChangeRequest(
    CalendarFormatChangeRequest event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(calendarFormat: event.requestedCalendarFormat));
  }
}
