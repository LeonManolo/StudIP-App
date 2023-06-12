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

  final apiClient = StudIpApiClient();

  final authenticationRepository = AuthenticationRepository(client: apiClient);

  final userRepository = UserRepository(studIpApiClient: apiClient);

  final coursesRepository = CourseRepository(apiClient: apiClient);

  final messagesRepository = MessageRepository(apiClient: apiClient);

  final calenderRepository = CalenderRepository(apiClient: apiClient);

  final filesRepository = FilesRepository(apiClient: apiClient);

  final activityRepository = ActivityRepository(apiClient: apiClient);

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
