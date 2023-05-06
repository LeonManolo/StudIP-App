import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';
import 'package:studipadawan/messages/message_overview/widgets/message_delete_button.dart';
import 'package:studipadawan/messages/message_overview/widgets/message_menu_button.dart';
import '../../../../app/bloc/app_bloc.dart';
import '../message_inbox_bloc /message_inbox_bloc.dart';
import '../message_inbox_bloc /message_inbox_event.dart';
import '../message_inbox_bloc /message_inbox_state.dart';
import '../message_outbox_bloc/message_outbox_bloc.dart';
import '../message_outbox_bloc/message_outbox_event.dart';
import '../message_outbox_bloc/message_outbox_state.dart';
import '../widgets/message_add_button.dart';
import '../widgets/message_bar.dart';
import '../widgets/message_filter_icon.dart';
import '../widgets/message_inbox_widget.dart';
import '../widgets/message_outbox_widget.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: MessagesPage());

  @override
  createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late InboxMessageBloc _inboxMessageBloc;
  late OutboxMessageBloc _outboxMessageBloc;
  late TabBarBloc _tabBarBloc;

  final List<Tab> _messageTabs = [
    const Tab(
      icon: Icon(Icons.all_inbox),
    ),
    const Tab(
      icon: Icon(Icons.outbox),
    )
  ];

  final _inboxScrollController = ScrollController();
  final _outboxScrollController = ScrollController();

  List<String> _markedInboxMessages = [];
  List<String> _markedOutboxMessages = [];

  @override
  void initState() {
    super.initState();
    _inboxMessageBloc = InboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const InboxMessagesRequested(filter: MessageFilter.none, offset: 0));
    _outboxMessageBloc = OutboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const OutboxMessagesRequested(offset: 0));
    _tabBarBloc = TabBarBloc();
    _inboxScrollController.addListener(() => _onInboxScroll());
    _outboxScrollController.addListener(() => _onOutboxScroll());
    _tabController = TabController(
      length: _messageTabs.length,
      vsync: this,
    )
      ..addListener(() {
        _onTabChanged(_tabController.index);
      })
      ..animation!.addListener(() {
        int currentIndex = _tabController.animation!.value.round();
        if (_tabBarBloc.state.currentTabIndex != currentIndex) {
          _tabBarBloc.add(TabIndexChanged(index: currentIndex));
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inboxScrollController.dispose();
    _outboxScrollController.dispose();
    _inboxMessageBloc.close();
    _outboxMessageBloc.close();
    _tabBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        key: UniqueKey(),
        body: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: MessageTabBar(controller: _tabController)),
            key: UniqueKey(),
            body: TabBarView(
              controller: _tabController,
              physics: const ScrollPhysics(),
              children: [
                BlocProvider.value(
                    value: _inboxMessageBloc,
                    child: BlocConsumer<InboxMessageBloc, InboxMessageState>(
                      listener: (context, state) {
                        if (state.status ==
                            InboxMessageStatus.deleteInboxMessagesSucceed) {
                          _buildSnackBar(context, state.message, Colors.green);
                        }
                        if (state.status ==
                            InboxMessageStatus.deleteInboxMessagesFailure) {
                          _buildSnackBar(context, state.message, Colors.red);
                        }
                      },
                      builder: (context, state) {
                        return InboxMessageWidget(
                            state: state,
                            readMessage: _readMessage,
                            markMessage: _markMessage,
                            unmarkMessage: _unmarkMessage,
                            markedMessages: _markedInboxMessages,
                            refresh: _refreshInboxMessages,
                            scrollController: _inboxScrollController);
                      },
                    )),
                BlocProvider.value(
                    value: _outboxMessageBloc,
                    child: BlocConsumer<OutboxMessageBloc, OutboxMessageState>(
                      listener: (context, state) {
                        if (state.status ==
                            OutboxMessageStatus.deleteOutboxMessagesSucceed) {
                          _buildSnackBar(context, state.message, Colors.green);
                        }
                        if (state.status ==
                            OutboxMessageStatus.deleteOutboxMessagesFailure) {
                          _buildSnackBar(context, state.message, Colors.red);
                        }
                      },
                      builder: (context, state) {
                        return OutboxMessageWidget(
                          state: state,
                          markMessage: _markMessage,
                          unmarkMessage: _unmarkMessage,
                          markedMessages: _markedOutboxMessages,
                          refresh: _refreshOutboxMessages,
                          scrollController: _outboxScrollController,
                        );
                      },
                    ))
              ],
            ),
            floatingActionButton:
                _markedInboxMessages.isEmpty && _markedOutboxMessages.isEmpty
                    ? const MessageAddButton()
                    : MessageDeleteButton(
                        deleteMessages: _deleteMessages,
                      ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat));
  }

  AppBar _buildAppBar(final BuildContext context) {
    return AppBar(
      title: const Text('Nachrichten'),
      actions: <Widget>[
        BlocProvider.value(
            value: _tabBarBloc,
            child:
                BlocBuilder<TabBarBloc, TabBarState>(builder: (context, state) {
              return Visibility(
                  visible: state.status == TabBarStatus.filterIconVisible &&
                      _markedInboxMessages.isEmpty,
                  child: MessageFilterIcon(
                      setFilter: _handleFilterSelection,
                      currentFilter: _inboxMessageBloc.state.currentFilter));
            })),
        if (_markedInboxMessages.isNotEmpty || _markedOutboxMessages.isNotEmpty)
          MessageMenuButton(markAll: _markAll, unmarkAll: _unmarkAll),
        IconButton(
          key: const Key('homePage_logout_iconButton'),
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
        )
      ],
    );
  }

  void _buildSnackBar(
      final BuildContext context, final String message, final Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _onInboxScroll() {
    final currentState = _inboxMessageBloc.state;
    if (!currentState.maxReached) {
      _onScroll(
          bloc: _inboxMessageBloc,
          event: InboxMessagesRequested(
              filter: currentState.currentFilter,
              offset: currentState.inboxMessages.length),
          scrollController: _inboxScrollController,
          threshold: currentState.inboxMessages.length,
          paginationLoading: currentState.paginationLoading,
          populated: currentState.status != InboxMessageStatus.failure);
    }
  }

  void _onOutboxScroll() {
    final currentState = _outboxMessageBloc.state;
    if (!currentState.maxReached) {
      _onScroll(
          bloc: _outboxMessageBloc,
          event: OutboxMessagesRequested(
              offset: currentState.outboxMessages.length),
          scrollController: _outboxScrollController,
          threshold: currentState.outboxMessages.length,
          paginationLoading: currentState.paginationLoading,
          populated: currentState.status != OutboxMessageStatus.failure);
    }
  }

  void _onScroll(
      {required Bloc bloc,
      required dynamic event,
      required ScrollController scrollController,
      required int threshold,
      required bool paginationLoading,
      required bool populated}) {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (!paginationLoading &&
        populated &&
        maxScroll - currentScroll <= threshold) {
      bloc.add(event);
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _unmarkAll();
    });
  }

  void _deleteMessages() {
    if (_tabController.index == 0) {
      _inboxMessageBloc
          .add(DeleteInboxMessagesRequested(messageIds: _markedInboxMessages));
    } else {
      _outboxMessageBloc.add(
          DeleteOutboxMessagesRequested(messageIds: _markedOutboxMessages));
    }
    setState(() {
      _unmarkAll();
    });
  }

  void _markMessage(final String messageId) {
    setState(() {
      if (_tabController.index == 0) {
        _markedInboxMessages.add(messageId);
      } else {
        _markedOutboxMessages.add(messageId);
      }
    });
  }

  void _unmarkMessage(final String messageId) {
    setState(() {
      if (_tabController.index == 0) {
        _markedInboxMessages.removeWhere((id) => id == messageId);
      } else {
        _markedOutboxMessages.removeWhere((id) => id == messageId);
      }
    });
  }

  void _unmarkAll() {
    setState(() {
      _markedInboxMessages = [];
      _markedOutboxMessages = [];
    });
  }

  void _markAll() {
    setState(() {
      if (_tabController.index == 0) {
        _markedInboxMessages.addAll(_inboxMessageBloc.state.inboxMessages
            .where((message) => !(_markedInboxMessages.contains(message.id)))
            .map((message) => message.id));
      } else {
        _markedOutboxMessages.addAll(_outboxMessageBloc.state.outboxMessages
            .where((message) => !(_markedOutboxMessages.contains(message.id)))
            .map((message) => message.id));
      }
    });
  }

  void _readMessage(final Message message) {
    setState(() {
      if (_inboxMessageBloc.state.currentFilter == MessageFilter.unread) {
        _inboxMessageBloc.state.inboxMessages.remove(message);
      } else {
        message.read();
      }
      _inboxMessageBloc.add(ReadMessageRequested(message: message));
    });
  }

  void _handleFilterSelection(final MessageFilter filter) {
    setState(() => {
          if (_inboxMessageBloc.state.currentFilter != filter)
            {
              _inboxMessageBloc
                  .add(InboxMessagesRequested(filter: filter, offset: 0))
            }
        });
  }

  void _refreshInboxMessages() {
    _inboxMessageBloc.add(const RefreshInboxRequested());
    _unmarkAll();
  }

  void _refreshOutboxMessages() {
    _outboxMessageBloc.add(const RefreshOutboxRequested());
    _unmarkAll();
  }
}
