// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      serverId: (json['id'] as num?)?.toInt(),
      created: const DateTimeConverter().fromJson(json['created'] as String),
      modified: const DateTimeConverter().fromJson(json['modified'] as String),
      userId: json['userId'] as String,
      planName: json['planName'] as String,
      subId: json['subId'] as String,
      source: json['source'] as String,
      trialStart: _$JsonConverterFromJson<String, DateTime>(
        json['trialStart'],
        const DateTimeConverter().fromJson,
      ),
      trialEnd: _$JsonConverterFromJson<String, DateTime>(
        json['trialEnd'],
        const DateTimeConverter().fromJson,
      ),
      collections:
          (json['collections'] as num?)?.toInt() ?? defaultCollectionCount,
      itemsPerCollection:
          (json['itemsPerCollection'] as num?)?.toInt() ??
          defaultMaxItemPerCollection,
      dragNdrop: json['drag_n_drop'] as bool? ?? false,
      theming: json['theming'] as bool? ?? false,
      syncHours: (json['syncHr'] as num?)?.toInt() ?? defaultSyncHourOffset,
      ads: json['ads'] as bool? ?? true,
      syncInterval:
          (json['syncInt'] as num?)?.toInt() ?? defaultBestEffortSyncInterval,
      activeTill: _$JsonConverterFromJson<String, DateTime>(
        json['activeTill'],
        const DateTimeConverter().fromJson,
      ),
      maxSyncDevices:
          (json['devices'] as num?)?.toInt() ?? defaultNoOfSyncedDevices,
      customExclusionRules: json['cers'] as bool? ?? false,
      pasteStackLimit:
          (json['ps_limit'] as num?)?.toInt() ?? defaultPasteStackLimit,
      grants: (json['grants'] as num?)?.toInt() ?? 0,
      tkn: json['tkn'] as String?,
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'created': const DateTimeConverter().toJson(instance.created),
      'modified': const DateTimeConverter().toJson(instance.modified),
      'userId': instance.userId,
      'planName': instance.planName,
      'subId': instance.subId,
      'source': instance.source,
      'trialStart': _$JsonConverterToJson<String, DateTime>(
        instance.trialStart,
        const DateTimeConverter().toJson,
      ),
      'trialEnd': _$JsonConverterToJson<String, DateTime>(
        instance.trialEnd,
        const DateTimeConverter().toJson,
      ),
      'collections': instance.collections,
      'itemsPerCollection': instance.itemsPerCollection,
      'drag_n_drop': instance.dragNdrop,
      'theming': instance.theming,
      'syncHr': instance.syncHours,
      'ads': instance.ads,
      'syncInt': instance.syncInterval,
      'activeTill': _$JsonConverterToJson<String, DateTime>(
        instance.activeTill,
        const DateTimeConverter().toJson,
      ),
      'devices': instance.maxSyncDevices,
      'cers': instance.customExclusionRules,
      'ps_limit': instance.pasteStackLimit,
      'grants': instance.grants,
      'tkn': instance.tkn,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
