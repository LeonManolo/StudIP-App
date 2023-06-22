// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageListResponse _$MessageListResponseFromJson(Map<String, dynamic> json) =>
    MessageListResponse(
      messageResponseItems: (json['data'] as List<dynamic>)
          .map((e) => MessageResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageListResponseToJson(
        MessageListResponse instance) =>
    <String, dynamic>{
      'data': instance.messageResponseItems,
    };

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    MessageResponse(
      messageResponseItem:
          MessageResponseItem.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{
      'data': instance.messageResponseItem,
    };

MessageResponseItem _$MessageResponseItemFromJson(Map<String, dynamic> json) =>
    MessageResponseItem(
      id: json['id'] as String,
      attributes: MessageResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: MessageResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageResponseItemToJson(
        MessageResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

MessageResponseItemAttributes _$MessageResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    MessageResponseItemAttributes(
      subject: json['subject'] as String,
      message: json['message'] as String,
      createdAt: json['mkdate'] as String,
      isRead: json['is-read'] as bool,
    );

Map<String, dynamic> _$MessageResponseItemAttributesToJson(
        MessageResponseItemAttributes instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'message': instance.message,
      'mkdate': instance.createdAt,
      'is-read': instance.isRead,
    };

MessageResponseItemRelationships _$MessageResponseItemRelationshipsFromJson(
        Map<String, dynamic> json) =>
    MessageResponseItemRelationships(
      sender: MessageResponseItemRelationshipsSender.fromJson(
          json['sender'] as Map<String, dynamic>),
      recipients: MessageResponseItemRelationshipsRecipients.fromJson(
          json['recipients'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageResponseItemRelationshipsToJson(
        MessageResponseItemRelationships instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'recipients': instance.recipients,
    };

MessageResponseItemRelationshipsSender
    _$MessageResponseItemRelationshipsSenderFromJson(
            Map<String, dynamic> json) =>
        MessageResponseItemRelationshipsSender(
          data: MessageResponseItemRelationshipsSenderData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$MessageResponseItemRelationshipsSenderToJson(
        MessageResponseItemRelationshipsSender instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

MessageResponseItemRelationshipsSenderData
    _$MessageResponseItemRelationshipsSenderDataFromJson(
            Map<String, dynamic> json) =>
        MessageResponseItemRelationshipsSenderData(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$MessageResponseItemRelationshipsSenderDataToJson(
        MessageResponseItemRelationshipsSenderData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };

MessageResponseItemRelationshipsRecipients
    _$MessageResponseItemRelationshipsRecipientsFromJson(
            Map<String, dynamic> json) =>
        MessageResponseItemRelationshipsRecipients(
          dataItems: (json['data'] as List<dynamic>)
              .map((e) =>
                  MessageResponseItemRelationshipsRecipientsDataItem.fromJson(
                      e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$MessageResponseItemRelationshipsRecipientsToJson(
        MessageResponseItemRelationshipsRecipients instance) =>
    <String, dynamic>{
      'data': instance.dataItems,
    };

MessageResponseItemRelationshipsRecipientsDataItem
    _$MessageResponseItemRelationshipsRecipientsDataItemFromJson(
            Map<String, dynamic> json) =>
        MessageResponseItemRelationshipsRecipientsDataItem(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$MessageResponseItemRelationshipsRecipientsDataItemToJson(
        MessageResponseItemRelationshipsRecipientsDataItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
