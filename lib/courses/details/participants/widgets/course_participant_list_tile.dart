import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/courses/extensions/participant_extension.dart';
import 'package:studipadawan/messages/message_send/view/message_send_page.dart';
import 'package:studipadawan/utils/widgets/profile_image_avatar.dart';

class CourseParticipantListTile extends StatelessWidget {
  const CourseParticipantListTile({
    super.key,
    required this.participant,
  });

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${participant.familyName}, ${participant.givenName}'),
      subtitle: Text(participant.email),
      leading: ProfileImageAvatar(
        profileImageUrl: participant.avatarUrl,
        replacementLetter: participant.familyName.split('').firstOrNull ?? ' ',
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<MessageSendPage>(
              builder: (context) => MessageSendPage(
                message: Message.empty(recipient: participant.toMessageUser()),
              ),
              fullscreenDialog: true,
            ),
          );
        },
        icon: const Icon(EvaIcons.emailOutline),
      ),
    );
  }
}
