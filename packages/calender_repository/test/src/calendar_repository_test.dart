import 'dart:convert';

import 'package:calender_repository/calender_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studip_api_client/studip_api_client.dart';

class MockStudIPCalendarClient extends Mock implements StudIPCalendarClient {}

void main() {
  late CalenderRepository sut;
  late MockStudIPCalendarClient mockedApiClient;

  const rawScheduleResponse = '''
    {
    "meta": {
        "semester": "/jsonapi.php/v1/semesters/322f640f3f4643ebe514df65f1163eb1"
    },
    "links": {
        "self": "/jsonapi.php/v1/users/f6e5879dd84fe0f21eae9f0627d4f807/schedule?filter%5Btimestamp%5D=1680300000"
    },
    "data": [
              {
                "type": "seminar-cycle-dates",
                "id": "26540cfa2dfa122a34f161168db1e685",
                "attributes": {
                    "title": "Vorlesung 1",
                    "description": null,
                    "start": "14:00",
                    "end": "14:30",
                    "weekday": 1,
                    "recurrence": {
                        "FREQ": "WEEKLY",
                        "INTERVAL": 2,
                        "DTSTART": "2023-04-17T14:00:00+02:00",
                        "UNTIL": "2023-07-10T14:00:00+02:00",
                        "EXDATES": [
                            "2023-05-01T14:00:00+02:00",
                            "2023-05-29T14:00:00+02:00"
                        ]
                    },
                    "locations": []
                },
                "relationships": {
                    "owner": {
                        "links": {
                            "related": "/jsonapi.php/v1/courses/659293838e125e2fbf889210672a100f"
                        },
                        "data": {
                            "type": "courses",
                            "id": "659293838e125e2fbf889210672a100f"
                        }
                    }
                },
                "links": {
                    "self": "/jsonapi.php/v1/seminar-cycle-dates/26540cfa2dfa122a34f161168db1e685"
                }
              }
      ]
    }
    ''';

  setUp(() {
    mockedApiClient = MockStudIPCalendarClient();
    sut = CalenderRepository(apiClient: mockedApiClient);
  });

  group('getCalendarSchedule', () {
    test('return schedule entry', () async {
      when(
        () => mockedApiClient.getSchedule(
          userId: 'f6e5879dd84fe0f21eae9f0627d4f807',
          semesterStart: DateTime(2023, 5, 15, 17, 14),
        ),
      ).thenAnswer((_) async {
        return ScheduleListResponse.fromJson(
          jsonDecode(rawScheduleResponse) as Map<String, dynamic>,
        );
      });

      final CalendarWeekData calendarWeekData = await sut.getCalendarSchedule(
        userId: 'f6e5879dd84fe0f21eae9f0627d4f807',
        requestedDateTime: DateTime(2023, 5, 15, 17, 14),
      );

      final scheduleTitle =
          calendarWeekData.data[Weekday.monday]?['14:0 - 14:30']?.first;

      expect(
        calendarWeekData.data.entries.isEmpty,
        false,
      );
      expect(scheduleTitle?.title, 'Vorlesung 1');
    });

    test("don't return schedule entry because of excluded dates", () async {
      when(
        () => mockedApiClient.getSchedule(
          userId: 'f6e5879dd84fe0f21eae9f0627d4f807',
          semesterStart: DateTime(2023, 5, 1, 17, 14),
        ),
      ).thenAnswer((_) async {
        return ScheduleListResponse.fromJson(
          jsonDecode(rawScheduleResponse) as Map<String, dynamic>,
        );
      });

      final CalendarWeekData calendarWeekData = await sut.getCalendarSchedule(
        userId: 'f6e5879dd84fe0f21eae9f0627d4f807',
        requestedDateTime: DateTime(2023, 5, 1, 17, 14),
      );

      expect(
        calendarWeekData.data.entries.isEmpty,
        true,
      );
    });

    test("don't return schedule entry because of interval", () async {
      when(
        () => mockedApiClient.getSchedule(
          userId: 'f6e5879dd84fe0f21eae9f0627d4f807',
          semesterStart: DateTime(2023, 6, 19, 17, 14),
        ),
      ).thenAnswer((_) async {
        return ScheduleListResponse.fromJson(
          jsonDecode(rawScheduleResponse) as Map<String, dynamic>,
        );
      });

      final CalendarWeekData calendarWeekData = await sut.getCalendarSchedule(
        userId: 'f6e5879dd84fe0f21eae9f0627d4f807',
        requestedDateTime: DateTime(2023, 6, 19, 17, 14),
      );

      expect(
        calendarWeekData.data.entries.isEmpty,
        true,
      );
    });
  });
}
