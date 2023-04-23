import 'package:studip_api_client/studip_api_client.dart';

class MessageUser {
  final String id;
  String username;
  MessageUser({required this.id, required this.username});

  factory MessageUser.fromUserResponse(UserResponse response) {
    return MessageUser(id: response.id, username: response.username);
  }
}
