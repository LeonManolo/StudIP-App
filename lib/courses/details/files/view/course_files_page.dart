import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';

import '../../bloc/course_details_bloc.dart';

class CourseFilesPage extends StatelessWidget {
  const CourseFilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseFilesBloc(
        course: context.read<CourseDetailsBloc>().course,
        courseRepository: context.read<CourseRepository>(),
      )..add(LoadRootFolderEvent()),
      child: BlocBuilder<CourseFilesBloc, CourseFilesState>(
        builder: (context, state) {
          if (state is CourseFilesLoadedState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final folderInfo = state.parentFolders.elementAt(index);
                        return TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: const Size.fromWidth(20)),
                          child: Text(folderInfo.displayName),
                          onPressed: () {
                            context
                                .read<CourseFilesBloc>()
                                .add(DidSelectFolderEvent(
                                  selectedFolder: folderInfo.folder,
                                  parentFolders: state.parentFolders,
                                ));
                          },
                        );
                      },
                      separatorBuilder: ((context, index) {
                        return const Center(
                          child: Text(">"),
                        );
                      }),
                      itemCount: state.parentFolders.length),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
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
                      }, (file) {
                        return ListTile(
                            title: Text(file.name),
                            leading: const Icon(EvaIcons.fileOutline));
                      });
                    },
                    itemCount: state.items.length,
                  ),
                ),
              ],
            );
          } else if (state is CourseFilesFailureState) {
            return Center(child: Text(state.errorMessage));
          } else if (state is CourseFilesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Text("Unexpected State. Shouldn't happen");
          }
        },
      ),
    );
  }
}
