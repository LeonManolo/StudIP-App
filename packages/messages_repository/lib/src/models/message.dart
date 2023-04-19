import '../models/models.dart';

class Message {
  final String id;
  final String subject;
  final String message;
  MessageUser sender;
  final List<MessageUser> recipients;
  final String mkdate;
  bool isRead;

  Message(
      {required this.id,
      required this.subject,
      required this.message,
      required this.sender,
      required this.recipients,
      required this.mkdate,
      required this.isRead});

  void read() {
    isRead = true;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    List<dynamic> recipients = json["relationships"]["recipients"]["data"];
    var sender = json["relationships"]["sender"]["data"];

    return Message(
        id: json["id"],
        subject: json["attributes"]["subject"],
        message: json["attributes"]["message"].split("<!--HTML-->")[1],
        sender: MessageUser.fromJson(sender),
        recipients: recipients
            .map((recipient) => MessageUser.fromJson(recipient))
            .toList(),
        mkdate: json["attributes"]["mkdate"],
        isRead: json["attributes"]["is-read"]);
  }
}
