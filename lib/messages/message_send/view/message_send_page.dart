import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';
import 'package:studipadawan/messages/message_send/message_users_bloc/message_users_bloc.dart';
import 'package:studipadawan/messages/message_send/message_users_bloc/message_users_event.dart';
import 'package:studipadawan/messages/message_send/message_users_bloc/message_users_state.dart';
import 'package:user_repository/user_repository.dart';
import '../../../app/bloc/app_bloc.dart';

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
      body: MultiBlocProvider(
        providers: [
          BlocProvider<MessageSendBloc>(
            create: (context) => MessageSendBloc(
              messageRepository: context.read<MessageRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<MessageUsersBloc>(
            create: (context) => MessageUsersBloc(
              userRepository: context.read<UserRepository>(),
            )..add(const MessageUsersRequested()),
          ),
        ],
        child: BlocBuilder<MessageSendBloc, MessageSendState>(
          builder: (context, messageSendState) {
            if (messageSendState.status == MessageSendStatus.populated) {
              _buildSnackBar(context, "Nachricht verschickt", Colors.green);
              recipientController.text = "";
              subjectController.text = "";
              messageController.text = "";
            }
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
                        BlocBuilder<MessageUsersBloc, MessageUsersState>(
                            builder: (context, messageUsersState) {
                          return TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: recipientController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              if (recipientController.text.isEmpty) {
                                return List.empty();
                              }
                              return messageUsersState.users!
                                  .map((user) => user.username)
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
                          );
                        }),
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
                              var subject = subjectController.text;
                              var message = messageController.text;
                              if (_assertUserExists(
                                      context, recipientController.text) &&
                                  _assertFieldsAreFilled(
                                      context, subject, message)) {
                                _sendMessage(context, subject, message, [
                                  _getUserId(context, recipientController.text)
                                ]);
                              }
                            },
                            child: const Text('Senden'),
                          ),
                        ],
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _assertUserExists(BuildContext context, String username) {
    var users = BlocProvider.of<MessageUsersBloc>(context).state.users;
    var userExists = users!
        .map((recipient) => recipient.username)
        .toList()
        .contains(username);
    if (!userExists) {
      _buildSnackBar(context, "Bitte wähle einen Empfänger", Colors.red);
    }
    return userExists;
  }

  bool _assertFieldsAreFilled(
      BuildContext context, String subject, String message) {
    if (subject.isEmpty) {
      _buildSnackBar(context, "Bitte schreibe einen Betreff", Colors.red);
      return false;
    } else if (message.isEmpty) {
      _buildSnackBar(context, "Bitte schreibe eine Nachricht", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  String _getUserId(BuildContext context, String username) {
    var users = BlocProvider.of<MessageUsersBloc>(context).state.users;
    return users!.where((user) => user.username == username).single.id;
  }

  void _buildSnackBar(BuildContext context, String message, Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _sendMessage(BuildContext context, String subject, String message,
      List<String> recipients) {
    BlocProvider.of<MessageSendBloc>(context).add(
      SendMessageRequest(
        message: OutgoingMessage(
          subject: subject,
          message: message,
          recipients: recipients,
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
