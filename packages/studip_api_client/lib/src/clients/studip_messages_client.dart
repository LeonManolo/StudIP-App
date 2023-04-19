import '../models/models.dart';

abstract class StudIPMessagesClient {
  Future<MessageListResponse> getOutboxMessages(String userId);
  Future<MessageResponse> getMessage(String messageId);
  Future<void> readMessage(String messageId);
  Future<MessageListResponse> getInboxMessages(String userId);
  Future<UserResponse> getUser(String userId);
}
