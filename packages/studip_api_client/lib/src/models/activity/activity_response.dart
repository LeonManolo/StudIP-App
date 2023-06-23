import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'activity_response.g.dart';

@JsonSerializable()
class ActivityListResponse {
  ActivityListResponse({
    required this.activityResponseItems,
    required this.included,
  });

  factory ActivityListResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivityListResponseFromJson(json);

  @JsonKey(name: 'data')
  final List<ActivityResponseItem> activityResponseItems;

  @ActivityListResponseIncludedConverter()
  final List<ActivityListResponseIncluded> included;
}

@JsonSerializable()
class ActivityResponseItem {
  ActivityResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory ActivityResponseItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityResponseItemFromJson(json);
  final String id;
  final ActivityResponseItemAttributes attributes;
  final ActivityResponseItemRelationships relationships;

  String get contextId => relationships.context.data.id;
  String get actorId => relationships.actor.data.id;
  String get objectId => relationships.object.data.id;
}

@JsonSerializable()
class ActivityResponseItemAttributes {
  ActivityResponseItemAttributes({
    required this.title,
    required this.content,
  });

  factory ActivityResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$ActivityResponseItemAttributesFromJson(json);
  final String title;
  final String content;
}

// --- Relationships ---
@JsonSerializable()
class ActivityResponseItemRelationships {
  ActivityResponseItemRelationships({
    required this.actor,
    required this.object,
    required this.context,
  });

  factory ActivityResponseItemRelationships.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ActivityResponseItemRelationshipsFromJson(json);
  final ActivityResponseItemRelationshipsIncluded actor;
  final ActivityResponseItemRelationshipsIncluded object;
  final ActivityResponseItemRelationshipsIncluded context;
}

@JsonSerializable()
class ActivityResponseItemRelationshipsIncluded {
  ActivityResponseItemRelationshipsIncluded({required this.data});

  factory ActivityResponseItemRelationshipsIncluded.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ActivityResponseItemRelationshipsIncludedFromJson(json);
  final ActivityResponseItemRelationshipsData data;
}

@JsonSerializable()
class ActivityResponseItemRelationshipsData {
  ActivityResponseItemRelationshipsData({
    required this.type,
    required this.id,
  });

  factory ActivityResponseItemRelationshipsData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ActivityResponseItemRelationshipsDataFromJson(json);
  final String type;
  final String id;
}

// --- Included ---

class ActivityListResponseIncludedConverter
    implements
        JsonConverter<ActivityListResponseIncluded, Map<String, dynamic>> {
  const ActivityListResponseIncludedConverter();

  @override
  ActivityListResponseIncluded fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String;

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
        'The following json is not expected to be included in an Activity Stream: $json',
      );
    }
  }

  @override
  Map<String, dynamic> toJson(ActivityListResponseIncluded object) {
    throw UnimplementedError();
  }
}

sealed class ActivityListResponseIncluded {}

class ActivityListResponseIncludedUser extends ActivityListResponseIncluded {
  ActivityListResponseIncludedUser({required this.userResponseItem});
  final UserResponseItem userResponseItem;
}

class ActivityListResponseIncludedNews extends ActivityListResponseIncluded {
  ActivityListResponseIncludedNews({required this.newsResponseItem});
  final CourseNewsResponseItem newsResponseItem;
}

class ActivityListResponseIncludedCourse extends ActivityListResponseIncluded {
  ActivityListResponseIncludedCourse({required this.courseResponseItem});
  final CourseResponseItem courseResponseItem;
}

class ActivityListResponseIncludedFile extends ActivityListResponseIncluded {
  ActivityListResponseIncludedFile({required this.fileResponseItem});
  final FileResponseItem fileResponseItem;
}
