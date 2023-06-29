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

  factory MessageUser.fromUserResponseItem(UserResponseItem response) {
    final attributes = response.attributes;
    return MessageUser(
      id: response.id,
      username: attributes.username,
      firstName: attributes.givenName,
      lastName: attributes.familyName,
      formattedName: attributes.formattedName,
      role: attributes.permission,
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

  factory MessageUser.withUsername({required String username}) {
    return MessageUser(
      id: '',
      username: username,
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
