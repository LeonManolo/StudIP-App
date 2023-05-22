import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';
import 'package:studipadawan/courses/details/files/view/course_files_page.dart';
import 'package:studipadawan/courses/details/info/view/course_info_page.dart';
import 'package:studipadawan/courses/details/participants/view/course_participants_page.dart';
import 'package:studipadawan/courses/details/wiki/view/course_wiki_page.dart';

class CourseDetailsMainContent extends StatelessWidget {
  const CourseDetailsMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
      builder: (context, state) {
        switch (state.selectedTab) {
          case CourseDetailsTab.info:
            return const CourseInfoPage();
          case CourseDetailsTab.files:
            return const CourseFilesPage();
          case CourseDetailsTab.participants:
            return const CourseParticipantsPage();
          case CourseDetailsTab.wiki:
            return const CourseWikiPage();
        }
      },
    );
  }
}
