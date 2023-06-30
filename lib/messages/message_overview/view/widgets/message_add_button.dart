import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/messages/message_send/view/message_send_page.dart';

class MessageAddButton extends StatelessWidget {
  const MessageAddButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return 
    
    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<MessageSendPage>(
            builder: (context) => const MessageSendPage(),
            fullscreenDialog: true,
          ),
        );
      },
      icon: const Icon(EvaIcons.plus),
    );
  }
}
