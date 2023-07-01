import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_bloc.dart';
import 'package:studipadawan/messages/message_send/view/message_send_page.dart';

class MessageAddButton extends StatelessWidget {
  const MessageAddButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<MessageSendPage>(
            builder: (context) => BlocProvider(
              create: (context) => MessageSendBloc(
                messageRepository: context.read<MessageRepository>(),
              ),
              child: const MessageSendPage(),
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: const Icon(EvaIcons.plus),
    );
  }
}
