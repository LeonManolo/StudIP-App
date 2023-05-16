import 'package:flutter/material.dart';

class PaginationLoadingIndicator extends StatelessWidget {
  const PaginationLoadingIndicator({
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
