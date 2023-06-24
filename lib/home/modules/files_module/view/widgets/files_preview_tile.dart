import 'package:activity_repository/activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/view/course_details_page.dart';
import 'package:studipadawan/utils/utils.dart';

class FilePreviewTile extends StatelessWidget {
  const FilePreviewTile({super.key, required this.fileActivity});
  final FileActivity fileActivity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fileActivity.fileName),
      subtitle: Text(
        '${fileActivity.course.courseDetails.title}\n${fileActivity.ownerFormattedName}',
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(fileTypeToIcon(fileName: fileActivity.fileName))],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(fileActivity.getTimeAgo()),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<CourseDetailsPage>(
            builder: (context) {
              return CourseDetailsPage(course: fileActivity.course);
            },
          ),
        );
      },
    );
  }
}
