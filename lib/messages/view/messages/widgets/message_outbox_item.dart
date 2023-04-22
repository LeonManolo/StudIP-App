import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../message_details/view/message_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class OutboxMessageItem extends StatelessWidget {
  final Message message;

  const OutboxMessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    messageIcon(Color iconColor) {
      return Icon(EvaIcons.messageSquareOutline, color: iconColor, size: 24.0);
    }

    parseRecipients(final List<User> recipients) {
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
        onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MessageDetailpage(message: message)),
              )
            },
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[messageIcon(Theme.of(context).primaryColor)],
        ),
        trailing: Text(
          timeago.format(
            DateTime.parse(message.mkdate),
            locale: 'de',
          ),
        ),
        title: Text(message.subject),
        subtitle: Text(parseRecipients(message.recipients)));
  }
}
