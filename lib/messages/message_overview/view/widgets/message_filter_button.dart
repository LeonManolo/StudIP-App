import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_filter_item.dart';

class MessageFilterButton extends StatelessWidget {
  const MessageFilterButton({
    super.key,
  });
  Icon funnelIcon(MessageFilter currentFilter) {
    if (currentFilter != MessageFilter.none) {
      return const Icon(EvaIcons.funnel);
    } else {
      return const Icon(EvaIcons.funnelOutline);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MessageFilter>(
      icon: funnelIcon(currentFilter),
      position: PopupMenuPosition.under,
      onSelected: (newFilter) => {setFilter(newFilter)},
      itemBuilder: (context) => [
        PopupMenuItem<MessageFilter>(
          value: MessageFilter.none,
          child: FilterItem(
            isSelected: currentFilter == MessageFilter.none,
            filter: MessageFilter.none,
            funnelIcon:
                funnelIcon(currentFilter),
            filterDescription: MessageFilter.none.description,
          ),
        ),
        PopupMenuItem<MessageFilter>(
          value: MessageFilter.unread,
          child: FilterItem(
            isSelected: currentFilter == MessageFilter.unread,
            filter: MessageFilter.unread,
            funnelIcon:
                funnelIcon(currentFilter),
            filterDescription: MessageFilter.unread.description,
          ),
        )
      ],
    );
  }
}
