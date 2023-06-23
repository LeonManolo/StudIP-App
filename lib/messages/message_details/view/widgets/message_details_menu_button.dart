import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

enum MessageDetailsMenuOption {
  answer('Antworten'),
  delete('Nachricht löschen');

  const MessageDetailsMenuOption(this.description);
  final String description;
}

class MessageDetailsMenuButton extends StatelessWidget {
  const MessageDetailsMenuButton({
    super.key,
    required this.answerMessage,
    required this.isInbox,
    required this.deleteMessage,
  });
  final bool isInbox;
  final void Function() answerMessage;
  final void Function() deleteMessage;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MessageDetailsMenuOption>(
      icon: const Icon(EvaIcons.menu2Outline),
      onSelected: (state) => {
        if (state == MessageDetailsMenuOption.answer)
          {answerMessage()}
        else
          {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
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
                      },
                    ),
                    TextButton(
                      child: const Text('Ja'),
                      onPressed: () {
                        deleteMessage();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            )
          }
      },
      itemBuilder: (context) => [
        if (isInbox)
          PopupMenuItem<MessageDetailsMenuOption>(
            value: MessageDetailsMenuOption.answer,
            child: Text(MessageDetailsMenuOption.answer.description),
          ),
        PopupMenuItem<MessageDetailsMenuOption>(
          value: MessageDetailsMenuOption.delete,
          child: Text(MessageDetailsMenuOption.delete.description),
        ),
      ],
    );
  }
}
