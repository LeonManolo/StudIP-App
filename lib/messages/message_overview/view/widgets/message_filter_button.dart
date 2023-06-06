import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_filter_item.dart';

class MessageFilterButton extends StatelessWidget {
  const MessageFilterButton({
    super.key,
    required this.setFilter,
    required this.currentFilter,
  });
  final void Function(MessageFilter) setFilter;
  final MessageFilter currentFilter;

  Icon funnelIcon(MessageFilter currentFilter, Color iconColor) {
    if (currentFilter != MessageFilter.none) {
      return Icon(EvaIcons.funnel, size: 25, color: iconColor);
    } else {
      return Icon(EvaIcons.funnelOutline, size: 25, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MessageFilter>(
      icon: funnelIcon(currentFilter, Colors.black),
      onSelected: (newFilter) => {setFilter(newFilter)},
      itemBuilder: (context) => [
        PopupMenuItem<MessageFilter>(
            value: MessageFilter.none,
            child: ListTile(
            title: Text(MessageFilter.none.description),
            trailing: currentFilter == MessageFilter.none ? const Icon(EvaIcons.checkmark) : null,
        )),
        PopupMenuItem<MessageFilter>(
          value: MessageFilter.unread,
          child: FilterItem(
            isSelected: currentFilter == MessageFilter.unread,
            filter: MessageFilter.unread,
            funnelIcon:
                funnelIcon(currentFilter, Colors.black),
            filterDescription: MessageFilter.unread.description,
          ),
        )
      ],
    );
  }
}
