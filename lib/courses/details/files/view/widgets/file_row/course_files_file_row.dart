import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/models/file_info.dart';
import 'package:studipadawan/courses/details/files/view/widgets/file_row/course_files_file_info_alert.dart';
import 'package:studipadawan/courses/details/files/view/widgets/file_row/course_files_file_row_trailling.dart';
import 'package:studipadawan/utils/utils.dart';

enum FilePopupMenuOption { info, download, display }

class CourseFilesFileRow extends StatelessWidget {
  const CourseFilesFileRow({super.key, required this.fileInfo});
  final FileInfo fileInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fileInfo.file.name),
      leading: Icon(fileTypeToIcon(fileName: fileInfo.file.name)),
      trailing: CourseFilesFileRowTrailling(fileInfo: fileInfo),
      onTap: () {
        context
            .read<CourseFilesBloc>()
            .add(DidSelectFileEvent(selectedFileInfo: fileInfo));
      },
      onLongPress: () {
        showDialog<void>(
          context: context,
          builder: (context) => CourseFilesFileInfoAlert(file: fileInfo.file),
        );
      },
    );
  }
}
