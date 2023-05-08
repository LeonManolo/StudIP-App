import 'package:studip_api_client/studip_api_client.dart';

class UserRepository {
  UserRepository({
    required StudIPUserClient studIpApiClient,
  }) : _apiClient = studIpApiClient;
  final StudIPUserClient _apiClient;

  Future<UserResponse> getCurrentUser() async {
    return _apiClient.getCurrentUser();
  }

  Future<UserListResponse> getUsers(String? searchParams) async {
    return _apiClient.getUsers(searchParams);
  }
}
