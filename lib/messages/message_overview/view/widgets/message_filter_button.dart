import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_state.dart';
import 'package:studipadawan/utils/utils.dart';
import 'package:studipadawan/utils/widgets/segmented_selection/segmented_selection.dart';

class MessageFilterButton extends StatelessWidget {
  const MessageFilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InboxMessageBloc, InboxMessageState>(
      builder: (context, state) => IconButton(
        icon: Icon(
          color: state.isDefaultFilter ? null : Theme.of(context).primaryColor,
          state.isDefaultFilter ? EvaIcons.funnelOutline : EvaIcons.funnel,
        ),
        onPressed: () {
          showCustomModalBottomSheet(
            context: context,
            title: 'Nachrichtenauswahl',
            child: _MessageFilterModalContent(
              currentMessageFilter: state.currentFilter,
              onMessageFilterChanged: (newFilter) =>
                  context.read<InboxMessageBloc>().add(
                        InboxMessagesRequested(offset: 0, newFilter: newFilter),
                      ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageFilterModalContent extends StatefulWidget {
  const _MessageFilterModalContent({
    required this.onMessageFilterChanged,
    required this.currentMessageFilter,
  });

  final void Function(MessageFilter) onMessageFilterChanged;
  final MessageFilter currentMessageFilter;

  @override
  // ignore: library_private_types_in_public_api
  _MessageFilterModalContentState createState() =>
      _MessageFilterModalContentState();
}

class _MessageFilterModalContentState
    extends State<_MessageFilterModalContent> {
  late void Function(MessageFilter) onMessageFilterChanged;
  late MessageFilter currentMessageFilter;

  @override
  void initState() {
    onMessageFilterChanged = widget.onMessageFilterChanged;
    currentMessageFilter = widget.currentMessageFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ModalBottomSheetSubtitle(title: 'Filter'),
        SegmentedSelection(
          selected: currentMessageFilter,
          selections: [
            SegmentedSelectionData(
              value: MessageFilter.all,
              iconData: EvaIcons.eyeOutline,
              text: 'Alle',
            ),
            SegmentedSelectionData(
              value: MessageFilter.unread,
              iconData: EvaIcons.eyeOffOutline,
              text: 'Ungelesen',
            ),
          ],
          onSelectionChange: (filter) {
            setState(() {
              currentMessageFilter = filter;
            });
            onMessageFilterChanged(filter);
          },
        ),
      ],
    );
  }
}
