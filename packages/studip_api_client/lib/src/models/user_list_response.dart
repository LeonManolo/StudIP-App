import 'package:studip_api_client/src/models/models.dart';

class UserListResponse {
  final List<UserResponse> userResponses;

  UserListResponse({required this.userResponses});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> users = json["data"];
    return UserListResponse(
        userResponses: users.map((user) => UserResponse.fromJson(user)).toList());
  }
}
