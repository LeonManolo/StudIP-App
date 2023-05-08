import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

enum MessageMenuOption {
  markAll('Alle Markieren'),
  unmarkAll('Markierugnen entfernen');

  const MessageMenuOption(this.description);
  final String description;
}

class MessageMenuButton extends StatelessWidget {
  const MessageMenuButton({
    super.key,
    required this.markAll,
    required this.unmarkAll,
  });
  final void Function() markAll;
  final void Function() unmarkAll;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MessageMenuOption>(
      icon: Icon(
        EvaIcons.menu2Outline,
        size: 25,
        color: Theme.of(context).primaryColor,
      ),
      onSelected: (state) => {
        if (state == MessageMenuOption.markAll) {markAll()} else {unmarkAll()}
      },
      itemBuilder: (context) => [
        PopupMenuItem<MessageMenuOption>(
          value: MessageMenuOption.markAll,
          child: Text(MessageMenuOption.markAll.description),
        ),
        PopupMenuItem<MessageMenuOption>(
          value: MessageMenuOption.unmarkAll,
          child: Text(MessageMenuOption.unmarkAll.description),
        ),
      ],
    );
  }
}
