import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/models/course_list_item.dart';
import 'package:studipadawan/courses/view/widgets/semester_cell.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({
    super.key,
    required this.listItems,
    required this.onCourseSelection,
  });

  final List<CourseListItem> listItems;
  final void Function(Course) onCourseSelection;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<CoursesBloc>(context).add(CoursesRequested());
      },
      child: ListView.separated(
        itemCount: listItems.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          final item = listItems.elementAt(index);

          switch (item) {
            case CourseListSemesterItem(semester: final semester):
              return Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: AppSpacing.lg,
                    ),
                    SemesterCell(semester: semester),
                  ],
                ),
              );

            case CourseListCourseItem(course: final course):
              return ListTile(
                title: Text(course.courseDetails.title),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
                onTap: () => onCourseSelection(course),
              );
          }
        },
      ),
    );
  }
}
