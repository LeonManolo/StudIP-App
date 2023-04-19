import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/info/bloc/course_info_bloc.dart';

class CourseInfoPage extends StatelessWidget {
  const CourseInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseInfoBloc(),
      child: const Text("Info"),
    );
  }
}
