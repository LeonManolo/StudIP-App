import 'package:courses_repository/courses_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;

void main() {
  group("test event date conversion", () {
    final courseEventResponse = studip_api_client.CourseEventResponse.fromJson({
      "type": "course-events",
      "id": "015e133e3ac12de8e63520a92c355ba2",
      "attributes": {
        "title": "Veranstaltung am Donnerstag 10:00 bis 11:30",
        "description": "",
        "start": "2023-04-13T10:00:00+02:00",
        "end": "2023-04-13T11:30:00+02:00",
        "categories": ["Vorlesung"],
        "location": null,
        "mkdate": "2023-04-20T20:17:21+02:00",
        "chdate": "2023-04-20T20:17:21+02:00"
      }
    });

    test("Init with CourseEventResponse", () {
      final courseEvent = StudIPCourseEvent.fromCourseEventResponse(
        courseEventResponse: courseEventResponse,
      );

      expect(courseEvent.getEventTimeSpan, "13.04.2023 (10:00 - 11:30)");
    });
  });
}
