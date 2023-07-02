import 'package:flutter/material.dart';

class MessageDetailDeleteDialog extends StatelessWidget {
  const MessageDetailDeleteDialog({
    super.key,
    this.onNegativePressed,
    this.onPositivePressed,
  });

  final VoidCallback? onNegativePressed;
  final VoidCallback? onPositivePressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Löschen'),
      content: const Text(
        'Möchtest du diese Nachricht wirklich löschen?',
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Nein'),
          onPressed: () {
            Navigator.of(context).pop();
            onNegativePressed?.call();
          },
        ),
        TextButton(
          child: const Text('Ja'),
          onPressed: () {
            Navigator.of(context).pop();
            onPositivePressed?.call();
          },
        )
      ],
    );
  }
}
