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

class MessageSendPage extends StatefulWidget {
  const MessageSendPage({super.key, this.message});
  final Message? message;

  @override
  State<MessageSendPage> createState() => _MessageSendPageState();
}

class _MessageSendPageState extends State<MessageSendPage> {
  late TextEditingController recipientController;
  late TextEditingController subjectController;
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    recipientController = TextEditingController();
    subjectController = TextEditingController();
    messageController = TextEditingController();

    if (widget.message != null) {
      final subject = widget.message!.subject.contains('RE:')
          ? widget.message!.subject
          : 'RE: ${widget.message!.subject}';
      recipientController.text = widget.message!.sender.username;
      subjectController.text = subject;
      messageController.text = widget.message!.getPreviouseMessageString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    recipientController.dispose();
    subjectController.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MessageUser> userSuggestions = [];

    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text('Senden')),
      body: BlocProvider<MessageSendBloc>(
        create: (context) => MessageSendBloc(
          messageRepository: context.read<MessageRepository>(),
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
                        const SizedBox(height: 8),
                        TypeAheadField(
                          hideOnEmpty: true,
                          hideOnLoading: true,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: recipientController,
                            enabled: widget.message == null,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            if (recipientController.text.isEmpty ||
                                pattern.isEmpty) {
                              userSuggestions.clear();
                              return [];
                            }

                            if (pattern.length >= 3) {
                              final flilteredUsers = _filterUsernamesByPattern(
                                pattern,
                                userSuggestions,
                              );
                              if (flilteredUsers.isEmpty) {
                                userSuggestions =
                                    await _fetchUsers(context, pattern);
                              }
                              return _filterUsernamesByPattern(
                                pattern,
                                userSuggestions,
                              );
                            } else {
                              return [];
                            }
                          },
                          itemBuilder: (context, user) {
                            final messageUser = user as MessageUser;
                            return ListTile(
                              title: Text(_parseUser(messageUser)),
                              subtitle: Text(messageUser.role),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            final user = suggestion as MessageUser;
                            recipientController.text = _parseUser(user);
                          },
                        ),
                        const SizedBox(height: bigMargin),
                        const Text('Betreff'),
                        const SizedBox(height: smallMargin),
                        TextField(
                          controller: subjectController,
                          enabled: widget.message == null,
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
                            final String recipient = recipientController.text;
                            final String subject = subjectController.text;
                            final String text = messageController.text;
                            if (widget.message != null) {
                              _sendMessage(
                                context,
                                subject,
                                text,
                                [widget.message!.sender.id],
                              );
                            } else {
                              final user = _getUser(
                                context,
                                recipient,
                                userSuggestions,
                              );
                              if (user != null) {
                                _sendMessage(
                                  context,
                                  subject,
                                  text,
                                  [user.id],
                                );
                              } else {
                                _buildSnackBar(
                                  context,
                                  missingRecipientErrorMessage,
                                  Colors.red,
                                );
                              }
                            }
                          },
                          child: const Text('Senden'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  MessageUser? _getUser(
    BuildContext context,
    String input,
    List<MessageUser> userSuggestions,
  ) {
    final user = userSuggestions.where((user) => _parseUser(user) == input);
    if (user.isEmpty) {
      return null;
    }
    return user.first;
  }

  String _parseUser(MessageUser user) {
    return '${user.parseUsername()} (${user.username})';
  }

  Future<List<MessageUser>> _fetchUsers(
    BuildContext context,
    String searchParams,
  ) async {
    final usersResponse =
        await context.read<UserRepository>().getUsers(searchParams);
    return usersResponse.userResponses
        .map(MessageUser.fromUserResponse)
        .toList();
  }

  List<MessageUser> _filterUsernamesByPattern(
    String pattern,
    List<MessageUser> users,
  ) {
    return users
        .where(
          (user) =>
              _parseUser(user).toLowerCase().contains(pattern.toLowerCase()),
        )
        .toList();
  }

  void _buildSnackBar(
    BuildContext context,
    String message,
    Color color,
  ) {
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

  void _sendMessage(
    BuildContext context,
    String subject,
    String message,
    List<String> recipients,
  ) {
    context.read<MessageSendBloc>().add(
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
