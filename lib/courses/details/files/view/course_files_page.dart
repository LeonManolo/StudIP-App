import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';

class CourseFilesPage extends StatelessWidget {
  const CourseFilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseFilesBloc(),
      child: const Text("Dateien"),
    );
  }
}
