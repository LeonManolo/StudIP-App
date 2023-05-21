import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:studipadawan/calendar/calendar_notifications/bloc/calendar_notifications_event.dart';
import 'package:studipadawan/calendar/calendar_notifications/bloc/calendar_notifications_state.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course_event.dart';

final class CalendarNotificationsBloc
    extends Bloc<CalendarNotificationsEvent, CalendarNotificationsState> {
  CalendarNotificationsBloc({
    required AuthenticationRepository authenticationRepository,
    required CourseRepository courseRepository,
  })  : _authenticationRepository = authenticationRepository,
        _courseRepository = courseRepository,
        super(const CalendarNotificationsInitial()) {
    on<CalendarNotificationsRequested>(_onCalendarNotificationsRequested);
    on<CalendarNotificationsSelected>(_onCalendarNotificationsSelected);
    on<CalendarNotificationsSaveAll>(_onCalendarNotificationsSaveAll);
  }

  static const notificationTopic = 'course_schedule';

  final AuthenticationRepository _authenticationRepository;
  final CourseRepository _courseRepository;

  FutureOr<void> _onCalendarNotificationsRequested(
    CalendarNotificationsRequested event,
    Emitter<CalendarNotificationsState> emit,
  ) async {
    emit(const CalendarNotificationsLoading());

    final courses = await _fetchSemesterCourses();
    final notifications = await _loadNotifications();
    _combineCoursesAndNotifications(courses, notifications);

    emit(CalendarNotificationsPopulated(courses: courses));
  }

  FutureOr<void> _onCalendarNotificationsSelected(
    CalendarNotificationsSelected event,
    Emitter<CalendarNotificationsState> emit,
  ) {
    if (state case CalendarNotificationsPopulated(courses: final courses)) {
      emit(const CalendarNotificationsLoading()); // geht irgendwie nicht ohne

      final index =
          courses.indexWhere((course) => course.course.id == event.courseId);

      courses[index].events[event.courseEventKey]?.notificationEnabled =
          event.notificationEnabled;

      emit(CalendarNotificationsPopulated(courses: [...courses]));
    }
  }

  FutureOr<void> _onCalendarNotificationsSaveAll(
    CalendarNotificationsSaveAll event,
    Emitter<CalendarNotificationsState> emit,
  ) async {
    if (state case CalendarNotificationsPopulated(courses: final courses)) {
      await _scheduleNotifications(courses);
    }
  }

  void _combineCoursesAndNotifications(
    List<CalendarNotificationsCourse> courses,
    List<LocalNotification> notifications,
  ) {
    courses.forEachIndexed((i, course) {
      course.events.forEach((combinedKey, courseEvent) {
        final notificationEnabled =
            notifications.any((e) => switch (e.payload) {
                  {
                    'courseId': final String courseId,
                    'time': final String time,
                  } =>
                    courseId == course.course.id &&
                        time == courseEvent.eventDate.toIso8601String(),
                  _ => false,
                });
        courses[i].events[combinedKey]?.notificationEnabled =
            notificationEnabled;
      });
    });
  }

  Future<void> _scheduleNotifications(
    List<CalendarNotificationsCourse> courses,
  ) async {
    await LocalNotifications.cancelNotifications(topic: notificationTopic);

    for (final course in courses) {
      course.events.forEach((key, event) async {
        if (event.notificationEnabled) {
          await LocalNotifications.scheduleNotification(
              title: '${course.course.courseDetails.title} startet um ...',
              subtitle: '${course.course.courseDetails.subtitle}',
              showAt: DateTime.now().add(const Duration(seconds: 5)),
              payload: {
                'courseId': course.course.id,
                'time': event.eventDate.toIso8601String(),
              },
          );
        }
      });
    }
  }

  Future<List<LocalNotification>> _loadNotifications() async {
    final notifications =
        await LocalNotifications.getNotifications(topic: notificationTopic);
    return notifications;
  }

  Future<({int totalNotifications, int availableNotifications})>
      _notificationsStatus() {
    return LocalNotifications.totalNotificationsStatus(
      excludingTopic: notificationTopic,
    );
  }

  Future<List<CalendarNotificationsCourse>> _fetchSemesterCourses() async {
    final semesters = await _courseRepository.getCoursesGroupedBySemester(
      _authenticationRepository.currentUser.id,
    );
    final semester = semesters.first;

    final List<CalendarNotificationsCourse> courses = [];
    for (final course in semester.courses) {
      final courseEventsUnfiltered =
          await _courseRepository.getCourseEvents(courseId: course.id);

      final events = <String, CalendarNotificationsCourseEvent>{};
      for (final event in courseEventsUnfiltered) {
        final cEvent = CalendarNotificationsCourseEvent(
            courseId: course.id,
            eventDate: event.startDate,
            notificationEnabled: false);
        events[cEvent.combinedKey] = cEvent;
      }
      courses.add(CalendarNotificationsCourse(course: course, events: events));
    }
    return courses;
  }
}
