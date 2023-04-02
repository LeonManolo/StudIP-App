
import 'package:studip_api_client/studip_api_client.dart';

class UserRepository {
  final StudIpApiClient _apiClient;

  UserRepository({
    required StudIpApiClient studIpApiClient,
}) : _apiClient = studIpApiClient;

  Future<CurrentUserResponse> getCurrentUser() async {
    return await _apiClient.getCurrentUser();
  }
}