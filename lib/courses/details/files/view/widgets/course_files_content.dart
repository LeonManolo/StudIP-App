import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_items_list.dart';

class CourseFilesContent extends StatelessWidget {
  const CourseFilesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseFilesBloc, CourseFilesState>(
      builder: (context, state) {
        switch (state.type) {
          case CourseFilesStateType.didLoad:
            return const CourseFilesItemsList();
          case CourseFilesStateType.isLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case CourseFilesStateType.error:
            return Center(
              child: Text(
                state.errorMessage ?? 'Ein unbekannter Fehler ist aufgetreten',
                textAlign: TextAlign.center,
              ),
            );
        }
      },
    );
  }
}
