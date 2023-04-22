import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_inbox_bloc.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import '../../../message_details/view/message_detail_page.dart';
import 'message_filter_row.dart';
import 'package:timeago/timeago.dart' as timeago;

class InboxMessageWidget extends StatelessWidget {
  final InboxMessageState state;
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
    timeago.setLocaleMessages('de', timeago.DeMessages());

    Icon messageUnreadIcon(Color iconColor) {
      return Icon(EvaIcons.messageSquare, color: iconColor, size: 24.0);
    }

    Icon messageReadIcon(Color iconColor) {
      return Icon(EvaIcons.messageSquareOutline, color: iconColor, size: 24.0);
    }

    return Column(
      children: [
        filterRow,
        Expanded(
            child: state.status != MessageStatus.populated
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => {
                      BlocProvider.of<InboxMessageBloc>(context)
                          .add(InboxMessagesRequested(filter: currentFilter))
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        message.isRead
                                            ? messageReadIcon(
                                                Theme.of(context).primaryColor)
                                            : messageUnreadIcon(
                                                Theme.of(context).primaryColor)
                                      ],
                                    ),
                                    trailing: Text(
                                      timeago.format(
                                        DateTime.parse(message.mkdate),
                                        locale: 'de',
                                      ),
                                    ),
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
