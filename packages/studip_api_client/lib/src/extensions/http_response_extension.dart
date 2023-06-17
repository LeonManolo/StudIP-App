import 'dart:convert';

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
}
