import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/participants/bloc/course_participants_bloc.dart';

class CourseParticipantsPage extends StatelessWidget {
  const CourseParticipantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseParticipantsBloc(),
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: const Text('Max Mustermann'),
              subtitle: const Text('max@mustermann.de'),
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                child: Padding(

                  padding: const EdgeInsets.all(AppSpacing.xxs),
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                  onPressed: () {}, icon: const Icon(EvaIcons.emailOutline)),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              indent: AppSpacing.xxxlg,
            );
          },
          itemCount: 5),
    );
  }
}
