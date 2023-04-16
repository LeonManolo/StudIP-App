import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_bloc.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/widgets/inbox_messages.dart';
import 'package:studipadawan/messages/view/widgets/outbox_messages.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../../app/bloc/app_bloc.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: MessagesPage());

  @override
  createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  MessageFilter _currentFilter = MessageFilter.none;

  final List<Tab> _messageTabs = [
    const Tab(
      icon: Icon(Icons.all_inbox),
    ),
    const Tab(
      icon: Icon(Icons.outbox),
    )
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: _messageTabs.length,
        vsync: this,
        animationDuration: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocProvider(
        create: (context) => MessageBloc(
          messageRepository: context.read<MessageRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        )..add(RefreshRequested(filter: _currentFilter, isInbox: true)),
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            return DefaultTabController(
              initialIndex: 0,
              length: _messageTabs.length,
              child: Scaffold(
                appBar: _buildTabBar(context),
                body: TabBarView(
                  children: <Widget>[
                    _buildInboxWidget(context, state),
                    _buildOutboxWidget(context, state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilter(MessageFilter filter, String filterText) {
    return PopupMenuItem<MessageFilter>(
      value: filter,
      child: Row(
        children: [
          Expanded(
            child: Text(filterText),
          ),
          if (_currentFilter == filter)
            Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: const Icon(
                Icons.check,
                color: Colors.indigo,
                size: 20.0,
              ),
            ),
        ],
      ),
    );
  }

  Row _buildFilterRow(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        PopupMenuButton<MessageFilter>(
            icon: _funnelIcon(),
            onSelected: (newFilter) =>
                _handleFilterSelection(context, newFilter),
            itemBuilder: (context) => [
                  PopupMenuItem<MessageFilter>(
                      value: MessageFilter.none,
                      child: _buildFilter(MessageFilter.none, "Kein Filter")),
                  PopupMenuItem<MessageFilter>(
                      value: MessageFilter.unread,
                      child: _buildFilter(
                          MessageFilter.unread, "Ungelesene Nachrichten")),
                  PopupMenuItem<MessageFilter>(
                      value: MessageFilter.read,
                      child: _buildFilter(
                          MessageFilter.read, "Gelesene Nachrichten")),
                ])
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Nachrichten'),
      actions: <Widget>[
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

  PreferredSize _buildTabBar(BuildContext context) {
    _controller.addListener(() => {_fetchMessages(context)});
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              TabBar(
                controller: _controller,
                tabs: _messageTabs,
                labelColor: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshableList({
    required BuildContext context,
    required MessageState state,
    required bool inbox,
  }) {
    if (state.messages.isEmpty) {
      return const Center(
        child: Text('Keine Nachrichten vorhanden'),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => _fetchMessages(context),
      child: ListView.separated(
        itemCount: state.messages.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          if (state.status != MessageStatus.populated) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (_controller.index == 0) {
              return InboxMessageWidget(message: state.messages[index]);
            } else {
              return OutboxMessageWidget(message: state.messages[index]);
            }
          }
        },
      ),
    );
  }

  Widget _buildInboxWidget(BuildContext context, MessageState state) {
    return Column(
      children: [
        if (_controller.index == 0) _buildFilterRow(context),
        Expanded(
            child: state.status != MessageStatus.populated
                ? const Center(child: CircularProgressIndicator())
                : _buildRefreshableList(
                    context: context, state: state, inbox: true)),
      ],
    );
  }

  Widget _buildOutboxWidget(BuildContext context, MessageState state) {
    return state.status != MessageStatus.populated
        ? const Center(child: CircularProgressIndicator())
        : _buildRefreshableList(context: context, state: state, inbox: false);
  }

  void _fetchMessages(BuildContext context) {
    BlocProvider.of<MessageBloc>(context).add(RefreshRequested(
        filter: _currentFilter, isInbox: _controller.index == 0));
  }

  void _handleFilterSelection(BuildContext context, MessageFilter filter) {
    _currentFilter = filter;
    _fetchMessages(context);
  }

  Icon _funnelIcon() {
    if (_currentFilter != MessageFilter.none) {
      return const Icon(EvaIcons.funnel, size: 25, color: Colors.indigo);
    } else {
      return const Icon(EvaIcons.funnelOutline, size: 25, color: Colors.indigo);
    }
  }
}
