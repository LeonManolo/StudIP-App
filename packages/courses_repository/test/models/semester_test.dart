import 'package:courses_repository/courses_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;

void main() {
  group('test semester date conversion', () {
    final semesterResponse = studip_api_client.SemesterResponse.fromJson({
      'data': {
        'type': 'semesters',
        'id': 'c3361be2abf51c4e36701f84b42c09e7',
        'attributes': {
          'title': 'WS 2021/2022',
          'description': '',
          'token': '',
          'start': '2021-08-01T00:00:00+02:00',
          'end': '2022-02-28T23:59:59+01:00',
          'start-of-lectures': '2021-09-20T00:00:00+02:00',
          'end-of-lectures': '2022-01-25T23:59:59+01:00',
          'visible': true
        },
        'links': {
          'self': '/jsonapi.php/v1/semesters/c3361be2abf51c4e36701f84b42c09e7'
        }
      }
    });

    test('Init with Semester API Response', () {
      final semester = Semester.fromSemesterResponse(
          semesterResponse: semesterResponse, courses: [],);

      expect(semester.lecturesTimeSpan, '20.09.2021 - 25.01.2022');
      expect(semester.semesterTimeSpan, '01.08.2021 - 28.02.2022');
    });
  });
}
