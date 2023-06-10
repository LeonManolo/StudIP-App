import 'package:calender_repository/calender_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarEntryDataList', () {
    test('insert in empty list', () {
      final List<CalendarEntryData> sut = [];
      final CalendarEntryData newEntry = CalendarEntryData(
        id: '1',
        type: '',
        weekday: Weekday.monday,
        timeframe: CalendarTimeframe(
          start: HourMinute(hours: 10, minutes: 15),
          end: HourMinute(hours: 11, minutes: 15),
        ),
      );

      sut.insertAndMaintainSortOrder(newEntry);

      expect(sut[0], newEntry);
    });

    test('insert in non empty list', () {
      final List<CalendarEntryData> sut = [
        CalendarEntryData(
          id: '1',
          type: '',
          weekday: Weekday.monday,
          timeframe: CalendarTimeframe(
            start: HourMinute(hours: 10, minutes: 15),
            end: HourMinute(hours: 11, minutes: 15),
          ),
        ),
        CalendarEntryData(
          id: '2',
          type: '',
          weekday: Weekday.monday,
          timeframe: CalendarTimeframe(
            start: HourMinute(hours: 15, minutes: 10),
            end: HourMinute(hours: 17, minutes: 20),
          ),
        )
      ];
      final CalendarEntryData newEntry = CalendarEntryData(
        id: '3',
        type: '',
        weekday: Weekday.monday,
        timeframe: CalendarTimeframe(
          start: HourMinute(hours: 10, minutes: 30),
          end: HourMinute(hours: 16, minutes: 30),
        ),
      );

      sut.insertAndMaintainSortOrder(newEntry);

      expect(sut.length, 3);
      expect(sut[1], newEntry);
    });

    test('insert new value at end of list', () {
      final List<CalendarEntryData> sut = [
        CalendarEntryData(
          id: '1',
          type: '',
          weekday: Weekday.monday,
          timeframe: CalendarTimeframe(
            start: HourMinute(hours: 10, minutes: 15),
            end: HourMinute(hours: 11, minutes: 15),
          ),
        )
      ];
      final CalendarEntryData newEntry = CalendarEntryData(
        id: '2',
        type: '',
        weekday: Weekday.monday,
        timeframe: CalendarTimeframe(
          start: HourMinute(hours: 10, minutes: 30),
          end: HourMinute(hours: 16, minutes: 30),
        ),
      );

      sut.insertAndMaintainSortOrder(newEntry);

      expect(sut.length, 2);
      expect(sut[1], newEntry);
    });
  });
}
