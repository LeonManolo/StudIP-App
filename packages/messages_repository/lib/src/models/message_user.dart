import 'package:studip_api_client/studip_api_client.dart';

class MessageUser {
  MessageUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory MessageUser.fromUserResponse(UserResponse response) {
    return MessageUser(
        id: response.id,
        username: response.username,
        firstName: response.givenName,
        lastName: response.familyName,
        role: response.permission ?? '',);
  }
  final String id;
  String username;
  String firstName;
  String lastName;
  String role;

  String parseUsername() {
    return '$firstName $lastName';
  }
}
