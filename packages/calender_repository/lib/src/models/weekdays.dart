enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  static Weekdays indexToWeekday(int index) {
    switch (index) {
      case 0:
        {
          return Weekdays.monday;
        }
      case 1:
        {
          return Weekdays.tuesday;
        }
      case 2:
        {
          return Weekdays.wednesday;
        }
      case 3:
        {
          return Weekdays.thursday;
        }
      case 4:
        {
          return Weekdays.friday;
        }
      case 5:
        {
          return Weekdays.saturday;
        }
      case 6:
        {
          return Weekdays.sunday;
        }
      default:
        {
          throw InvalidWeekdayIndex();
        }
    }
  }

  static List<Weekdays> toList() {
    final list = [
      Weekdays.monday,
      Weekdays.tuesday,
      Weekdays.wednesday,
      Weekdays.thursday,
      Weekdays.friday,
      Weekdays.saturday,
      Weekdays.sunday
    ];
    return list;
  }
}

extension on Weekdays {
  int index() {
    switch (this) {
      case Weekdays.monday:
        {
          return 0;
        }
      case Weekdays.tuesday:
        {
          return 1;
        }
      case Weekdays.wednesday:
        {
          return 2;
        }
      case Weekdays.thursday:
        {
          return 3;
        }
      case Weekdays.friday:
        {
          return 4;
        }
      case Weekdays.saturday:
        {
          return 5;
        }
      case Weekdays.sunday:
        {
          return 6;
        }
    }
  }
}

class InvalidWeekdayIndex implements Exception {}
