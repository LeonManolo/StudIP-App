import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../app/bloc/app_bloc.dart';

class MessageSendPage extends StatefulWidget {
  const MessageSendPage({Key? key}) : super(key: key);

  @override
  State<MessageSendPage> createState() => _MessageSendPageState();
}

class _MessageSendPageState extends State<MessageSendPage> {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode _recipientFocusNode = FocusNode();
  final List<String> recipients = ['Alice', 'Bob', 'Charlie', 'David'];
  List<String> suggestionsList = [];

  @override
  void initState() {
    super.initState();
    _recipientFocusNode.addListener(() {
      if (!_recipientFocusNode.hasFocus) {
        setState(() {
          suggestionsList = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController recipientController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    return Scaffold(
      key: UniqueKey(),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
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
                      focusNode: _recipientFocusNode,
                    ),
                    suggestionsCallback: (pattern) async {
                      setState(() {
                        suggestionsList = recipients
                            .where((recipient) =>
                                recipient.toLowerCase().contains(pattern.toLowerCase()))
                            .toList();
                      });
                      return suggestionsList;
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
                        // TODO: Send Message
                      },
                      child: const Text('Senden'),
                    ),
                  ],
                ))
          ],
        ),
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
