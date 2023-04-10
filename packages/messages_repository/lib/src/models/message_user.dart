class MessageUser {
  final String id;
  final String type;
  String username;
  MessageUser({required this.id, required this.type, required this.username});

  factory MessageUser.fromJson(dynamic json) {
    return MessageUser(id: json["id"], type: json["type"], username: "");
  }
}
