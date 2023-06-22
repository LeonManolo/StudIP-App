import 'package:flutter/material.dart';

class MessageTabBar extends StatelessWidget {
  const MessageTabBar({
    super.key,
    required this.controller,
  });
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
    );
  }
}
