import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onCourseSelection,
  });
  final Course course;
  final void Function(Course) onCourseSelection;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCourseSelection(course),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.orangeAccent,
        ),
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
                      course.courseDetails.title,
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
