import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';

class SemesterCell extends StatelessWidget {
  const SemesterCell({super.key, required this.semester});
  final Semester semester;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          semester.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        GestureDetector(
          child: Icon(
            Icons.info_outline_rounded,
            size: 22,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(semester.title),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Semesterzeitraum:\n${semester.semesterTimeSpan}',
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Unterrichtszeitraum:\n${semester.lecturesTimeSpan}',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
