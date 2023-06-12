class FileActivityListResponse {
  final List<FileActivityResponse> fileActivities;

  const FileActivityListResponse({required this.fileActivities});

  factory FileActivityListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fileActivities = json["data"];
    return FileActivityListResponse(
        fileActivities: fileActivities
            .map((fileActivity) => FileActivityResponse.fromJson(fileActivity))
            .toList());
  }
}

class FileActivityResponse {
  const FileActivityResponse({
    required this.createDate,
    required this.content,
    required this.verb,
    required this.fileId,
    required this.courseId,
  });
  final String createDate;
  final String content;
  final String verb;
  final String fileId;
  final String courseId;

  factory FileActivityResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["attributes"];
    final relationShips = json["relationships"];

    return FileActivityResponse(
      createDate: attributes["mkdate"],
      content: attributes["content"],
      verb: attributes["verb"],
      fileId: relationShips["object"]["data"]["id"],
      courseId: relationShips["context"]["data"]["id"],
    );
  }
}
