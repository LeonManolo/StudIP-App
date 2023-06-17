import 'package:http_forked/http.dart' as http;

abstract interface class StudIpHttpCore {
  Future<http.Response> get({
    required String endpoint,
    Map<String, String>? queryParameters,
  });

  Future<http.Response> delete({
    required String endpoint,
    Map<String, String>? queryParameters,
  });

  Future<http.Response> patch({
    required String endpoint,
    Map<String, String>? bodyParameters,
    String? jsonString,
  });

  Future<http.Response> post({
    required String endpoint,
    Map<String, String>? bodyParameters,
    String? jsonString,
  });
}
