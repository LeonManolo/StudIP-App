import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_bloc.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/widgets/filter_row.dart';
import 'package:studipadawan/messages/view/widgets/inbox_message_widget.dart';
import 'package:studipadawan/messages/view/widgets/outbox_message_widget.dart';
import 'package:studipadawan/messages/view/widgets/tabbar.dart';

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
      vsync: this
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocProvider(
        create: (context) => MessageBloc(
          messageRepository: context.read<MessageRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        )..add(RefreshRequested(filter: _currentFilter)),
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: MessageTabBar(controller: _controller)),
              body: TabBarView(
                controller: _controller,
                children: [
                  InboxMessageWidget(
                    state: state,
                    filterRow: FilterRow(
                      currentFilter: _currentFilter,
                      setFilter: _handleFilterSelection,
                    ),
                    currentFilter: _currentFilter,
                  ),
                  OutboxMessageWidget(
                    state: state,
                    currentFilter: _currentFilter,
                  ),
                ],
              ),
            );
          },
        ),
      ),
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

  void _fetchMessages(BuildContext context) {
    BlocProvider.of<MessageBloc>(context)
        .add(RefreshRequested(filter: _currentFilter));
  }

  void _handleFilterSelection(BuildContext context, MessageFilter filter) {
    setState(() {
      _currentFilter = filter;
      _fetchMessages(context);
    });
  }
}
