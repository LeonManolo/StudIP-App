import 'dart:convert';
import 'dart:io';

import 'package:http_forked/http.dart' as http;
import 'package:studip_api_client/src/exceptions.dart';

extension HttpJsonExtension on http.Response {
  Map<String, dynamic> json() {
    try {
      if (body.isEmpty) {
        return {};
      } else {
        return jsonDecode(body) as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StudIpApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }

  void throwIfInvalidHttpStatus({
    int expectedStatus = HttpStatus.ok,
    required Map<String, dynamic> body,
  }) {
    if (statusCode != expectedStatus) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: statusCode,
      );
    }
  }
}
