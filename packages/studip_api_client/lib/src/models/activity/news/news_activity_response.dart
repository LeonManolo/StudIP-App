import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'news_activity_response.g.dart';

@JsonSerializable()
class NewsActivityListResponse {
  @JsonKey(name: 'data')
  final List<NewsActivityResponseItem> newsActivityResponseItems;

  @NewsActivityListResponseIncludedConverter()
  final List<NewsActivityListResponseIncluded> included;

  NewsActivityListResponse(this.newsActivityResponseItems, this.included);

  factory NewsActivityListResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsActivityListResponseFromJson(json);
}

@JsonSerializable()
class NewsActivityResponseItem {
  final String id;
  final NewsActivityResponseItemAttributes attributes;
  final NewsActivityResponseItemRelationships relationships;

  NewsActivityResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory NewsActivityResponseItem.fromJson(Map<String, dynamic> json) =>
      _$NewsActivityResponseItemFromJson(json);

  String get courseId => relationships.course.data.id;
  String get userId => relationships.user.data.id;
  String get newsId => relationships.news.data.id;
}

@JsonSerializable()
class NewsActivityResponseItemAttributes {
  final String title;
  final String content;

  NewsActivityResponseItemAttributes({
    required this.title,
    required this.content,
  });

  factory NewsActivityResponseItemAttributes.fromJson(
          Map<String, dynamic> json) =>
      _$NewsActivityResponseItemAttributesFromJson(json);
}

// --- Relationships ---
@JsonSerializable()
class NewsActivityResponseItemRelationships {
  @JsonKey(name: 'actor')
  final NewsActivityResponseItemRelationshipsIncluded user;

  @JsonKey(name: 'object')
  final NewsActivityResponseItemRelationshipsIncluded news;

  @JsonKey(name: 'context')
  final NewsActivityResponseItemRelationshipsIncluded course;

  NewsActivityResponseItemRelationships({
    required this.user,
    required this.news,
    required this.course,
  });

  factory NewsActivityResponseItemRelationships.fromJson(
          Map<String, dynamic> json) =>
      _$NewsActivityResponseItemRelationshipsFromJson(json);
}

@JsonSerializable()
class NewsActivityResponseItemRelationshipsIncluded {
  final NewsActivityResponseItemRelationshipsData data;

  NewsActivityResponseItemRelationshipsIncluded({required this.data});

  factory NewsActivityResponseItemRelationshipsIncluded.fromJson(
          Map<String, dynamic> json) =>
      _$NewsActivityResponseItemRelationshipsIncludedFromJson(json);
}

@JsonSerializable()
class NewsActivityResponseItemRelationshipsData {
  final String type;
  final String id;

  NewsActivityResponseItemRelationshipsData({
    required this.type,
    required this.id,
  });

  factory NewsActivityResponseItemRelationshipsData.fromJson(
          Map<String, dynamic> json) =>
      _$NewsActivityResponseItemRelationshipsDataFromJson(json);
}

// --- Included ---

class NewsActivityListResponseIncludedConverter
    implements
        JsonConverter<NewsActivityListResponseIncluded, Map<String, dynamic>> {
  const NewsActivityListResponseIncludedConverter();

  @override
  NewsActivityListResponseIncluded fromJson(Map<String, dynamic> json) {
    final String type = json['type'];

    if (type == 'users') {
      return NewsActivityListResponseIncludedUser(
        userResponseItem: UserResponseItem.fromJson(json),
      );
    } else if (type == 'news') {
      return NewsActivityListResponseIncludedNews(
        courseNewsResponseItem: CourseNewsResponseItem.fromJson(json),
      );
    } else if (type == 'courses') {
      return NewsActivityListResponseIncludedCourse(
        courseResponseItem: CourseResponseItem.fromJson(json),
      );
    } else {
      throw UnsupportedError(
          'The following json is not expected to be included in News Activity Stream: ${json}');
    }
  }

  @override
  Map<String, dynamic> toJson(NewsActivityListResponseIncluded object) {
    throw UnimplementedError();
  }
}

sealed class NewsActivityListResponseIncluded {}

class NewsActivityListResponseIncludedUser
    extends NewsActivityListResponseIncluded {
  final UserResponseItem userResponseItem;

  NewsActivityListResponseIncludedUser({required this.userResponseItem});
}

class NewsActivityListResponseIncludedNews
    extends NewsActivityListResponseIncluded {
  final CourseNewsResponseItem courseNewsResponseItem;

  NewsActivityListResponseIncludedNews({required this.courseNewsResponseItem});
}

class NewsActivityListResponseIncludedCourse
    extends NewsActivityListResponseIncluded {
  final CourseResponseItem courseResponseItem;

  NewsActivityListResponseIncludedCourse({required this.courseResponseItem});
}
