import '../models/models.dart';

abstract class StudIPUserClient {
  Future<UserResponse> getCurrentUser();
}
