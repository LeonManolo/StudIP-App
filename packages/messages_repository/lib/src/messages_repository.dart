import 'dart:convert';

import 'package:studip_api_client/studip_api_client.dart';

import 'models/models.dart';

class MessageRepository {
  final StudIPMessagesClient _apiClient;

  const MessageRepository({
    required StudIPMessagesClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<Message>> getInboxMessages(String userId) async {
    try {
      final response = await _apiClient.getInboxMessages(userId);
      final messages = response.messages;
      final Map<String, String> knownUsers = {};
      for (var message in messages) {
        message.sender.username = await _fetchUserName(knownUsers, userId);
        await _fetchUsernames(knownUsers, message.recipients);
      }

      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Message>> getOutboxMessages(String userId) async {
    try {
      final response = await _apiClient.getOutboxMessages(userId);
      final messages = response.messages;
      final Map<String, String> knownUsers = {};
      for (var message in messages) {
        message.sender.username = await _fetchUserName(knownUsers, userId);
        await _fetchUsernames(knownUsers, message.recipients);
      }
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Message> sendMessage(OutgoingMessage outgoingMessage) async {
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
      final MessageResponse response = await _apiClient.sendMessage(message);
      return response.message;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> readMessage(String messageId) async {
    String params = jsonEncode({
      'data': {
        'type': 'messages',
        'attributes': {
          'is-read': true,
        },
      },
    });
    try {
      await _apiClient.readMessage(messageId, params);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> _fetchUsernames(
      Map<String, String> knownUsers, final List<User> users) async {
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
      final fetchedUser = await _apiClient.getUser(userId);
      knownUsers[userId] = fetchedUser.username;
      return fetchedUser.username;
    } else {
      return knownUsers[userId]!;
    }
  }
}
