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
        print(offset);
    try {
      final response = await _apiClient.getInboxMessages(
          userId: userId, offset: offset, limit: limit, filterUnread: filterUnread);
      final messages = response.messageResponses
          .map((response) => Message.fromMessageResponse(response))
          .toList();
      final Map<String, String> knownUsers = {};
      for (var message in messages) {
        message.sender.username =
            await _fetchUserName(knownUsers, message.sender.id);
        await _fetchUserNames(knownUsers, message.recipients);
      }
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Message>> getOutboxMessages(
      {required String userId, required int offset}) async {
    try {
      final response = await _apiClient.getOutboxMessages(userId: userId);
      final messages = response.messageResponses
          .map((response) => Message.fromMessageResponse(response))
          .toList();
      final Map<String, String> knownUsers = {};
      for (var message in messages) {
        message.sender.username =
            await _fetchUserName(knownUsers, message.sender.id);
        await _fetchUserNames(knownUsers, message.recipients);
      }
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Message> sendMessage({required OutgoingMessage outgoingMessage}) async {
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

  Future<void> _fetchUserNames(
      Map<String, String> knownUsers, final List<MessageUser> users) async {
    for (var user in users) {
      if (knownUsers[user.id] == null) {
        final fetchedUser = await _fetchUserName(knownUsers, user.id);
        user.username = fetchedUser;
        knownUsers[user.id] = fetchedUser;
      } else {
        user.username = knownUsers[user.id]!;
      }
    }
  }

  Future<String> _fetchUserName(
      Map<String, String> knownUsers, String userId) async {
    if (knownUsers[userId] == null) {
      final fetchedUser = await _apiClient.getUser(userId: userId);
      knownUsers[userId] = fetchedUser.username;
      return fetchedUser.username;
    } else {
      return knownUsers[userId]!;
    }
  }
}
