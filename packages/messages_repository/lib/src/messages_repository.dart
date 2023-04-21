import 'dart:convert';

import 'package:messages_repository/src/models/message_out.dart';
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
        if (knownUsers[message.sender.id] != null) {
          message.sender.username = knownUsers[message.sender.id]!;
        } else {
          final user = await _apiClient.getUser(message.sender.id);
          message.sender.username = user.username;
          knownUsers[message.sender.id] = user.username;
        }
      }

      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Message> sendMessage(OutgoingMessage outgoingMessage) async {
    var parsedRecipients =
        outgoingMessage.recipients.map((id) => {"type": "users", "id": id}).toList();
        print("trigger");
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

  Future<Message> getMessage(String messageId) async {
    try {
      final MessageResponse response = await _apiClient.getMessage(messageId);
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

  Future<List<Message>> getOutboxMessages(String userId) async {
    try {
      final response = await _apiClient.getOutboxMessages(userId);
      final messages = response.messages;
      final Map<String, String> knownUsers = {};

      for (var message in messages) {
        for (var recipient in message.recipients) {
          if (knownUsers[recipient.id] != null) {
            recipient.username = knownUsers[recipient.id]!;
          } else {
            final user = await _apiClient.getUser(recipient.id);
            recipient.username = user.username;
            knownUsers[recipient.id] = user.username;
          }
        }
      }

      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
