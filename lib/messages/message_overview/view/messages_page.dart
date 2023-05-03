import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
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

  List<int> _markedInboxMessages = [];
  List<int> _markedOutboxMessages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _messageTabs.length,
      vsync: this,
    )..addListener(() {
      setState(() {
        _onTabChanged(_tabController.index);
      });
      });
    _inboxMessageBloc = InboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const InboxMessagesRequested(filter: MessageFilter.none, offset: 0));
    _outboxMessageBloc = OutboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const OutboxMessagesRequested(offset: 0));
    _inboxScrollController.addListener(() => _onInboxScroll());
    _outboxScrollController.addListener(() => _onOutboxScroll());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inboxScrollController.dispose();
    _outboxScrollController.dispose();
    _inboxMessageBloc.close();
    _outboxMessageBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context, _tabController.index),
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
                  child: BlocBuilder<InboxMessageBloc, InboxMessageState>(
                    builder: (context, state) {
                      return InboxMessageWidget(
                        state: state,
                        readMessage: _readMessage,
                        markMessage: _markMessage,
                        unmarkMessage: _unmarkMessage,
                        markedMessages: _markedInboxMessages,
                        refresh: _refreshInboxMessages,
                        scrollController: _inboxScrollController
                      );
                    },
                  ),
                ),
                BlocProvider.value(
                  value: _outboxMessageBloc,
                  child: BlocBuilder<OutboxMessageBloc, OutboxMessageState>(
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
                  ),
                ),
              ],
            ),
            floatingActionButton: const MessageAddButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat));
  }

  AppBar _buildAppBar(BuildContext context, int tab) {
    return AppBar(
      title: const Text('Nachrichten'),
      actions: <Widget>[
          if (tab == 0)
          MessageFilterIcon(
              setFilter: _handleFilterSelection,
              currentFilter: _inboxMessageBloc.state.currentFilter),
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
          populated: currentState.status == InboxMessageStatus.populated);
    }
  }

  void _onTabChanged(int index) {
    _tabController.animateTo(index);
    setState(() {
      _markedInboxMessages = [];
      _markedOutboxMessages = [];
    });
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
          populated: currentState.status == OutboxMessageStatus.populated);
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

  void _markMessage(bool isInbox, int index) {
    var offsetBefore = _inboxScrollController.offset;
    setState(() {
      if (isInbox) {
        _markedInboxMessages.add(index);
        _inboxScrollController.jumpTo(offsetBefore);
      } else {
        _markedOutboxMessages.add(index);
      }
      _inboxScrollController.jumpTo(offsetBefore);
    });
  }

  void _unmarkMessage(bool isInbox, int index) {
    setState(() {
      if (isInbox) {
        _markedInboxMessages.removeWhere((idx) => idx == index);
      } else {
        _markedOutboxMessages.removeWhere((idx) => idx == index);
      }
    });
  }

  void _readMessage(Message message) {
    setState(() {
      if (_inboxMessageBloc.state.currentFilter == MessageFilter.unread) {
        _inboxMessageBloc.state.inboxMessages.remove(message);
      } else {
        message.read();
      }
      _inboxMessageBloc.add(ReadMessageRequested(message: message));
    });
  }

  void _handleFilterSelection(MessageFilter filter) {
    if (_inboxMessageBloc.state.currentFilter != filter) {
      _inboxMessageBloc.add(InboxMessagesRequested(filter: filter, offset: 0));
    }
  }

  void _refreshInboxMessages() {
    _inboxMessageBloc.add(const RefreshInboxRequested());
  }

  void _refreshOutboxMessages() {
    _outboxMessageBloc.add(const RefreshOutboxRequested());
  }
}
