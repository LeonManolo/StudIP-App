class CourseParticipantsResponse {
  final int offset;
  final int limit;
  final int total;
  final List<CourseParticipantResponse> participants;

  const CourseParticipantsResponse._({
    required this.offset,
    required this.limit,
    required this.total,
    required this.participants,
  });

  factory CourseParticipantsResponse.fromJson(Map<String, dynamic> json) {
    final int offset = json["meta"]["page"]["offset"];
    final int limit = json["meta"]["page"]["limit"];
    final int total = json["meta"]["page"]["total"];
    final participants = (json["data"] as List)
        .map((participant) => CourseParticipantResponse.fromJson(participant))
        .toList();

    return CourseParticipantsResponse._(
      offset: offset,
      limit: limit,
      total: total,
      participants: participants,
    );
  }
}

class CourseParticipantResponse {
  final String type;
  final String id;

  const CourseParticipantResponse._({required this.type, required this.id});

  factory CourseParticipantResponse.fromJson(Map<String, dynamic> json) {
    final String rawId = json["id"];
    final String id = rawId.split("_").last;

    return CourseParticipantResponse._(type: json["type"], id: id);
  }
}
