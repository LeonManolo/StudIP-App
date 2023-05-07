import 'package:flutter/material.dart';

class PaginationLoading extends StatelessWidget {

  const PaginationLoading({
    super.key,
    required this.visible,
  });
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: const SizedBox(
        height: 48,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
