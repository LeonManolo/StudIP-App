import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/models/file_info.dart';
import 'package:studipadawan/courses/details/files/view/widgets/file_row/course_files_file_row_trailling.dart';

import '../../../bloc/course_files_bloc.dart';
import 'course_files_file_info_alert.dart';

enum FilePopupMenuOption { info, download, display }

class CourseFilesFileRow extends StatelessWidget {
  final FileInfo fileInfo;
  const CourseFilesFileRow({Key? key, required this.fileInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      onSelected: (selectedOption) {
        switch (selectedOption) {
          case FilePopupMenuOption.info:
            showDialog(
                context: context,
                builder: (context) =>
                    CourseFilesFileInfoAlert(file: fileInfo.file));
            break;

          case FilePopupMenuOption.download:
            context
                .read<CourseFilesBloc>()
                .add(DidSelectDownloadFileEvent(selectedFileInfo: fileInfo));
            break;
          case FilePopupMenuOption.display:
            context
                .read<CourseFilesBloc>()
                .add(DidSelectOpenFileEvent(selectedFileInfo: fileInfo));
            break;
        }
      },
      child: ListTile(
        title: Text(fileInfo.file.name),
        leading: const Icon(EvaIcons.fileOutline),
        trailing: CourseFilesFileRowTrailling(fileInfo: fileInfo),
      ),
      itemBuilder: (context) => _popupItems(fileInfo: fileInfo),
    );
  }

  List<PopupMenuEntry<FilePopupMenuOption>> _popupItems(
      {required FileInfo fileInfo}) {
    if (fileInfo.fileType == FileType.remote) {
      return [
        const PopupMenuItem(
            value: FilePopupMenuOption.info, child: Text("Info")),
        const PopupMenuItem(
            value: FilePopupMenuOption.download, child: Text("Herunterladen"))
      ];
    } else if (fileInfo.fileType == FileType.downloaded) {
      return [
        const PopupMenuItem(
            value: FilePopupMenuOption.info, child: Text("Info")),
        const PopupMenuItem(
            value: FilePopupMenuOption.display, child: Text("Anzeigen"))
      ];
    } else {
      return [
        const PopupMenuItem(
            value: FilePopupMenuOption.info, child: Text("Info"))
      ];
    }
  }
}
