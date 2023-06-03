import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_forked/http.dart' as http;
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:logger/logger.dart';

class StudIpApiClient
    implements
        StudIPAuthenticationClient,
        StudIPMessagesClient,
        StudIPCoursesClient,
        StudIPCalendarClient,
        StudIPUserClient,
        StudIPFilesClient {
  StudIpApiClient._({
    StudIpAPICore? core,
  }) : _core = core ?? StudIpAPICore();

  StudIpApiClient({StudIpAPICore? core}) : this._(core: core);

  final StudIpAPICore _core;

  // **** Shared **** (aktuell nur in StudIPMessagesClient benutzt aber in Zukunft sicherlich auch an anderen Stellen benötigt)
  @override
  Future<UserResponse> getUser({required String userId}) async {
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

  @override
  Future<UserListResponse> getUsers(String? searchParam) async {
    Map<String, String> queryParameters = {};
    if (searchParam != null) {
      queryParameters["filter[search]"] = searchParam;
    }

    final response =
        await _core.get(endpoint: "users", queryParameters: queryParameters);

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return UserListResponse.fromJson(body);
  }

  // **** Messages ****
  @override
  Future<MessageListResponse> getOutboxMessages({
    required String userId,
    required int offset,
    required int limit,
  }) async {
    Map<String, String> queryParameters = {};
    queryParameters["page[offset]"] = offset.toString();
    queryParameters["page[limit]"] = limit.toString();
    final response = await _core.get(
        endpoint: "users/$userId/outbox", queryParameters: queryParameters);

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
  Future<MessageListResponse> getInboxMessages(
      {required String userId,
      required int offset,
      required int limit,
      required bool filterUnread}) async {
    Map<String, String> queryParameters = {};
    if (filterUnread) {
      queryParameters["filter[unread]"] = "true";
    }
    queryParameters["page[offset]"] = offset.toString();
    queryParameters["page[limit]"] = limit.toString();

    final response = await _core.get(
        endpoint: "users/$userId/inbox", queryParameters: queryParameters);
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
  Future<void> readMessage(
      {required String messageId, required String message}) async {
    final response =
        await _core.patch(endpoint: "messages/$messageId", jsonString: message);
    final body = response.json();
    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
          body: body, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> deleteMessage({required String messageId}) async {
    final response = await _core.delete(endpoint: "messages/$messageId");
    final body = response.json();
    if (response.statusCode != HttpStatus.noContent) {
      throw StudIpApiRequestFailure(
          body: body, statusCode: response.statusCode);
    }
  }

  @override
  Future<MessageResponse> sendMessage({required String message}) async {
    final response =
        await _core.post(endpoint: "messages", jsonString: message);
    final body = response.json();
    if (response.statusCode != HttpStatus.created) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return MessageResponse.fromJson(body);
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
  Future<SemesterResponse> getSemester({required String semesterId}) async {
    final response = await _core.get(endpoint: "semesters/$semesterId");

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
          body: body, statusCode: response.statusCode);
    }
    return SemesterResponse.fromJson(body);
  }

  @override
  Future<CourseNewsListResponse> getCourseNews({
    required String courseId,
    required int limit,
    required int offset,
  }) async {
    final response = await _core.get(
        endpoint: "courses/$courseId/news",
        queryParameters: {"page[limit]": "$limit", "page[offset]": "$offset"});

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

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return CourseWikiPagesListResponse.fromJson(body);
  }

  // **** Files ****

  @override
  Future<FolderResponse> getCourseRootFolder({required String courseId}) async {
    final response = await _core
        .get(endpoint: "courses/$courseId/folders", queryParameters: {
      "page[limit]": "1",
    });

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return FolderListResponse.fromJson(body).folders.first;
  }

  Future<CourseParticipantsResponse> getCourseParticipants({
    required String courseId,
    required int offset,
    required int limit,
  }) async {
    final response = await _core
        .get(endpoint: "courses/$courseId/relationships/memberships",
        queryParameters: {
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
    return CourseParticipantsResponse.fromJson(body);
  }

  @override
  Future<FileListResponse> getFiles(
      {required String folderId,
      required int offset,
      required int limit}) async {
    final response = await _core
        .get(endpoint: "folders/$folderId/file-refs", queryParameters: {
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
    return FileListResponse.fromJson(body);
  }

  @override
  Future<FolderListResponse> getFolders(
      {required String folderId,
      required int offset,
      required int limit}) async {
    final response = await _core
        .get(endpoint: "folders/$folderId/folders", queryParameters: {
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
    return FolderListResponse.fromJson(body);
  }

  @override
  Future<String?> downloadFile(
      {required String fileId,
      required String fileName,
      required List<String> parentFolderIds,
      required DateTime lastModified}) {
    return _core.downloadFile(
        fileId: fileId,
        fileName: fileName,
        parentFolderIds: parentFolderIds,
        lastModified: lastModified);
  }

  @override
  FutureOr<void> uploadFiles({
    required String parentFolderId,
    required Iterable<String> localFilePaths,
  }) async {
    await _core.uploadFiles(
      parentFolderId: parentFolderId,
      localFilePaths: localFilePaths,
    );
  }

  @override
  FutureOr<void> createNewFolder({
    required String courseId,
    required String parentFolderId,
    required String folderName,
  }) async {
    await _core.post(
      endpoint: 'courses/$courseId/folders',
      jsonString: jsonEncode(
        {
          "data": {
            "type": "folders",
            "attributes": {"name": folderName},
            "relationships": {
              "parent": {
                "data": {"type": "folders", "id": parentFolderId}
              }
            }
          }
        },
      ),
    );
  }

  @override
  Future<bool> isFilePresentAndUpToDate({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
    bool deleteOutdatedVersion = true,
  }) {
    return _core.isFilePresentAndUpToDate(
      fileId: fileId,
      fileName: fileName,
      parentFolderIds: parentFolderIds,
      lastModified: lastModified,
      deleteOutdatedVersion: deleteOutdatedVersion,
    );
  }

  @override
  Future<String> localFilePath(
      {required String fileId,
      required String fileName,
      required List<String> parentFolderIds}) async {
    return _core.localFilePath(
        fileId: fileId, fileName: fileName, parentFolderIds: parentFolderIds);
  }

  @override
  FutureOr<void> cleanup(
      {required List<String> parentFolderIds,
      required List<String> expectedIds}) {
    return _core.cleanup(
      parentFolderIds: parentFolderIds,
      expectedIds: expectedIds,
    );
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
