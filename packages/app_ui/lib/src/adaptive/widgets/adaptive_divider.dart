import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AdaptiveDivider extends StatelessWidget {
  const AdaptiveDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      key: key,
      height: height,
      thickness: thickness,
      indent: endIndent,
      color: color ?? context.adaptiveHintColor,
    );
  }
}
