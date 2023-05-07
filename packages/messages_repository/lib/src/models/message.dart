import 'package:studip_api_client/studip_api_client.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';
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

  String getPreviouseMessageString() {
    var builder = StringBuffer();
    builder.writeln("\n. . . ursprüngliche Nachricht . . .");
    builder.writeln("Betreff: $subject");
    builder
        .writeln("Datum: ${DateFormat("dd/MM/yyyy hh:mm:ss").format(mkdate)}");
    builder.writeln("Von: ${sender.firstName} ${sender.lastName}");
    builder.writeln("An: ${parseRecipients()}");
    builder.writeln(message);
    return builder.toString();
  }

  String parseRecipients({String joinedWith = ","}) {
    return recipients
        .map((user) => "${user.firstName} ${user.lastName}")
        .join(joinedWith);
  }

  factory Message.fromMessageResponse(final MessageResponse response) {
    return Message(
        id: response.id,
        subject: response.subject,
        message: response.message
            .replaceAll("<!--HTML-->", "") // TODO: Format Html
            .replaceAll("<br />", ""),
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
