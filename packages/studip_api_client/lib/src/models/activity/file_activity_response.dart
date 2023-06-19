class FileActivityListResponse {
  final List<FileActivityResponse> fileActivities;

  const FileActivityListResponse({required this.fileActivities});

  factory FileActivityListResponse.fromJson(Map<String, dynamic> json) {
    final dynamic included = json["included"];
    final List<dynamic> fileActivities = json["data"];
    return FileActivityListResponse(
        fileActivities: fileActivities
            .map((fileActivity) =>
                FileActivityResponse.fromJson(fileActivity, included))
            .toList());
  }
}

class FileActivityResponse {
  const FileActivityResponse({
    required this.createDate,
    required this.content,
    required this.owner,
    required this.fileName,
    required this.course,
  });
  final String createDate;
  final String content;
  final String owner;
  final String fileName;
  final Map<String, dynamic> course;

  factory FileActivityResponse.fromJson(
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

    return FileActivityResponse(
        createDate: attributes["mkdate"],
        content: attributes["content"],
        fileName: extractById(
                included, relationShips["object"]["data"]["id"])["attributes"]
            ["name"],
        course: extractById(included, relationShips["context"]["data"]["id"]),
        owner: extractById(
                included, relationShips["actor"]["data"]["id"])["attributes"]
            ["formatted-name"]);
  }
}
