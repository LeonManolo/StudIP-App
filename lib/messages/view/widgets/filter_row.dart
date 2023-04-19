import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/src/models/message.dart';

import '../../bloc/message_state.dart';
import 'filter_item.dart';

class FilterRow extends StatelessWidget {
  final Function(BuildContext, MessageFilter) setFilter;
  final MessageFilter currentFilter;

  const FilterRow({
    Key? key,
    required this.setFilter,
    required this.currentFilter,
  }) : super(key: key);

  Icon funnelIcon(MessageFilter filter) {
    if (currentFilter != MessageFilter.none) {
      return const Icon(EvaIcons.funnel, size: 25, color: Colors.indigo);
    } else {
      return const Icon(EvaIcons.funnelOutline, size: 25, color: Colors.indigo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        PopupMenuButton<MessageFilter>(
          icon: funnelIcon(currentFilter),
          onSelected: (newFilter) => {setFilter(context, newFilter)},
          itemBuilder: (context) => [
            PopupMenuItem<MessageFilter>(
              value: MessageFilter.none,
              child: FilterItem(
                currentFilter: currentFilter,
                filter: MessageFilter.none,
                funnelIcon: funnelIcon(currentFilter),
                filterDescription: "Kein Filter",
              ),
            ),
            PopupMenuItem<MessageFilter>(
              value: MessageFilter.unread,
              child: FilterItem(
                currentFilter: currentFilter,
                filter: MessageFilter.unread,
                funnelIcon: funnelIcon(currentFilter),
                filterDescription: "Ungelesene Nachrichten",
              ),
            ),
            PopupMenuItem<MessageFilter>(
              value: MessageFilter.read,
              child: FilterItem(
                currentFilter: currentFilter,
                filter: MessageFilter.read,
                funnelIcon: funnelIcon(currentFilter),
                filterDescription: "Gelesene Nachrichten",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
