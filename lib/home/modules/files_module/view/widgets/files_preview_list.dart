import 'package:activity_repository/activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/home/modules/files_module/view/widgets/files_preview_tile.dart';
import 'package:studipadawan/utils/empty_view.dart';

class FilespreviewList extends StatelessWidget {
  const FilespreviewList({
    super.key,
    required this.fileActivities,
  });
  final List<FileActivity> fileActivities;

  @override
  Widget build(BuildContext context) {
    if (fileActivities.isEmpty) {
      return const Center(
        child: EmptyView(
          title: 'Keine Dateien',
          message: 'Es wurden keine neuen Dateien veröffentlicht',
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: fileActivities.asMap().entries.map((file) {
          final index = file.key;
          final fileActivity = file.value;
          final isLastFile = index == fileActivities.length - 1;

          return Column(
            children: [
              FilePreviewTile(fileActivity: fileActivity),
              if (!isLastFile) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
