import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';

class InboxMessageWidget extends StatelessWidget {
  final Message message;

  const InboxMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    messageUnreadIcon() {
      return const Icon(Icons.message, color: Colors.blue, size: 24.0);
    }

    messageReadIcon() {
      return const Icon(Icons.message_outlined, color: Colors.blue, size: 24.0);
    }

    return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            message.isRead ? messageReadIcon() : messageUnreadIcon()
          ],
        ),
        trailing: Text(
            DateTime.parse(message.mkdate).toLocal().toString().split(".")[0]),
        title: Text(message.subject),
        subtitle: Text(message.sender.username));
  }
}
