import 'package:flutter/material.dart';

class PaginationLoading extends StatelessWidget {
  final bool visible;

  const PaginationLoading({
    Key? key,
    required this.visible,
  }) : super(key: key);

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
