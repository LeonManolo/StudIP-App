import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messages_repository/messages_repository.dart';

class MessageDetailpage extends StatelessWidget {
  final Message message;

  const MessageDetailpage({Key? key, required this.message}) : super(key: key);

  String parseRecipients(final Message message) {
    return message.recipients.map((user) => user.username).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    const double headlineSize = AppSpacing.lg;
    const double smallMargin = AppSpacing.xs;
    const double bigMargin = AppSpacing.lg;
    return Scaffold(
      appBar: AppBar(title: const Text('Nachrichten')),
      body: Padding(
        padding: const EdgeInsets.all(bigMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Von:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: smallMargin),
            Text(message.sender.username),
            const SizedBox(height: bigMargin),
            const Text(
              'An:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: smallMargin),
            Text(parseRecipients(message)),
            const SizedBox(height: bigMargin),
            const Text(
              'Datum:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: smallMargin),
            Text(DateFormat("dd.MM.yyyy").format(message.mkdate)),
            const SizedBox(height: bigMargin),
            const Text(
              'Betreff:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: smallMargin),
            Text(message.subject),
            const SizedBox(height: 16.0),
            const Text(
              'Nachricht:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: smallMargin),
            Text(message.message)
          ],
        ),
      ),
    );
  }
}
