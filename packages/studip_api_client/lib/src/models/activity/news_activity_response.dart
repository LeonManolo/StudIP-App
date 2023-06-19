class NewsActivityListResponse {
  final List<NewsActivityResponse> newsActivities;

  const NewsActivityListResponse({required this.newsActivities});

  factory NewsActivityListResponse.fromJson(Map<String, dynamic> json) {
    final dynamic included = json["included"];
    final List<dynamic> newsActivities = json["data"];
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
    required this.title,
    required this.course,
    required this.publicationEnd,
    required this.username,
  });
  final String createDate;
  final String title;
  final Map<String, dynamic> course;
  final DateTime publicationEnd;
  final String username;

  factory NewsActivityResponse.fromJson(
      Map<String, dynamic> data, List<dynamic> included) {
    final attributes = data["attributes"];
    final relationships = data["relationships"];

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

    final newsMap =
        extractById(included, relationships["object"]["data"]["id"]);

    final Map<String, dynamic> rawCourse =
        extractById(included, relationships["context"]["data"]["id"]);

    final DateTime publicationEnd =
        DateTime.parse(newsMap["attributes"]["publication-end"]);

    final String username = extractById(
            included, relationships["actor"]["data"]["id"])["attributes"]
        ["formatted-name"];

    return NewsActivityResponse(
        createDate: attributes["mkdate"],
        title: newsMap["attributes"]["title"],
        course: rawCourse,
        publicationEnd: publicationEnd,
        username: username);
  }
}
