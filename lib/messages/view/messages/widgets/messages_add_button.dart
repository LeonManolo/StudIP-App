import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../message_send/message_send_page.dart';

class MessageAddButton extends StatelessWidget {
  const MessageAddButton({
    Key? key,
  }) : super(key: key);
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
                MaterialPageRoute(
                    builder: (context) => const MessageSendPage()),
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
