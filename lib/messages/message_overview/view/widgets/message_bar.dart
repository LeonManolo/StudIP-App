import 'package:flutter/material.dart';

class MessageTabBar extends StatelessWidget {
  const MessageTabBar({
    super.key,
    required this.controller,
  });
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    final List<Tab> messageTabs = [
      const Tab(
        icon: Icon(Icons.all_inbox),
      ),
      const Tab(
        icon: Icon(Icons.outbox),
      )
    ];
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            TabBar(
              controller: controller,
              tabs: messageTabs,
              labelColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
