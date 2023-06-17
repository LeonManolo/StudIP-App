import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_icon.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_tile.dart';
import 'package:studipadawan/utils/empty_view.dart';

import 'package:studipadawan/utils/pagination/pagination.dart';
import 'package:studipadawan/utils/refreshable_content.dart';

final _inboxWidgetKey = GlobalKey<ScaffoldState>();

class InboxMessageWidget extends StatefulWidget {
  const InboxMessageWidget({
    super.key,
    required this.state,
    required this.scrollController,
    required this.unmarkAll,
  });
  final InboxMessageState state;
  final ScrollController scrollController;
  final Function unmarkAll;

  @override
  State<InboxMessageWidget> createState() => InboxMessageWidgetState();
}

class InboxMessageWidgetState extends State<InboxMessageWidget> {
  final List<String> _markedInboxMessages = [];

  @override
  Widget build(BuildContext context) {
    if (widget.state.status == InboxMessageStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state.inboxMessages.isEmpty) {
      return RefreshableContent(
        callback: _refreshInboxMessages,
        child: const EmptyView(
          title: 'Keine Nachrichten',
          message: 'Es sind keine Nachrichten vorhanden',
        ),
      );
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
                  return PaginationLoadingIndicator(
                    visible: widget.state.status ==
                        InboxMessageStatus.paginationLoading,
                  );
                } else {
                  final message = widget.state.inboxMessages[index];
                  return ColoredBox(
                    color: (_markedInboxMessages.contains(message.id))
                        ? Theme.of(context).primaryColor.withOpacity(0.5)
                        : Colors.transparent,
                    child: MessageTile(
                      messageIcon: messageIcon(context, isRead: message.isRead),
                      onTapFunction: () => {
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
                              MaterialPageRoute<MessageDetailpage>(
                                builder: (context) => MessageDetailpage(
                                  isInbox: true,
                                  message: message,
                                  refreshMessages: _refreshInboxMessages,
                                ),
                              ),
                            )
                          }
                      },
                      onLongPressFunction: () => _markMessage(message.id),
                      trailing: message.getTimeAgo(),
                      title: message.subject,
                      subTitle: message.sender.formattedName,
                    ),
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
      _markedInboxMessages.addAll(
        context
            .read<InboxMessageBloc>()
            .state
            .inboxMessages
            .where((message) => !_markedInboxMessages.contains(message.id))
            .map((message) => message.id),
      );
    });
  }

  void _markMessage(String messageId) {
    setState(() {
      _markedInboxMessages.add(messageId);
      context.read<TabBarBloc>().add(const ShowMenuIcon());
    });
  }

  void _readMessage(Message message) {
    final bloc = context.read<InboxMessageBloc>();
    setState(() {
      if (bloc.state.currentFilter == MessageFilter.unread) {
        bloc.state.inboxMessages.remove(message);
      } else {
        message.read();
      }
    });
  }

  void unmarkAll() {
    setState(() {
      _markedInboxMessages.clear();
      context.read<TabBarBloc>().add(const HideMenuicon());
    });
  }

  void _unmarkMessage(String messageId) {
    setState(() {
      _markedInboxMessages.removeWhere((id) => id == messageId);
      if (_markedInboxMessages.isEmpty) {
        context.read<TabBarBloc>().add(const HideMenuicon());
      }
    });
  }

  void deleteMessages() {
    context.read<InboxMessageBloc>().add(
          DeleteInboxMessagesRequested(
            messageIds: _markedInboxMessages.toList(),
          ),
        );
    context.read<TabBarBloc>().add(const HideMenuicon());
  }
}
