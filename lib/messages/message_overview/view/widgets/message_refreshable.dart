import 'package:flutter/material.dart';

class RefreshableMessage extends StatelessWidget {
  final String text;
  final Function() callback;

  const RefreshableMessage(
      {Key? key, required this.callback, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => {callback()},
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
            child: Center(child: Text(text)),
          )
        ]));
  }
}
