import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/forum/bloc/course_forum_bloc.dart';

class CourseForumPage extends StatelessWidget {
  const CourseForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseForumBloc(),
      child: const Text('Forum'),
    );
  }
}
