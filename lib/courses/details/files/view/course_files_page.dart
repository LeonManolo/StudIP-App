import 'package:courses_repository/courses_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_content.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_path_list.dart';

class CourseFilesPage extends StatelessWidget {
  const CourseFilesPage({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseFilesBloc(
        course: course,
        filesRepository: context.read<FilesRepository>(),
      )..add(LoadRootFolderEvent()),
      child: BlocBuilder<CourseFilesBloc, CourseFilesState>(
        builder: (context, state) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CourseFilesPathRowList(),
              SizedBox(
                height: 10,
              ),
              Expanded(child: CourseFilesContent())
            ],
          );
        },
      ),
    );
  }
}
