import 'package:flutter/material.dart';
import '../../message_inbox_bloc /message_inbox_state.dart';

class FilterItem extends StatelessWidget {
  final MessageFilter filter;
  final bool isSelected;
  final String filterDescription;
  final Icon funnelIcon;

  const FilterItem(
      {Key? key,
      required this.filter,
      required this.isSelected,
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
          if (isSelected)
            Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
                size: 20.0,
              ),
            ),
        ],
      ),
    );
  }
}
