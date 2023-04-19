import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';
import 'package:studipadawan/courses/details/files/view/course_files_page.dart';
import 'package:studipadawan/courses/details/forum/view/course_forum_page.dart';
import 'package:studipadawan/courses/details/info/view/course_info_page.dart';
import 'package:studipadawan/courses/details/participants/view/course_participants_page.dart';

class CourseDetailsMainContent extends StatelessWidget {
  const CourseDetailsMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.read<CourseDetailsBloc>().state.selectedTab) {
      case CourseDetailsTab.info:
        return CourseInfoPage();
      case CourseDetailsTab.files:
        return CourseFilesPage();
      case CourseDetailsTab.participants:
        return CourseParticipantsPage();
      case CourseDetailsTab.forum:
        return CourseForumPage();
    }
  }
}
