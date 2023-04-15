import 'package:messages_repository/src/models/models.dart';

class MessageListResponse {
  final List<Message> messages;

  const MessageListResponse({required this.messages});

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> messages = json["data"];

    return MessageListResponse(
        messages: messages.map((j) => Message.fromJson(j)).toList());
  }
}
