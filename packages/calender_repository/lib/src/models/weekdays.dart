enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  factory Weekday.fromIndex(int weekdayIndex) => Weekday.values[weekdayIndex];
}
