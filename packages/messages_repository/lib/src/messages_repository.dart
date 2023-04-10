import 'package:studip_api_client/studip_api_client.dart';

import 'models/models.dart';

class MessageRepository {
  final StudIpApiClient _apiClient;

  const MessageRepository({
    required StudIpApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<Message>> getInboxMessages(String userId) async {
    try {
      final response = await _apiClient.getInboxMessages(userId);
      final messages = response.messages;
      await Future.wait(messages.map((message) async => {
            await _apiClient
                .getUser(message.sender.id)
                .then((user) => message.sender.username = user.username)
                .onError((error, stackTrace) => message.sender.username = "")
          }));
      return messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Message>> getOutboxMessages(String userId) async {
    try {
      final response = await _apiClient.getOutboxMessages(userId);
      final messages = response.messages;
      await Future.wait(messages.map((message) async => {
            await Future.wait(message.recipients.map((recipient) async => {
                  await _apiClient
                      .getUser(recipient.id)
                      .then((user) => recipient.username = user.username)
                      .onError(
                          (error, stackTrace) => message.sender.username = "")
                }))
          }));
      return response.messages;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
