import 'package:calender_repository/src/models/hour_minute.dart';

class CalendarTimeframe {
  CalendarTimeframe({required HourMinute start, required HourMinute end})
      : _start = start,
        _end = end,
        assert(start.minutesAwayFrom(end) > 0, 'start should be before end');
  final HourMinute _start;
  final HourMinute _end;

  HourMinute get start {
    return _start;
  }

  HourMinute get end {
    return _end;
  }

  String combinedKey() {
    return '${_start.hours}:${_start.minutes} - ${_end.hours}:${_end.minutes}';
  }

  @override
  String toString() {
    String minutesAsStringStart = _start.minutes.toString();
    if (minutesAsStringStart.length == 1) {
      minutesAsStringStart = '0$minutesAsStringStart';
    }
    String minutesAsStringEnd = _end.minutes.toString();
    if (minutesAsStringEnd.length == 1) {
      minutesAsStringEnd = '0$minutesAsStringEnd';
    }
    return '${_start.hours}:$minutesAsStringStart - ${_end.hours}:$minutesAsStringEnd';
  }

  bool containsHourMinute(HourMinute other) {
    if (_start.equals(other) || _end.equals(other)) {
      return true;
    }
    return other.isAfter(_start) && other.isBefore(_end);
  }

  bool containsHourMinuteExclusive(HourMinute hourMinute) {
    return containsHourMinute(hourMinute) &&
        !_start.equals(hourMinute) &&
        !_end.equals(hourMinute);
  }

  // TODO: tests schreiben
  double determinePercentageElapsedByHourMinute(HourMinute hourMinute) {
    if (!containsHourMinute(hourMinute)) {
      return 0;
    }
    final totalMinutes = _start.minutesAwayFrom(_end);
    final minutesUntilReachingEnd = hourMinute.minutesAwayFrom(_end);

    return 1 - minutesUntilReachingEnd / totalMinutes;
  }
}
