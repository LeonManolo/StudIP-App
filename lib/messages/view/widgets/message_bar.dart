import 'package:flutter/material.dart';

class MessageTabBar extends StatelessWidget {
  final TabController controller;

  const MessageTabBar({
    Key? key,
    required this.controller,
  }) : super(key: key);
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
  return Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              TabBar(
                controller: controller,
                tabs: messageTabs,
                labelColor: Colors.indigo,
              ),
            ],
          ),
        ),
      );
  }
}
