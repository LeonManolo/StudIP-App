import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MessageDetailsMenuButton extends StatelessWidget {
  final bool isInbox;
  final Function() answerMessage;
  final Function() deleteMessage;
  const MessageDetailsMenuButton(
      {Key? key,
      required this.answerMessage,
      required this.isInbox,
      required this.deleteMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(EvaIcons.menu2Outline, size: 25, color: Colors.black),
      onSelected: (index) => {
        if (index == 0)
          {answerMessage()}
        else
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Löschen'),
                  content: const Text(
                      'Möchtest du diese Nachricht wirklich löschen?'),
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
          const PopupMenuItem<int>(value: 0, child: Text("Antworten")),
        const PopupMenuItem<int>(value: 1, child: Text("Nachricht löschen")),
      ],
    );
  }
}
