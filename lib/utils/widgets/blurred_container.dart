import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlurredContainer extends StatelessWidget {

  const BlurredContainer({super.key,
    required this.child,
    this.blurStrength = 10.0,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.margin,
    this.alignment
  });
  final Widget child;
  final double blurStrength;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.95),
          border: Border(
            bottom: BorderSide(
              color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context).withOpacity(0.7), // inactiveGray as fallback
              width: 0.0,  // One physical pixel.
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
          child: Container(
            alignment: alignment,
            width: width,
            padding: padding,
            margin: margin,
            decoration: decoration,
            color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey6, context),
            foregroundDecoration: foregroundDecoration,
            child: Container(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
