import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';

import 'package:studipadawan/utils/pagination_loading_indicator.dart';
import 'package:studipadawan/utils/refreshable_content.dart';

class OutboxMessageWidget extends StatefulWidget {
  const OutboxMessageWidget({
    super.key,
    required this.state,
    required this.scrollController,
    required this.unmarkAll,
  });
  final OutboxMessageState state;
  final ScrollController scrollController;
  final Function unmarkAll;

  @override
  State<OutboxMessageWidget> createState() => OutboxMessageWidgetState();
}

class OutboxMessageWidgetState extends State<OutboxMessageWidget> {
  Icon messageIcon(Color iconColor) {
    return Icon(EvaIcons.emailOutline, color: iconColor, size: 24);
  }

  final List<String> _markedOutboxMessages = [];

  @override
  Widget build(BuildContext context) {
    if (widget.state.status == OutboxMessageStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state.outboxMessages.isEmpty) {
      return RefreshableContent(
        callback: _refreshOutboxMessages,
        child: const Text('Es sind keine Nachrichten vorhanden'),
      );
    }
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _refreshOutboxMessages(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.state.outboxMessages.length + 1,
              separatorBuilder: (context, index) => const Divider(height: 0.5),
              itemBuilder: (context, index) {
                if (index == widget.state.outboxMessages.length) {
                  return PaginationLoadingIndicator(
                    visible: widget.state.status ==
                        OutboxMessageStatus.paginationLoading,
                  );
                } else {
                  final message = widget.state.outboxMessages[index];
                  return ColoredBox(
                    color: (_markedOutboxMessages.contains(message.id))
                        ? Theme.of(context).primaryColor.withOpacity(0.5)
                        : Colors.transparent,
                    child: ListTile(
                      onTap: () => {
                        if (_markedOutboxMessages.isNotEmpty)
                          {
                            if (_markedOutboxMessages.contains(message.id))
                              _unmarkMessage(context, message.id)
                            else
                              _markMessage(context, message.id)
                          }
                        else
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute<MessageDetailpage>(
                                builder: (context) => MessageDetailpage(
                                  isInbox: false,
                                  message: message,
                                  refreshMessages: _refreshOutboxMessages,
                                ),
                              ),
                            )
                          }
                      },
                      onLongPress: () => _markMessage(context, message.id),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          messageIcon(Theme.of(context).primaryColor)
                        ],
                      ),
                      trailing: Text(message.getTimeAgo()),
                      title: Text(message.subject),
                      subtitle: Text(message.parseRecipients()),
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

  void _markMessage(BuildContext context, String messageId) {
    setState(() {
      _markedOutboxMessages.add(messageId);
      context.read<TabBarBloc>().add(const ShowMenuIcon());
    });
  }

  void _unmarkMessage(BuildContext context, String messageId) {
    setState(() {
      _markedOutboxMessages.removeWhere((id) => id == messageId);
      if (_markedOutboxMessages.isEmpty) {
        context.read<TabBarBloc>().add(const HideMenuicon());
      }
    });
  }

  void markAll() {
    setState(() {
      _markedOutboxMessages.addAll(
        context
            .read<OutboxMessageBloc>()
            .state
            .outboxMessages
            .where((message) => !_markedOutboxMessages.contains(message.id))
            .map((message) => message.id),
      );
    });
  }

  void unmarkAll() {
    setState(() {
      _markedOutboxMessages.clear();
      context.read<TabBarBloc>().add(const HideMenuicon());
    });
  }

  void deleteMessages() {
    context.read<OutboxMessageBloc>().add(
          DeleteOutboxMessagesRequested(
            messageIds: _markedOutboxMessages.toList(),
          ),
        );
    context.read<TabBarBloc>().add(const HideMenuicon());
  }

  void _refreshOutboxMessages() {
    setState(() {
      context.read<OutboxMessageBloc>().add(const RefreshOutboxRequested());
      context.read<TabBarBloc>().add(const HideMenuicon());
      unmarkAll();
    });
  }
}
