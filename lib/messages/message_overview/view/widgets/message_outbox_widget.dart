import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_icon.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_tile.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/loading_indicator.dart';

import 'package:studipadawan/utils/pagination/pagination.dart';
import 'package:studipadawan/utils/refreshable_content.dart';
import 'package:studipadawan/utils/snackbar.dart';

final _outboxWidgetKey = GlobalKey<ScaffoldState>();
class OutboxMessageWidget extends StatefulWidget {
  const OutboxMessageWidget({
    super.key,
  });

  @override
  State<OutboxMessageWidget> createState() => OutboxMessageWidgetState();
}

class OutboxMessageWidgetState extends State<OutboxMessageWidget> {
  final List<String> _markedOutboxMessages = [];
  final _outboxScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _outboxScrollController.addListener(_onOutboxScroll);
  }

  @override
  void dispose() {
    _outboxScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OutboxMessageBloc, OutboxMessageState>(
      listener: (context, state) {
        if (state is OutboxMessageStateDeleteSucceed) {
          buildSnackBar(
            context,
            state.blocResponse,
            Colors.green,
          );
        }
        if (state is TabBarStateMarkAllOutboxMessages) {
          _markAll();
        }
        if (state is OutboxMessageStateDeleteError) {
          buildSnackBar(
            context,
            state.blocResponse,
            Colors.red,
          );
        }
      },
      builder: (context, outBoxState) {
        if (outBoxState is OutboxMessageStateLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (outBoxState.outboxMessages.isEmpty) {
          return RefreshableContent(
            callback: _refreshOutboxMessages,
            child: const EmptyView(
              title: 'Keine Nachrichten',
              message: 'Es sind keine Nachrichten vorhanden',
            ),
          );
        }

        return BlocConsumer<TabBarBloc, TabBarState>(
          listener: (context, state) {
            if (_markedOutboxMessages.isNotEmpty &&
                !state.messageMenuIconVisible) {
              _unmarkAll();
            }
            if (state is TabBarStateMarkAllOutboxMessages) {
              _markAll();
            }
            if (state is TabBarStateDeleteOutboxMessages) {
              _deleteMessages();
              context.read<TabBarBloc>().add(const HideMenuicon());
            }
          },
          builder: (context, state) {
            return Column(
              key: _outboxWidgetKey,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshOutboxMessages(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: outBoxState.outboxMessages.length + 1,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 0.5),
                      itemBuilder: (context, index) {
                        if (index == outBoxState.outboxMessages.length) {
                          return PaginationLoadingIndicator(
                            visible: outBoxState.paginationLoading,
                          );
                        } else {
                          final message = outBoxState.outboxMessages[index];
                          return ColoredBox(
                            color: (_markedOutboxMessages.contains(message.id))
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                                : Colors.transparent,
                            child: MessageTile(
                              messageIcon: MessageIcon(
                                iconData: getMessageIconData(isRead: true),
                              ),
                              onTapFunction: () => {
                                if (_markedOutboxMessages.isNotEmpty)
                                  {
                                    if (_markedOutboxMessages
                                        .contains(message.id))
                                      _unmarkMessage(context, message.id)
                                    else
                                      _markMessage(context, message.id)
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<MessageDetailPage>(
                                        builder: (context) => MessageDetailPage(
                                          isInbox: false,
                                          message: message,
                                          refreshMessages:
                                              _refreshOutboxMessages,
                                        ),
                                      ),
                                    )
                                  }
                              },
                              onLongPressFunction: () =>
                                  _markMessage(context, message.id),
                              title: message.subject,
                              subTitle:
                                  'An ${message.parseRecipients()} ${message.getTimeAgo()}',
                            ),
                          );
                        }
                      },
                      controller: _outboxScrollController,
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _onOutboxScroll() {
    final outBoxMessageBloc = context.read<OutboxMessageBloc>();
    final currentState = outBoxMessageBloc.state;
    if (!currentState.maxReached) {
      _onScroll(
        bloc: outBoxMessageBloc,
        event: OutboxMessagesRequested(
          offset: currentState.outboxMessages.length,
        ),
        scrollController: _outboxScrollController,
        threshold: currentState.outboxMessages.length,
        paginationLoading: currentState.paginationLoading,
        populated: currentState is! OutboxMessageStateError,
      );
    }
  }

  void _onScroll({
    required Bloc<dynamic, dynamic> bloc,
    required dynamic event,
    required ScrollController scrollController,
    required int threshold,
    required bool paginationLoading,
    required bool populated,
  }) {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (!paginationLoading &&
        populated &&
        maxScroll - currentScroll <= threshold) {
      bloc.add(event);
    }
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

  void _markAll() {
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

  void _unmarkAll() {
    setState(() {
      _markedOutboxMessages.clear();
      context.read<TabBarBloc>().add(const HideMenuicon());
    });
  }

  void _deleteMessages() {
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
      _unmarkAll();
    });
  }
}
