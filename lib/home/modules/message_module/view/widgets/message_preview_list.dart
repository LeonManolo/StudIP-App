import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_event.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_icon.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_tile.dart';
import 'package:studipadawan/utils/empty_view.dart';

class MessagePreviewList extends StatelessWidget {
  const MessagePreviewList({
    super.key,
    required this.messages,
    required this.messageModuleBloc,
  });
  final List<Message> messages;
  final MessageModuleBloc messageModuleBloc;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: EmptyView(
          title: 'Keine Nachrichten',
          message: 'Es sind keine Nachrichten vorhanden',
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: messages.asMap().entries.map((entry) {
          final index = entry.key;
          final message = entry.value;
          final isLastMessage = index == messages.length - 1;

          return Column(
            children: [
              MessageTile(
                messageIcon: messageIcon(context, isRead: message.isRead),
                onTapFunction: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute<MessageDetailpage>(
                      builder: (context) => MessageDetailpage(
                        isInbox: true,
                        message: message,
                        refreshMessages: () => messageModuleBloc
                            .add(const MessagePreviewRequested()),
                      ),
                    ),
                  )
                },
                trailing: message.getTimeAgo(),
                title: message.subject,
                subTitle: message.sender.formattedName,
              ),
              if (!isLastMessage) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
