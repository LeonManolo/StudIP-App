import 'hour_minute.dart';

class CalendarTimeframe {
  final HourMinute _start;
  final HourMinute _end;

  CalendarTimeframe({required HourMinute start, required HourMinute end})
      : _start = start,
        _end = end,
        assert(start.minutesAwayFrom(end) > 0);

  HourMinute get start {
    return _start;
  }

  HourMinute get end {
    return _end;
  }

  String combinedKey() {
    return "${_start.hours}:${_start.minutes} - ${_end.hours}:${_end.minutes}";
  }

  @override
  String toString() {
    String minutesAsStringStart = _start.minutes.toString();
    if (minutesAsStringStart.length == 1) {
      minutesAsStringStart = "0$minutesAsStringStart";
    }
    String minutesAsStringEnd = _end.minutes.toString();
    if (minutesAsStringEnd.length == 1) {
      minutesAsStringEnd = "0$minutesAsStringEnd";
    }
    return "${_start.hours}:$minutesAsStringStart - ${_end.hours}:$minutesAsStringEnd";
  }

  bool containsHourMinute(HourMinute other) {
    if (_start.equals(other) || _end.equals(other)) {
      return true;
    }
    return other.isAfter(_start) && other.isBefore(_end);
  }

  double determinePercentageElapsedByHourMinute(HourMinute hourMinute) {
    if (!containsHourMinute(hourMinute)) {
      return 0;
    }
    final totalMinutes = _start.minutesAwayFrom(_end);
    final minutesUntilReachingEnd = hourMinute.minutesAwayFrom(_end);
    print(this);
    print(hourMinute);
    print(minutesUntilReachingEnd);

    final result = (1 - minutesUntilReachingEnd / totalMinutes);
    print("result: $result");
    return 1 - minutesUntilReachingEnd / totalMinutes;
  }
}
