import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class LoginIllustration extends StatelessWidget {
  const LoginIllustration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xlg),
      margin: const EdgeInsets.only(
        top: AppSpacing.xxxlg + AppSpacing.xxlg,
        bottom: AppSpacing.xxlg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        EvaIcons.logInOutline,
        size: MediaQuery.of(context).size.width * 0.18,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
