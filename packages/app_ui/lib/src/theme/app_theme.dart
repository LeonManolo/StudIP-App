

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  const AppTheme();

  ThemeData get themeData {
    return ThemeData(
      primaryColor: Colors.indigo,
      primarySwatch: Colors.indigo,
      appBarTheme: _appBarTheme,

      bottomNavigationBarTheme: _bottomNavigationBarThemeData,
    );
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
  
  BottomNavigationBarThemeData get _bottomNavigationBarThemeData {
    return BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    );
  }
}