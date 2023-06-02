import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({
    super.key,
    this.home,
    this.title = '',
    this.cupertinoTheme,
    this.materialTheme,
  });

  final Widget? home;
  final String title;
  final CupertinoThemeData? cupertinoTheme;
  final ThemeData? materialTheme;

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return CupertinoApp(
        title: title,
        home: home,
        theme: cupertinoTheme,
      );
    }
    else {
      return MaterialApp(
        title: title,
        home: home,
        theme: materialTheme,
      );
    }
  }
}
