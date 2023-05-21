import 'package:flutter/material.dart';

void buildSnackBar(
  BuildContext context,
  String message,
  Color? color,
) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  });
}
