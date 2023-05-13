import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  const ConditionalWidget({
    super.key,
    required this.currentValue,
    required this.onTrue,
    required this.onFalse,
  });

  final bool currentValue;
  final Widget onTrue;
  final Widget onFalse;

  @override
  Widget build(BuildContext context) {
    return currentValue ? onTrue : onFalse;
  }
}
