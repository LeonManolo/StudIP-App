import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/messages/message_inbox_bloc%20/message_inbox_state.dart';
import '../../message_details/view/message_detail_page.dart';
import '../message_inbox_bloc /message_inbox_bloc.dart';
import '../message_inbox_bloc /message_inbox_event.dart';
import 'message_filter_row.dart';

class InboxMessageWidget extends StatelessWidget {
  final InboxMessageState state;
  final FilterRow filterRow;
  final Function(BuildContext, Message) readMessage;

  const InboxMessageWidget({
    Key? key,
    required this.state,
    required this.filterRow,
    required this.readMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon messageIcon(BuildContext context, bool isRead) {
      if (isRead) {
        return Icon(EvaIcons.messageSquareOutline,
            color: Theme.of(context).primaryColor, size: 24.0);
      } else {
        return Icon(EvaIcons.messageSquare,
            color: Theme.of(context).primaryColor, size: 24.0);
      }
    }

    return Column(
      children: [
        filterRow,
        Expanded(
            child: state.status != InboxMessageStatus.populated
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => {
                      BlocProvider.of<InboxMessageBloc>(context)
                          .add(InboxMessagesRequested(filter: state.currentFilter))
                    },
                    child: state.inboxMessages.isEmpty
                        ? const CustomScrollView(slivers: [
                            SliverFillRemaining(
                              child: Center(
                                  child: Text(
                                      "Es sind keine Nachrichten vorhanden")),
                            )
                          ])
                        : ListView.separated(
                            itemCount: state.inboxMessages.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              if (state.status !=
                                  InboxMessageStatus.populated) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        messageIcon(context, message.isRead)
                                      ],
                                    ),
                                    trailing: Text(message.getTimeAgo()),
                                    title: Text(message.subject),
                                    subtitle: Text(message.sender.username));
                              }
                            },
                          ),
                  )),
      ],
    );
  }
}
