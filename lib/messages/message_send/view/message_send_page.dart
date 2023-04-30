import 'package:app_ui/app_ui.dart';
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

const double smallMargin = AppSpacing.sm;
const double bigMargin = AppSpacing.lg;

class MessageSendPage extends StatelessWidget {
  const MessageSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController recipientController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text('Senden')),
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
            )..add(const MessageUsersRequested(null)),
          ),
        ],
        child: BlocBuilder<MessageSendBloc, MessageSendState>(
          builder: (context, messageSendState) {
            if (messageSendState.status == MessageSendStatus.failure) {
              _buildSnackBar(
                  context, messageSendState.errorMessage, Colors.red);
            }
            if (messageSendState.status == MessageSendStatus.populated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _buildSnackBar(
                    context, "Die Nachricht wurde versendet", Colors.green);
                Navigator.pop(context);
              });
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(bigMargin),
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
                              if (recipientController.text.isEmpty ||
                                  pattern.isEmpty) {
                                return List.empty();
                              }
                              if (pattern.length % 3 == 0) {
                                _fetchUsers(context, pattern);
                              }
                              return _filterUsernamesByPattern(
                                  pattern, messageUsersState.users);
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
                        const SizedBox(height: bigMargin),
                        const Text('Betreff'),
                        const SizedBox(height: smallMargin),
                        TextField(
                          controller: subjectController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: bigMargin),
                        const Text('Nachricht'),
                        const SizedBox(height: smallMargin),
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
                      padding: const EdgeInsets.only(right: bigMargin),
                      child: Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              var subject = subjectController.text;
                              var message = messageController.text;
                              if (_assertUserExists(
                                  context, recipientController.text)) {
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

  void _fetchUsers(BuildContext context, String searchParams) async {
    BlocProvider.of<MessageUsersBloc>(context)
        .add(MessageUsersRequested(searchParams));
  }

  List<String> _filterUsernamesByPattern(
      String pattern, List<MessageUser> users) {
    return users
        .map((user) => user.username)
        .where((recipient) =>
            recipient.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  bool _assertUserExists(BuildContext context, String username) {
    var users = BlocProvider.of<MessageUsersBloc>(context).state.users;
    var userExists = users
        .map((recipient) => recipient.username)
        .toList()
        .contains(username);
    if (!userExists) {
      _buildSnackBar(context, "Bitte wähle einen Empfänger", Colors.red);
    }
    return userExists;
  }

  String _getUserId(BuildContext context, String username) {
    var users = BlocProvider.of<MessageUsersBloc>(context).state.users;
    return users.where((user) => user.username == username).single.id;
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
}
