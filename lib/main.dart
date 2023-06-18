import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:studipadawan/app/view/app.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authenticationClient = StudIPAuthenticationClientImpl();
  final authenticationRepository =
      AuthenticationRepository(client: authenticationClient);

  final userClient = StudIPUserClientImpl();
  // TODO: studIpApiClient <- Naming anpassen
  final userRepository = UserRepository(studIpApiClient: userClient);

  final coursesClient = StudIPCoursesClientImpl();
  final coursesRepository = CourseRepository(
    coursesApiClient: coursesClient,
    userApiClient: userClient,
  );

  final messageClient = StudIPMessagesClientImpl();
  final messagesRepository = MessageRepository(
    messageClient: messageClient,
    userClient: userClient,
  );

  final calendarClient = StudIPCalendarClientImpl();
  final calenderRepository = CalenderRepository(apiClient: calendarClient);

  final filesClient = StudIPFilesClientImpl();
  final filesRepository = FilesRepository(apiClient: filesClient);

  final activityClient = StudIPActivityClientImpl();
  final activityRepository = ActivityRepository(
    activityClient: activityClient,
    courseClient: coursesClient,
    userClient: userClient,
    filesClient: filesClient,
  );

  await initializeDateFormatting();

  await LocalNotifications.initialize(
    androidChannelId: 'course_notifications',
    androidChannelName: 'Kurs Benachrichtigungen',
    androidChannelDescription: 'Kurs Benachrichtigungen',
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await HomeWidget.setAppGroupId('group.de.hs-flensburg.studipadawan');

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      calenderRepository: calenderRepository,
      activityRepository: activityRepository,
      userRepository: userRepository,
      coursesRepository: coursesRepository,
      messageRepository: messagesRepository,
      filesRepository: filesRepository,
    ),
  );
}
