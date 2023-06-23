import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

/// List of [UserResponseItem]s
@JsonSerializable()
class UserListResponse {
  @JsonKey(name: 'data')
  final List<UserResponseItem> userResponseItems;

  UserListResponse({required this.userResponseItems});

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);
}

/// Single [UserResponseItem]
@JsonSerializable()
class UserResponse {
  @JsonKey(name: 'data')
  final UserResponseItem userResponseItem;

  UserResponse({required this.userResponseItem});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@JsonSerializable()
class UserResponseItem {
  final String id;
  final UserResponseItemAttributes attributes;
  final UserResponseItemMeta meta;

  UserResponseItem({
    required this.id,
    required this.attributes,
    required this.meta,
  });

  factory UserResponseItem.fromJson(Map<String, dynamic> json) =>
      _$UserResponseItemFromJson(json);
}

@JsonSerializable()
class UserResponseItemAttributes {
  final String username;

  @JsonKey(name: 'formatted-name')
  final String formattedName;

  @JsonKey(name: 'family-name')
  final String familyName;

  @JsonKey(name: 'given-name')
  final String givenName;

  @JsonKey(name: 'name-prefix')
  final String namePrefix;

  @JsonKey(name: 'name-suffix')
  final String nameSuffix;
  final String permission;
  final String email;
  final String? phone;
  final String? homepage;
  final String? address;

  UserResponseItemAttributes({
    required this.username,
    required this.formattedName,
    required this.familyName,
    required this.givenName,
    required this.namePrefix,
    required this.nameSuffix,
    required this.permission,
    required this.email,
    required this.phone,
    required this.homepage,
    required this.address,
  });
  factory UserResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$UserResponseItemAttributesFromJson(json);
}

@JsonSerializable()
class UserResponseItemMeta {
  final UserResponseItemMetaAvatar avatar;

  UserResponseItemMeta({required this.avatar});

  factory UserResponseItemMeta.fromJson(Map<String, dynamic> json) =>
      _$UserResponseItemMetaFromJson(json);
}

@JsonSerializable()
class UserResponseItemMetaAvatar {
  @JsonKey(name: 'small')
  final String smallAvatarUrl;

  @JsonKey(name: 'medium')
  final String mediumAvatarUrl;

  @JsonKey(name: 'normal')
  final String normalAvatarUrl;

  @JsonKey(name: 'original')
  final String originalAvatarUrl;

  UserResponseItemMetaAvatar({
    required this.smallAvatarUrl,
    required this.mediumAvatarUrl,
    required this.normalAvatarUrl,
    required this.originalAvatarUrl,
  });

  factory UserResponseItemMetaAvatar.fromJson(Map<String, dynamic> json) =>
      _$UserResponseItemMetaAvatarFromJson(json);
}
