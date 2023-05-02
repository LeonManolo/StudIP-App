import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/view/widgets/file_row/course_files_file_row.dart';

import '../../bloc/course_files_bloc.dart';

class CourseFilesItemsList extends StatelessWidget {
  const CourseFilesItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseFilesBloc, CourseFilesState>(
      builder: (context, state) {
        return state.items.isEmpty
            ? const Center(
                child: Text(
                "Keine Dateien vorhanden",
                textAlign: TextAlign.center,
              ))
            : ListView.builder(
                itemBuilder: (context, index) {
                  return state.items.elementAt(index).fold((folder) {
                    return ListTile(
                      title: Text(folder.name),
                      leading: const Icon(Icons.folder),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      onTap: () => context
                          .read<CourseFilesBloc>()
                          .add(DidSelectFolderEvent(
                            selectedFolder: folder,
                            parentFolders: state.parentFolders,
                          )),
                    );
                  }, (fileInfo) {
                    return CourseFilesFileRow(fileInfo: fileInfo);
                  });
                },
                itemCount: state.items.length,
              );
      },
    );
  }
}
