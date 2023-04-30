import 'package:authentication_repository/authentication_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
  final _outboxScrollController = ScrollController();
=======
  final _outboxPagingController = PagingController<int, ListTile>(
    firstPageKey: 1,
  );
>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
    _tabController = TabController(
      length: _messageTabs.length,
      vsync: this,
    )..addListener(() {
      setState(() {
      });
      });
=======
    _controller = TabController(length: _messageTabs.length, vsync: this);

>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart
    _inboxMessageBloc = InboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const InboxMessagesRequested(filter: MessageFilter.none, offset: 0));
    _outboxMessageBloc = OutboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
    )..add(const OutboxMessagesRequested(offset: 0));
    _inboxScrollController.addListener(() => _onInboxScroll());
    _outboxScrollController.addListener(() => _onOutboxScroll());
=======
    )..add(const OutboxMessagesRequested());
    _inboxScrollController.addListener(() => _onInboxScroll());
>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart
  }

  @override
  void dispose() {
<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
    _tabController.dispose();
    _inboxScrollController.dispose();
    _outboxScrollController.dispose();
=======
    _controller.dispose();
    _inboxScrollController.dispose();
    _outboxPagingController.dispose();
>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart
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
                        refresh: _refreshInboxMessages,
                        scrollController: _inboxScrollController,
<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
=======
                        filterRow: FilterRow(
                            currentFilter: state.currentFilter,
                            setFilter: _handleFilterSelection),
>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart
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
<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
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
=======
    final maxScroll = _inboxScrollController.position.maxScrollExtent;
    final currentScroll = _inboxScrollController.position.pixels;
    final threshold = currentState.inboxMessages.length;

    if (!currentState.maxReached &&
        currentState.status == InboxMessageStatus.populated 
        && !currentState.paginationLoading
        && maxScroll - currentScroll <= threshold) {
      _inboxMessageBloc.add(InboxMessagesRequested(
          filter: currentState.currentFilter,
          offset: currentState.inboxMessages.length));
>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart
    }
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

<<<<<<< HEAD:lib/messages/message_overview/view/messages_page.dart
  void _handleFilterSelection(MessageFilter filter) {
    setState(() {
      if (_inboxMessageBloc.state.currentFilter != filter) {
        _inboxMessageBloc
            .add(InboxMessagesRequested(filter: filter, offset: 0));
      }
    });
  }

  void _refreshInboxMessages() {
    _inboxMessageBloc.add(const RefreshInboxRequested());
  }

  void _refreshOutboxMessages() {
    _outboxMessageBloc.add(const RefreshOutboxRequested());
=======
  void _handleFilterSelection(BuildContext context, MessageFilter filter) {
    _inboxMessageBloc.add(InboxMessagesRequested(filter: filter, offset: 0));
  }

  void _refreshInboxMessages() {
    _inboxMessageBloc.add(const RefreshRequested());
>>>>>>> 21af4e8 (Implemented lazy loading inboxmessages. Needs to be refactored):lib/messages/messages/view/messages_page.dart
  }
}
