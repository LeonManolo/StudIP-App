import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';

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
          child: BlocConsumer<CourseNewsBloc, CourseNewsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is CourseNewsDidLoad) {
                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<CourseNewsBloc>()
                      .add(CourseNewsReloadRequested()),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final newsItem = state.news.elementAt(index);
                      return ListTile(
                        title: Text(newsItem.title),
                        subtitle: HtmlWidget(newsItem.content),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemCount: state.news.length,
                  ),
                );
              } else if (state is CourseNewsIsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CourseNewsError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else {
                return const Center(
                  child: Text('invalid state'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
