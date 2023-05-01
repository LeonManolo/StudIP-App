import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/messages/message_outbox_bloc/message_outbox_state.dart';
import '../../message_details/view/message_detail_page.dart';
import 'message_pagination_loading.dart';
import 'message_refreshable.dart';

final _outboxWidgetKey = GlobalKey<ScaffoldState>();

class OutboxMessageWidget extends StatelessWidget {
  final OutboxMessageState state;
  final Function(bool, int) markMessage;
  final Function(bool, int) unmarkMessage;
  final Function() refresh;
  final ScrollController scrollController;
  final List<int> markedMessages;

  const OutboxMessageWidget(
      {Key? key,
      required this.state,
      required this.refresh,
      required this.markMessage,
      required this.unmarkMessage,
      required this.markedMessages,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon messageIcon(Color iconColor) {
      return Icon(EvaIcons.messageSquareOutline, color: iconColor, size: 24.0);
    }

    String parseRecipients(final Message message) {
      return message.recipients.map((user) => user.username).join(", ");
    }

    if (state.status == OutboxMessageStatus.outboxMessagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == OutboxMessageStatus.failure) {
      return RefreshableMessage(
          text:
              "Ein unbekannter Fehler ist aufgetreten, bitte versuche es erneut",
          callback: refresh);
    }
    if (state.outboxMessages.isEmpty) {
      RefreshableMessage(
          text: "Es sind keine Nachrichten vorhanden", callback: refresh);
    }
    return Column(
      key: _outboxWidgetKey,
      children: [
        Expanded(
            child: RefreshIndicator(
          onRefresh: () async => {refresh()},
          child: ListView.separated(
            itemCount: state.outboxMessages.length + 1,
            separatorBuilder: (context, index) => const Divider(
              height: 0
              ),
            itemBuilder: (context, index) {
              if (index == state.outboxMessages.length) {
                return PaginationLoading(
                    visible:
                        state.status == OutboxMessageStatus.paginationLoading);
              } else {
                var message = state.outboxMessages[index];
                return ListTile(
                    onTap: () => {
                          if (markedMessages.isNotEmpty)
                            {
                              if (markedMessages.contains(index))
                                unmarkMessage(false, index)
                              else
                                markMessage(false, index)
                            }
                          else
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MessageDetailpage(message: message)),
                              )
                            }
                        },
                    onLongPress: () => {
                          if (!markedMessages.contains(index))
                            markMessage(false, index)
                        },
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        messageIcon(Theme.of(context).primaryColor)
                      ],
                    ),
                    trailing: Text(message.getTimeAgo()),
                    title: Text(message.subject),
                    subtitle: Text(parseRecipients(message)));
              }
            },
            controller: scrollController,
          ),
        ))
      ],
    );
  }
}
