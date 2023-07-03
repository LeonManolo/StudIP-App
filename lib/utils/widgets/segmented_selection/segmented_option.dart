import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SegmentedOption extends StatelessWidget {
  const SegmentedOption({
    super.key,
    this.selected = false,
    required this.iconData,
    required this.text,
    required this.onTap,
  });

  final bool selected;
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themePrimaryColor = Theme.of(context).primaryColor;
    final themeHintColor = Theme.of(context).hintColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? themePrimaryColor.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1.5,
            color: selected
                ? themePrimaryColor
                : themeHintColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: selected ? themePrimaryColor : themeHintColor,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: selected ? themePrimaryColor : themeHintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
