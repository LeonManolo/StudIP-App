import 'package:studip_api_client/studip_api_client.dart';

class CourseParticipantsData {
  const CourseParticipantsData({
    required this.participants,
    required this.totalParticipants,
  });

  final int totalParticipants;
  final List<Participant> participants;
}

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
    required this.namePrefix,
    required this.nameSuffix,
  });

  factory Participant.fromUserResponseItem(UserResponseItem userResponseItem) {
    final attributes = userResponseItem.attributes;
    return Participant(
      id: userResponseItem.id,
      username: attributes.username,
      formattedName: attributes.formattedName,
      familyName: attributes.familyName,
      givenName: attributes.givenName,
      permission: attributes.permission,
      email: attributes.email,
      phone: attributes.phone,
      homepage: attributes.homepage,
      address: attributes.address,
      avatarUrl: userResponseItem.meta.avatar.mediumAvatarUrl,
      namePrefix: attributes.namePrefix,
      nameSuffix: attributes.nameSuffix,
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
  final String namePrefix;
  final String nameSuffix;
}
