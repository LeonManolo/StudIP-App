import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:collection/collection.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course_event.dart';

part 'calendar_notifications_state.dart';
part '../model/notification_time.dart';
part 'calendar_notifications_event.dart';


/// A Bloc handling calendar notifications related events and states.
final class CalendarNotificationsBloc extends HydratedBloc<
    CalendarNotificationsEvent, CalendarNotificationsState> {
  CalendarNotificationsBloc({
    required AuthenticationRepository authenticationRepository,
    required CourseRepository courseRepository,
  })  : _authenticationRepository = authenticationRepository,
        _courseRepository = courseRepository,
        super(
          const CalendarNotificationsInitial(
            notificationTime: NotificationTime.fifteenMinutesEarly,
          ),
        ) {
    on<CalendarNotificationsRequested>(_onCalendarNotificationsRequested);
    on<CalendarNotificationsSelected>(_onCalendarNotificationsSelected);
    on<CalendarNotificationsSaveAll>(_onCalendarNotificationsSaveAll);
    on<CalendarNotificationSelectedTime>(_onCalendarNotificationSelectedTime);
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
    emit(
      CalendarNotificationsLoading(notificationTime: state.notificationTime),
    );

    final courses = await _fetchSemesterCourses();
    final notifications = await _loadNotifications();
    _combineCoursesAndNotifications(
      courses,
      notifications,
      state.notificationTime,
    );
    final totalNotifications = await _totalNotifications();

    emit(
      CalendarNotificationsPopulated(
        courses: courses,
        totalNotifications: totalNotifications,
        notificationTime: state.notificationTime,
      ),
    );
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
      emit(
        CalendarNotificationsLoading(
          notificationTime: state.notificationTime,
        ),
      ); // geht irgendwie nicht ohne

      final index =
          courses.indexWhere((course) => course.course.id == event.courseId);

      courses[index].events[event.courseEventKey]?.notificationEnabled =
          event.notificationEnabled;

      emit(
        CalendarNotificationsPopulated(
          courses: [...courses],
          totalNotifications: totalNotifications,
          notificationTime: state.notificationTime,
        ),
      );
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
      await _scheduleNotifications(courses, state.notificationTime);

      emit(
        CalendarNotificationsPopulated(
          courses: courses,
          totalNotifications: totalNotifications,
          notificationsSaved: true,
          notificationTime: state.notificationTime,
        ),
      );
    }
  }

  /// Handles `CalendarNotificationSelectedTime` events.
  /// This function updates the `CalendarNotificationsState` with the selected notification time.
  FutureOr<void> _onCalendarNotificationSelectedTime(
    CalendarNotificationSelectedTime event,
    Emitter<CalendarNotificationsState> emit,
  ) async {
    if (state
        case CalendarNotificationsPopulated(
          courses: final courses,
          totalNotifications: final totalNotifications,
        )) {
      emit(
        CalendarNotificationsPopulated(
          courses: courses,
          totalNotifications: totalNotifications,
          notificationTime: event.notificationTime,
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
    NotificationTime notificationTime,
  ) {
    courses.forEachIndexed((i, course) {
      course.events.forEach((combinedKey, courseEvent) {
        final notificationEnabled = notifications.any(
          (e) => switch (e.payload) {
            {
              'courseId': final String courseId,
              'time': final String time,
            } =>
              courseId == course.course.id &&
                  time ==
                      courseEvent.eventDate
                          .subtract(
                            Duration(minutes: notificationTime.toInt()),
                          )
                          .toIso8601String(),
            _ => false,
          },
        );
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
    NotificationTime notificationTime,
  ) async {
    await LocalNotifications.requestPermissions(android: true, iOS: true);
    await LocalNotifications.cancelNotifications(topic: notificationTopic);

    for (final course in courses) {
      course.events.forEach((key, event) async {
        if (event.notificationEnabled) {
          final notificationDate = event.eventDate.subtract(Duration(
            minutes: notificationTime.toInt(),
          ),);
          await LocalNotifications.scheduleNotification(
            title: '${course.course.courseDetails.title} startet gleich',
            topic: notificationTopic,
            subtitle: course.course.courseDetails.subtitle ?? '',
            showAt: notificationDate,
            payload: {
              'courseId': course.course.id,
              'time': notificationDate.toIso8601String(),
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
        .totalNotifications;
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

  @override
  CalendarNotificationsState? fromJson(Map<String, dynamic> json) {
    final notificationTime = json['notificationTime'];
    if (notificationTime is String) {
      return CalendarNotificationsInitial(
        notificationTime: NotificationTime.fromString(notificationTime),
      );
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(CalendarNotificationsState state) {
    return {
      'notificationTime': state.notificationTime.toString(),
    };
  }
}
