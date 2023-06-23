import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

class FileActivity {
  FileActivity({
    required this.lastUpdatedDate,
    required this.content,
    required this.ownerFormattedName,
    required this.fileName,
    required this.course,
  });
  factory FileActivity.fromFileActivityResponse({
    required ActivityResponseItem activityResponseItem,
    required FileResponseItem fileResponseItem,
    required UserResponseItem userResponseItem,
    required CourseResponseItem courseResponseItem,
  }) {
    return FileActivity(
      lastUpdatedDate:
          DateTime.parse(fileResponseItem.attributes.lastUpdatedAt).toLocal(),
      content: activityResponseItem
          .attributes.content, // TODO: Wird content überhaupt genutzt?
      ownerFormattedName: userResponseItem.attributes.formattedName,
      fileName: fileResponseItem.attributes.name,
      course: Course.fromCourseResponseItem(courseResponseItem),
    );
  }
  final DateTime lastUpdatedDate;
  final String content;
  final String ownerFormattedName;
  final String fileName;
  final Course course;

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(lastUpdatedDate, locale: 'de');
  }
}
