import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ModalBottomSheetSubtitle extends StatelessWidget {
  const ModalBottomSheetSubtitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
