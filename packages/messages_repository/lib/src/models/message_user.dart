import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class MessageUser {
  MessageUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.formattedName,
    required this.role,
  });

  factory MessageUser.fromParticipant(Participant participant) {
    return MessageUser(id: participant.id, username: participant.username, firstName: participant.givenName, lastName: participant.familyName, formattedName: participant.formattedName, role:  participant.permission ?? '');
  }

  factory MessageUser.fromUserResponse(UserResponse response) {
    return MessageUser(
      id: response.id,
      username: response.username,
      firstName: response.givenName,
      lastName: response.familyName,
      formattedName: response.formattedName,
      role: response.permission ?? '',
    );
  }

  factory MessageUser.empty() {
    return MessageUser(
      id: '',
      username: '',
      firstName: '',
      lastName: '',
      formattedName: '',
      role: '',
    );
  }

  final String id;
  String username;
  String firstName;
  String lastName;
  String formattedName;
  String role;
}
