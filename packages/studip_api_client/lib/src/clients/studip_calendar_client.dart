import '../models/models.dart';

abstract class StudIPCalendarClient {
  Future<ScheduleResponse> getSchedule(
      {required String userId, DateTime? semesterStart});
}
