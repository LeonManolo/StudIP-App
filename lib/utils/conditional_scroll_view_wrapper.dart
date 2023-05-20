import 'package:flutter/material.dart';

class ConditionalScrollViewWrapper extends StatelessWidget {
  const ConditionalScrollViewWrapper(
      {super.key, required this.child, required this.wrapInScrollView});

  final Widget child;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    return wrapInScrollView
        ? SingleChildScrollView(
            child: child,
          )
        : child;
  }
}
