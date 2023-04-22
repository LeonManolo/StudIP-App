class MessageUser {
  final String id;
  String username;
  MessageUser({required this.id, required this.username});

  factory MessageUser.fromJson(dynamic json) {
    final attributes = json['attributes'];
    return MessageUser(
      id: json['id'] as String,
      username: attributes['MessageUsername'] as String,
    );
  }
}
