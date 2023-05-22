import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  const Headline(this.headline, {super.key});

  final String headline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, left: AppSpacing.lg, top: AppSpacing.lg),
      child: Text(
        headline,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
