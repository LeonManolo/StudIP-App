import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
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

final _inboxWidgetKey = GlobalKey<ScaffoldState>();

class InboxMessageWidget extends StatefulWidget {
  const InboxMessageWidget({
    super.key,
  });

  @override
  State<InboxMessageWidget> createState() => InboxMessageWidgetState();
}

class InboxMessageWidgetState extends State<InboxMessageWidget> {
  final List<String> _markedInboxMessages = [];
  final _inboxScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _inboxScrollController.addListener(_onInboxScroll);
  }

  @override
  void dispose() {
    _inboxScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InboxMessageBloc, InboxMessageState>(
      listener: (context, inboxState) {
        if (inboxState is InboxMessageStateDeleteSucceed) {
          buildSnackBar(
            context,
            inboxState.successInfo,
            Colors.green,
          );
        }
        if (inboxState is InboxMessageStateDeleteError) {
          buildSnackBar(
            context,
            inboxState.failureInfo,
            Colors.red,
          );
        }
      },
      builder: (context, inboxState) {
        if (inboxState is InboxMessageStateLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (inboxState.inboxMessages.isEmpty) {
          return RefreshableContent(
            callback: _refreshInboxMessages,
            child: const EmptyView(
              title: 'Keine Nachrichten',
              message: 'Es sind keine Nachrichten vorhanden',
            ),
          );
        }

        return BlocConsumer<TabBarBloc, TabBarState>(
          listener: (context, state) {
            if (_markedInboxMessages.isNotEmpty &&
                !state.messageMenuIconVisible) {
              _unmarkAll();
            }
            if (state is TabBarStateMarkAllInboxMessages) {
              _markAll();
            }
            if (state is TabBarStateDeleteInboxMessages) {
              _deleteMessages();
              context.read<TabBarBloc>().add(const HideMenuicon());
            }
          },
          builder: (context, state) {
            return Column(
              key: _inboxWidgetKey,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshInboxMessages(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: inboxState.inboxMessages.length + 1,
                      separatorBuilder: (context, index) => const Divider(
                        height: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        if (index == inboxState.inboxMessages.length) {
                          return PaginationLoadingIndicator(
                            visible: inboxState.paginationLoading,
                          );
                        } else {
                          final message = inboxState.inboxMessages[index];
                          return ColoredBox(
                            color: (_markedInboxMessages.contains(message.id))
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                                : Colors.transparent,
                            child: MessageTile(
                              messageIcon: MessageIcon(
                                iconData:
                                    getMessageIconData(isRead: message.isRead),
                                color: getMessageIconColor(
                                  isRead: message.isRead,
                                  context: context,
                                ),
                              ),
                              onTapFunction: () => {
                                if (_markedInboxMessages.isNotEmpty)
                                  {
                                    if (_markedInboxMessages
                                        .contains(message.id))
                                      _unmarkMessage(message.id)
                                    else
                                      _markMessage(message.id)
                                  }
                                else
                                  {
                                    _readMessage(message),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<MessageDetailPage>(
                                        builder: (context) => MessageDetailPage(
                                          isInbox: true,
                                          message: message,
                                          refreshMessages:
                                              _refreshInboxMessages,
                                        ),
                                      ),
                                    )
                                  }
                              },
                              onLongPressFunction: () =>
                                  _markMessage(message.id),
                              title: message.subject,
                              subTitle:
                                  'Von ${message.sender.formattedName} ${message.getTimeAgo()}',
                            ),
                          );
                        }
                      },
                      controller: _inboxScrollController,
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

  void _onInboxScroll() {
    final inboxMessageBloc = context.read<InboxMessageBloc>();
    final currentState = inboxMessageBloc.state;
    if (!currentState.maxReached) {
      _onScroll(
        bloc: inboxMessageBloc,
        event: InboxMessagesRequested(
          filter: currentState.currentFilter,
          offset: currentState.inboxMessages.length,
        ),
        scrollController: _inboxScrollController,
        threshold: currentState.inboxMessages.length,
        paginationLoading: currentState.paginationLoading,
        populated: currentState is! InboxMessageStateError,
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

  void _refreshInboxMessages() {
    setState(() {
      context.read<InboxMessageBloc>().add(const RefreshInboxRequested());
      _unmarkAll();
    });
  }

  void _markAll() {
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
      context.read<TabBarBloc>().add(const ShowMenuIcon());
      _markedInboxMessages.add(messageId);
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

  void _unmarkAll() {
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

  void _deleteMessages() {
    context.read<InboxMessageBloc>().add(
          DeleteInboxMessagesRequested(
            messageIds: _markedInboxMessages.toList(),
          ),
        );
    context.read<TabBarBloc>().add(const HideMenuicon());
  }
}
