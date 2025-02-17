import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/utils/widgets/error_view/error_illustration.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.title = 'Fehler',
    required this.message,
    this.iconColor,
    this.iconData = EvaIcons.alertTriangleOutline,
    this.onRetryPressed,
    this.retryButtonText = 'Erneut versuchen',
    this.marginTop = AppSpacing.xxxlg + AppSpacing.xxlg,
  });

  final String title;
  final String message;
  final Color? iconColor;
  final IconData? iconData;
  final VoidCallback? onRetryPressed;
  final String retryButtonText;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconData != null)
            ErrorIllustration(
              color: iconColor ?? Theme.of(context).primaryColor,
              iconData: iconData!,
              marginTop: marginTop,
            ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          if (onRetryPressed != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: TextButton(
                onPressed: onRetryPressed,
                child: Text(retryButtonText),
              ),
            ),
        ],
      ),
    );
  }
}
