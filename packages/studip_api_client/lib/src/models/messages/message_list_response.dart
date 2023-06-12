class MessageListResponse {
  final List<MessageResponse> messageResponses;

  const MessageListResponse({required this.messageResponses});

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> messages = json["data"];
    return MessageListResponse(
        messageResponses: messages
            .map((message) => MessageResponse.fromJson(message))
            .toList());
  }
}

class MessageResponse {
  final String id;
  final String subject;
  final String message;
  final String senderId;
  final List<String> recipientIds;
  final DateTime mkdate;
  final bool isRead;
  const MessageResponse(
      {required this.id,
      required this.subject,
      required this.message,
      required this.senderId,
      required this.recipientIds,
      required this.mkdate,
      required this.isRead});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? json;
    final List<dynamic> recipients =
        data["relationships"]["recipients"]["data"];
    var sender = data["relationships"]["sender"]["data"];
    return MessageResponse(
        id: data["id"],
        subject: data["attributes"]["subject"],
        message: data["attributes"]["message"],
        senderId: sender["id"],
        recipientIds:
            recipients.map((recipient) => recipient["id"] as String).toList(),
        mkdate: DateTime.parse(data["attributes"]["mkdate"]).toLocal(),
        isRead: data["attributes"]["is-read"]);
  }
}
