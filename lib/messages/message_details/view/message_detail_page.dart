import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messages_repository/messages_repository.dart';

import '../../../app/bloc/app_bloc.dart';

class MessageDetailpage extends StatelessWidget {
  final Message message;

  const MessageDetailpage({Key? key, required this.message}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    const double headlineSize = 17;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Von:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: 5.0),
            Text(message.sender.username),
            const SizedBox(height: 16.0),
            const Text(
              'An:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: 5.0),
            Text(parseRecipients(message.recipients)),
            const SizedBox(height: 16.0),
            const Text(
              'Datum:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: 5.0),
            Text(DateFormat("dd.MM.yyyy").format(DateTime.parse(message.mkdate))),
            const SizedBox(height: 16.0),
            
            const Text(
              'Betreff:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: 5.0),
            Text(message.subject),
            const SizedBox(height: 16.0),
            const Text(
              'Nachricht:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: headlineSize),
            ),
            const SizedBox(height: 5.0),
            Text(message.message)
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Nachrichten'),
      actions: <Widget>[
        IconButton(
          key: const Key('homePage_logout_iconButton'),
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
        )
      ],
    );
  }
}
