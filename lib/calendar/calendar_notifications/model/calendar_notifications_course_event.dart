final class CalendarNotificationsCourseEvent {
  CalendarNotificationsCourseEvent({
    required String courseId,
    required this.eventDate,
    required this.eventEndDate,
    this.notificationEnabled = false,
  }) : combinedKey = '${courseId}_/**/${eventDate.toIso8601String()}';

  final String combinedKey;
  final DateTime eventDate;
  final DateTime eventEndDate;
  bool notificationEnabled;
}
