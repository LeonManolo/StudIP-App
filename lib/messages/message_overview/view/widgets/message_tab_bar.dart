import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';

class MessageTabBar extends StatelessWidget {
  const MessageTabBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    print(AppBarTheme.of(context).backgroundColor);
    print(AppBarTheme.of(context));
    return BlocBuilder<TabBarBloc, TabBarState>(
      builder: (blocContext, state) {
        if (Platform.isIOS) {
          return CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            transitionBetweenRoutes: false,
            heroTag: '____none',
            border: null,
            middle: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: SizedBox.expand(
                child: AdaptiveTabBar(
                  selectedTab: state.currentTabIndex,
                  onValueChanged: (value) {
                    blocContext
                        .read<TabBarBloc>()
                        .add(TabIndexChanged(index: value));
                    tabController.animateTo(value);
                  },
                  tabs: const [
                    (
                      title: 'Empfangen',
                      widget: Tab(
                        icon: Icon(Icons.all_inbox),
                      )
                    ),
                    (
                      title: 'Gesendet',
                      widget: Tab(
                        icon: Icon(Icons.outbox),
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: AppBarTheme.of(context).backgroundColor,
            child: TabBar(
              indicatorColor: context.adaptivePrimaryColor,
              labelColor: context.adaptivePrimaryColor,
              tabs: const [
                Tab(
                  text: 'Empfangen',
                  icon: Icon(Icons.all_inbox),
                ),
                Tab(
                  text: 'Gesendet',
                  icon: Icon(Icons.outbox),
                )
              ],
              controller: tabController,
            ),
          );
        }
      },
    );
  }
}
