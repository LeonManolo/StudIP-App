class UserResponse {
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

  UserResponse({
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

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? json;
    final attributes = data['attributes'] as Map<String, dynamic>;
    return UserResponse(
      id: data['id'] as String,
      username: attributes['username'] as String,
      formattedName: attributes['formatted-name'] as String,
      familyName: attributes['family-name'] as String,
      givenName: attributes['given-name'] as String,
      permission: attributes['permission'] as String,
      email: attributes['email'] as String,
      phone: attributes['phone'] as String?,
      homepage: attributes['homepage'] as String?,
      address: attributes['address'] as String?,
      avatarUrl: data['meta']['avatar']['medium'] as String,
      namePrefix: attributes['name-prefix'] as String,
      nameSuffix: attributes['name-suffix'] as String,
    );
  }
}
