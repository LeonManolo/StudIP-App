import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_bloc.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/widgets/InboxMessageWidget.dart';
import 'package:studipadawan/messages/view/widgets/OutboxMessageWidget.dart';
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
  MessageFilter currentFilter = MessageFilter.none;
  late MessageBloc messageBloc;
  late TabController _controller;

  final List<Tab> messageTabs = [
    const Tab(
      icon: Icon(Icons.all_inbox),
    ),
    const Tab(
      icon: Icon(Icons.outbox),
    )
  ];

  bool isFilterVisible = true;

  void toggleFilter() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: messageTabs.length,
        vsync: this,
        animationDuration: Duration.zero);
    messageBloc = MessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(RefreshRequested(filter: currentFilter, isInbox: true));
    _controller.addListener(() => {
          toggleFilter(),
          fetchMessages(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BlocBuilder<MessageBloc, MessageState>(
        bloc: messageBloc,
        builder: (context, state) {
          return DefaultTabController(
            initialIndex: 0,
            length: messageTabs.length,
            child: Scaffold(
              appBar: buildTabBar(context),
              body: TabBarView(
                children: <Widget>[
                  buildInboxWidget(context, state),
                  buildOutboxWidget(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row buildFilterRow(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        PopupMenuButton<MessageFilter>(
            icon: funnelIcon(),
            onSelected: (newFilter) => handleFilterSelection(newFilter),
            itemBuilder: (context) => [
                  PopupMenuItem<MessageFilter>(
                      value: MessageFilter.none,
                      child: filter(MessageFilter.none, "Kein Filter")),
                  PopupMenuItem<MessageFilter>(
                      value: MessageFilter.unread,
                      child: filter(
                          MessageFilter.unread, "Ungelesene Nachrichten")),
                  PopupMenuItem<MessageFilter>(
                      value: MessageFilter.read,
                      child:
                          filter(MessageFilter.read, "Gelesene Nachrichten")),
                ])
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
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

  PreferredSize buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              TabBar(
                controller: _controller,
                tabs: messageTabs,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRefreshableList({
    required MessageState state,
    required bool inbox,
  }) {
    if (state.messages.isEmpty) {
      return const Center(
        child: Text('No messages found'),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => fetchMessages(),
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

  Widget buildInboxWidget(BuildContext context, MessageState state) {
    return Column(
      children: [
        if (isFilterVisible) buildFilterRow(context),
        Expanded(
            child: state.status != MessageStatus.populated
                ? const Center(child: CircularProgressIndicator())
                : buildRefreshableList(state: state, inbox: true)),
      ],
    );
  }

  Widget buildOutboxWidget(BuildContext context, MessageState state) {
    return state.status != MessageStatus.populated
        ? const Center(child: CircularProgressIndicator())
        : buildRefreshableList(state: state, inbox: false);
  }

  fetchMessages() {
    messageBloc.add(RefreshRequested(
        filter: currentFilter, isInbox: _controller.index == 0));
  }

  handleFilterSelection(MessageFilter filter) {
    currentFilter = filter;
    fetchMessages();
  }

  funnelIcon() {
    if (currentFilter != MessageFilter.none) {
      return const Icon(EvaIcons.funnel, size: 25, color: Colors.blue);
    } else {
      return const Icon(EvaIcons.funnelOutline, size: 25, color: Colors.blue);
    }
  }

  filter(MessageFilter filter, String filterText) {
    if (currentFilter == filter) {
      return Row(children: [
        Text(filterText),
        Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child: const Icon(
              Icons.check,
              color: Colors.blue,
              size: 20.0,
            ))
      ]);
    } else {
      return Text(filterText);
    }
  }
}
