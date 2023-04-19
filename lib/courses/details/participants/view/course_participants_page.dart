import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/participants/bloc/course_participants_bloc.dart';

class CourseParticipantsPage extends StatelessWidget {
  const CourseParticipantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseParticipantsBloc(),
      child: const Text("Teilnehmer"),
    );
  }
}
