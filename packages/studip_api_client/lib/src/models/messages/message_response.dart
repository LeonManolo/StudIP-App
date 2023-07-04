import 'package:json_annotation/json_annotation.dart';

part 'message_response.g.dart';

/// List of [MessageResponseItem]s
@JsonSerializable()
class MessageListResponse {
  MessageListResponse({required this.messageResponseItems});

  factory MessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageListResponseFromJson(json);
  @JsonKey(name: 'data')
  final List<MessageResponseItem> messageResponseItems;
}

/// Single [MessageResponseItem]
@JsonSerializable()
class MessageResponse {
  MessageResponse({required this.messageResponseItem});

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
  @JsonKey(name: 'data')
  final MessageResponseItem messageResponseItem;
}

@JsonSerializable()
class MessageResponseItem {
  MessageResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory MessageResponseItem.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseItemFromJson(json);
  final String id;
  final MessageResponseItemAttributes attributes;
  final MessageResponseItemRelationships relationships;
}

@JsonSerializable()
class MessageResponseItemAttributes {
  MessageResponseItemAttributes({
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory MessageResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseItemAttributesFromJson(json);
  final String subject;
  final String message;

  @JsonKey(name: 'mkdate')
  final String createdAt;

  @JsonKey(name: 'is-read')
  final bool isRead;
}

@JsonSerializable()
class MessageResponseItemRelationships {
  MessageResponseItemRelationships({
    this.sender,
    required this.recipients,
  });

  factory MessageResponseItemRelationships.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MessageResponseItemRelationshipsFromJson(json);

  final MessageResponseItemRelationshipsSender? sender;
  final MessageResponseItemRelationshipsRecipients recipients;
}

// --- Sender ---

@JsonSerializable()
class MessageResponseItemRelationshipsSender {
  MessageResponseItemRelationshipsSender({required this.data});

  factory MessageResponseItemRelationshipsSender.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MessageResponseItemRelationshipsSenderFromJson(json);
  final MessageResponseItemRelationshipsSenderData data;
}

@JsonSerializable()
class MessageResponseItemRelationshipsSenderData {
  MessageResponseItemRelationshipsSenderData({
    required this.type,
    required this.id,
  });

  factory MessageResponseItemRelationshipsSenderData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MessageResponseItemRelationshipsSenderDataFromJson(json);
  final String type;
  final String id;
}

// --- Recipients ---

@JsonSerializable()
class MessageResponseItemRelationshipsRecipients {
  MessageResponseItemRelationshipsRecipients({required this.dataItems});

  factory MessageResponseItemRelationshipsRecipients.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MessageResponseItemRelationshipsRecipientsFromJson(json);
  @JsonKey(name: 'data')
  final List<MessageResponseItemRelationshipsRecipientsDataItem> dataItems;
}

@JsonSerializable()
class MessageResponseItemRelationshipsRecipientsDataItem {
  MessageResponseItemRelationshipsRecipientsDataItem({
    required this.type,
    required this.id,
  });

  factory MessageResponseItemRelationshipsRecipientsDataItem.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MessageResponseItemRelationshipsRecipientsDataItemFromJson(json);
  final String type;
  final String id;
}
