import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';
import 'package:studipadawan/messages/message_send/view/widgets/message_recipient_chip.dart';
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
  late TextEditingController _recipientController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;
  late SuggestionsBoxController _suggestionsBoxController;
  late MessageSendBloc _messageSendBloc;
  final List<MessageRecipientChip> _recipientChips = [];

  @override
  void initState() {
    super.initState();
    _suggestionsBoxController = SuggestionsBoxController();
    _recipientController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();
    _messageSendBloc = MessageSendBloc(
      messageRepository: context.read<MessageRepository>(),
      userRepository: context.read<UserRepository>(),
    );
    if (widget.message != null) {
      final subject = widget.message!.subject.contains('RE:')
          ? widget.message!.subject
          : 'RE: ${widget.message!.subject}';
      for (final recipient in widget.message!.recipients) {
        _addRecipient(context, recipient);
      }
      _subjectController.text = subject;
      _messageController.text = widget.message!.getPreviouseMessageString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageSendBloc.close();
    _recipientController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text('Senden')),
      body: BlocProvider<MessageSendBloc>.value(
        value: _messageSendBloc,
        child: BlocConsumer<MessageSendBloc, MessageSendState>(
          listener: (context, state) {
            if (state.status == MessageSendStatus.failure) {
              _buildSnackBar(context, state.blocResponse, Colors.red);
            }
            if (state.status == MessageSendStatus.populated) {
              _buildSnackBar(context, state.blocResponse, Colors.green);
              Navigator.pop(context);
            }
            if (state.status == MessageSendStatus.recipientsChanged) {
              _buildChips(state.recipients);
            }
            if (state.status == MessageSendStatus.userSuggestionsFetched) {
              if (_suggestionsBoxController.effectiveFocusNode!.hasFocus) {
                _triggerSuggestionCallback();
              }
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
                          getImmediateSuggestions: true,
                          hideOnLoading: true,
                          suggestionsBoxController: _suggestionsBoxController,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _recipientController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            final normalizedPattern =
                                pattern.toLowerCase().replaceAll(' ', '');
                            if (pattern.length < 3) {
                              return List<MessageUser>.empty();
                            } else {
                              final suggestions = _filterUsernamesByPattern(
                                normalizedPattern,
                                _messageSendBloc.state.suggestions,
                              );
                              if (suggestions.isEmpty) {
                                _messageSendBloc.add(
                                  FetchSuggestions(
                                    pattern: normalizedPattern,
                                  ),
                                );
                              }
                              return suggestions;
                            }
                          },
                          itemBuilder: (context, user) {
                            return ListTile(
                              title: Text(_parseUser(user)),
                              subtitle: Text(user.role),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            final user = suggestion;
                            _addRecipient(context, user);
                            _recipientController.clear();
                          },
                        ),
                        Wrap(
                          children: _recipientChips,
                        ),
                        const SizedBox(height: bigMargin),
                        const Text('Betreff'),
                        const SizedBox(height: smallMargin),
                        TextField(
                          controller: _subjectController,
                          enabled: widget.message == null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: bigMargin),
                        const Text('Nachricht'),
                        const SizedBox(height: smallMargin),
                        TextField(
                          controller: _messageController,
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
                            final String subject = _subjectController.text;
                            final String text = _messageController.text;
                            if (widget.message != null) {
                              _sendMessage(
                                context,
                                subject,
                                text,
                              );
                            } else {
                              _sendMessage(
                                context,
                                subject,
                                text,
                              );
                            }
                            _suggestionsBoxController.open();
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

  void _buildChips(List<MessageUser> recipients) {
    setState(() {
      _recipientChips.clear();
      for (final recipient in recipients) {
        _recipientChips.add(
          MessageRecipientChip(
            recipient: recipient,
            delete: _removeRecipient,
          ),
        );
      }
    });
  }

  String _parseUser(MessageUser user) {
    return '${user.parseUsername()} (${user.username})';
  }

  void _triggerSuggestionCallback() {
    if (_suggestionsBoxController.effectiveFocusNode!.hasFocus) {
      final text = _recipientController.text;
      _recipientController
        ..clear()
        ..text = text
        ..selection = TextSelection.collapsed(
          offset: _recipientController.text.length,
        );
    }
  }

  void _addRecipient(BuildContext context, MessageUser recipient) {
    setState(() {
      _messageSendBloc.add(AddRecipient(recipient: recipient));
    });
  }

  void _removeRecipient(BuildContext context, MessageUser recipient) {
    setState(() {
      _messageSendBloc.add(RemoveRecipient(recipient: recipient));
    });
  }

  List<MessageUser> _filterUsernamesByPattern(
    String pattern,
    List<MessageUser> users,
  ) {
    return users
        .where(
          (user) => !_messageSendBloc.state.recipients
              .map((u) => u.id)
              .contains(user.id),
        )
        .where(
          (user) => _parseUser(user).toLowerCase().contains(pattern),
        )
        .toList();
  }

  void _buildSnackBar(
    BuildContext context,
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendMessage(BuildContext context, String subject, String messageText) {
    _messageSendBloc.add(
      SendMessageRequest(
        subject: subject,
        messageText: messageText,
      ),
    );
  }
}
