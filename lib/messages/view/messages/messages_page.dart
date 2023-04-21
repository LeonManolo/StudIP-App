import 'package:authentication_repository/authentication_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_bloc.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/message_send/message_send_page.dart';
import 'package:studipadawan/messages/view/messages/widgets/filter_row.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_bar.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_inbox_widget.dart';
import 'package:studipadawan/messages/view/messages/widgets/message_outbox_widget.dart';
import '../../../app/bloc/app_bloc.dart';

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
    _controller = TabController(length: _messageTabs.length, vsync: this);
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
                      readMessage: _readMessage,
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
                floatingActionButton: Stack(
                  children: [
                    const Positioned(
                      bottom: 4.0,
                      right: 4.0,
                      child: Icon(EvaIcons.plusCircleOutline,
                          color: Colors.white, size: 60),
                    ),
                    Positioned(
                      bottom: 24.0,
                      right: 24.0,
                      child: IconButton(
                        icon: Icon(EvaIcons.plusCircle,
                            color: Theme.of(context).primaryColor, size: 60),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MessageSendPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat);
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

  void _readMessage(BuildContext context, Message message) {
    setState(() {
      BlocProvider.of<MessageBloc>(context)
          .add(ReadMessageRequested(messageId: message.id));
      message.read();
    });
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
