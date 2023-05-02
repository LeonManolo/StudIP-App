import 'package:flutter/material.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studipadawan/courses/details/view/course_details_page.dart';
import 'package:studipadawan/courses/view/widgets/course_card.dart';

class SemesterCard extends StatelessWidget {
  final Semester semester;

  const SemesterCard({Key? key, required this.semester}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.black12),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  semester.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const Spacer(),
                GestureDetector(
                  child: const Icon(Icons.info_outline_rounded, size: 22),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(semester.title),
                        content: SingleChildScrollView(
                            child: ListBody(
                          children: [
                            Text(
                                "Semesterzeitraum:\n${semester.semesterTimeSpan}"),
                            const SizedBox(height: 12),
                            Text(
                                "Unterrichtszeitraum:\n${semester.lecturesTimeSpan}"),
                          ],
                        )),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Ok"),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
            for (Course course in semester.courses)
              CourseCard(
                course: course,
                onCourseSelection: (selectedCourse) => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CourseDetailsPage(course: selectedCourse);
                  }))
                },
              )
          ],
        ),
      ),
    );
  }
}
