import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:studipadawan/calendar/calendar_notifications/bloc/calendar_notifications_bloc.dart';
import 'package:studipadawan/calendar/calendar_notifications/widgets/calendar_notification_save_button.dart';
import 'package:studipadawan/calendar/calendar_notifications/widgets/calendar_notification_time_selection.dart';
import 'package:studipadawan/calendar/calendar_notifications/widgets/headline.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/extensions/date_time_extension.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/snackbar.dart';
import 'package:studipadawan/utils/widgets/non_empty_listview_builder.dart';

class CalendarScheduleNotificationsPage extends StatelessWidget {
  const CalendarScheduleNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarNotificationsBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
        courseRepository: context.read<CourseRepository>(),
      )..add(const CalendarNotificationsRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Benachrichtigungen'),
          actions: [
            BlocBuilder<CalendarNotificationsBloc, CalendarNotificationsState>(
              builder: (context, state) => IconButton(
                onPressed: () {
                  context.read<CalendarNotificationsBloc>().add(
                        const CalendarNotificationsDeletePendingNotifications(),
                      );
                },
                icon: const Icon(EvaIcons.trashOutline),
              ),
            ),
          ],
        ),
        body:
            BlocConsumer<CalendarNotificationsBloc, CalendarNotificationsState>(
          listener: (context, state) {
            if (state
                case CalendarNotificationsPopulated(notificationsSaved: true)) {
              buildSnackBar(context, 'Benachrichtigungen gespeichert', null);
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return BlocBuilder<CalendarNotificationsBloc,
                CalendarNotificationsState>(
              builder: (context, state) {
                switch (state) {
                  case CalendarNotificationsFailure():
                    return const Center(child: Text('Fehler'));

                  case CalendarNotificationsInitial() ||
                        CalendarNotificationsLoading():
                    return const LoadingIndicator();

                  case CalendarNotificationsPopulated(courses: final courses)
                      when courses.isEmpty:
                    return const EmptyView(
                      title: 'Kein Semester',
                      message: 'Es wurde kein Semester gefunden.',
                    );

                  case CalendarNotificationsPopulated(
                      courses: final courses,
                      totalNotifications: final totalNotifications
                    ):
                    return Column(
                      children: [
                        Expanded(
                          child: NonEmptyListViewBuilder(
                            header: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Headline('Erinnerungen'),
                                CalendarNotificationTimeSelection(
                                  onChanged: (selectedNotificationTime) {
                                    context
                                        .read<CalendarNotificationsBloc>()
                                        .add(
                                          CalendarNotificationSelectedTime(
                                            notificationTime:
                                                selectedNotificationTime,
                                          ),
                                        );
                                  },
                                  activeNotificationTime:
                                      state.notificationTime,
                                ),
                                const Headline('Kurse'),
                              ],
                            ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final events = courses[index].events;
                              final course = courses[index].course;

                              return ExpansionTile(
                                title: Text(course.courseDetails.title),
                                children: events.values
                                    .map(
                                      (event) => ListTile(
                                        trailing: Icon(
                                          event.notificationEnabled
                                              ? EvaIcons.bell
                                              : EvaIcons.bellOutline,
                                        ),
                                        title: Text(
                                          event.eventDate
                                              .getFormattedGermanTimeSpanBetweenDates(
                                            event.eventEndDate,
                                          ),
                                        ),
                                        subtitle: const Text('Vorlesung'),
                                        selected: event.notificationEnabled,
                                        onTap: () {
                                          context
                                              .read<CalendarNotificationsBloc>()
                                              .add(
                                                CalendarNotificationsSelected(
                                                  courseEventKey:
                                                      event.combinedKey,
                                                  courseId: course.id,
                                                  notificationEnabled: !event
                                                      .notificationEnabled,
                                                ),
                                              );
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),
                        CalendarNotificationSaveButton(
                          totalNotifications: totalNotifications,
                          courses: courses,
                          onTap: () {
                            context.read<CalendarNotificationsBloc>().add(
                                  const CalendarNotificationsSaveAll(),
                                );
                          },
                        ),
                      ],
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }
}
