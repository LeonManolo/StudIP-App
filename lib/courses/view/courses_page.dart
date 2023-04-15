import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/courses/bloc/course_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/courses/view/widgets/semester_card.dart';
import 'package:user_repository/user_repository.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: CoursesPage());

  @override
  Widget build(BuildContext context) {
    final courseBloc = CourseBloc(
        courseRepository: context.read<CourseRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>())
      ..add(CoursesRequested());

    return Scaffold(
      appBar: _appBar(context),
      body: BlocBuilder<CourseBloc, CourseState>(
        bloc: courseBloc,
        builder: (context, state) {
          if (state.status != CourseStatus.populated) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                courseBloc.add(CoursesRequested());
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
        },
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text("Kurse"),
      actions: <Widget>[
        IconButton(
          key: const Key('homePage_logout_iconButton'),
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
        )
      ],
    );
  }
}
