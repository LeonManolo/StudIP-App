import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class FileActivity {
  FileActivity({
    required this.createDate,
    required this.content,
    required this.verb,
    required this.fileId,
    required this.courseId,
    this.owner,
    this.course,
  });
  factory FileActivity.fromFileActivityResponse({
    required studip_api_client.FileActivityResponse fileActivityResponse,
  }) {
    return FileActivity(
      createDate: DateTime.parse(fileActivityResponse.createDate).toLocal(),
      content: fileActivityResponse.content,
      verb: fileActivityResponse.verb,
      fileId: fileActivityResponse.fileId,
      courseId: fileActivityResponse.courseId,
    );
  }
  final DateTime createDate;
  final String content;
  final String verb;
  final String fileId;
  final String courseId;
  Course? course;
  String? owner;
  String? fileName;

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(createDate, locale: 'de');
  }
}
