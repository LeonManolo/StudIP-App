import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.onTapFunction,
    required this.title,
    required this.subTitle,
    this.onLongPressFunction,
    required this.isRead,
  });

  final String title;
  final String subTitle;
  final void Function() onTapFunction;
  final void Function()? onLongPressFunction;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => {onTapFunction()},
      onLongPress: () => {
        if (onLongPressFunction != null) {onLongPressFunction!()}
      },
      leading: Icon(
        isRead ? EvaIcons.emailOutline : EvaIcons.email,
        color: isRead ? null : Theme.of(context).primaryColor,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? null : FontWeight.w600,
          ),
        ),
      ),
      subtitle: Text(subTitle),
    );
  }
}
