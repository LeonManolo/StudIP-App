import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:studip_api_client/studip_api_client.dart';

import 'models/message_response.dart';


/// An exception thrown when there is a problem decoded the response body.
class StudIpApiMalformedResponse implements Exception {
  const StudIpApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// An exception thrown when an http request failure occurs.
class StudIpApiRequestFailure implements Exception {
  const StudIpApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

/// Signature for the authentication token provider.
typedef TokenProvider = Future<String?> Function();

class StudIpApiClient {
  StudIpApiClient._({
    required String baseUrl,
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider;

  StudIpApiClient({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
            baseUrl: "http://miezhaus.feste-ip.net:55109",
            httpClient: httpClient,
            tokenProvider: tokenProvider);

  StudIpApiClient.localhost({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(baseUrl: "http://10.0.2.2:8080", tokenProvider: tokenProvider);

  final String _baseUrl;
  final http.Client _httpClient;
  final TokenProvider _tokenProvider;

  Future<void> getUsers({Int? offset, Int? page, filter}) async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/users")
        .replace(queryParameters: <String, String>{
      if (page != null) 'page': '$page',
      if (offset != null) 'offset': '$offset',
    });

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
  }

  Future<UserResponse> getCurrentUser() async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/users/me");

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );


    final body = response.json();


    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return UserResponse.fromJson(body);
  }

  Future<UserResponse> getUser(String userId) async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/users/$userId");

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return UserResponse.fromJson(body);
  }

  Future<MessageListResponse> getOutboxMessages(String userId) async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/users/$userId/outbox");

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );


    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return MessageListResponse.fromJson(body);
  }

  Future<MessageListResponse> getInboxMessages(String userId) async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/users/$userId/inbox");

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );


    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return MessageListResponse.fromJson(body);
  }

  Future<CourseListResponse> getCourses(
      {required String userId, required int offset, required int limit}) async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/users/$userId/courses")
        .replace(queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit"
    });

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return CourseListResponse.fromJson(body);
  }

  Future<SemesterResponse> getSemester(String semesterId) async {
    final uri = Uri.parse("$_baseUrl/jsonapi.php/v1/semesters/$semesterId");
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
          body: body, statusCode: response.statusCode);
    }
    return SemesterResponse.fromJson(body);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = await _tokenProvider();
   // _printWrapped(token);
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: "*/*",
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  void _printWrapped(String? text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text!).forEach((match) => print(match.group(0)));
  }
}

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StudIpApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
