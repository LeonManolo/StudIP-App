// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListResponse _$UserListResponseFromJson(Map<String, dynamic> json) =>
    UserListResponse(
      userResponseItems: (json['data'] as List<dynamic>)
          .map((e) => UserResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserListResponseToJson(UserListResponse instance) =>
    <String, dynamic>{
      'data': instance.userResponseItems,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      userResponseItem:
          UserResponseItem.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'data': instance.userResponseItem,
    };

UserResponseItem _$UserResponseItemFromJson(Map<String, dynamic> json) =>
    UserResponseItem(
      id: json['id'] as String,
      attributes: UserResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      meta: UserResponseItemMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseItemToJson(UserResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'meta': instance.meta,
    };

UserResponseItemAttributes _$UserResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    UserResponseItemAttributes(
      username: json['username'] as String,
      formattedName: json['formatted-name'] as String,
      familyName: json['family-name'] as String,
      givenName: json['given-name'] as String,
      namePrefix: json['name-prefix'] as String,
      nameSuffix: json['name-suffix'] as String,
      permission: json['permission'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      homepage: json['homepage'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$UserResponseItemAttributesToJson(
        UserResponseItemAttributes instance) =>
    <String, dynamic>{
      'username': instance.username,
      'formatted-name': instance.formattedName,
      'family-name': instance.familyName,
      'given-name': instance.givenName,
      'name-prefix': instance.namePrefix,
      'name-suffix': instance.nameSuffix,
      'permission': instance.permission,
      'email': instance.email,
      'phone': instance.phone,
      'homepage': instance.homepage,
      'address': instance.address,
    };

UserResponseItemMeta _$UserResponseItemMetaFromJson(
        Map<String, dynamic> json) =>
    UserResponseItemMeta(
      avatar: UserResponseItemMetaAvatar.fromJson(
          json['avatar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseItemMetaToJson(
        UserResponseItemMeta instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
    };

UserResponseItemMetaAvatar _$UserResponseItemMetaAvatarFromJson(
        Map<String, dynamic> json) =>
    UserResponseItemMetaAvatar(
      smallAvatarUrl: json['small'] as String,
      mediumAvatarUrl: json['medium'] as String,
      normalAvatarUrl: json['normal'] as String,
      originalAvatarUrl: json['original'] as String,
    );

Map<String, dynamic> _$UserResponseItemMetaAvatarToJson(
        UserResponseItemMetaAvatar instance) =>
    <String, dynamic>{
      'small': instance.smallAvatarUrl,
      'medium': instance.mediumAvatarUrl,
      'normal': instance.normalAvatarUrl,
      'original': instance.originalAvatarUrl,
    };
