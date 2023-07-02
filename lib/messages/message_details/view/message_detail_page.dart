import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_bloc.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_event.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_state.dart';
import 'package:studipadawan/messages/message_details/view/dialogs/message_detail_delete_dialog.dart';
import 'package:studipadawan/messages/message_details/view/widgets/message_detail_action_button.dart';
import 'package:studipadawan/messages/message_send/view/message_send_page.dart';
import 'package:studipadawan/utils/utils.dart';
import 'package:studipadawan/utils/widgets/profile_image_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageDetailPage extends StatelessWidget {
  const MessageDetailPage({
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nachrichten'),
      ),
      body: BlocProvider(
        create: (context) => MessageDetailsBloc(
          messageRepository: context.read<MessageRepository>(),
        )..add(ReadMessageRequested(message: message)),
        child: BlocConsumer<MessageDetailsBloc, MessageDetailsState>(
          listener: (context, state) {
            if (state is MessageDetailsStateDeleteSucceed) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                buildSnackBar(context, state.successInfo, Colors.green);
                refreshMessages();
                Navigator.pop(context);
              });
            }
            if (state is MessageDetailsStateDeleteError) {
              buildSnackBar(context, state.failureInfo, Colors.red);
            }
          },
          builder: (context, state) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    message.subject,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  leading: ProfileImageAvatar(
                    replacementLetter: message.sender.lastName,
                  ),
                  title: Text(message.sender.formattedName),
                  subtitle: Text(
                    timeago.format(
                      message.mkdate,
                      locale: Localizations.localeOf(context).languageCode,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    bottom: AppSpacing.lg,
                    top: AppSpacing.xlg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlWidget(message.message),
                      const SizedBox(
                        height: AppSpacing.xlg,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MessageDetailActionButton(
                              foregroundColor: Colors.red,
                              onPressed: () => _onDeleteButtonPressed(context),
                              title: const Text('Löschen'),
                              iconData: EvaIcons.trashOutline,
                            ),
                          ),
                          if (isInbox)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: AppSpacing.lg),
                                child: MessageDetailActionButton(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  onPressed: () =>
                                      _onAnswerButtonPressed(context),
                                  title: const Text('Antworten'),
                                  iconData: EvaIcons.cornerUpRightOutline,
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onAnswerButtonPressed(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<MessageSendPage>(
        builder: (context) => MessageSendPage(message: message),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _onDeleteButtonPressed(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return MessageDetailDeleteDialog(
          onConfirmPressed: () {
            context
                .read<MessageDetailsBloc>()
                .add(DeleteMessageRequested(messageId: message.id));
          },
        );
      },
    );
  }
}
