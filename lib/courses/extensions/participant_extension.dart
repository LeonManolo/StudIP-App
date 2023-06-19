import 'package:courses_repository/courses_repository.dart';
import 'package:messages_repository/messages_repository.dart';

extension MessageUserFromParticipant on Participant {
  MessageUser toMessageUser() {
    return MessageUser(
      id: id,
      username: username,
      firstName: givenName,
      lastName: familyName,
      formattedName: formattedName,
      role: permission ?? '',
    );
  }
}
