import 'package:studip_api_client/studip_api_client.dart';

import '../models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

class Message {
  final String id;
  final String subject;
  final String message;
  MessageUser sender;
  List<MessageUser> recipients;
  bool isRead;
  final DateTime mkdate;

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

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(mkdate, locale: 'de');
  }

  factory Message.fromMessageResponse(final MessageResponse response) {
    return Message(
        id: response.id,
        subject: response.subject,
        message: response.message,
        sender: MessageUser(
            id: response.senderId,
            username: "",
            firstName: "",
            lastName: "",
            role: ""),
        recipients: response.recipientIds
            .map((id) => MessageUser(
                id: id, username: "", firstName: "", lastName: "", role: ""))
            .toList(),
        mkdate: response.mkdate,
        isRead: response.isRead);
  }
}
