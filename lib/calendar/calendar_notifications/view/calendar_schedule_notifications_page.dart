import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studipadawan/utils/empty_view.dart';

import '../bloc/calendar_notifications_bloc.dart';
import '../bloc/calendar_notifications_event.dart';
import '../bloc/calendar_notifications_state.dart';

class CalendarScheduleNotificationsPage extends StatelessWidget {
  const CalendarScheduleNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
      ),
      body: BlocProvider(
        create: (context) => CalendarNotificationsBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
          courseRepository: context.read<CourseRepository>(),
        )..add(const CalendarNotificationsRequested()),
        child:
            BlocBuilder<CalendarNotificationsBloc, CalendarNotificationsState>(
          builder: (context, state) {
            switch (state) {
              case CalendarNotificationsInitial() ||
                    CalendarNotificationsLoading():
                return SpinKitThreeBounce(
                  color: Theme.of(context).primaryColor,
                );
              case CalendarNotificationsPopulated(courses: final courses)
                  when courses.isEmpty:
                return const EmptyView(
                    title: 'Kein Semester',
                    message: 'Es wurde kein Semester gefunden.');
              case CalendarNotificationsPopulated(courses: final courses):
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final events = courses[index].events;
                            final course = courses[index].course;

                            return ExpansionTile(
                              title: Text(course.courseDetails.title),
                              children: events
                                  .values.map((event) => ListTile(
                                        title: Text(
                                            '${event.eventDate} '),
                                        //subtitle: Text(event.title),
                                selected: event.notificationEnabled,
                                onTap: () {
                                          context.read<CalendarNotificationsBloc>().add(
                                              CalendarNotificationsSelected(courseEventKey: event.combinedKey,
                                                  courseId: course.id,
                                                  notificationEnabled: !event.notificationEnabled,
                                              )
                                          );
                                },
                                      )).toList(),
                            );
                          }),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<CalendarNotificationsBloc>().add(
                          const CalendarNotificationsSaveAll(),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(
                            left: AppSpacing.sm,
                            right: AppSpacing.sm,
                            top: AppSpacing.xlg,
                            bottom: AppSpacing.lg),
                        child: SafeArea(
                          child: Text(
                            '2/64 Benachrichtigungen',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              case CalendarNotificationsFailure():
                return const Text('Fehler');
            }
          },
        ),
      ),
    );
  }
}
