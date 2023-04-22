import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../message_inbox_bloc /message_inbox_state.dart';
import 'message_filter_item.dart';

class FilterRow extends StatelessWidget {
  final Function(BuildContext, MessageFilter) setFilter;
  final MessageFilter currentFilter;

  const FilterRow({
    Key? key,
    required this.setFilter,
    required this.currentFilter,
  }) : super(key: key);

  Icon funnelIcon(MessageFilter currentFilter, Color iconColor) {
    if (currentFilter != MessageFilter.none) {
      return Icon(EvaIcons.funnel, size: 25, color: iconColor);
    } else {
      return Icon(EvaIcons.funnelOutline, size: 25, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        PopupMenuButton<MessageFilter>(
          icon: funnelIcon(currentFilter, Theme.of(context).primaryColor),
          onSelected: (newFilter) => {setFilter(context, newFilter)},
          itemBuilder: (context) => [
            PopupMenuItem<MessageFilter>(
              value: MessageFilter.none,
              child: FilterItem(
                isSelected: currentFilter == MessageFilter.none,
                filter: MessageFilter.none,
                funnelIcon:
                    funnelIcon(currentFilter, Theme.of(context).primaryColor),
                filterDescription: MessageFilter.none.description,
              ),
            ),
            PopupMenuItem<MessageFilter>(
              value: MessageFilter.unread,
              child: FilterItem(
                isSelected: currentFilter == MessageFilter.unread,
                filter: MessageFilter.unread,
                funnelIcon:
                    funnelIcon(currentFilter, Theme.of(context).primaryColor),
                filterDescription: MessageFilter.unread.description,
              ),
            ),
            PopupMenuItem<MessageFilter>(
              value: MessageFilter.read,
              child: FilterItem(
                isSelected: currentFilter == MessageFilter.read,
                filter: MessageFilter.read,
                funnelIcon:
                    funnelIcon(currentFilter, Theme.of(context).primaryColor),
                filterDescription: MessageFilter.read.description,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
