import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/widgets/filter_row.dart';

import '../../bloc/message_bloc.dart';
import '../../bloc/message_event.dart';
import 'inbox_message_item.dart';

class InboxMessageWidget extends StatelessWidget {
  final MessageState state;
  final FilterRow filterRow;
  final MessageFilter currentFilter;

  const InboxMessageWidget({
    Key? key,
    required this.state,
    required this.currentFilter,
    required this.filterRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        filterRow,
        Expanded(
            child: state.status != MessageStatus.populated
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => {
                      BlocProvider.of<MessageBloc>(context)
                          .add(RefreshRequested(filter: currentFilter))
                    },
                    child: ListView.separated(
                      itemCount: state.inboxMessages.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        if (state.status != MessageStatus.populated) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return InboxMessageItem(
                              message: state.inboxMessages[index]);
                        }
                      },
                    ),
                  ))
      ],
    );
  }
}
