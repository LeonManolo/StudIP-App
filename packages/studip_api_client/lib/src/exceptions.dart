/// An exception thrown when there is a problem decoded the response body.
class StudIpApiMalformedResponse implements Exception {
  const StudIpApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// An exception thrown when an http request failure occurs.
class StudIpApiRequestFailure implements Exception {
  const StudIpApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}
