import 'package:courses_repository/courses_repository.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course_event.dart';

class CalendarNotificationsCourse {
  CalendarNotificationsCourse({required this.course, required this.events});

  final Course course;
  final Map<String, CalendarNotificationsCourseEvent> events;
}
