import 'package:messages_repository/messages_repository.dart';

import '../models/models.dart';

abstract class StudIPUserClient {
  Future<UserResponse> getCurrentUser();
  Future<UserListResponse> getUsers();
}
