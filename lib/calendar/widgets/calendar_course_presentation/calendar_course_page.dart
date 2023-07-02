import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/calendar/widgets/calendar_course_presentation/bloc/calendar_course_bloc.dart';
import 'package:studipadawan/courses/details/view/course_details_page.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

/// This Widget can be used to display a [CourseDetailsPage] if only the [courseId] of the corresponding course is known.
class CalendarCoursePage extends StatelessWidget {
  const CalendarCoursePage({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCourseBloc(
        courseRepository: context.read<CourseRepository>(),
        courseId: courseId,
      )..add(CalendarCourseRequested()),
      child: const CalendarCourseView(),
    );
  }
}

class CalendarCourseView extends StatelessWidget {
  const CalendarCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCourseBloc, CalendarCourseState>(
      builder: (context, state) {
        switch (state) {
          case CalendarCourseStateLoading _:
            return Scaffold(
              appBar: AppBar(title: const Text('Kurs laden')),
              body: const Center(child: LoadingIndicator()),
            );

          case CalendarCourseStateCourseDidLoad _:
            return CourseDetailsPage(course: state.course);

          case CalendarCourseStateError _:
            return Scaffold(
              appBar: AppBar(title: const Text('Kurs laden')),
              body: ErrorView(
                iconData: null,
                message: state.errorMessage,
                onRetryPressed: () => context
                    .read<CalendarCourseBloc>()
                    .add(CalendarCourseRequested()),
              ),
            );
        }
      },
    );
  }
}
