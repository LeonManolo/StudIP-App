import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';

class CourseFilesPathRowList extends StatelessWidget {
  const CourseFilesPathRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseFilesBloc, CourseFilesState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final folderInfo = state.parentFolders.elementAt(index);
              return TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromWidth(20),
                ),
                child: Text(folderInfo.displayName),
                onPressed: () {
                  context.read<CourseFilesBloc>().add(
                        DidSelectFolderEvent(
                          selectedFolder: folderInfo.folder,
                          parentFolders: state.parentFolders,
                        ),
                      );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Center(
                child: Text('>'),
              );
            },
            itemCount: state.parentFolders.length,
          ),
        );
      },
    );
  }
}
