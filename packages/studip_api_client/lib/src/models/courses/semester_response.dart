class SemesterResponse {
  final String id;
  final String title;
  final String description;
  final String start;
  final String end;
  final String startOfLectures;
  final String endOfLectures;

  SemesterResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.startOfLectures,
    required this.endOfLectures,
  });

  factory SemesterResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["data"]["attributes"];
    return SemesterResponse(
      id: json["data"]["id"],
      title: attributes["title"],
      description: attributes["description"],
      start: attributes["start"],
      end: attributes["end"],
      startOfLectures: attributes["start-of-lectures"],
      endOfLectures: attributes["end-of-lectures"],
    );
  }
}
