import 'dart:convert';
import 'package:studip_api_client/studip_api_client.dart';
import 'models/models.dart';

class MessageRepository {
  final StudIPMessagesClient _apiClient;

  const MessageRepository({
    required StudIPMessagesClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<Message>> getInboxMessages(
      {required String userId,
      required int offset,
      required int limit,
      required bool filterUnread}) async {
    try {
      final response = await _apiClient.getInboxMessages(
          userId: userId,
          offset: offset,
          limit: limit,
          filterUnread: filterUnread);
      final messages = response.messageResponses
          .map((response) => Message.fromMessageResponse(response))
          .toList();
      final Map<String, MessageUser> knownUsers = {};
      for (var message in messages) {
        message.sender = await _fetchUser(knownUsers, message.sender.id);
        message.recipients =
            await _fetchUsers(knownUsers, message.recipients);
      }
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Message>> getOutboxMessages({
    required String userId,
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getOutboxMessages(
          userId: userId, offset: offset, limit: limit);
      final messages = response.messageResponses
          .map((response) => Message.fromMessageResponse(response))
          .toList();
      final Map<String, MessageUser> knownUsers = {};
      for (var message in messages) {
        message.sender = await _fetchUser(knownUsers, message.sender.id);
        message.recipients = await _fetchUsers(knownUsers, message.recipients);
      }
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Message> sendMessage(
      {required OutgoingMessage outgoingMessage}) async {
    var parsedRecipients = outgoingMessage.recipients
        .map((id) => {"type": "users", "id": id})
        .toList();
    var message = jsonEncode({
      "data": {
        "type": "messages",
        "attributes": {
          "subject": outgoingMessage.subject,
          "message": outgoingMessage.message
        },
        "relationships": {
          "recipients": {"data": parsedRecipients}
        }
      }
    });
    try {
      final MessageResponse response =
          await _apiClient.sendMessage(message: message);
      return Message.fromMessageResponse(response);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> readMessage({required String messageId}) async {
    String message = jsonEncode({
      'data': {
        'type': 'messages',
        'attributes': {
          'is-read': true,
        },
      },
    });
    try {
      await _apiClient.readMessage(messageId: messageId, message: message);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteMessages({required List<String> messageIds}) async {
    try {
      for (var messageId in messageIds) {
        await deleteMessage(messageId: messageId);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteMessage({required String messageId}) async {
    await _apiClient.deleteMessage(messageId: messageId);
  }

  Future<List<MessageUser>> _fetchUsers(Map<String, MessageUser> knownUsers,
      final List<MessageUser> users) async {
    final List<MessageUser> messageUsers = [];
    for (var user in users) {
      if (knownUsers[user.id] == null) {
        user = await _fetchUser(knownUsers, user.id);
        knownUsers[user.id] = user;
        messageUsers.add(user);
      } else {
        messageUsers.add(knownUsers[user.id]!);
      }
    }
    return messageUsers;
  }

  Future<MessageUser> _fetchUser(
      Map<String, MessageUser> knownUsers, String userId) async {
    if (knownUsers[userId] == null) {
      final userResponse = await _apiClient.getUser(userId: userId);
      knownUsers[userId] = MessageUser.fromUserResponse(userResponse);
      return knownUsers[userId]!;
    } else {
      return knownUsers[userId]!;
    }
  }
}
