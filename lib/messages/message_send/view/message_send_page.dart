import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';
import 'package:user_repository/user_repository.dart';

const double smallMargin = AppSpacing.sm;
const double bigMargin = AppSpacing.lg;

class MessageSendPage extends StatelessWidget {
  final Message? message;
  const MessageSendPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final TextEditingController recipientController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    List<MessageUser> userSuggestions = [];

    if (message != null) {
      var builder = StringBuffer();
      var subject = message!.subject.contains("RE:")
          ? message!.subject
          : "RE: ${message!.subject}";
      recipientController.text = message!.sender.username;
      subjectController.text = subject;
      builder.writeln("\n. . . ursprüngliche Nachricht . . .");
      builder.writeln("Betreff: $subject");
      builder.writeln(
          "Datum: ${DateFormat("dd/MM/yyyy hh:mm:ss").format(message!.mkdate)}");
      builder.writeln(
          "Von: ${message!.sender.firstName} ${message!.sender.lastName}");
      builder.writeln("An: ${_parseRecipients(message!)}");
      builder.writeln(message!.message);

      messageController.text = builder.toString();
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
                          hideOnEmpty: true,
                          hideOnLoading: true,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: recipientController,
                            enabled: message == null,
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
                              var flilteredUsers = _filterUsernamesByPattern(
                                  pattern, userSuggestions);
                              if (flilteredUsers.isEmpty) {
                                userSuggestions =
                                    await _fetchUsers(context, pattern);
                              }
                              return _filterUsernamesByPattern(
                                  pattern, userSuggestions);
                            } else {
                              return [];
                            }
                          },
                          itemBuilder: (context, user) {
                            var messageUser = user as MessageUser;
                            return ListTile(
                              title: Text(_parseUsername(messageUser)),
                              subtitle: Text(messageUser.role),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            var user = suggestion as MessageUser;
                            recipientController.text = _parseUsername(user);
                          },
                        ),
                        const SizedBox(height: bigMargin),
                        const Text('Betreff'),
                        const SizedBox(height: smallMargin),
                        TextField(
                          controller: subjectController,
                          enabled: message == null,
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
                              String recipient = recipientController.text;
                              String subject = subjectController.text;
                              String text = messageController.text;
                              if (message != null) {
                                _sendMessage(context, subject, text,
                                    [message!.sender.id]);
                              } else {
                                var user = _getUser(
                                    context, recipient, userSuggestions);
                                if (user != null) {
                                  _sendMessage(
                                      context, subject, text, [user.id]);
                                } else {
                                  _buildSnackBar(context,
                                      missingRecipientErrorMessage, Colors.red);
                                }
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

  MessageUser? _getUser(
      BuildContext context, String input, List<MessageUser> userSuggestions) {
    var user = userSuggestions.where((user) => _parseUsername(user) == input);
    if (user.isEmpty) {
      return null;
    }
    return user.first;
  }

  String _parseUsername(MessageUser user) {
    return "${user.lastName}, ${user.firstName} (${user.username})";
  }

  String _parseRecipients(final Message message) {
    return message.recipients
        .map((user) => "${user.firstName} ${user.lastName}")
        .join(",");
  }

  Future<List<MessageUser>> _fetchUsers(
      BuildContext context, String searchParams) async {
    final usersResponse =
        await context.read<UserRepository>().getUsers(searchParams);
    return usersResponse.userResponses
        .map((response) => MessageUser.fromUserResponse(response))
        .toList();
  }

  List<MessageUser> _filterUsernamesByPattern(
      String pattern, List<MessageUser> users) {
    return users
        .where((user) =>
            _parseUsername(user).toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  void _buildSnackBar(
      final BuildContext context, final String message, final Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _sendMessage(final BuildContext context, final String subject,
      final String message, List<String> recipients) {
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
