import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  const ConditionalWidget({
    super.key,
    required this.condition,
    required this.onTrue,
    required this.onFalse,
  });

  final bool condition;
  final Widget onTrue;
  final Widget onFalse;

  @override
  Widget build(BuildContext context) {
    return condition ? onTrue : onFalse;
  }
}
