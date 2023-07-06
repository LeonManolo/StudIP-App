import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/info/bloc/course_info_bloc.dart';
import 'package:studipadawan/courses/details/info/view/widgets/events_section.dart';
import 'package:studipadawan/courses/details/info/view/widgets/general_info_section.dart';

class CourseInfoPage extends StatelessWidget {
  const CourseInfoPage({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseInfoBloc(
        course: course,
        courseRepository: context.read<CourseRepository>(),
      )..add(TriggerInitialLoadEvent()),
      child: BlocBuilder<CourseInfoBloc, CourseInfoState>(
        builder: (context, state) {
          if (state is CourseInfoLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CourseInfoPopulatedState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final section =
                    context.read<CourseInfoBloc>().allSections.elementAt(index);
                switch (section) {
                  case InfoType.general:
                    return GeneralInfoSection(
                      generalInfo: state.generalInfoExpansionModel,
                      onExpansionChanged: ({required isExpanded}) {
                        context.read<CourseInfoBloc>().add(
                              ToggleSectionEvent(
                                type: InfoType.general,
                                newExpansionState: isExpanded,
                              ),
                            );
                      },
                    );
                  case InfoType.events:
                    return EventsSection(
                      eventExpansionModel: state.eventExpansionModel,
                      onExpansionChanged: ({required isExpanded}) {
                        context.read<CourseInfoBloc>().add(
                              ToggleSectionEvent(
                                type: InfoType.events,
                                newExpansionState: isExpanded,
                              ),
                            );
                      },
                    );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: AppSpacing.lg,
                );
              },
              itemCount: context.read<CourseInfoBloc>().allSections.length,
            );
          } else {
            return const Text("Unexpected State. This shouldn't happen.");
          }
        },
      ),
    );
  }
}
