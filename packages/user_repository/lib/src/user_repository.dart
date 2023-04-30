import 'package:studip_api_client/studip_api_client.dart';

class UserRepository {
  final StudIPUserClient _apiClient;

  UserRepository({
    required StudIPUserClient studIpApiClient,
  }) : _apiClient = studIpApiClient;

  Future<UserResponse> getCurrentUser() async {
    return await _apiClient.getCurrentUser();
  }

  Future<UserListResponse> getUsers(String? searchParams) async {
    return await _apiClient.getUsers(searchParams);
  }
}
