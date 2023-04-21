import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_state.dart';

import '../../message_details/message_detail_page.dart';
import '../bloc/message_bloc.dart';
import '../bloc/message_event.dart';
import 'filter_row.dart';

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
    messageUnreadIcon() {
      return const Icon(EvaIcons.messageSquare,
          color: Colors.indigo, size: 24.0);
    }

    messageReadIcon() {
      return const Icon(EvaIcons.messageSquareOutline,
          color: Colors.indigo, size: 24.0);
    }

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
                          var message = state.inboxMessages[index];
                          return ListTile(
                              onTap: () => {
                                    readMessage(context, message),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MessageDetailpage(
                                                  message: message)),
                                    )
                                  },
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  message.isRead
                                      ? messageReadIcon()
                                      : messageUnreadIcon()
                                ],
                              ),
                              trailing: Text(DateTime.parse(message.mkdate)
                                  .toLocal()
                                  .toString()
                                  .split(".")[0]),
                              title: Text(message.subject),
                              subtitle: Text(message.sender.username));
                        }
                      },
                    ),
                  ))
      ],
    );
  }
}
