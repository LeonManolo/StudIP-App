import 'package:activity_repository/activity_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:studipadawan/home/models/preview_model.dart';
import 'package:studipadawan/utils/utils.dart';

class FilePreviewModel implements PreviewModel {
  FilePreviewModel({required this.fileActivity});

  final FileActivity fileActivity;

  @override
  IconData get iconData => fileTypeToIcon(fileName: fileActivity.fileName);

  @override
  String get subtitle =>
      '${fileActivity.course.courseDetails.title}\nVon ${fileActivity.ownerFormattedName} ${fileActivity.getTimeAgo()}';

  @override
  String get title => fileActivity.fileName;
}
