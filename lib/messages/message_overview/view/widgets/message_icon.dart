import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

IconData getMessageIconData({required bool isRead}) {
  return isRead ? EvaIcons.emailOutline : EvaIcons.email;
}

Color? getMessageIconColor({
  required bool isRead,
  required BuildContext context,
}) {
  return isRead ? null : Theme.of(context).primaryColor;
}

class MessageIcon extends StatelessWidget {
  const MessageIcon({super.key, required this.iconData, this.color});

  final IconData iconData;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: color,
      size: 24,
    );
  }
}
