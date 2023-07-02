import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';
import 'package:studipadawan/messages/message_send/view/widgets/message_recipient_chip.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/utils.dart';

const double smallMargin = AppSpacing.sm;
const double bigMargin = AppSpacing.lg;

class MessageSendPage extends StatelessWidget {
  const MessageSendPage({super.key, this.message});

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MessageSendBloc(messageRepository: context.read<MessageRepository>()),
      child: MessageSendView(
        message: message,
      ),
    );
  }
}

class MessageSendView extends StatefulWidget {
  const MessageSendView({super.key, this.message});
  final Message? message;

  @override
  State<MessageSendView> createState() => _MessageSendViewState();
}

class _MessageSendViewState extends State<MessageSendView> {
  late TextEditingController _recipientController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;
  late SuggestionsBoxController _suggestionsBoxController;
  final List<MessageRecipientChip> _recipientChips = [];

  @override
  void initState() {
    super.initState();
    _suggestionsBoxController = SuggestionsBoxController();
    _recipientController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();
    if (widget.message != null) {
      final subject = widget.message!.subject.contains('RE:')
          ? widget.message!.subject
          : 'RE: ${widget.message!.subject}';
      for (final recipient in widget.message!.recipients) {
        _addRecipient(context, recipient);
      }
      _subjectController.text = widget.message!.subject.isEmpty ? '' : subject;
      _messageController.text = widget.message!.getPreviouseMessageString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _recipientController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text('Senden')),
      body: BlocConsumer<MessageSendBloc, MessageSendState>(
        listener: (context, state) {
          switch (state) {
            case MessageSendStateError _:
              buildSnackBar(context, state.failureInfo, Colors.red);
              break;
            case MessageSendStateDidLoad _:
              buildSnackBar(context, state.successInfo, Colors.green);
              Navigator.pop(context);
              break;
            case MessageSendStateRecipientsChanged _:
              _buildChips(state.recipients);
              break;
            case MessageSendStateUserSuggestionsFetched _:
              _triggerSuggestionCallback();
              break;
            case MessageSendStateUserSuggestionsError _:
              buildSnackBar(context, state.failureInfo, Colors.red);
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          if (state is MessageSendStateLoading) {
            return const Center(child: LoadingIndicator());
          } else {
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
                                context
                                    .read<MessageSendBloc>()
                                    .state
                                    .suggestions,
                              );
                              if (suggestions.isEmpty) {
                                context.read<MessageSendBloc>().add(
                                      FetchSuggestionsRequested(
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
                          },
                          child: const Text('Senden'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
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
    return '${user.formattedName} (${user.username})';
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
      context
          .read<MessageSendBloc>()
          .add(AddRecipientRequested(recipient: recipient));
    });
  }

  void _removeRecipient(BuildContext context, MessageUser recipient) {
    setState(() {
      context
          .read<MessageSendBloc>()
          .add(RemoveRecipientRequested(recipient: recipient));
    });
  }

  List<MessageUser> _filterUsernamesByPattern(
    String pattern,
    List<MessageUser> users,
  ) {
    return users
        .where(
          (user) => !context
              .read<MessageSendBloc>()
              .state
              .recipients
              .map((user) => user.id)
              .contains(user.id),
        )
        .where(
          (user) => _parseUser(user).toLowerCase().contains(pattern),
        )
        .toList();
  }

  void _sendMessage(BuildContext context, String subject, String messageText) {
    context.read<MessageSendBloc>().add(
          SendMessageRequested(
            subject: subject,
            messageText: messageText,
          ),
        );
  }
}
