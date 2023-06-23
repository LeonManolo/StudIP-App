import 'dart:io';
import 'package:app_ui/src/theme/material_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkMaterialAppTheme {
  const DarkMaterialAppTheme();

  Color get primaryColor {
    return Colors.indigo[200]!;
  }

  ThemeData get themeData {
    return ThemeData(
      platform: TargetPlatform.android,
      primaryColor: primaryColor,
      primarySwatch: getMaterialColor(Colors.indigo[200]!),
      appBarTheme: _appBarTheme,
      brightness: Brightness.dark,
      bottomNavigationBarTheme: _bottomNavigationBarThemeData,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      tabBarTheme: _tabBarTheme,
      scaffoldBackgroundColor: Platform.isIOS ? Colors.black : null,
    );
  }

  TabBarTheme get _tabBarTheme {
    return const TabBarTheme();
  }

  FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    );
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Platform.isIOS ? Colors.black : null,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarThemeData {
    return BottomNavigationBarThemeData(
      elevation: 8,
      backgroundColor: Platform.isIOS ? Colors.black : null,
      selectedItemColor: primaryColor,
    );
  }
}
