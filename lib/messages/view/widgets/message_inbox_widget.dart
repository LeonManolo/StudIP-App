import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/widgets/filter_row.dart';

import '../../bloc/message_bloc.dart';
import '../../bloc/message_event.dart';
import 'message_inbox_item.dart';

class InboxMessageWidget extends StatelessWidget {
  final MessageState state;
  final FilterRow filterRow;
  final MessageFilter currentFilter;
  final Function(BuildContext, Message) readMessage;

  const InboxMessageWidget({
    Key? key,
    required this.state,
    required this.currentFilter,
    required this.filterRow,
    required this.readMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /*void readMessage(BuildContext context, Message message) {
      BlocProvider.of<MessageBloc>(context)
          ..add(ReadMessageRequested(messageId: message.id))
          ..add(RefreshRequested(filter: currentFilter));
    } */

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
                              readMessage: () => readMessage(context, state.inboxMessages[index]),
                              message: state.inboxMessages[index]);
                        }
                      },
                    ),
                  ))
      ],
    );
  }
}
