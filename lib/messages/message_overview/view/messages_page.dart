import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_add_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_delete_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_filter_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_inbox_widget.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_menu_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_outbox_widget.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: MessagesPage());

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabBarBloc _tabBarBloc;

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
    _tabBarBloc = TabBarBloc();
    _tabController = TabController(
      length: _messageTabs.length,
      vsync: this,
    )..animation!.addListener(() {
        final int currentIndex = _tabController.animation!.value.round();
        if (_tabBarBloc.state.currentTabIndex != currentIndex) {
          _tabBarBloc
            ..add(const HideMenuicon())
            ..add(TabIndexChanged(index: currentIndex));
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InboxMessageBloc(
            messageRepository: context.read<MessageRepository>(),
            authenticationRepository: context.read<AuthenticationRepository>(),
          )..add(
              const InboxMessagesRequested(
                filter: MessageFilter.none,
                offset: 0,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => OutboxMessageBloc(
            messageRepository: context.read<MessageRepository>(),
            authenticationRepository: context.read<AuthenticationRepository>(),
          )..add(
              const OutboxMessagesRequested(offset: 0),
            ),
        ),
        BlocProvider.value(
          value: _tabBarBloc,
        ),
      ],
      child: BlocBuilder<TabBarBloc, TabBarState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: TabBarView(
              controller: _tabController,
              physics: const ScrollPhysics(),
              children: const [
                InboxMessageWidget(),
                OutboxMessageWidget(),
              ],
            ),
            floatingActionButton: state.messageMenuIconVisible
                ? MessageDeleteButton(
                    buildContext: context,
                  )
                : const MessageAddButton(),
          );
        }, 
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Nachrichten'),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.all_inbox),
            text: 'Empfangen',
          ),
          Tab(
            icon: Icon(Icons.outbox),
            text: 'Gesendet',
          )
        ],
        labelColor: Theme.of(context).primaryColor,
        indicatorColor: Theme.of(context).primaryColor,
      ),
      actions: <Widget>[
        BlocBuilder<TabBarBloc, TabBarState>(
          builder: (context, state) {
            if (state.filterIconVisible) {
              return const MessageFilterButton();
            } else if (state.messageMenuIconVisible) {
              return const MessageMenuButton();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
