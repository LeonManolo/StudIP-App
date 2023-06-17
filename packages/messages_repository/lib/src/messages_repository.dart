import 'dart:convert';

import 'package:messages_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class MessageRepository {
  const MessageRepository({
    required StudIPMessagesClient messageClient,
    required StudIPUserClient userClient,
  })  : _messagesClient = messageClient,
        _userClient = userClient;

  final StudIPMessagesClient _messagesClient;
  final StudIPUserClient _userClient;

  Future<List<Message>> getInboxMessages({
    required String userId,
    required int offset,
    required int limit,
    required bool filterUnread,
  }) async {
    try {
      final response = await _messagesClient.getInboxMessages(
        userId: userId,
        offset: offset,
        limit: limit,
        filterUnread: filterUnread,
      );
      final messages =
          response.messageResponses.map(Message.fromMessageResponse).toList();
      final Map<String, MessageUser> knownUsers = {};
      for (final message in messages) {
        message
          ..sender = await _fetchUser(knownUsers, message.sender.id)
          ..recipients = await _fetchUsers(knownUsers, message.recipients);
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
      final response = await _messagesClient.getOutboxMessages(
        userId: userId,
        offset: offset,
        limit: limit,
      );
      final messages =
          response.messageResponses.map(Message.fromMessageResponse).toList();
      final Map<String, MessageUser> knownUsers = {};
      for (final message in messages) {
        message
          ..sender = await _fetchUser(knownUsers, message.sender.id)
          ..recipients = await _fetchUsers(knownUsers, message.recipients);
      }
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Message> sendMessage({
    required OutgoingMessage outgoingMessage,
  }) async {
    final parsedRecipients = outgoingMessage.recipients
        .map((id) => {'type': 'users', 'id': id})
        .toList();
    final message = jsonEncode({
      'data': {
        'type': 'messages',
        'attributes': {
          'subject': outgoingMessage.subject,
          'message': outgoingMessage.message
        },
        'relationships': {
          'recipients': {'data': parsedRecipients}
        }
      }
    });
    try {
      final MessageResponse response =
          await _messagesClient.sendMessage(message: message);
      return Message.fromMessageResponse(response);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> readMessage({required String messageId}) async {
    final String message = jsonEncode({
      'data': {
        'type': 'messages',
        'attributes': {
          'is-read': true,
        },
      },
    });
    try {
      await _messagesClient.readMessage(messageId: messageId, message: message);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteMessages({required List<String> messageIds}) async {
    try {
      for (final messageId in messageIds) {
        await deleteMessage(messageId: messageId);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<MessageUser>> searchUsers({required String searchParam}) async {
    final usersResponse = await _userClient.getUsers(searchParam);
    return usersResponse.userResponses
        .map(MessageUser.fromUserResponse)
        .toList();
  }

  Future<void> deleteMessage({required String messageId}) async {
    await _messagesClient.deleteMessage(messageId: messageId);
  }

  Future<List<MessageUser>> _fetchUsers(
    Map<String, MessageUser> knownUsers,
    List<MessageUser> users,
  ) async {
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
    Map<String, MessageUser> knownUsers,
    String userId,
  ) async {
    if (knownUsers[userId] == null) {
      final userResponse = await _userClient.getUser(userId: userId);
      knownUsers[userId] = MessageUser.fromUserResponse(userResponse);
      return knownUsers[userId]!;
    } else {
      return knownUsers[userId]!;
    }
  }
}
