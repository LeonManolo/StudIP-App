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
        super(const CalendarInitial(layout: CalendarLayout.withoutTimeIndicators)) {
    on<CalendarRequested>(_onCalendarRequested);
    on<CalendarNextDayRequested>(_onCalendarNextDayRequested);
    on<CalendarPreviousDayRequested>(_onCalendarPreviousDayRequested);
    on<CalendarExactDayRequested>(_onCalendarExactDayRequested);
    on<CalendarSwitchLayoutRequested>(_onCalendarSwitchLayoutRequested);
  }

  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    final day = event.day;
    emit(CalendarLoading(layout: state.layout));
    final calendar = await _fetchCalendar(day);
    print("calendar ${calendar.data}");
    emit(
      CalendarPopulated(
        calendarWeekData: calendar,
        currentDay: day,
        layout: event.layout,
      ),
    );
  }

  FutureOr<void> _onCalendarNextDayRequested(
    CalendarNextDayRequested event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarPopulated) {
      try {
        final currentState = state as CalendarPopulated;
        final nextDay = currentState.currentDay.add(const Duration(days: 1));
        emit(CalendarLoading(layout: state.layout));
        final calendar = await _fetchCalendar(nextDay);
        emit(
          CalendarPopulated(
            calendarWeekData: calendar,
            currentDay: nextDay,
            layout: currentState.layout,
          ),
        );
      } catch (e) {
        emit(CalendarFailure(failureMessage: e.toString(), layout: state.layout));
      }
    }
  }

  FutureOr<void> _onCalendarPreviousDayRequested(
    CalendarPreviousDayRequested event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarPopulated) {
      try {
        final currentState = state as CalendarPopulated;
        final previousDay =
            currentState.currentDay.subtract(const Duration(days: 1));

        emit(CalendarLoading(layout: state.layout));
        final calendar = await _fetchCalendar(previousDay);
        emit(
          CalendarPopulated(
            calendarWeekData: calendar,
            currentDay: previousDay,
            layout: currentState.layout,
          ),
        );
      } catch (e) {
        emit(CalendarFailure(failureMessage: e.toString(), layout: state.layout));
      }
    }
  }

  Future<CalendarWeekData> _fetchCalendar(DateTime day) async {
    return _calendarRepository.getCalenderSchedule(
      userId: _authenticationRepository.currentUser.id,
      dateTime: day,
    );
  }

  FutureOr<void> _onCalendarExactDayRequested(
    CalendarExactDayRequested event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarPopulated) {
      final currentState = state as CalendarPopulated;
      final day = event.exactDay;
      emit(CalendarLoading(layout: state.layout));
      final calendar = await _fetchCalendar(day);
      emit(
        CalendarPopulated(
          calendarWeekData: calendar,
          currentDay: day,
          layout: currentState.layout,
        ),
      );
    }
  }

  FutureOr<void> _onCalendarSwitchLayoutRequested(
      CalendarSwitchLayoutRequested event, Emitter<CalendarState> emit) {
    if (state is CalendarPopulated) {
      final currentState = state as CalendarPopulated;
      final layout = currentState.layout == CalendarLayout.withoutTimeIndicators
          ? CalendarLayout.withTimeIndicators
          : CalendarLayout.withoutTimeIndicators;

      emit(
        CalendarPopulated(
          calendarWeekData: currentState.calendarWeekData,
          currentDay: currentState.currentDay,
          layout: layout,
        ),
      );
    }
  }
}
