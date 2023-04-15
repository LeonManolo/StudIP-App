import '../models/models.dart';

abstract class StudIPMessagesClient {
  Future<MessageListResponse> getOutboxMessages(String userId);

  Future<MessageListResponse> getInboxMessages(String userId);
  Future<UserResponse> getUser(String userId);
}
