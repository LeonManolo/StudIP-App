import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import '../../../message_details/view/message_detail_page.dart';

import '../../message_inbox_bloc /message_inbox_state.dart';
import '../../message_tabbar_bloc /message_tabbar_bloc.dart';
import '../../message_tabbar_bloc /message_tabbar_event.dart';
import 'message_pagination_loading.dart';
import 'message_refreshable.dart';

final _inboxWidgetKey = GlobalKey<ScaffoldState>();

class InboxMessageWidget extends StatefulWidget {
  final InboxMessageState state;
  final ScrollController scrollController;
  final Function unmarkAll;

  const InboxMessageWidget(
      {Key? key,
      required this.state,
      required this.scrollController,
      required this.unmarkAll})
      : super(key: key);

  @override
  State<InboxMessageWidget> createState() => InboxMessageWidgetState();
}

class InboxMessageWidgetState extends State<InboxMessageWidget> {
  Icon messageIcon(BuildContext context, bool isRead) {
    if (isRead) {
      return Icon(EvaIcons.messageSquareOutline,
          color: Theme.of(context).primaryColor, size: 24.0);
    } else {
      return Icon(EvaIcons.messageSquare,
          color: Theme.of(context).primaryColor, size: 24.0);
    }
  }

  final List<String> _markedInboxMessages = [];

  @override
  Widget build(BuildContext context) {
    if (widget.state.status == InboxMessageStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state.inboxMessages.isEmpty) {
      return RefreshableMessage(
          text: "Es sind keine Nachrichten vorhanden",
          callback: _refreshInboxMessages);
    }

    return Column(
      key: _inboxWidgetKey,
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _refreshInboxMessages(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.state.inboxMessages.length + 1,
              separatorBuilder: (context, index) => const Divider(
                height: 0.5,
              ),
              itemBuilder: (context, index) {
                if (index == widget.state.inboxMessages.length) {
                  return PaginationLoading(
                      visible: widget.state.status ==
                          InboxMessageStatus.paginationLoading);
                } else {
                  var message = widget.state.inboxMessages[index];

                  return Container(
                    color: (_markedInboxMessages.contains(message.id))
                        ? Theme.of(context).primaryColor.withOpacity(0.5)
                        : Colors.transparent,
                    child: ListTile(
                        onTap: () => {
                              if (_markedInboxMessages.isNotEmpty)
                                {
                                  if (_markedInboxMessages.contains(message.id))
                                    _unmarkMessage(message.id)
                                  else
                                    _markMessage(message.id)
                                }
                              else
                                {
                                  _readMessage(message),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessageDetailpage(
                                            isInbox: true,
                                            message: message,
                                            refreshMessages:
                                                _refreshInboxMessages)),
                                  )
                                }
                            },
                        onLongPress: () => _markMessage(message.id),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            messageIcon(context, message.isRead)
                          ],
                        ),
                        trailing: Text(message.getTimeAgo()),
                        title: Text(message.subject),
                        subtitle: Text(message.sender.parseUsername())),
                  );
                }
              },
              controller: widget.scrollController,
            ),
          ),
        )
      ],
    );
  }

  void _refreshInboxMessages() {
    setState(() {
      context.read<InboxMessageBloc>().add(const RefreshInboxRequested());
      unmarkAll();
    });
  }

  void markAll() {
    setState(() {
      _markedInboxMessages.addAll(context
          .read<InboxMessageBloc>()
          .state
          .inboxMessages
          .where((message) => !(_markedInboxMessages.contains(message.id)))
          .map((message) => message.id));
    });
  }

  void _markMessage(final String messageId) {
    setState(() {
      _markedInboxMessages.add(messageId);
      context.read<TabBarBloc>().add(const ShowMenuIcon());
    });
  }

  void _readMessage(final Message message) {
    var bloc = context.read<InboxMessageBloc>();
    setState(() {
      if (bloc.state.currentFilter == MessageFilter.unread) {
        bloc.state.inboxMessages.remove(message);
      } else {
        message.read();
      }
      bloc.add(ReadMessageRequested(message: message));
    });
  }

  void unmarkAll() {
    setState(() {
      _markedInboxMessages.clear();
      context.read<TabBarBloc>().add(const HideMenuicon());
    });
  }

  void _unmarkMessage(final String messageId) {
    setState(() {
      _markedInboxMessages.removeWhere((id) => id == messageId);
      if (_markedInboxMessages.isEmpty) {
        context.read<TabBarBloc>().add(const HideMenuicon());
      }
    });
  }

  void deleteMessages() {
    context
        .read<InboxMessageBloc>()
        .add(DeleteInboxMessagesRequested(messageIds: _markedInboxMessages.toList()));
       context.read<TabBarBloc>().add(const HideMenuicon());
  }
}
