import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class OutboxMessageWidget extends StatelessWidget {
  final Message message;

  const OutboxMessageWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    messageIcon() {
      return const Icon(EvaIcons.messageSquare,
          color: Colors.indigo, size: 24.0);
    }

    parseRecipients(final List<MessageUser> recipients) {
      var buffer = StringBuffer();
      for (int i = 0; i < recipients.length; i++) {
        buffer.write(recipients.elementAt(i).username);
        if (i < recipients.length - 1) {
          buffer.write(", ");
        }
      }
      return buffer.toString();
    }

    return ListTile(
        leading: Column(
          // Center leading
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[messageIcon()],
        ),
        trailing: Text(
            DateTime.parse(message.mkdate).toLocal().toString().split(".")[0]),
        title: Text(message.subject),
        subtitle: Text(parseRecipients(message.recipients)));
  }
}
