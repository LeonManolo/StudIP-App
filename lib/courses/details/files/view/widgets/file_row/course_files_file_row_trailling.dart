import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/files/models/file_info.dart';

class CourseFilesFileRowTrailling extends StatelessWidget {
  final FileInfo fileInfo;

  const CourseFilesFileRowTrailling({Key? key, required this.fileInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (fileInfo.fileType) {
      case FileType.downloaded:
        return const Icon(Icons.download_done_outlined);
      case FileType.remote:
        return const Icon(Icons.cloud_outlined);
      case FileType.isDownloading:
        return const CircularProgressIndicator.adaptive();
    }
  }
}
