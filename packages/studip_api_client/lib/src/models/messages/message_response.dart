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
    List<dynamic> recipients = json["relationships"]["recipients"]["data"];
    var sender = json["relationships"]["sender"]["data"];
    return MessageResponse(
        id: json["id"],
        subject: json["attributes"]["subject"],
        message: normalizeMessage(json["attributes"]["message"] as String),
        senderId: sender["id"],
        recipientIds:
            recipients.map((recipient) => recipient["id"] as String).toList(),
        mkdate: DateTime.parse(json["attributes"]["mkdate"]).toLocal(),
        isRead: json["attributes"]["is-read"]);
  }
}
