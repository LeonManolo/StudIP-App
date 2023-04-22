import 'package:messages_repository/messages_repository.dart';

class UserListResponse {
  final List<MessageUser> users;

  UserListResponse({required this.users});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> users = json["data"];
    return UserListResponse(
        users: users.map((user) => MessageUser.fromJson(user)).toList());
  }
}
