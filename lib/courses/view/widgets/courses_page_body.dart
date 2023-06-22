import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/courses/details/view/course_details_page.dart';
import 'package:studipadawan/courses/view/widgets/semester_list.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class CoursesPageBody extends StatelessWidget {
  const CoursesPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        switch (state) {
          case CoursesStateLoading _:
            return _loadingWidget();
          case CoursesStateDidLoad(items: final items):
            return CoursesList(
              listItems: items,
              onCourseSelection: (selectedCourse) {
                Navigator.push(
                  context,
                  MaterialPageRoute<CourseDetailsPage>(
                    builder: (context) {
                      return CourseDetailsPage(course: selectedCourse);
                    },
                  ),
                );
              },
            );
          case CoursesStateError _:
            return Center(
              child: ErrorView(
                  title: 'Fehler',
                  message:
                      'Fehler beim Laden der Kurse.\nBitte erneut versuchen.',
                onRetryPressed: () {
                  BlocProvider.of<CoursesBloc>(context).add(CoursesRequested());
                },
              ),
            );
        }
      },
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _failureWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Error on load'),
          ElevatedButton(
            onPressed: () =>
                BlocProvider.of<CoursesBloc>(context).add(CoursesRequested()),
            child: const Text('Load courses'),
          )
        ],
      ),
    );
  }
}
