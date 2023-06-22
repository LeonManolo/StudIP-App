import 'package:json_annotation/json_annotation.dart';

part 'message_response.g.dart';

/// List of [MessageResponseItem]s
@JsonSerializable()
class MessageListResponse {
  @JsonKey(name: 'data')
  final List<MessageResponseItem> messageResponseItems;

  MessageListResponse({required this.messageResponseItems});

  factory MessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageListResponseFromJson(json);
}

/// Single [MessageResponseItem]
@JsonSerializable()
class MessageResponse {
  @JsonKey(name: 'data')
  final MessageResponseItem messageResponseItem;

  MessageResponse({required this.messageResponseItem});

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}

@JsonSerializable()
class MessageResponseItem {
  final String id;
  final MessageResponseItemAttributes attributes;
  final MessageResponseItemRelationships relationships;

  MessageResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory MessageResponseItem.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseItemFromJson(json);
}

@JsonSerializable()
class MessageResponseItemAttributes {
  final String subject;
  final String message;

  @JsonKey(name: 'mkdate')
  final String createdAt;

  @JsonKey(name: 'is-read')
  final bool isRead;

  MessageResponseItemAttributes({
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory MessageResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseItemAttributesFromJson(json);
}

@JsonSerializable()
class MessageResponseItemRelationships {
  final MessageResponseItemRelationshipsSender sender;
  final MessageResponseItemRelationshipsRecipients recipients;

  MessageResponseItemRelationships(
      {required this.sender, required this.recipients});

  factory MessageResponseItemRelationships.fromJson(
          Map<String, dynamic> json) =>
      _$MessageResponseItemRelationshipsFromJson(json);
}

// --- Sender ---

@JsonSerializable()
class MessageResponseItemRelationshipsSender {
  final MessageResponseItemRelationshipsSenderData data;

  MessageResponseItemRelationshipsSender({required this.data});

  factory MessageResponseItemRelationshipsSender.fromJson(
          Map<String, dynamic> json) =>
      _$MessageResponseItemRelationshipsSenderFromJson(json);
}

@JsonSerializable()
class MessageResponseItemRelationshipsSenderData {
  final String type;
  final String id;

  MessageResponseItemRelationshipsSenderData(
      {required this.type, required this.id});

  factory MessageResponseItemRelationshipsSenderData.fromJson(
          Map<String, dynamic> json) =>
      _$MessageResponseItemRelationshipsSenderDataFromJson(json);
}

// --- Recipients ---

@JsonSerializable()
class MessageResponseItemRelationshipsRecipients {
  @JsonKey(name: 'data')
  final List<MessageResponseItemRelationshipsRecipientsDataItem> dataItems;

  MessageResponseItemRelationshipsRecipients({required this.dataItems});

  factory MessageResponseItemRelationshipsRecipients.fromJson(
          Map<String, dynamic> json) =>
      _$MessageResponseItemRelationshipsRecipientsFromJson(json);
}

@JsonSerializable()
class MessageResponseItemRelationshipsRecipientsDataItem {
  final String type;
  final String id;

  MessageResponseItemRelationshipsRecipientsDataItem(
      {required this.type, required this.id});

  factory MessageResponseItemRelationshipsRecipientsDataItem.fromJson(
          Map<String, dynamic> json) =>
      _$MessageResponseItemRelationshipsRecipientsDataItemFromJson(json);
}
