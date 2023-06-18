import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    this.color,
    this.onPressed,
    required this.text,
    required this.iconData,
  });

  final Color? color;
  final String text;
  final IconData iconData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: FadeInUp(
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              color ?? context.adaptivePrimaryColor,
            ),
          ),
          onPressed: () => onPressed?.call(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              const SizedBox(
                width: AppSpacing.sm,
              ),
              Icon(iconData),
            ],
          ),
        ),
      ),
    );
  }
}
