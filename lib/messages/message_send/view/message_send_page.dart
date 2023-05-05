import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';
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
    List<MessageUser> userSuggestions = [];

    bool assertUserExists(String username) {
      var userExists = userSuggestions
          .map((recipient) => recipient.username)
          .toList()
          .contains(username);
      if (!userExists) {
        _buildSnackBar(context, "Bitte wähle einen Empfänger", Colors.red);
      }
      return userExists;
    }

    String getUserId(String username) {
      return userSuggestions
          .where((user) => user.username == username)
          .single
          .id;
    }

    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text('Senden')),
      body: BlocProvider<MessageSendBloc>(
        create: (context) => MessageSendBloc(
          messageRepository: context.read<MessageRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        child: BlocConsumer<MessageSendBloc, MessageSendState>(
          listener: (context, state) {
            if (state.status == MessageSendStatus.failure) {
              _buildSnackBar(context, state.message, Colors.red);
            }
            if (state.status == MessageSendStatus.populated) {
              _buildSnackBar(context, state.message, Colors.green);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _buildSnackBar(context, state.message, Colors.green);
                Navigator.pop(context);
              });
            }
          },
          builder: (context, state) {
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
                        TypeAheadField(
                          noItemsFoundBuilder: (value) {
                            return const Text("Keine Benutzer gefunden");
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: recipientController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            if (recipientController.text.isEmpty ||
                                pattern.isEmpty) {
                              userSuggestions = [];
                              return List.empty();
                            }
                            if (pattern.length >= 3) {
                              userSuggestions =
                                  await _fetchUsers(context, pattern);
                            }
                            return _filterUsernamesByPattern(
                                pattern, userSuggestions);
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
                              if (assertUserExists(recipientController.text)) {
                                _sendMessage(context, subject, message,
                                    [getUserId(recipientController.text)]);
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

  Future<List<MessageUser>> _fetchUsers(
      BuildContext context, String searchParams) async {
    final usersResponse =
        await context.read<UserRepository>().getUsers(searchParams);
    return usersResponse.userResponses
        .map((response) => MessageUser.fromUserResponse(response))
        .toList();
  }

  List<String> _filterUsernamesByPattern(
      String pattern, List<MessageUser> users) {
    return users
        .map((user) => user.username)
        .where((recipient) =>
            recipient.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
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
