import 'package:studip_api_client/studip_api_client.dart';

class Participant {
  const Participant({
    required this.id,
    required this.username,
    required this.formattedName,
    required this.familyName,
    required this.givenName,
    required this.permission,
    required this.email,
    required this.phone,
    required this.homepage,
    required this.address,
    required this.avatarUrl,
  });

  factory Participant.fromUserResponse(UserResponse user) {
    return Participant(
        id: user.id,
        username: user.username,
        formattedName: user.formattedName,
        familyName: user.familyName,
        givenName: user.givenName,
        permission: user.permission,
        email: user.email,
        phone: user.phone,
        homepage: user.homepage,
        address: user.address,
        avatarUrl: user.avatarUrl,
    );
  }

  final String id;
  final String username;
  final String formattedName;
  final String familyName;
  final String givenName;
  final String? permission;
  final String email;
  final String? phone;
  final String? homepage;
  final String? address;
  final String avatarUrl;
}
