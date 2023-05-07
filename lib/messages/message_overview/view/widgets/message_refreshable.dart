import 'package:flutter/material.dart';

class RefreshableMessage extends StatelessWidget {
  const RefreshableMessage({
    super.key,
    required this.callback,
    required this.text,
  });
  final String text;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => {callback()},
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(child: Text(text)),
          )
        ],
      ),
    );
  }
}
