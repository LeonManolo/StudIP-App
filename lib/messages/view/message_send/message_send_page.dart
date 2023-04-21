import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/view/message_send/bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/view/message_send/bloc/message_send_event.dart';
import 'package:studipadawan/messages/view/message_send/bloc/message_send_state.dart';
import '../../../app/bloc/app_bloc.dart';

final List<String> recipients = ['Alice', 'Bob', 'Charlie', 'David'];

class MessageSendPage extends StatelessWidget {
  const MessageSendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController recipientController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    return Scaffold(
      key: UniqueKey(),
      appBar: _buildAppBar(context),
      body: BlocProvider(
        create: (context) => MessageSendBloc(
          messageRepository: context.read<MessageRepository>(),
        ),
        child: BlocBuilder<MessageSendBloc, MessageSendState>(
            builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Empfänger'),
                      const SizedBox(height: 8.0),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: recipientController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return recipients
                              .where((recipient) => recipient
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          recipientController.text = suggestion;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Betreff'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Nachricht'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: messageController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<MessageSendBloc>(context).add(
                                SendMessageRequested(
                                    message: OutgoingMessage(
                                        subject: subjectController.text,
                                        message: messageController.text,
                                        recipients: [
                                  recipientController.text
                                ])));
                          },
                          child: const Text('Senden'),
                        ),
                      ],
                    ))
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Senden'),
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
