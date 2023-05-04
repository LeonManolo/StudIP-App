import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MessageMenuButton extends StatelessWidget {
  final Function() markAll;
  final Function() unmarkAll;

  const MessageMenuButton({
    Key? key,
    required this.markAll,
    required this.unmarkAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(EvaIcons.menu2Outline,
          size: 25, color: Theme.of(context).primaryColor),
      onSelected: (index) => {
        if (index == 0) {markAll()} else {unmarkAll()}
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(value: 0, child: Text("Alle Markieren")),
        const PopupMenuItem<int>(
            value: 1, child: Text("Markierungen entfernen")),
      ],
    );
  }
}
