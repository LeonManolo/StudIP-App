import 'package:flutter/material.dart';
import 'package:studipadawan/home/modules/message_module/model/message_preview_model.dart';
import 'package:studipadawan/messages/message_details/view/message_detail_page.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_icon.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_tile.dart';

class MessagePreviewTile extends StatefulWidget {
  const MessagePreviewTile({
    super.key,
    required this.messagePreview,
    required this.onRefresh,
  });

  final MessagePreviewModel messagePreview;
  final VoidCallback? onRefresh;

  @override
  // ignore: library_private_types_in_public_api
  _MessagePreviewTileState createState() => _MessagePreviewTileState();
}

class _MessagePreviewTileState extends State<MessagePreviewTile> {
  late MessagePreviewModel messagePreview;
  late VoidCallback? onRefresh;

  @override
  void initState() {
    messagePreview = widget.messagePreview;
    onRefresh = widget.onRefresh;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MessageTile(
      messageIcon: MessageIcon(
        iconData: messagePreview.iconData,
        color: getMessageIconColor(
          isRead: messagePreview.message.isRead,
          context: context,
        ),
      ),
      onTapFunction: () {
        if (!messagePreview.message.isRead) {
          // Optimistic UI-Update
          setState(() {
            messagePreview = messagePreview.copyWith(readMessage: true);
          });
        }

        Navigator.push(
          context,
          MaterialPageRoute<MessageDetailPage>(
            builder: (context) => MessageDetailPage(
              isInbox: true,
              message: messagePreview.message,
              refreshMessages: onRefresh ?? () {},
            ),
          ),
        );
      },
      title: messagePreview.title,
      subTitle: messagePreview.subtitle,
    );
  }
}
