import 'package:flutter/widgets.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/models/preview_model.dart';
import 'package:studipadawan/messages/message_overview/view/widgets/message_icon.dart';

class MessagePreviewModel implements PreviewModel {
  MessagePreviewModel({required this.message});

  final Message message;

  @override
  IconData get iconData => getMessageIconData(isRead: message.isRead);

  @override
  String get title => message.subject;

  @override
  String get subtitle =>
      'Von ${message.sender.formattedName} ${message.getTimeAgo()}';

  MessagePreviewModel copyWith({required bool readMessage}) {
    return MessagePreviewModel(message: message.copyWith(isRead: readMessage));
  }
}
