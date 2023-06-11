import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:studipadawan/courses/bloc/courses_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/courses/view/widgets/courses_page_body.dart';
import 'package:studipadawan/courses/view/widgets/semester_sort_filter_modal_sheet.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: CoursesPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      CoursesBloc(
        courseRepository: context.read<CourseRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      )
        ..add(CoursesRequested()),
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          return PlatformScaffold(
            iosContentBottomPadding: true,
            appBar: PlatformAppBar(
              title: const Text('Kurse'),
              trailingActions: switch (state) {
                CoursesStateLoading _ => [],
                CoursesStateError _ => [],
                CoursesStateDidLoad(
                semesterFilter: final currentFilter,
                semesterSortOrder: final currentSortOrder
                ) =>
                [
                  AdaptiveAppBarIconButton(
                    materialIcon: EvaIcons.funnelOutline,
                    cupertinoIcon: CupertinoIcons.arrow_up_arrow_down_circle,
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
    return showPlatformModalSheet<void>(
      context: context,
      builder: (modalContext) {
        return SemesterSortFilterModalSheet(
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
        );
      },
    );
  }
}
