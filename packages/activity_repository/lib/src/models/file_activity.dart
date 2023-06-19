import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class FileActivity {
  FileActivity({
    required this.createDate,
    required this.content,
    required this.owner,
    required this.fileName,
    required this.course,
  });
  factory FileActivity.fromFileActivityResponse({
    required studip_api_client.FileActivityResponse fileActivityResponse,
  }) {
    return FileActivity(
      createDate: DateTime.parse(fileActivityResponse.createDate).toLocal(),
      content: fileActivityResponse.content,
      owner: fileActivityResponse.owner,
      fileName: fileActivityResponse.fileName,
      course: Course.fromCourseResponse(
        studip_api_client.CourseResponse.fromJson(
          fileActivityResponse.course,
        ),
      ),
    );
  }
  final DateTime createDate;
  final String content;
  final String owner;
  final String fileName;
  final Course course;

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(createDate, locale: 'de');
  }
}
