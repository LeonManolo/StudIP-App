import 'package:intl/intl.dart';
import 'package:messages_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

class Message {
  Message({
    required this.id,
    required this.subject,
    required this.message,
    required this.sender,
    required this.recipients,
    required this.mkdate,
    required this.isRead,
  });

  factory Message.fromMessageResponse(MessageResponse response) {
    return Message(
      id: response.id,
      subject: response.subject,
      message: response.message,
      sender: MessageUser(
        id: response.senderId,
        username: '',
        firstName: '',
        formattedName: '',
        lastName: '',
        role: '',
      ),
      recipients: response.recipientIds
          .map(
            (id) => MessageUser(
              id: id,
              username: '',
              firstName: '',
              formattedName: '',
              lastName: '',
              role: '',
            ),
          )
          .toList(),
      mkdate: response.mkdate,
      isRead: response.isRead,
    );
  }
  final String id;
  final String subject;
  final String message;
  MessageUser sender;
  List<MessageUser> recipients;
  bool isRead;
  final DateTime mkdate;

  void read() {
    isRead = true;
  }

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(mkdate, locale: 'de');
  }

  String getPreviouseMessageString() {
    final builder = StringBuffer()
      ..writeln('\n. . . ursprüngliche Nachricht . . .')
      ..writeln('Betreff: $subject')
      ..writeln("Datum: ${DateFormat("dd/MM/yyyy hh:mm:ss").format(mkdate)}")
      ..writeln('Von: ${sender.firstName} ${sender.lastName}')
      ..writeln('An: ${parseRecipients()}')
      ..writeln(message);
    return builder.toString();
  }

  String parseRecipients({String joinedWith = ','}) {
    return recipients
        .map((user) => '${user.firstName} ${user.lastName}')
        .join(joinedWith);
  }
}
