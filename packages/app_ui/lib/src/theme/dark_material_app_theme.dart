import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkMaterialAppTheme {
  const DarkMaterialAppTheme();

  ThemeData get themeData {
    return ThemeData(
      primaryColor: Colors.indigo,
      primarySwatch: Colors.indigo,
      appBarTheme: _appBarTheme,
      brightness: Brightness.light,
      bottomNavigationBarTheme: _bottomNavigationBarThemeData,
    );
  }

  AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarThemeData {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
    );
  }
}