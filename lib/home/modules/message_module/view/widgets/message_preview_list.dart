import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_event.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_icon.dart';

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
        child: Text('Keine neuen Nachrichten vorhanden'),
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
              ListTile(
                onTap: () {
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
                  );
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    messageIcon(context, isRead: message.isRead)
                  ],
                ),
                title: Text(message.subject),
                subtitle: Text(message.sender.formattedName),
                trailing: Text(message.getTimeAgo()),
              ),
              if (!isLastMessage) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
