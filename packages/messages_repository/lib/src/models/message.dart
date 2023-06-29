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

  factory Message.empty({
    required MessageUser recipient,
  }) {
    return Message(
      id: '',
      subject: '',
      message: '',
      sender: MessageUser.empty(),
      recipients: [recipient],
      mkdate: DateTime.now(),
      isRead: true,
    );
  }

  factory Message.fromMessageResponseItem(
    MessageResponseItem messageResponseItem,
  ) {
    final MessageResponseItemAttributes attributes =
        messageResponseItem.attributes;
    return Message(
      id: messageResponseItem.id,
      subject: attributes.subject,
      message: attributes.message,
      sender: MessageUser(
        id: messageResponseItem.relationships.sender.data.id,
        username: '',
        firstName: '',
        formattedName: '',
        lastName: '',
        role: '',
      ),
      recipients: messageResponseItem.relationships.recipients.dataItems
          .map(
            (recipientDataItem) => MessageUser(
              id: recipientDataItem.id,
              username: '',
              firstName: '',
              formattedName: '',
              lastName: '',
              role: '',
            ),
          )
          .toList(),
      mkdate: DateTime.parse(attributes.createdAt).toLocal(),
      isRead: attributes.isRead,
    );
  }

  Message copyWith({required bool isRead}) {
    return Message(
      id: id,
      subject: subject,
      message: message,
      sender: sender,
      recipients: recipients,
      mkdate: mkdate,
      isRead: isRead,
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
    if (message.isEmpty) {
      return '';
    } else {
      final builder = StringBuffer()
        ..writeln('\n. . . ursprüngliche Nachricht . . .')
        ..writeln('Betreff: $subject')
        ..writeln("Datum: ${DateFormat("dd/MM/yyyy hh:mm:ss").format(mkdate)}")
        ..writeln('Von: ${sender.firstName} ${sender.lastName}')
        ..writeln('An: ${parseRecipients()}')
        ..writeln(message);
      return builder.toString();
    }
  }

  String parseRecipients({String joinedWith = ','}) {
    return recipients
        .map((user) => '${user.firstName} ${user.lastName}')
        .join(joinedWith);
  }
}
