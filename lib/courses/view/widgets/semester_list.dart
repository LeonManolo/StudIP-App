import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/bloc/course_bloc.dart';
import 'package:studipadawan/courses/view/widgets/semester_card.dart';

import '../../bloc/courses_event.dart';

class SemesterList extends StatelessWidget {
  const SemesterList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<CourseBloc>(context).state;

    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<CourseBloc>(context).add(CoursesRequested());
      },
      child: ListView.builder(
          itemCount: state.semesters.length,
          itemBuilder: (context, index) {
            return SemesterCard(
              semester: state.semesters.elementAt(index),
            );
          }),
    );
  }
}
