import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';
import 'package:studipadawan/courses/details/participants/bloc/course_participants_bloc.dart';
import 'package:studipadawan/courses/details/participants/widgets/course_participants_list.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/snackbar.dart';

class CourseParticipantsPage extends StatelessWidget {
  const CourseParticipantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseParticipantsBloc(
        courseRepository: context.read<CourseRepository>(),
        courseId: context.read<CourseDetailsBloc>().course.id,
      )..add(CourseParticipantsRequested()),
      child: BlocConsumer<CourseParticipantsBloc, CourseParticipantsState>(
        listener: (context, state) {
          if (state case CourseParticipantsError(errorMessage: final error)) {
            buildSnackBar(context, error, null);
          }
        },
        builder: (context, state) {
          switch (state) {
            case CourseParticipantsLoading():
              return const LoadingIndicator();

            case CourseParticipantsDidLoad(participants: final participants):
              return CourseParticipantsList(
                participants: participants,
                onRefresh: () {
                  context.read<CourseParticipantsBloc>().add(
                        CourseParticipantsRequested(),
                      );
                },
                onBottomReached: () {
                  context.read<CourseParticipantsBloc>().add(
                        CourseParticipantsReachedBottom(),
                      );
                },
              );

            case _:
              // TODO: create universial error state widget
              return const Text('Other');
          }
        },
      ),
    );
  }
}
