import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';

enum MessageMenuOption {
  markAll('Alle Markieren'),
  unmarkAll('Markierungen entfernen');

  const MessageMenuOption(this.description);
  final String description;
}

class MessageMenuButton extends StatelessWidget {
  const MessageMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MessageMenuOption>(
      position: PopupMenuPosition.under,
      icon: const Icon(
        EvaIcons.moreVerticalOutline,
      ),
      onSelected: (state) => {
        if (state == MessageMenuOption.markAll)
          {context.read<TabBarBloc>().add(const MarkAllMessages())}
        else
          {context.read<TabBarBloc>().add(const HideMenuicon())}
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
