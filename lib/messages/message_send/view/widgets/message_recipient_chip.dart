import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';

class MessageRecipientChip extends StatelessWidget {
  const MessageRecipientChip({
    super.key,
    required this.recipient,
    required this.delete,
  });
  final void Function(BuildContext, MessageUser) delete;
  final MessageUser recipient;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 2,
      ),
      child: InputChip(
        backgroundColor: Theme.of(context).primaryColorLight,
        padding: const EdgeInsets.all(5),
        visualDensity: VisualDensity.compact,
        avatar: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(recipient.role[0].toUpperCase()),
        ),
        label: Text(
          recipient.username,
          style: const TextStyle(color: Colors.black),
        ),
        onDeleted: () => delete(context, recipient),
      ),
    );
  }
}
