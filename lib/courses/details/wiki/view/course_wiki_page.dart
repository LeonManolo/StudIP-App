import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/wiki/bloc/course_wiki_bloc.dart';
import 'package:studipadawan/courses/details/wiki/view/widgets/course_wiki_list.dart';

class CourseWikiPage extends StatelessWidget {
  const CourseWikiPage({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseWikiBloc>(
      create: (context) => CourseWikiBloc(
        courseId: course.id,
        courseRepository: context.read<CourseRepository>(),
      )..add(CourseWikiReloadRequested()),
      child: const CourseWikiList(),
    );
  }
}
