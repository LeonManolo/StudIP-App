import 'dart:io';

import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';

import 'package:studip_api_client/src/models/models.dart';

abstract interface class StudIPMessagesClient {
  Future<MessageListResponse> getOutboxMessages({
    required String userId,
    required int limit,
    required int offset,
  });
  Future<void> readMessage({
    required String messageId,
    required String message,
  });
  Future<void> deleteMessage({required String messageId});
  Future<MessageResponse> sendMessage({required String message});
  Future<MessageListResponse> getInboxMessages({
    required String userId,
    required int limit,
    required int offset,
    required bool filterUnread,
  });
}

class StudIPMessagesClientImpl implements StudIPMessagesClient {

  StudIPMessagesClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;
  final StudIpHttpCore _core;

  @override
  Future<MessageListResponse> getOutboxMessages({
    required String userId,
    required int offset,
    required int limit,
  }) async {
    Map<String, String> queryParameters = {};
    queryParameters['page[offset]'] = offset.toString();
    queryParameters['page[limit]'] = limit.toString();
    final response = await _core.get(
        endpoint: 'users/$userId/outbox', queryParameters: queryParameters,);

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return MessageListResponse.fromJson(body);
  }

  @override
  Future<MessageListResponse> getInboxMessages(
      {required String userId,
      required int offset,
      required int limit,
      required bool filterUnread,}) async {
    Map<String, String> queryParameters = {};
    if (filterUnread) {
      queryParameters['filter[unread]'] = 'true';
    }
    queryParameters['page[offset]'] = offset.toString();
    queryParameters['page[limit]'] = limit.toString();

    final response = await _core.get(
        endpoint: 'users/$userId/inbox', queryParameters: queryParameters,);
    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return MessageListResponse.fromJson(body);
  }

  @override
  Future<void> readMessage(
      {required String messageId, required String message,}) async {
    final response =
        await _core.patch(endpoint: 'messages/$messageId', jsonString: message);
    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);
  }

  @override
  Future<void> deleteMessage({required String messageId}) async {
    final response = await _core.delete(endpoint: 'messages/$messageId');
    final body = response.json();
    response.throwIfInvalidHttpStatus(
        expectedStatus: HttpStatus.noContent, body: body,);
  }

  @override
  Future<MessageResponse> sendMessage({required String message}) async {
    final response =
        await _core.post(endpoint: 'messages', jsonString: message);
    final body = response.json();
    response.throwIfInvalidHttpStatus(
        expectedStatus: HttpStatus.created, body: body,);
    return MessageResponse.fromJson(body);
  }
}
