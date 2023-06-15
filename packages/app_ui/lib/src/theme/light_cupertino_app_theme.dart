import 'package:flutter/cupertino.dart';

class LightCupertinoAppTheme {
  const LightCupertinoAppTheme();

  CupertinoThemeData get themeData {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemIndigo,
    );
  }
}