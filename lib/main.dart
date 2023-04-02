import 'package:authentication_repository/authentication_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:studipadawan/app/view/app.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Firebase.initializeApp();

  final tokenStorage = SharedPrefsTokenStorage();
  final refreshTokenStorage = SecureTokenStorage();

  final apiClient = StudIpApiClient(tokenProvider: tokenStorage.readToken);


  final authenticationRepository = AuthenticationRepository(
      accessTokenStorage: tokenStorage,
      refreshTokenStorage: refreshTokenStorage);

  final userRepository = UserRepository(studIpApiClient: apiClient);

  final coursesRepository = CourseRepository(apiClient: apiClient);

  //await authenticationRepository.user.first;

  runApp(App(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
      coursesRepository: coursesRepository,
  ));
}
