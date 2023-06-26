import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ErrorIllustration extends StatelessWidget {
  const ErrorIllustration({
    super.key,
    this.color,
    this.marginTop = AppSpacing.xxxlg + AppSpacing.xxlg,
    required this.iconData,
  });

  final Color? color;
  final IconData iconData;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xlg),
      margin: EdgeInsets.only(
        top: marginTop,
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
