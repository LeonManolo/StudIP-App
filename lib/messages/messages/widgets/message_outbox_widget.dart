import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/messages/messages/message_outbox_bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/messages/message_outbox_bloc/message_outbox_state.dart';
import '../message_outbox_bloc/message_outbox_event.dart';
import 'message_outbox_item.dart';

class OutboxMessageWidget extends StatelessWidget {
  final OutboxMessageState state;

  const OutboxMessageWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.status != OutboxMessageStatus.populated) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: () async => {
          BlocProvider.of<OutboxMessageBloc>(context)
              .add(const OutboxMessagesRequested())
        },
        child: state.outboxMessages.isEmpty
            ? const CustomScrollView(slivers: [
                SliverFillRemaining(
                  child: Center(
                      child: Text("Es sind keine Nachrichten vorhanden")),
                )
              ])
            : ListView.separated(
                itemCount: state.outboxMessages.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  if (state.status != OutboxMessageStatus.populated) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return OutboxMessageItem(
                        message: state.outboxMessages[index]);
                  }
                },
              ),
      );
    }
  }
}
