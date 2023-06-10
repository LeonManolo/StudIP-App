import 'package:auto_size_text/auto_size_text.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/files/view/course_files_page.dart';
import 'package:studipadawan/courses/details/info/view/course_info_page.dart';
import 'package:studipadawan/courses/details/news/view/course_news_page.dart';
import 'package:studipadawan/courses/details/participants/view/course_participants_page.dart';
import 'package:studipadawan/courses/details/view/widgets/course_page_view.dart';
import 'package:studipadawan/courses/details/wiki/view/course_wiki_page.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          course.courseDetails.title,
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
                    courseId: course.id,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: CoursePageView(
          children: [
            CourseFilesPage(course: course),
            CourseParticipantsPage(course: course),
            CourseWikiPage(course: course),
            CourseInfoPage(course: course),
          ],
        ),
      ),
    );
  }
}
