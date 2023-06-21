import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';

import '../core/interfaces/studip_http_request_core.dart';
import '../models/models.dart';

abstract interface class StudIPCoursesClient {
  Future<CourseListResponse> getCourses({
    required String userId,
    required int offset,
    required int limit,
  });

  Future<SemesterResponse> getSemester({
    required String semesterId,
  });

  Future<CourseNewsResponse> getCourseNews({
    required String courseId,
    required int limit,
    required int offset,
  });

  Future<CourseEventResponse> getCourseEvents({
    required String courseId,
    required int offset,
    required int limit,
  });

  Future<CourseWikiPagesListResponse> getCourseWikiPages({
    required String courseId,
    required int offset,
    required int limit,
  });

  Future<CourseParticipantsResponse> getCourseParticipants({
    required String courseId,
    required int offset,
    required int limit,
  });

  Future<CourseResponse> getCourse({
    required String courseId,
  });
}

class StudIPCoursesClientImpl implements StudIPCoursesClient {
  final StudIpHttpCore _core;

  StudIPCoursesClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;
  @override
  Future<CourseListResponse> getCourses(
      {required String userId, required int offset, required int limit}) async {
    final response =
        await _core.get(endpoint: "users/$userId/courses", queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit",
    });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return CourseListResponse.fromJson(body);
  }

  @override
  Future<SemesterResponse> getSemester({required String semesterId}) async {
    final response = await _core.get(endpoint: "semesters/$semesterId");

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return SemesterResponse.fromJson(body);
  }

  @override
  Future<CourseNewsResponse> getCourseNews({
    required String courseId,
    required int limit,
    required int offset,
  }) async {
    final response = await _core.get(
        endpoint: "courses/$courseId/news",
        queryParameters: {"page[limit]": "$limit", "page[offset]": "$offset"});

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return CourseNewsResponse.fromJson(body);
  }

  @override
  Future<CourseEventResponse> getCourseEvents({
    required String courseId,
    required int offset,
    required int limit,
  }) async {
    final response =
        await _core.get(endpoint: "courses/$courseId/events", queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit",
    });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return CourseEventResponse.fromJson(body);
  }

  @override
  Future<CourseWikiPagesListResponse> getCourseWikiPages({
    required String courseId,
    required int offset,
    required int limit,
  }) async {
    final response = await _core
        .get(endpoint: "courses/$courseId/wiki-pages", queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit",
    });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return CourseWikiPagesListResponse.fromJson(body);
  }

  @override
  Future<CourseParticipantsResponse> getCourseParticipants({
    required String courseId,
    required int offset,
    required int limit,
  }) async {
    final response = await _core.get(
        endpoint: "courses/$courseId/relationships/memberships",
        queryParameters: {
          "page[offset]": "$offset",
          "page[limit]": "$limit",
        });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return CourseParticipantsResponse.fromJson(body);
  }

  @override
  Future<CourseResponse> getCourse({
    required String courseId,
  }) async {
    final response = await _core.get(endpoint: "courses/$courseId");
    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return CourseResponse.fromJson(body["data"]);
  }
}
