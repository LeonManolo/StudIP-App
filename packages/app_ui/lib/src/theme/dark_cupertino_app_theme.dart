import 'package:flutter/cupertino.dart';

class DarkCupertinoAppTheme {
  const DarkCupertinoAppTheme();

  CupertinoThemeData get themeData {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.systemIndigo,
      //applyThemeToAll: true,
    );
  }
}