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

class InvalidWeekdayIndex implements Exception {}
