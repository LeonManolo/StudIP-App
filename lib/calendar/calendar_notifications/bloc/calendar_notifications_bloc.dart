import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course_event.dart';

part 'calendar_notifications_state.dart';

part 'calendar_notifications_event.dart';

/// A Bloc handling calendar notifications related events and states.
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

  /// Used as a topic for local notifications
  static const notificationTopic = 'course_schedule';

  final AuthenticationRepository _authenticationRepository;
  final CourseRepository _courseRepository;

  /// Handles `CalendarNotificationsRequested` events.
  /// Fetches semester courses and their notifications,
  /// combines them and gets the total count of notifications.
  FutureOr<void> _onCalendarNotificationsRequested(
    CalendarNotificationsRequested event,
    Emitter<CalendarNotificationsState> emit,
  ) async {
    emit(const CalendarNotificationsLoading());

    final courses = await _fetchSemesterCourses();
    final notifications = await _loadNotifications();
    _combineCoursesAndNotifications(courses, notifications);
    final totalNotifications = await _totalNotifications();

    emit(CalendarNotificationsPopulated(
        courses: courses, totalNotifications: totalNotifications,),);
  }

  /// Handles `CalendarNotificationsSelected` events.
  /// Updates notification selection for a course event
  FutureOr<void> _onCalendarNotificationsSelected(
    CalendarNotificationsSelected event,
    Emitter<CalendarNotificationsState> emit,
  ) {
    if (state
        case CalendarNotificationsPopulated(
          courses: final courses,
          totalNotifications: final totalNotifications
        )) {
      emit(const CalendarNotificationsLoading()); // geht irgendwie nicht ohne

      final index =
          courses.indexWhere((course) => course.course.id == event.courseId);

      courses[index].events[event.courseEventKey]?.notificationEnabled =
          event.notificationEnabled;

      emit(CalendarNotificationsPopulated(
        courses: [...courses],
        totalNotifications: totalNotifications,
      ),);
    }
  }

  /// Handles `CalendarNotificationsSaveAll` events.
  /// Schedules notifications for all course events
  FutureOr<void> _onCalendarNotificationsSaveAll(
    CalendarNotificationsSaveAll event,
    Emitter<CalendarNotificationsState> emit,
  ) async {
    if (state
        case CalendarNotificationsPopulated(
          courses: final courses,
          totalNotifications: final totalNotifications,
        )) {
      await _scheduleNotifications(courses);

      emit(
        CalendarNotificationsPopulated(
          courses: courses,
          totalNotifications: totalNotifications,
          notificationsSaved: true,
        ),
      );
    }
  }

  /// Combines course events with their notifications.
  ///
  /// [courses] is a list of `CalendarNotificationsCourse` instances. Each represents a course and its related events.
  ///
  /// [notifications] is a list of `LocalNotification` instances. Each represents a notification for a course event.
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
                },);
        courses[i].events[combinedKey]?.notificationEnabled =
            notificationEnabled;
      });
    });
  }


  /// Schedules notifications for all course events.
  ///
  /// [courses] is a list of `CalendarNotificationsCourse` instances for which notifications should be scheduled.
  Future<void> _scheduleNotifications(
    List<CalendarNotificationsCourse> courses,
  ) async {
    await LocalNotifications.cancelNotifications(topic: notificationTopic);
    for (final course in courses) {
      course.events.forEach((key, event) async {
        if (event.notificationEnabled) {
          await LocalNotifications.scheduleNotification(
            title: '${course.course.courseDetails.title} startet gleich',
            topic: notificationTopic,
            subtitle: course.course.courseDetails.subtitle ?? '',
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

  /// Returns a list of all notifications for the `notificationTopic`.
  Future<List<LocalNotification>> _loadNotifications() async {
    final notifications =
        await LocalNotifications.getNotifications(topic: notificationTopic);
    return notifications;
  }

  /// Returns the total number of available notifications, excluding those with the `notificationTopic`.
  Future<int> _totalNotifications() async {
    return (await LocalNotifications.totalNotificationsStatus(
      excludingTopic: notificationTopic,
    ))
        .availableNotifications;
  }

  /// Fetches semester courses and transforms them to `CalendarNotificationsCourse` instances.
  Future<List<CalendarNotificationsCourse>> _fetchSemesterCourses() async {
    final semesters = await _courseRepository.getCoursesGroupedBySemester(
      _authenticationRepository.currentUser.id,
    );
    final semester = semesters.first;

    final List<CalendarNotificationsCourse> courses = [];
    for (final course in semester.courses) {
      final courseEventsUnfiltered =
          await _courseRepository.getCourseEvents(courseId: course.id);
      final courseEvents = courseEventsUnfiltered.where(
        (courseEvent) => courseEvent.startDate.isAfter(DateTime.now()),
      );

      final events = <String, CalendarNotificationsCourseEvent>{};
      for (final event in courseEvents) {
        final cEvent = CalendarNotificationsCourseEvent(
          courseId: course.id,
          eventDate: event.startDate,
        );
        events[cEvent.combinedKey] = cEvent;
      }

      courses.add(CalendarNotificationsCourse(course: course, events: events));
    }
    return courses;
  }
}
