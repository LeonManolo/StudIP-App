import 'package:flutter/material.dart';

class NonEmptyListViewBuilder extends StatelessWidget {
  const NonEmptyListViewBuilder({
    super.key,
    required this.itemBuilder,
    required this.header,
    this.itemCount,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.controller,
    this.padding,
  });

  final int? itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final Widget header;
  final bool reverse;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: key,
      controller: controller,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      padding: padding,
      itemCount: (itemCount ?? 0) <= 0 ? 1 : (itemCount! + 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return header;
        }

        return itemBuilder(context, index - 1);
      },
    );
  }
}
