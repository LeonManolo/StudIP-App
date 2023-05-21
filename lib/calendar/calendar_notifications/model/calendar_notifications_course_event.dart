final class CalendarNotificationsCourseEvent {
  CalendarNotificationsCourseEvent({
    required String courseId,
    required this.eventDate,
    this.notificationEnabled = false,
  }) : combinedKey = '${courseId}_/**/${eventDate.toIso8601String()}';

  final String combinedKey;
  final DateTime eventDate;
  bool notificationEnabled;
}
