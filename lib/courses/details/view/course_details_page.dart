import 'package:app_ui/app_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';
import 'package:studipadawan/courses/details/files/view/course_files_page.dart';
import 'package:studipadawan/courses/details/info/view/course_info_page.dart';
import 'package:studipadawan/courses/details/news/view/course_news_page.dart';
import 'package:studipadawan/courses/details/participants/view/course_participants_page.dart';
import 'package:studipadawan/courses/details/view/widgets/course_detail_tab.dart';
import 'package:studipadawan/courses/details/view/widgets/course_details_main_content.dart';
import 'package:studipadawan/courses/details/view/widgets/course_page_view.dart';
import 'package:studipadawan/courses/details/wiki/view/course_wiki_page.dart'
    as wiki_widget;

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({super.key, required this.course});

  final Course course;

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.course.courseDetails.title,
          maxLines: 2,
        ),
        actions: [
          IconButton(
            icon: const Icon(EvaIcons.bellOutline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<CourseNewsPage>(
                  builder: (context) => CourseNewsPage(
                    courseId: widget.course.id,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => CourseDetailsBloc(course: widget.course),
          child: const CoursePageView(
            children: [
              CourseFilesPage(),
              CourseParticipantsPage(),
              wiki_widget.CourseWikiPage(),
              CourseInfoPage(),
            ],
          ),
        ),
      ),
    );
  }
}
