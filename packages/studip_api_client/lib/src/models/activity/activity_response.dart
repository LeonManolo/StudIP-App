import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'activity_response.g.dart';

@JsonSerializable()
class ActivityListResponse {
  @JsonKey(name: 'data')
  final List<ActivityResponseItem> activityResponseItems;

  @ActivityListResponseIncludedConverter()
  final List<ActivityListResponseIncluded> included;

  ActivityListResponse(this.activityResponseItems, this.included);

  factory ActivityListResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivityListResponseFromJson(json);
}

@JsonSerializable()
class ActivityResponseItem {
  final String id;
  final ActivityResponseItemAttributes attributes;
  final ActivityResponseItemRelationships relationships;

  ActivityResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory ActivityResponseItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityResponseItemFromJson(json);

  String get contextId => relationships.context.data.id;
  String get actorId => relationships.actor.data.id;
  String get objectId => relationships.object.data.id;
}

@JsonSerializable()
class ActivityResponseItemAttributes {
  final String title;
  final String content;

  ActivityResponseItemAttributes({
    required this.title,
    required this.content,
  });

  factory ActivityResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$ActivityResponseItemAttributesFromJson(json);
}

// --- Relationships ---
@JsonSerializable()
class ActivityResponseItemRelationships {
  final ActivityResponseItemRelationshipsIncluded actor;
  final ActivityResponseItemRelationshipsIncluded object;
  final ActivityResponseItemRelationshipsIncluded context;

  ActivityResponseItemRelationships({
    required this.actor,
    required this.object,
    required this.context,
  });

  factory ActivityResponseItemRelationships.fromJson(
          Map<String, dynamic> json) =>
      _$ActivityResponseItemRelationshipsFromJson(json);
}

@JsonSerializable()
class ActivityResponseItemRelationshipsIncluded {
  final ActivityResponseItemRelationshipsData data;

  ActivityResponseItemRelationshipsIncluded({required this.data});

  factory ActivityResponseItemRelationshipsIncluded.fromJson(
          Map<String, dynamic> json) =>
      _$ActivityResponseItemRelationshipsIncludedFromJson(json);
}

@JsonSerializable()
class ActivityResponseItemRelationshipsData {
  final String type;
  final String id;

  ActivityResponseItemRelationshipsData({
    required this.type,
    required this.id,
  });

  factory ActivityResponseItemRelationshipsData.fromJson(
          Map<String, dynamic> json) =>
      _$ActivityResponseItemRelationshipsDataFromJson(json);
}

// --- Included ---

class ActivityListResponseIncludedConverter
    implements
        JsonConverter<ActivityListResponseIncluded, Map<String, dynamic>> {
  const ActivityListResponseIncludedConverter();

  @override
  ActivityListResponseIncluded fromJson(Map<String, dynamic> json) {
    final String type = json['type'];

    if (type == 'users') {
      return ActivityListResponseIncludedUser(
        userResponseItem: UserResponseItem.fromJson(json),
      );
    } else if (type == 'news') {
      return ActivityListResponseIncludedNews(
        newsResponseItem: CourseNewsResponseItem.fromJson(json),
      );
    } else if (type == 'courses') {
      return ActivityListResponseIncludedCourse(
        courseResponseItem: CourseResponseItem.fromJson(json),
      );
    } else if (type == 'file-refs') {
      return ActivityListResponseIncludedFile(
        fileResponseItem: FileResponseItem.fromJson(json),
      );
    } else {
      throw UnsupportedError(
          'The following json is not expected to be included in an Activity Stream: ${json}');
    }
  }

  @override
  Map<String, dynamic> toJson(ActivityListResponseIncluded object) {
    throw UnimplementedError();
  }
}

sealed class ActivityListResponseIncluded {}

class ActivityListResponseIncludedUser extends ActivityListResponseIncluded {
  final UserResponseItem userResponseItem;

  ActivityListResponseIncludedUser({required this.userResponseItem});
}

class ActivityListResponseIncludedNews extends ActivityListResponseIncluded {
  final CourseNewsResponseItem newsResponseItem;

  ActivityListResponseIncludedNews({required this.newsResponseItem});
}

class ActivityListResponseIncludedCourse extends ActivityListResponseIncluded {
  final CourseResponseItem courseResponseItem;

  ActivityListResponseIncludedCourse({required this.courseResponseItem});
}

class ActivityListResponseIncludedFile extends ActivityListResponseIncluded {
  final FileResponseItem fileResponseItem;

  ActivityListResponseIncludedFile({required this.fileResponseItem});
}
