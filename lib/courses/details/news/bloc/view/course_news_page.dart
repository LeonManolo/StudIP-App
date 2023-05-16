import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';
import 'package:studipadawan/courses/details/news/bloc/view/widgets/news_list.dart';
import 'package:studipadawan/utils/pagination_loading_indicator.dart';

class CourseNewsPage extends StatelessWidget {
  const CourseNewsPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ankündigungen')),
      body: SafeArea(
        child: BlocProvider<CourseNewsBloc>(
          create: (context) => CourseNewsBloc(
            courseId: courseId,
            courseRepository: context.read<CourseRepository>(),
          )..add(CourseNewsReloadRequested()),
          child: const NewsList(),
        ),
      ),
    );
  }
}
