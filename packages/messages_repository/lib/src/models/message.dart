import '../models/models.dart';

class Message {
  final String id;
  final String subject;
  final String message;
  final User sender;
  final List<User> recipients;
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
          message: json["attributes"]["message"],
          sender: User(id: sender["id"], username: ""),
          recipients:
              recipients.map((recipient) => User(id: recipient["id"], username: "")).toList(),
          mkdate: json["attributes"]["mkdate"],
          isRead: json["attributes"]["is-read"]);
  }
}
