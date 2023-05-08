import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
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

  runApp(App(
    authenticationRepository: authenticationRepository,
    calenderRepository: calenderRepository,
    userRepository: userRepository,
    coursesRepository: coursesRepository,
    messageRepository: messagesRepository,
    filesRepository: filesRepository,
  ),);
}
