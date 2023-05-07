import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MessageDeleteButton extends StatelessWidget {
  const MessageDeleteButton({super.key, required this.deleteMessages});
  final void Function() deleteMessages;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
        Positioned(
          left: -1,
          right: 0,
          top: -2,
          bottom: 0,
          child: IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Löschen'),
                    content: const Text(
                      'Möchtest du diese Nachrichten wirklich löschen?',
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
                          deleteMessages();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              EvaIcons.trash2,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
