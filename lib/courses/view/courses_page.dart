import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/courses/view/widgets/courses_page_body.dart';
import 'package:studipadawan/courses/view/widgets/semester_sort_filter_modal_sheet.dart';
import 'package:studipadawan/utils/widgets/modal_sheet/modal_bottom_sheet.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: CoursesPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoursesBloc(
        courseRepository: context.read<CourseRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
        todayDateTime: DateTime.now(),
      )..add(CoursesRequested()),
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Kurse'),
              actions: switch (state) {
                CoursesStateLoading _ => [],
                CoursesStateError _ => [],
                CoursesStateDidLoad(
                  semesterFilter: final currentFilter,
                  semesterSortOrder: final currentSortOrder
                ) =>
                  [
                    IconButton(
                      color: state.isDefaultFilter
                          ? null
                          : Theme.of(context).primaryColor,
                      icon: Icon(
                        state.isDefaultFilter
                            ? EvaIcons.funnelOutline
                            : EvaIcons.funnel,
                      ),
                      onPressed: () {
                        _showSemesterSortFilterModal(
                          context: context,
                          currentFilter: currentFilter,
                          currentSortOrder: currentSortOrder,
                        );
                      },
                    )
                  ]
              },
            ),
            body: const CoursesPageBody(),
          );
        },
      ),
    );
  }

  Future<void> _showSemesterSortFilterModal({
    required BuildContext context,
    required SemesterFilter currentFilter,
    required SemesterSortOrder currentSortOrder,
  }) {
    return showCustomModalBottomSheet(
      context: context,
      title: 'Semesterauswahl',
      child: SemesterSortFilterModalSheet(
        onSemesterFilterSelectionChanged: (newFilter) {
          context.read<CoursesBloc>().add(
                SemesterFilterChanged(
                  selectedSemesterFilter: newFilter,
                ),
              );
        },
        onSemesterSortOrderSelectionChanged: (newSortOrder) {
          context.read<CoursesBloc>().add(
                SemesterSortOrderChanged(
                  selectedSemesterSortOrder: newSortOrder,
                ),
              );
        },
        currentSemesterFilter: currentFilter,
        currentSemesterSortOrder: currentSortOrder,
      ),
    );
  }
}
