import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/wiki/view/widgets/course_wiki_details_page.dart';

class CourseWikiListRow extends StatelessWidget {
  const CourseWikiListRow({super.key, required this.wikiPage});

  final CourseWikiPage wikiPage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        wikiPage.title,
      ),
      subtitle: Text(
        'Von ${wikiPage.lastEditorAuthor.formattedName} ${wikiPage.formattedLastEditedDate} bearbeitet',
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<CourseWikiDetailsPage>(
          builder: (context) {
            return CourseWikiDetailsPage(wikiPage: wikiPage);
          },
        ),
      ),
    );
  }
}
