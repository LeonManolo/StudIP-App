import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:studipadawan/messages/message_send/view/message_send_page.dart';

class MessageAddButton extends StatelessWidget {
  const MessageAddButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        Positioned(
          left: -13,
          right: 0,
          top: -13,
          bottom: 0,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<MessageSendPage>(
                  builder: (context) => const MessageSendPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            icon: Icon(
              EvaIcons.plusCircle,
              color: Theme.of(context).primaryColor,
              size: 60,
            ),
          ),
        ),
      ],
    );
  }
}
