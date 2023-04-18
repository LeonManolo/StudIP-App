import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class InboxMessageItem extends StatelessWidget {
  final Message message;

  const InboxMessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    messageUnreadIcon() {
      return const Icon(EvaIcons.messageSquare,
          color: Colors.indigo, size: 24.0);
    }

    messageReadIcon() {
      return const Icon(EvaIcons.messageSquareOutline,
          color: Colors.indigo, size: 24.0);
    }

    return ListTile(
        leading: Column(
          // Center leading
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
