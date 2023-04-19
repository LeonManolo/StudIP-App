import 'package:messages_repository/src/models/models.dart';

class MessageResponse {
  final Message message;

  const MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    dynamic message = json["data"];

    return MessageResponse(
        message:
            message.map((dynamicMessage) => Message.fromJson(dynamicMessage)));
  }
}
