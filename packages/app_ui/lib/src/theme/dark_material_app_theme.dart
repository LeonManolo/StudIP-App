import 'package:app_ui/src/theme/material_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkMaterialAppTheme {
  const DarkMaterialAppTheme();

  Color get primaryColor => Colors.indigo[200]!;

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
    );
  }

  TabBarTheme get _tabBarTheme {
    return TabBarTheme(
      indicatorColor: Colors.red,
    );
  }

  FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    );
  }

  AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      //foregroundColor: Colors.white,
      //backgroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarThemeData {
    return BottomNavigationBarThemeData(
      elevation: 8,
      selectedItemColor: primaryColor,
    );
  }
}