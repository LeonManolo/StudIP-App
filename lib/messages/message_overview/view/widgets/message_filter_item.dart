import 'package:flutter/material.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.funnelIcon,
    required this.filterDescription,
  });
  final MessageFilter filter;
  final bool isSelected;
  final String filterDescription;
  final Icon funnelIcon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem<MessageFilter>(
      value: filter,
      child: Row(
        children: [
          Expanded(
            child: Text(filterDescription),
          ),
          if (isSelected)
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: const Icon(
                Icons.check,
                color: Colors.black,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
