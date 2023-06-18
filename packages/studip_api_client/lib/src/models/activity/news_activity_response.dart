class NewsActivityListResponse {
  final List<NewsActivityResponse> newsActivities;

  const NewsActivityListResponse({required this.newsActivities});

  factory NewsActivityListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> newsActivities = json["data"];
    return NewsActivityListResponse(
        newsActivities: newsActivities
            .map((newsActivity) => NewsActivityResponse.fromJson(newsActivity))
            .toList());
  }
}

class NewsActivityResponse {
  const NewsActivityResponse({
    required this.createDate,
    required this.content,
    required this.verb,
    required this.title,
    required this.courseId,
    required this.userId,
  });
  final String createDate;
  final String content;
  final String verb;
  final String title;
  final String courseId;
  final String userId;

  factory NewsActivityResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["attributes"];
    final relationShips = json["relationships"];

    return NewsActivityResponse(
        createDate: attributes["mkdate"],
        content: attributes["content"],
        title: attributes["title"],
        verb: attributes["verb"],
        courseId: relationShips["context"]["data"]["id"],
        userId: relationShips["actor"]["data"]["id"]);
  }
}
