import '../models/models.dart';

abstract class StudIPMessagesClient {
  Future<MessageListResponse> getOutboxMessages(
      {required String userId, required int limit, required int offset});
  Future<void> readMessage(
      {required String messageId, required String message});
  Future<void> deleteMessage(
      {required String messageId});
  Future<MessageResponse> sendMessage({required String message});
  Future<MessageListResponse> getInboxMessages(
      {required String userId,
      required int limit,
      required int offset,
      required bool filterUnread});
  Future<UserResponse> getUser({required String userId});
  Future<UserListResponse> getUsers(String? searchParam);
}
