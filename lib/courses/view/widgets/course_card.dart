import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Course _course;
  final Function? _onCourseSelection;

  const CourseCard({Key? key, required course, onCourseSelection})
      : _course = course,
        _onCourseSelection = onCourseSelection,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onCourseSelection?.call(),
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
                        _course.courseDetails.title,
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
