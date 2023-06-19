class NewsActivityListResponse {
  final List<NewsActivityResponse> newsActivities;

  const NewsActivityListResponse({required this.newsActivities});

  factory NewsActivityListResponse.fromJson(Map<String, dynamic> json) {
    final dynamic included = json["included"];
    final List<dynamic> newsActivities = json["data"];
    try {
      NewsActivityListResponse(
          newsActivities: newsActivities
              .map((newsActivity) =>
                  NewsActivityResponse.fromJson(newsActivity, included))
              .toList());
    } catch (e) {
      print(e);
    }

    return NewsActivityListResponse(
        newsActivities: newsActivities
            .map((newsActivity) =>
                NewsActivityResponse.fromJson(newsActivity, included))
            .toList());
  }
}

class NewsActivityResponse {
  const NewsActivityResponse({
    required this.createDate,
    required this.content,
    required this.verb,
    required this.title,
    required this.course,
    required this.publicationEnd,
    required this.username,
  });
  final String createDate;
  final String content;
  final String verb;
  final String title;
  final Map<String, dynamic> course;
  final DateTime publicationEnd;
  final String username;

  factory NewsActivityResponse.fromJson(
      Map<String, dynamic> data, List<dynamic> included) {
    final attributes = data["attributes"];
    final relationShips = data["relationships"];

    Map<String, dynamic> extractById(
      List<dynamic> included,
      String id,
    ) {
      for (final include in included) {
        if (include["id"] == id) {
          return include;
        }
      }
      return {};
    }

    return NewsActivityResponse(
        createDate: attributes["mkdate"],
        content: attributes["content"],
        title: attributes["title"],
        verb: attributes["verb"],
        course: extractById(included, relationShips["context"]["data"]["id"]),
        publicationEnd: DateTime.parse(extractById(
                included, relationShips["object"]["data"]["id"])["attributes"]
            ["publication-end"]),
        username: extractById(
                included, relationShips["actor"]["data"]["id"])["attributes"]
            ["formatted-name"]);
  }
}
