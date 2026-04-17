// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipcollection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClipCollectionImpl _$$ClipCollectionImplFromJson(Map<String, dynamic> json) =>
    _$ClipCollectionImpl(
      serverId: (json['id'] as num?)?.toInt(),
      created: const DateTimeConverter().fromJson(json['created'] as String),
      modified: const DateTimeConverter().fromJson(json['modified'] as String),
      userId: json['userId'] as String? ?? kLocalUserId,
      deletedAt: _$JsonConverterFromJson<String, DateTime>(
        json['deletedAt'],
        const DateTimeConverter().fromJson,
      ),
      deviceId: json['deviceId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      emoji: json['emoji'] as String,
    );

Map<String, dynamic> _$$ClipCollectionImplToJson(
  _$ClipCollectionImpl instance,
) => <String, dynamic>{
  'created': const DateTimeConverter().toJson(instance.created),
  'modified': const DateTimeConverter().toJson(instance.modified),
  'userId': instance.userId,
  'deletedAt': _$JsonConverterToJson<String, DateTime>(
    instance.deletedAt,
    const DateTimeConverter().toJson,
  ),
  'deviceId': instance.deviceId,
  'title': instance.title,
  'description': instance.description,
  'emoji': instance.emoji,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
