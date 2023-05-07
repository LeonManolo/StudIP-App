import 'package:studip_api_client/studip_api_client.dart';

class MessageUser {
  final String id;
  String username;
  String firstName;
  String lastName;
  String role;
  MessageUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  String parseUsername() {
    return "$firstName $lastName";
  }

  factory MessageUser.fromUserResponse(UserResponse response) {
    return MessageUser(
        id: response.id,
        username: response.username,
        firstName: response.givenName,
        lastName: response.familyName,
        role: response.permission ?? "");
  }
}
