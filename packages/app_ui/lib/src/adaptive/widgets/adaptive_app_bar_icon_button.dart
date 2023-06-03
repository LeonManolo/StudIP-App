import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveAppBarIconButton extends StatelessWidget {
  const AdaptiveAppBarIconButton({
    super.key,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.onPressed,
  });

  final IconData cupertinoIcon;
  final IconData materialIcon;
  final VoidCallback? onPressed;


  double get cupertinoIconSize => 25;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: switch (Platform.isIOS) {
        true => Icon(cupertinoIcon, size: cupertinoIconSize),
        false => Icon(materialIcon),
      },
    );
  }
}
