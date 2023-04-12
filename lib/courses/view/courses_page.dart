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
    return Scaffold(
      appBar: _appBar(context),
      body: BlocProvider(
        create: (context) => CourseBloc(
          courseRepository: context.read<CourseRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        )..add(CoursesRequested()),
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state.status == CourseStatus.loading) {
              return _loadingWidget();
            } else if (state.status == CourseStatus.initial) {
              return _initialWidget(context);
            } else if (state.status == CourseStatus.failure) {
              return _failureWidget(context);
            } else {
              return _populatedWidget(context, state);
            }
          },
        ),
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
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _initialWidget(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () =>
            BlocProvider.of<CourseBloc>(context).add(CoursesRequested()),
        child: const Text("Load courses"),
      ),
    );
  }

  Widget _failureWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Error on load"),
          ElevatedButton(
            onPressed: () =>
                BlocProvider.of<CourseBloc>(context).add(CoursesRequested()),
            child: const Text("Load courses"),
          )
        ],
      ),
    );
  }

  Widget _populatedWidget(BuildContext context, CourseState state) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<CourseBloc>(context).add(CoursesRequested());
        // courseBloc.add(CoursesRequested());
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
