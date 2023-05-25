import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_bloc.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_event.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_state.dart';
import 'package:studipadawan/messages/message_details/view/widgets/message_details_menu_button.dart';

import 'package:studipadawan/messages/message_send/view/message_send_page.dart';
import 'package:studipadawan/utils/utils.dart';

class MessageDetailpage extends StatelessWidget {
  const MessageDetailpage({
    super.key,
    required this.message,
    required this.isInbox,
    required this.refreshMessages,
  });
  final Message message;
  final bool isInbox;
  final void Function() refreshMessages;

  @override
  Widget build(BuildContext context) {
    const double headlineSize = AppSpacing.lg;
    const double smallMargin = AppSpacing.xs;
    const double bigMargin = AppSpacing.lg;
    return BlocProvider(
      create: (context) => MessageDetailsBloc(
        messageRepository: context.read<MessageRepository>(),
      )..add(ReadMessageRequested(message: message)),
      child: BlocConsumer<MessageDetailsBloc, MessageDetailsState>(
        listener: (context, state) {
          if (state.status == MessageDetailsStatus.deleteMessageSucceed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              buildSnackBar(context, state.blocResponse, Colors.green);
              refreshMessages();
              Navigator.pop(context);
            });
          }
          if (state.status == MessageDetailsStatus.deleteMessageFailure) {
            buildSnackBar(context, state.blocResponse, Colors.red);
          }
        },
        builder: (context, state) {
          if (state.status == MessageDetailsStatus.loading) {
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Column(
                children: [
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nachrichten'),
              actions: [
                MessageDetailsMenuButton(
                  isInbox: isInbox,
                  answerMessage: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<MessageSendPage>(
                        builder: (context) => MessageSendPage(message: message),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  deleteMessage: () {
                    context
                        .read<MessageDetailsBloc>()
                        .add(DeleteMessageRequested(messageId: message.id));
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(bigMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Von:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: headlineSize,
                    ),
                  ),
                  const SizedBox(height: smallMargin),
                  Text(message.sender.formattedName),
                  const SizedBox(height: bigMargin),
                  const Text(
                    'An:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: headlineSize,
                    ),
                  ),
                  const SizedBox(height: smallMargin),
                  Text(message.parseRecipients(joinedWith: '\n')),
                  const SizedBox(height: bigMargin),
                  const Text(
                    'Datum:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: headlineSize,
                    ),
                  ),
                  const SizedBox(height: smallMargin),
                  Text(DateFormat('dd.MM.yyyy').format(message.mkdate)),
                  const SizedBox(height: bigMargin),
                  const Text(
                    'Betreff:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: headlineSize,
                    ),
                  ),
                  const SizedBox(height: smallMargin),
                  Text(message.subject),
                  const SizedBox(height: 16),
                  const Text(
                    'Nachricht:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: headlineSize,
                    ),
                  ),
                  const SizedBox(height: smallMargin),
                  HtmlWidget(message.message),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
