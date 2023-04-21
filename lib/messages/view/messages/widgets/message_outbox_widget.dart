import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_state.dart';
import '../bloc/message_event.dart';
import 'message_outbox_item.dart';

class OutboxMessageWidget extends StatelessWidget {
  final OutboxMessageState state;
  final MessageFilter currentFilter;

  const OutboxMessageWidget({
    Key? key,
    required this.state,
    required this.currentFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.status != MessageStatus.populated
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async => {
              BlocProvider.of<OutboxMessageBloc>(context)
                  .add(const OutboxMessagesRequested())
            },
            child: ListView.separated(
              itemCount: state.outboxMessages.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (state.status != MessageStatus.populated) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return OutboxMessageItem(message: state.outboxMessages[index]);
                }
              },
            ),
          );
  }
}
