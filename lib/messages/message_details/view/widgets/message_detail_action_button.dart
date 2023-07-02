import 'package:flutter/material.dart';

class MessageDetailActionButton extends StatelessWidget {
  const MessageDetailActionButton({
    super.key,
    this.foregroundColor,
    required this.title,
    required this.iconData,
    this.onPressed,
    this.backgroundColor,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final Widget title;
  final IconData iconData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(iconData),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(
          foregroundColor ?? Theme.of(context).hintColor,
        ),
      ),
      label: title,
    );
  }
}
