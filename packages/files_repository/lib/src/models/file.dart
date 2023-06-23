import 'package:intl/intl.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;

class File {
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
  });

  factory File.fromFileResponse({
    required studip_api_client.FileResponseItem fileResponseItem,
  }) {
    final studip_api_client.FileResponseItemAttributes attributes =
        fileResponseItem.attributes;
    return File(
      id: fileResponseItem.id,
      name: attributes.name,
      description: attributes.description,
      numberOfDownloads: attributes.numberOfDownloads,
      owner: fileResponseItem.relationships.owner.meta.name,
      createdAt: DateTime.parse(attributes.createdAt).toLocal(),
      lastUpdatedAt: DateTime.parse(attributes.lastUpdatedAt).toLocal(),
      mimeType: attributes.mimeType,
      isReadable: attributes.isReadable,
      isDownloadable: attributes.isDownloadable,
    );
  }
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

  String get createdAtFormatted =>
      DateFormat('dd.MM.yy (HH:mm)').format(createdAt);

  String get lastUpdatedAtFormatted =>
      DateFormat('dd.MM.yy (HH:mm)').format(lastUpdatedAt);
}
