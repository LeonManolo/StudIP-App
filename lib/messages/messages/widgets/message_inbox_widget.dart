import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/messages/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/messages/widgets/message_pagination_loading.dart';
import '../../message_details/view/message_detail_page.dart';

import 'message_filter_row.dart';
import 'message_refreshable.dart';

final _inboxWidgetKey = GlobalKey<ScaffoldState>();

class InboxMessageWidget extends StatelessWidget {
  final InboxMessageState state;
  final FilterRow filterRow;
  final Function() refresh;
  final Function(bool, int) markMessage;
  final Function(bool, int) unmarkMessage;
  final Function(Message) readMessage;
  final ScrollController scrollController;
  final List<int> markedMessages;

  const InboxMessageWidget(
      {Key? key,
      required this.state,
      required this.filterRow,
      required this.readMessage,
      required this.refresh,
      required this.markMessage,
      required this.unmarkMessage,
      required this.markedMessages,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon messageIcon(BuildContext context, bool isRead) {
      if (isRead) {
        return Icon(EvaIcons.messageSquareOutline,
            color: Theme.of(context).primaryColor, size: 24.0);
      } else {
        return Icon(EvaIcons.messageSquare,
            color: Theme.of(context).primaryColor, size: 24.0);
      }
    }

    if (state.status == InboxMessageStatus.inboxMessagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == InboxMessageStatus.failure) {
      return RefreshableMessage(
          text:
              "Ein unbekannter Fehler ist aufgetreten, bitte versuche es erneut",
          callback: refresh);
    }
    if (state.inboxMessages.isEmpty) {
      RefreshableMessage(
          text: "Es sind keine Nachrichten vorhanden", callback: refresh);
    }

    return Column(
      key: _inboxWidgetKey,
      children: [
        filterRow,
        Expanded(
            child: RefreshIndicator(
          onRefresh: () async => {refresh()},
          child: ListView.separated(
            itemCount: state.inboxMessages.length + 1,
            separatorBuilder: (context, index) => const Divider(
              height: 0,
            ),
            itemBuilder: (context, index) {
              if (index == state.inboxMessages.length) {
                return PaginationLoading(
                    visible:
                        state.status == InboxMessageStatus.paginationLoading);
              } else {
                var message = state.inboxMessages[index];

                return Container(
                    color: (markedMessages.contains(index))
                        ? Theme.of(context).primaryColor.withOpacity(0.5)
                        : Colors.transparent,
                    child: ListTile(
                        onTap: () => {
                              if (markedMessages.isNotEmpty)
                                {
                                  if (markedMessages.contains(index))
                                    unmarkMessage(true, index)
                                  else
                                    markMessage(true, index)
                                }
                              else
                                {
                                  readMessage(message),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessageDetailpage(
                                            message: message)),
                                  )
                                }
                            },
                        onLongPress: () => {
                              if (!markedMessages.contains(index))
                                markMessage(true, index)
                            },
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            messageIcon(context, message.isRead)
                          ],
                        ),
                        trailing: Text(message.getTimeAgo()),
                        title: Text(message.subject),
                        subtitle: Text(message.sender.username)));
              }
            },
            controller: scrollController,
          ),
        ))
      ],
    );
  }
}
