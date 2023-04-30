import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_file_info_alert.dart';

import '../../bloc/course_files_bloc.dart';

enum FilePopupMenuOption { info, download }

class CourseFilesFileRow extends StatelessWidget {
  final File file;
  const CourseFilesFileRow({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      onSelected: (selectedOption) {
        switch (selectedOption) {
          case FilePopupMenuOption.info:
            showDialog(
                context: context,
                builder: (context) => CourseFilesFileInfoAlert(file: file));
            break;
          case FilePopupMenuOption.download:
            context
                .read<CourseFilesBloc>()
                .add(DidSelectFileEvent(selectedFile: file));
        }
      },
      child: ListTile(
          title: Text(file.name), leading: const Icon(EvaIcons.fileOutline)),
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: FilePopupMenuOption.info, child: Text("Info")),
        const PopupMenuItem(
            value: FilePopupMenuOption.download, child: Text("Herunterladen"))
      ],
    );
  }
}
