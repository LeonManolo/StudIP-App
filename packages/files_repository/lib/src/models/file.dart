import 'package:intl/intl.dart';
import 'package:studip_api_client/src/models/models.dart' as APIModels;
import 'package:studip_api_client/studip_api_client.dart';

class File {
  final String id;
  final String name;
  final String description;
  final int numberOfDownloads;
  final String owner;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String mimeType;
  final bool isReadable;
  final bool isDownloadable;
  final String downloadUrl;

  File({
    required this.id,
    required this.name,
    required this.description,
    required this.numberOfDownloads,
    required this.owner,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.mimeType,
    required this.isReadable,
    required this.isDownloadable,
    required this.downloadUrl,
  });

  factory File.fromFileResponse(
      {required APIModels.FileResponse fileResponse}) {
    return File(
      id: fileResponse.id,
      name: fileResponse.name,
      description: fileResponse.description,
      numberOfDownloads: fileResponse.numberOfDownloads,
      owner: fileResponse.owner,
      createdAt: DateTime.parse(fileResponse.createdAt).toLocal(),
      lastUpdatedAt: DateTime.parse(fileResponse.lastUpdatedAt).toLocal(),
      mimeType: fileResponse.mimeType,
      isReadable: fileResponse.isReadable,
      isDownloadable: fileResponse.isDownloadable,
      downloadUrl: fileResponse.downloadUrl,
    );
  }

  String get createdAtFormatted =>
      DateFormat("dd.MM.yy (HH:mm)").format(createdAt);

  String get lastUpdatedAtFormatted =>
      DateFormat("dd.MM.yy (HH:mm)").format(lastUpdatedAt);
}
