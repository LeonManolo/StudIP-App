import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/courses/bloc/CourseBloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:user_repository/user_repository.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: CoursesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Veranstaltungen"),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          ),
          IconButton(
              onPressed: () {
                context
                    .read<UserRepository>()
                    .getCurrentUser()
                    .then((value) => print("${value.email} ${value.username}"));
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        bloc: CourseBloc(courseRepository: context.read<CourseRepository>())
          ..add(CoursesRequested(
              userId: context.read<AuthenticationRepository>().currentUser.id)),
        builder: (context, state) {
          if (state.status != CourseStatus.populated) {
            return const Text("LOADING..");
          } else {
            return ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) => ListTile(
                      title: Text(state.courses[index].title),
                      subtitle: Text(state.courses[index].subtitle ?? ""),
                    ));
          }
        },
      ),
    );
  }
}
