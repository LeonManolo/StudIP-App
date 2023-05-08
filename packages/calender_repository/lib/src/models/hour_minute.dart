class HourMinute {
  HourMinute({required int hours, required int minutes}) {
    _hours = hours % 24;
    final double leftOverHours = minutes.toDouble() / 60;

    if (leftOverHours >= 1) {
      _hours += leftOverHours.truncate();
      _hours %= 24;
      minutes = _minutes % 60;
    } else {
      _minutes = minutes;
    }
  }

  HourMinute.fromDateTime({required DateTime dateTime})
      : _hours = dateTime.hour,
        _minutes = dateTime.minute;
  int _hours = 0;
  int _minutes = 0;

  int get minutes {
    return _minutes;
  }

  int get hours {
    return _hours;
  }

  int minutesAwayFrom(HourMinute hourMinute) {
    final int hoursAway = hourMinute.hours - _hours;
    final int minutesAway = hoursAway * 60;
    return minutesAway + (hourMinute.minutes - _minutes);
  }

  bool isBefore(HourMinute other) {
    if (other.hours > _hours) {
      return true;
    }
    return other.hours == _hours && other.minutes > _minutes;
  }

  bool isAfter(HourMinute other) {
    if (_hours > other.hours) {
      return true;
    }
    return _hours == other._hours && _minutes > other.minutes;
  }

  bool equals(HourMinute other) {
    return _hours == other.hours && _minutes == other.minutes;
  }

  // TODO: addMinutes tests schreiben
  HourMinute addMinutes(int minutesToAdd) {
    final int totalMinutes = _minutes + minutesToAdd;
    final int extraHours = totalMinutes ~/ 60;
    final int newMinutes = totalMinutes % 60;
    final int newHours = (_hours + extraHours) % 24;

    return HourMinute(hours: newHours, minutes: newMinutes);
  }

  @override
  String toString() {
    final String hourString = _hours.toString();
    String minutesString = _minutes.toString();
    if (minutesString.length == 1) {
      minutesString = '0$minutesString';
    }
    return '$hourString:$minutesString';
  }
}
