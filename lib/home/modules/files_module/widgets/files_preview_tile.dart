import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/view/course_details_page.dart';
import 'package:studipadawan/home/modules/files_module/model/file_preview_model.dart';

class FilePreviewTile extends StatelessWidget {
  const FilePreviewTile({super.key, required this.filePreviewModel});
  final FilePreviewModel filePreviewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(filePreviewModel.title),
      subtitle: Text(filePreviewModel.subtitle),
      leading: Icon(filePreviewModel.iconData),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<CourseDetailsPage>(
            builder: (context) {
              return CourseDetailsPage(
                course: filePreviewModel.fileActivity.course,
              );
            },
          ),
        );
      },
    );
  }
}
