import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightMaterialAppTheme {
  const LightMaterialAppTheme();

  ThemeData get themeData {
    return ThemeData(
      primaryColor: Colors.indigo,
      primarySwatch: Colors.indigo,
      appBarTheme: _appBarTheme,
      brightness: Brightness.light,
      bottomNavigationBarTheme: _bottomNavigationBarThemeData,
      splashFactory: Platform.isIOS ? NoSplash.splashFactory : null,
      radioTheme: _radioTheme,
    );
  }

  RadioThemeData get _radioTheme {
    return RadioThemeData(
      fillColor: MaterialStateProperty.all(Colors.indigo),
    );
  }

  AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarThemeData {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    );
  }
}
