import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ErrorIllustration extends StatelessWidget {
  const ErrorIllustration({
    super.key,
    this.color,
    required this.iconData,
  });

  final Color? color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xlg),
      margin: const EdgeInsets.only(
        top: AppSpacing.xxxlg + AppSpacing.xxlg,
        bottom: AppSpacing.xxlg,
      ),
      decoration: BoxDecoration(
        color: (color ?? Colors.red).withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        iconData,
        size: MediaQuery.of(context).size.width * 0.18,
        color: color ?? Colors.red,
      ),
    );
  }
}
