import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_inbox_bloc.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_filter_row.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_bar.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_inbox_widget.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_outbox_widget.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_add_button.dart';
import '../../../app/bloc/app_bloc.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: MessagesPage());

  @override
  createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  MessageFilter _currentFilter = MessageFilter.none;

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

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _messageTabs.length, vsync: this);
    _inboxMessageBloc = InboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(InboxMessagesRequested(filter: _currentFilter));
    _outboxMessageBloc = OutboxMessageBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const OutboxMessagesRequested());
  }

  @override
  void dispose() {
    _controller.dispose();
    _inboxMessageBloc.close();
    _outboxMessageBloc.close();
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
                child: MessageTabBar(controller: _controller)),
            key: UniqueKey(),
            body: TabBarView(
              controller: _controller,
              children: [
                BlocProvider.value(
                  value: _inboxMessageBloc,
                  child: BlocBuilder<InboxMessageBloc, InboxMessageState>(
                    builder: (context, state) {
                      return InboxMessageWidget(
                        state: state,
                        readMessage: _readMessage,
                        filterRow: FilterRow(
                          currentFilter: _currentFilter,
                          setFilter: _handleFilterSelection,
                        ),
                        currentFilter: _currentFilter,
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
                        currentFilter: _currentFilter,
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

  void _readMessage(BuildContext context, Message message) {
    setState(() {
      BlocProvider.of<InboxMessageBloc>(context)
          .add(ReadMessageRequested(messageId: message.id));
      message.read();
    });
  }

  void _handleFilterSelection(BuildContext context, MessageFilter filter) {
    setState(() {
      _currentFilter = filter;
      BlocProvider.of<InboxMessageBloc>(context)
          .add(InboxMessagesRequested(filter: _currentFilter));
    });
  }
}
