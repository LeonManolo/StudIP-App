import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ProfileLogOutButton extends StatelessWidget {
  const ProfileLogOutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: FilledButton(
        onPressed: onPressed,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Logout'),
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.sm,
              ),
              child: Icon(EvaIcons.logOutOutline),
            ),
          ],
        ),
      ),
    );
  }
}
