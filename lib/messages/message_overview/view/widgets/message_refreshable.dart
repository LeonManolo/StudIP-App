import 'package:flutter/material.dart';

class RefreshableContent extends StatelessWidget {
  const RefreshableContent({
    super.key,
    required this.callback,
    required this.widget,
  });
  final Widget widget;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => {callback()},
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(child: widget),
          )
        ],
      ),
    );
  }
}
