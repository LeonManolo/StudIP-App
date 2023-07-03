import 'package:studip_api_client/studip_api_client.dart';

/// Repository for user data.
class UserRepository {
  /// Instantiates a UserRepository with a StudIPUserClient.
  ///
  /// Requires a [userApiClient] of type [StudIPUserClient].
  /// The [userApiClient] is used to access the API.
  UserRepository({
    required StudIPUserClient userApiClient,
  }) : _userApiClient = userApiClient;

  final StudIPUserClient _userApiClient;

  /// Retrieves the current user.
  ///
  /// Returns a [UserResponse] containing the current user
  /// (the authenticated user).
  Future<UserResponse> getCurrentUser() async {
    return _userApiClient.getCurrentUser();
  }

  /// Retrieves a list of users.
  ///
  /// Takes an optional [searchParams] parameter for filtering the
  /// search (the search term to find users).
  ///
  /// Returns [UserListResponse] containing the list of users.
  Future<UserListResponse> getUsers(String? searchParams) async {
    return _userApiClient.getUsers(searchParams);
  }
}
