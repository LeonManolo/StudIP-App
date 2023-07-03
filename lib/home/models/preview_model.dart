import 'package:flutter/material.dart';

abstract interface class PreviewModel {
  PreviewModel({
    required this.iconData,
    required this.title,
    required this.subtitle,
  });

  final IconData? iconData;
  final String title;
  final String subtitle;
}
