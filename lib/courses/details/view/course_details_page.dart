import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';
import 'package:studipadawan/courses/details/view/widgets/course_detail_tab.dart';
import 'package:studipadawan/courses/details/view/widgets/course_details_main_content.dart';

class CourseDetailsPage extends StatelessWidget {

  const CourseDetailsPage({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: BlocProvider(
        create: (context) => CourseDetailsBloc(course: course),
        child: BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0,),
                    child: Text(
                      context
                          .read<CourseDetailsBloc>()
                          .course
                          .courseDetails
                          .title,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: AppSpacing.lg,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: context.read<CourseDetailsBloc>().allTabs.length,
                    itemBuilder: (context, index) {
                      final bloc = context.read<CourseDetailsBloc>();
                      final tab = bloc.allTabs.elementAt(index);

                      return CourseDetailTabView(
                        tab: tab,
                        isSelected: bloc.state.selectedTab == tab,
                        onSelection: () => {
                          bloc.add(
                            CourseDetailsSelectTabEvent(selectedTab: tab),
                          )
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: CourseDetailsMainContent(),
                ),)
              ],
            );
          },
        ),
      ),
    );
  }
}
