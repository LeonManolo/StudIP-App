import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';

class MessageDeleteButton extends StatelessWidget {
  const MessageDeleteButton({
    required this.buildContext,
    super.key,
  });
  final BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
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
                    Navigator.of(context).pop();
                    buildContext.read<TabBarBloc>().add(
                          const DeleteMarkedMessages(),
                        );
                  },
                )
              ],
            );
          },
        );
      },
      child: const Icon(
        EvaIcons.trash2,
        color: Colors.white,
      ),
    );
  }
}
