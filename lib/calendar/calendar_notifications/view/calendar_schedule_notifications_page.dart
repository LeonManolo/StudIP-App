import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:studipadawan/calendar/calendar_notifications/bloc/calendar_notifications_bloc.dart';
import 'package:studipadawan/calendar/calendar_notifications/widgets/calendar_notification_save_button.dart';
import 'package:studipadawan/calendar/calendar_notifications/widgets/calendar_notification_time_selection.dart';
import 'package:studipadawan/calendar/calendar_notifications/widgets/headline.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/widgets/non_empty_listview_builder.dart';

class CalendarScheduleNotificationsPage extends StatelessWidget {
  const CalendarScheduleNotificationsPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: CalendarScheduleNotificationsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarNotificationsBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
        courseRepository: context.read<CourseRepository>(),
      )..add(const CalendarNotificationsRequested()),
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Benachrichtigungen'),
          trailingActions: const [_DeleteButton()],
        ),
        body: SafeArea(
          child: BlocBuilder<CalendarNotificationsBloc,
              CalendarNotificationsState>(
            builder: (context, state) {
              switch (state) {
                case CalendarNotificationsFailure():
                  return const EmptyView(
                    title: 'Fehler',
                    message: 'Fehler beim laden der Benachrichtigungen',
                  );

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
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        child: NonEmptyListViewBuilder(
                          header: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Headline('Erinnerungen'),
                              CalendarNotificationTimeSelection(
                                onChanged: (selectedNotificationTime) {
                                  context.read<CalendarNotificationsBloc>().add(
                                        CalendarNotificationSelectedTime(
                                          notificationTime:
                                              selectedNotificationTime,
                                        ),
                                      );
                                },
                                activeNotificationTime: state.notificationTime,
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
                                      title: Text(_formatDate(event.eventDate)),
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
                                                notificationEnabled:
                                                    !event.notificationEnabled,
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
                      Column(
                        children: [
                          const Spacer(),
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
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    return SizedBox(
      width: 50,
      child: AdaptiveAppBarIconButton(
        onPressed: () {
          ctx.read<CalendarNotificationsBloc>().add(
                const CalendarNotificationsDeletePendingNotifications(),
              );
        },
        materialIcon: EvaIcons.trashOutline,
        cupertinoIcon: CupertinoIcons.trash,
      ),
    );
  }
}
