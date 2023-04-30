import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/messages/message_inbox_bloc%20/message_inbox_state.dart';
import '../../message_details/view/message_detail_page.dart';

import 'message_filter_row.dart';

class InboxMessageWidget extends StatelessWidget {
  final InboxMessageState state;
  final FilterRow filterRow;
  final Function() refresh;
  final Function(Message) readMessage;
  final ScrollController scrollController;

  const InboxMessageWidget(
      {Key? key,
      required this.state,
      required this.filterRow,
      required this.readMessage,
      required this.refresh,
      required this.scrollController})
      : super(key: key);

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

    if (state.status == InboxMessageStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == InboxMessageStatus.failure) {
      return _buildRefreshableMessage(
          "Ein unbekannter Fehler ist aufgetreten, bitte versuche es erneut");
    }
    if (state.inboxMessages.isEmpty) {
      _buildRefreshableMessage("Es sind keine Nachrichten vorhanden");
    }
    return Column(
      children: [
        filterRow,
        Expanded(
            child: RefreshIndicator(
          onRefresh: () async => {refresh()},
          child: ListView.separated(
            itemCount: state.inboxMessages.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              var message = state.inboxMessages[index];
              return ListTile(
                  onTap: () => {
                        readMessage(message),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MessageDetailpage(message: message)),
                        )
                      },
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[messageIcon(context, message.isRead)],
                  ),
                  trailing: Text(message.getTimeAgo()),
                  title: Text(message.subject),
                  subtitle: Text(message.sender.username));
            },
            controller: scrollController,
          ),
        )),
        Visibility(
          visible: state.status == InboxMessageStatus.paginationLoading,
          child: const SizedBox(
            height: 48,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  _buildRefreshableMessage(String message) {
    return Expanded(
        child: RefreshIndicator(
            onRefresh: () async => {refresh()},
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                child: Center(child: Text(message)),
              )
            ])));
  }
}
