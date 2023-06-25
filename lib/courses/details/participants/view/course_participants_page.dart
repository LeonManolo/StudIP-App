import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/participants/bloc/course_participants_bloc.dart';
import 'package:studipadawan/courses/details/participants/widgets/course_participants_list.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/snackbar.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class CourseParticipantsPage extends StatelessWidget {
  const CourseParticipantsPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseParticipantsBloc(
        courseRepository: context.read<CourseRepository>(),
        courseId: courseId,
      )..add(CourseParticipantsRequested()),
      child: BlocBuilder<CourseParticipantsBloc, CourseParticipantsState>(
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

            case final CourseParticipantsError errorState:
              return ErrorView(
                iconData: null,
                message: errorState.errorMessage,
                onRetryPressed: () {
                  BlocProvider.of<CourseParticipantsBloc>(context)
                      .add(CourseParticipantsRequested());
                },
              );
          }
        },
      ),
    );
  }
}
