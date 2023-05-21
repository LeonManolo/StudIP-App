
class CalendarNotificationsCourseEvent {
  CalendarNotificationsCourseEvent({required String courseId, required this.eventDate, required this.notificationEnabled}) :
    combinedKey = '${courseId}_/**/${eventDate.toIso8601String()}';

  final String combinedKey;
  final DateTime eventDate;
  bool notificationEnabled;

}