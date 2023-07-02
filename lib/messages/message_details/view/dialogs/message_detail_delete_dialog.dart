import 'package:flutter/material.dart';

class MessageDetailDeleteDialog extends StatelessWidget {
  const MessageDetailDeleteDialog({
    super.key,
    this.onCancelPressed,
    this.onConfirmPressed,
  });

  final VoidCallback? onCancelPressed;
  final VoidCallback? onConfirmPressed;

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
            onCancelPressed?.call();
          },
        ),
        TextButton(
          child: const Text('Ja'),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmPressed?.call();
          },
        )
      ],
    );
  }
}
