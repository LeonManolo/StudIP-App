import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_add_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_bar.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_delete_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_filter_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_inbox_widget.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_menu_button.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_outbox_widget.dart';
import 'package:studipadawan/utils/utils.dart';

final _outboxWidgetKey = GlobalKey<OutboxMessageWidgetState>();
final _inboxWidgetKey = GlobalKey<InboxMessageWidgetState>();

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: MessagesPage());

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage>
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
    _inboxScrollController.addListener(_onInboxScroll);
    _outboxScrollController.addListener(_onOutboxScroll);
    _tabController = TabController(
      length: _messageTabs.length,
      vsync: this,
    )
      ..addListener(() {
        _onTabChanged(_tabController.index);
      })
      ..animation!.addListener(() {
        final int currentIndex = _tabController.animation!.value.round();
        if (_tabBarBloc.state.currentTabIndex != currentIndex) {
          _unmarkAll();
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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        cupertino: (_,__) => CupertinoNavigationBarData(
          border: Border.all(color: Colors.transparent),
          title: Text("Nachrichten"),
        ),
      ),
      body: Column(
        children: [
          const CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            transitionBetweenRoutes: false,
            heroTag: '____none',
            border: null,
            middle: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: SizedBox.expand(
                child: AdaptiveTabBar(tabs: [
                  (title: 'Empfangen', widget: Tab(
                    icon: Icon(Icons.all_inbox),
                  )),
                  (title: 'Gesendet', widget: Tab(
                    icon: Icon(Icons.outbox),
                  )),
                ]),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const ScrollPhysics(),
              children: [
                BlocProvider.value(
                  value: _inboxMessageBloc,
                  child: BlocConsumer<InboxMessageBloc, InboxMessageState>(
                    listener: (context, state) {
                      if (state.status ==
                          InboxMessageStatus.deleteInboxMessagesSucceed) {
                        buildSnackBar(
                          context,
                          state.blocResponse,
                          Colors.green,
                        );
                      }
                      if (state.status ==
                          InboxMessageStatus.deleteInboxMessagesFailure) {
                        buildSnackBar(
                          context,
                          state.blocResponse,
                          Colors.red,
                        );
                      }
                    },
                    builder: (context, state) {
                      return InboxMessageWidget(
                        key: _inboxWidgetKey,
                        state: state,
                        unmarkAll: _unmarkAll,
                        scrollController: _inboxScrollController,
                      );
                    },
                  ),
                ),
                BlocProvider.value(
                  value: _outboxMessageBloc,
                  child: BlocConsumer<OutboxMessageBloc, OutboxMessageState>(
                    listener: (context, state) {
                      if (state.status ==
                          OutboxMessageStatus.deleteOutboxMessagesSucceed) {
                        buildSnackBar(
                          context,
                          state.blocResponse,
                          Colors.green,
                        );
                      }
                      if (state.status ==
                          OutboxMessageStatus.deleteOutboxMessagesFailure) {
                        buildSnackBar(
                          context,
                          state.blocResponse,
                          Colors.red,
                        );
                      }
                    },
                    builder: (context, state) {
                      return OutboxMessageWidget(
                        key: _outboxWidgetKey,
                        unmarkAll: _unmarkAll,
                        state: state,
                        scrollController: _outboxScrollController,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  PlatformAppBar _buildAppBar() {
    return PlatformAppBar(
      title: const Text('Nachrichten'),
      trailingActions: <Widget>[
        BlocProvider.value(
          value: _tabBarBloc,
          child: BlocBuilder<TabBarBloc, TabBarState>(
            builder: (context, state) {
              return Row(
                children: [
                  Visibility(
                    visible: state.filterIconVisible,
                    child: MessageFilterButton(
                      setFilter: _handleFilterSelection,
                      currentFilter: _inboxMessageBloc.state.currentFilter,
                    ),
                  ),
                  Visibility(
                    visible: state.menuIconVisible,
                    child: MessageMenuButton(
                      markAll: _markAll,
                      unmarkAll: _unmarkAll,
                    ),
                  ),
                  IconButton(
                    key: const Key('homePage_logout_iconButton'),
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      context.read<AppBloc>().add(const AppLogoutRequested());
                    },
                  )
                ],
              );
            },
          ),
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
          offset: currentState.inboxMessages.length,
        ),
        scrollController: _inboxScrollController,
        threshold: currentState.inboxMessages.length,
        paginationLoading: currentState.paginationLoading,
        populated: currentState.status != InboxMessageStatus.failure,
      );
    }
  }

  void _onOutboxScroll() {
    final currentState = _outboxMessageBloc.state;
    if (!currentState.maxReached) {
      _onScroll(
        bloc: _outboxMessageBloc,
        event: OutboxMessagesRequested(
          offset: currentState.outboxMessages.length,
        ),
        scrollController: _outboxScrollController,
        threshold: currentState.outboxMessages.length,
        paginationLoading: currentState.paginationLoading,
        populated: currentState.status != OutboxMessageStatus.failure,
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

  void _onTabChanged(int index) {
    _unmarkAll();
  }

  void _deleteMessages() {
    if (_tabController.index == 0) {
      _inboxWidgetKey.currentState?.deleteMessages();
    } else {
      _outboxWidgetKey.currentState?.deleteMessages();
    }
    _unmarkAll();
  }

  void _unmarkAll() {
    _outboxWidgetKey.currentState?.unmarkAll();
    _inboxWidgetKey.currentState?.unmarkAll();
  }

  void _markAll() {
    if (_tabController.index == 0) {
      _inboxWidgetKey.currentState?.markAll();
    } else {
      _outboxWidgetKey.currentState?.markAll();
    }
  }

  void _handleFilterSelection(MessageFilter filter) {
    setState(
      () => {
        if (_inboxMessageBloc.state.currentFilter != filter)
          {
            _inboxMessageBloc
                .add(InboxMessagesRequested(filter: filter, offset: 0))
          }
      },
    );
  }
}
