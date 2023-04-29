import 'package:studip_api_client/studip_api_client.dart';

class FileListResponse implements ItemListResponse<FileResponse> {
  final List<FileResponse> files;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int total;

  FileListResponse({
    required this.files,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory FileListResponse.fromJson(Map<String, dynamic> json) {
    final page = json["meta"]["page"];
    List<dynamic> files = json["data"];

    return FileListResponse(
      files: files.map((rawFile) => FileResponse.fromJson(rawFile)).toList(),
      offset: page["offset"],
      limit: page["limit"],
      total: page["total"],
    );
  }

  @override
  List<FileResponse> get items => files;
}

class FileResponse {
  final String id;
  final String name;
  final String description;
  final int numberOfDownloads;
  final String owner;
  final String createdAt;
  final String lastUpdatedAt;
  final String mimeType;
  final bool isReadable;
  final bool isDownloadable;
  final String downloadUrl;

  FileResponse({
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

  factory FileResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["attributes"];
    final relationships = json["relationships"];

    return FileResponse(
      id: json["id"],
      name: attributes["name"],
      description: attributes["description"],
      numberOfDownloads: attributes["downloads"],
      owner: relationships["owner"]["meta"]["name"],
      createdAt: attributes["mkdate"],
      lastUpdatedAt: attributes["chdate"],
      mimeType: attributes["mime-type"],
      isReadable: attributes["is-readable"],
      isDownloadable: attributes["is-downloadable"],
      downloadUrl: json["meta"]["download-url"],
    );
  }
}
