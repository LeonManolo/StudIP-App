class HourMinute {
  int _hours = 0;
  int _minutes = 0;

  HourMinute({required int hours, required int minutes}) {
    _hours = hours % 24;
    double leftOverHours = minutes.toDouble() / 60;

    if (leftOverHours >= 1) {
      _hours += leftOverHours.truncate();
      _hours %= 24;
      minutes = _minutes % 60;
    } else {
      _minutes = minutes;
    }
  }

  int get minutes {
    return _minutes;
  }

  int get hours {
    return _hours;
  }

  int minutesAwayFrom(HourMinute hourMinute) {
    int hoursAway = hourMinute.hours - _hours;
    int minutesAway = hoursAway * 60;
    minutesAway += hourMinute.minutes - _minutes;

    return minutesAway;
  }

  @override
  String toString() {
    String hourString = _hours.toString();
    String minutesString = _minutes.toString();
    if (minutesString.length == 1) {
      minutesString = "0$minutesString";
    }
    return "$hourString:$minutesString";
  }
}
