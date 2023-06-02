import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        leading: leading,
        middle: title,
        trailing: switch (actions) {
          final List<Widget> actions => Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          _ => null,
        },
      );
    } else {
      return AppBar(
        backgroundColor: backgroundColor,
        leading: leading,
        title: title,
        actions: actions,
      );
    }
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kMinInteractiveDimensionCupertino);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(this.backgroundColor, context)
        ?? CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}
