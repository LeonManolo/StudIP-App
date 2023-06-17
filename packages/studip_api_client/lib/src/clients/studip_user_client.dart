import 'dart:io';

import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/exceptions.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';

import '../models/models.dart';

abstract class StudIPUserClient {
  Future<UserResponse> getCurrentUser();
  Future<UserListResponse> getUsers(String? searchparam);
  Future<UserResponse> getUser({required String userId});
}

class StudIPUserClientImpl implements StudIPUserClient {
  final StudIpHttpCore _core;

  StudIPUserClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;

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
}
