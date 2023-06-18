import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';
import 'package:studipadawan/courses/details/news/view/widgets/course_news_list.dart';

class CourseNewsPage extends StatelessWidget {
  const CourseNewsPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Ankündigungen')),
      body: BlocProvider<CourseNewsBloc>(
        create: (context) => CourseNewsBloc(
          courseId: courseId,
          courseRepository: context.read<CourseRepository>(),
        )..add(CourseNewsReloadRequested()),
        child: const CourseNewsPageBody(),
      ),
    );
  }
}

class CourseNewsPageBody extends StatelessWidget {
  const CourseNewsPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseNewsList(
      reachedBottom: () =>
          context.read<CourseNewsBloc>().add(CourseNewsReachedBottom()),
    );
  }
}
