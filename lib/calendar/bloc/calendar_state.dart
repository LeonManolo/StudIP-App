import 'package:calender_repository/calender_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;

/// Possible formats for Calendar (based on TableCalendar)
enum CalendarFormat {
  month,
  twoWeeks,
  week;

  table_calendar.CalendarFormat toTableCalendarFormat() {
    switch (this) {
      case CalendarFormat.month:
        return table_calendar.CalendarFormat.month;
      case CalendarFormat.twoWeeks:
        return table_calendar.CalendarFormat.twoWeeks;
      case CalendarFormat.week:
        return table_calendar.CalendarFormat.week;
    }
  }

  static CalendarFormat fromTableCalendarFormat({
    required table_calendar.CalendarFormat format,
  }) {
    switch (format) {
      case table_calendar.CalendarFormat.month:
        return CalendarFormat.month;
      case table_calendar.CalendarFormat.twoWeeks:
        return CalendarFormat.twoWeeks;
      case table_calendar.CalendarFormat.week:
        return CalendarFormat.week;
    }
  }
}

enum CalendarBodyType {
  timeframes,
  list,
}

sealed class CalendarState extends Equatable {
  const CalendarState(
      {required this.layout,
      required this.currentDay,
      required this.calendarFormat,});

  final CalendarBodyType layout;
  final DateTime currentDay;
  final CalendarFormat calendarFormat;

  @override
  List<Object?> get props => [layout, currentDay, calendarFormat];

  CalendarState copyWith({
    CalendarBodyType? layout,
    DateTime? currentDay,
    CalendarFormat? calendarFormat,
  });
}

class CalendarLoading extends CalendarState {
  const CalendarLoading({
    required super.layout,
    required super.currentDay,
    required super.calendarFormat,
  });
  factory CalendarLoading.fromState(CalendarState state) => CalendarLoading(
        layout: state.layout,
        currentDay: state.currentDay,
        calendarFormat: state.calendarFormat,
      );

  @override
  CalendarLoading copyWith(
      {CalendarBodyType? layout,
      DateTime? currentDay,
      CalendarFormat? calendarFormat,}) {
    return CalendarLoading(
      layout: layout ?? this.layout,
      currentDay: currentDay ?? this.currentDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}

class CalendarPopulated extends CalendarState {
  const CalendarPopulated({
    required this.calendarWeekData,
    required super.currentDay,
    required super.layout,
    required super.calendarFormat,
  });

  final CalendarWeekData calendarWeekData;

  @override
  CalendarPopulated copyWith({
    CalendarBodyType? layout,
    DateTime? currentDay,
    CalendarWeekData? calendarWeekData,
    CalendarFormat? calendarFormat,
  }) {
    return CalendarPopulated(
        layout: layout ?? this.layout,
        currentDay: currentDay ?? this.currentDay,
        calendarWeekData: calendarWeekData ?? this.calendarWeekData,
        calendarFormat: calendarFormat ?? this.calendarFormat,);
  }

  @override
  List<Object?> get props => [calendarWeekData, ...super.props];
}

class CalendarFailure extends CalendarState {
  const CalendarFailure(
      {required this.failureMessage,
      required super.layout,
      required super.currentDay,
      required super.calendarFormat,});

  factory CalendarFailure.fromState(
          {required String failureMessage, required CalendarState state,}) =>
      CalendarFailure(
        failureMessage: failureMessage,
        layout: state.layout,
        currentDay: state.currentDay,
        calendarFormat: state.calendarFormat,
      );

  final String failureMessage;

  @override
  CalendarFailure copyWith({
    CalendarBodyType? layout,
    DateTime? currentDay,
    String? failureMessage,
    CalendarFormat? calendarFormat,
  }) {
    return CalendarFailure(
      layout: layout ?? this.layout,
      currentDay: currentDay ?? this.currentDay,
      failureMessage: failureMessage ?? this.failureMessage,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }

  @override
  List<Object?> get props => [failureMessage, ...super.props];
}
