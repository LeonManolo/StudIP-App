import 'package:flutter/material.dart';
import 'package:courses_repository/src/models/models.dart';

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
            for (Course course in semester.courses) _courseCard(course)
          ],
        ),
      ),
    );
  }

  Widget _courseCard(Course course) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.orangeAccent),
          margin: const EdgeInsets.only(top: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        course.title,
                      )
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18.0,
                )
              ],
            ),
          )),
    );
  }
}
