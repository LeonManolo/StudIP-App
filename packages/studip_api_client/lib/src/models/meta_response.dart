import 'package:json_annotation/json_annotation.dart';

part 'meta_response.g.dart';

@JsonSerializable()
class ResponseMeta {
  ResponseMeta({required this.page});

  factory ResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ResponseMetaFromJson(json);

  final ResponsePage page;
}

@JsonSerializable()
class ResponsePage {
  ResponsePage({
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory ResponsePage.fromJson(Map<String, dynamic> json) =>
      _$ResponsePageFromJson(json);

  final int offset;
  final int limit;
  final int total;
}
