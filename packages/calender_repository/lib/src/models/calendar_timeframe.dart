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

  //TODO: Name ändern ist falsch herum
  bool isInBetween(HourMinute hourMinute) {
    if (hourMinute.hours >= _start.hours &&
        hourMinute.minutes >= _start.minutes) {
      if (hourMinute.hours <= _end.hours &&
          hourMinute.minutes <= _end.minutes) {
        return true;
      }
    }
    return false;
  }
}
