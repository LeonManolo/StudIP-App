import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';

import '../../app/bloc/app_bloc.dart';

class MessageDetailpage extends StatelessWidget {
  final Message message;

  const MessageDetailpage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Betreff:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message.subject),
            const SizedBox(height: 16.0),
            const Text(
              'Absender:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message.sender.username),
            const SizedBox(height: 16.0),
            const Text(
              'Nachricht:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
