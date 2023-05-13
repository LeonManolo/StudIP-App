import 'package:studip_api_client/studip_api_client.dart';

class UploadFilesFailure implements Exception {
  UploadFilesFailure({required this.message});

  factory UploadFilesFailure.fromUploadFilesCoreFailure({
    required UploadFilesCoreFailure failure,
  }) {
    return UploadFilesFailure(message: failure.message);
  }

  final String message;
}
