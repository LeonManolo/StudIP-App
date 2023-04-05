
import 'package:studip_api_client/studip_api_client.dart';

class CourseRepository {
  final StudIpApiClient _apiClient;

  const CourseRepository({
    required StudIpApiClient apiClient,
})  : _apiClient = apiClient;

  Future<List<Course>> getCourses(String userId) async {
    try {
      final response = await _apiClient.getCourses(userId);
      return response.courses;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}