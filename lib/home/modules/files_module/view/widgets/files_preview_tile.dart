import 'package:activity_repository/activity_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/view/course_details_page.dart';

class FilePreviewTile extends StatelessWidget {
  const FilePreviewTile({super.key, required this.fileActivity});
  final FileActivity fileActivity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fileActivity.fileName),
      subtitle: Text(
        '${fileActivity.course.courseDetails.title}\n${fileActivity.owner}',
      ),
      leading: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(EvaIcons.fileOutline)],
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
