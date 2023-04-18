import 'package:flutter/material.dart';

import '../../bloc/message_state.dart';

class FilterItem extends StatelessWidget {
  final MessageFilter filter;
  final MessageFilter currentFilter;
  final String filterDescription;
  final Icon funnelIcon;

  const FilterItem(
      {Key? key,
      required this.filter,
      required this.currentFilter,
      required this.funnelIcon,
      required this.filterDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem<MessageFilter>(
      value: filter,
      child: Row(
        children: [
          Expanded(
            child: Text(filterDescription),
          ),
          if (currentFilter == filter)
            Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: const Icon(
                Icons.check,
                color: Colors.indigo,
                size: 20.0,
              ),
            ),
        ],
      ),
    );
  }
}
