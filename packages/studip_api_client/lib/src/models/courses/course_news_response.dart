class CourseNewsListResponse {
  final List<CourseNewsResponse> news;
  final int offset;
  final int limit;
  final int total;

  CourseNewsListResponse({
    required this.news,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory CourseNewsListResponse.fromJson(Map<String, dynamic> json) {
    final page = json["meta"]["page"];
    List<dynamic> news = json["data"];

    return CourseNewsListResponse(
      news:
          news.map((rawNews) => CourseNewsResponse.fromJson(rawNews)).toList(),
      offset: page["offset"],
      limit: page["limit"],
      total: page["total"],
    );
  }
}

class CourseNewsResponse {
  final String id;
  final String title;
  final String content;
  final String publicationStart;
  final String publicationEnd;

  CourseNewsResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.publicationStart,
    required this.publicationEnd,
  });

  factory CourseNewsResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["attributes"];
    return CourseNewsResponse(
      id: json["id"],
      title: attributes["title"],
      content: attributes["content"],
      publicationStart: attributes["publication-start"],
      publicationEnd: attributes["publication-end"],
    );
  }
}
