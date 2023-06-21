import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

Icon messageIcon(BuildContext context, {required bool isRead}) {
  if (isRead) {
    return Icon(
      EvaIcons.emailOutline,
      //color: Theme.of(context).primaryColor,
      size: 24,
    );
  } else {
    return Icon(
      EvaIcons.email,
      color: Theme.of(context).primaryColor,
      size: 24,
    );
  }
}
