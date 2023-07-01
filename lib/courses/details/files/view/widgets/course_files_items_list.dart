import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/view/widgets/file_row/course_files_file_row.dart';
import 'package:studipadawan/utils/empty_view.dart';

class CourseFilesItemsList extends StatelessWidget {
  const CourseFilesItemsList({super.key, required this.insertSpacerAtEnd});

  final bool insertSpacerAtEnd;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseFilesBloc, CourseFilesState>(
      builder: (context, state) {
        return state.items.isEmpty
            ? const Center(child: EmptyView(message: 'Keine Dateien vorhanden'))
            : ListView.builder(
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return const SizedBox(height: 75);
                  }
                  return state.items.elementAt(index).fold((folder) {
                    return ListTile(
                      title: Text(folder.name),
                      leading: const Icon(Icons.folder),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      onTap: () => context.read<CourseFilesBloc>().add(
                            DidSelectFolderEvent(
                              selectedFolder: folder,
                              parentFolders: state.parentFolders,
                            ),
                          ),
                    );
                  }, (fileInfo) {
                    return CourseFilesFileRow(fileInfo: fileInfo);
                  });
                },
                itemCount: insertSpacerAtEnd
                    ? state.items.length + 1
                    : state.items.length,
              );
      },
    );
  }
}
