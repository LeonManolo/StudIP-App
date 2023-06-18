import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(context.adaptivePrimaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: AppSpacing.sm,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Icon(EvaIcons.externalLinkOutline),
            ),
            Text('Mit Stud.IP anmelden'),
          ],
        ),
      ),
    );
  }
}
