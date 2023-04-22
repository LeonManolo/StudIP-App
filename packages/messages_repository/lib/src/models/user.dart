class User {
  final String id;
  String username;
  User({required this.id, required this.username});

  factory User.fromJson(dynamic json) {
    final attributes = json['attributes'];
    return User(id: json['id'] as String, username: attributes['username'] as String,);
  }
}
