import 'dart:async';

import '../models/models.dart';

abstract class StudIPActivityClient {
  Future<FileActivityListResponse> getFileActivities({
    required String userId,
    required int limit,
  });

  Future<CourseResponse> getCourse({
    required String courseId,
  });

  Future<FileResponse> getFileRef({
    required String fileId,
  });
}
