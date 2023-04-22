import 'package:studip_api_client/src/models/messages/message_response.dart';

class MessageListResponse {
  final List<MessageResponse> messageResponses;

  const MessageListResponse({required this.messageResponses});

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> messages = json["data"];
    return MessageListResponse(
        messageResponses: messages.map((message) => MessageResponse.fromJson(message)).toList()
        );
  }
}
