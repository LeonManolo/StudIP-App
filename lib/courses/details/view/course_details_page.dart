import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';
import 'package:studipadawan/courses/details/view/widgets/course_detail_tab.dart';
import 'package:studipadawan/courses/details/view/widgets/course_details_main_content.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: BlocProvider(
        create: (context) => CourseDetailsBloc(),
        child: BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
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
                Expanded(child: CourseDetailsMainContent())
              ],
            );
          },
        ),
      ),
    );
  }
}
