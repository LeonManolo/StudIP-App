import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_content.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_path_list.dart';

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              CourseFilesPathList(),
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
