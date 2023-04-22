import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:logger/logger.dart';
import '../exceptions.dart';

class StudIpApiClient
    implements
        StudIPAuthenticationClient,
        StudIPMessagesClient,
        StudIPCoursesClient,
        StudIPCalendarClient,
        StudIPUserClient {
  StudIpApiClient._({
    StudIpAPICore? core,
  }) : _core = core ?? StudIpAPICore();

  StudIpApiClient({StudIpAPICore? core}) : this._(core: core);

  final StudIpAPICore _core;

  // **** Shared **** (aktuell nur in StudIPMessagesClient benutzt aber in Zukunft sicherlich auch an anderen Stellen benötigt)
  @override
  Future<UserResponse> getUser(String userId) async {
    final response = await _core.get(endpoint: "users/$userId");

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return UserResponse.fromJson(body);
  }

  // **** User ****
  @override
  Future<UserResponse> getCurrentUser() async {
    final response = await _core.get(endpoint: "users/me");

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return UserResponse.fromJson(body);
  }

  // **** Messages ****
  @override
  Future<MessageListResponse> getOutboxMessages(String userId) async {
    final response = await _core.get(endpoint: "users/$userId/outbox");

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return MessageListResponse.fromJson(body);
  }

  @override
  Future<MessageListResponse> getInboxMessages(String userId) async {
    final response = await _core.get(endpoint: "users/$userId/inbox");

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return MessageListResponse.fromJson(body);
  }

  // **** Courses ****
  @override
  Future<CourseListResponse> getCourses(
      {required String userId, required int offset, required int limit}) async {
    final response =
        await _core.get(endpoint: "users/$userId/courses", queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit",
    });

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return CourseListResponse.fromJson(body);
  }

  @override
  Future<SemesterResponse> getSemester(String semesterId) async {
    final response = await _core.get(endpoint: "semesters/$semesterId");

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
          body: body, statusCode: response.statusCode);
    }
    return SemesterResponse.fromJson(body);
  }

  @override
  Future<CourseNewsListResponse> getCourseNews(
      {required String courseId, required int limit}) async {
    final response = await _core.get(
        endpoint: "courses/$courseId/news",
        queryParameters: {"page[limit]": "$limit"});

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
          body: body, statusCode: response.statusCode);
    }
    return CourseNewsListResponse.fromJson(body);
  }

  @override
  Future<CourseEventListResponse> getCourseEvents({
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

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return CourseEventListResponse.fromJson(body);
  }

  // **** Calendar ****
  @override
  Future<ScheduleResponse> getSchedule(
      {required String userId, DateTime? semesterStart}) async {
    int semesterStartInMillisecondsSinceEpoch;
    if (semesterStart == null) {
      semesterStartInMillisecondsSinceEpoch = DateTime.now().secondsSinceEpoch;
    } else {
      semesterStartInMillisecondsSinceEpoch = semesterStart.secondsSinceEpoch;
    }

    final response = await _core.get(
        endpoint: "users/$userId/schedule",
        queryParameters: {
          "filter[timestamp]": "$semesterStartInMillisecondsSinceEpoch"
        });

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      final failure = StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
      Logger().e("Unexpected Response status code", failure);
      throw failure;
    }
    return ScheduleResponse.fromJson(body);
  }

  // ***** AUTHENTICATION *****
  @override
  Future<void> removeAllTokens() async {
    await _core.removeAllTokens();
  }

  @override
  Future<String?> restoreUser() async {
    return await _core.restoreUser();
  }

  @override
  Future<String?> loginWithStudIp() async {
    return await _core.loginWithStudIp();
  }
}

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      if (body.isEmpty) {
        return {};
      } else {
        return jsonDecode(body) as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StudIpApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
