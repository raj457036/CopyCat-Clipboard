// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClipboardItemImpl _$$ClipboardItemImplFromJson(Map<String, dynamic> json) =>
    _$ClipboardItemImpl(
      serverId: (json['id'] as num?)?.toInt(),
      created: const DateTimeConverter().fromJson(json['created'] as String),
      modified: const DateTimeConverter().fromJson(json['modified'] as String),
      deviceId: json['deviceId'] as String?,
      type: $enumDecode(_$ClipItemTypeEnumMap, json['type']),
      userId: json['userId'] as String? ?? kLocalUserId,
      title: json['title'] as String?,
      description: json['description'] as String?,
      deletedAt: _$JsonConverterFromJson<String, DateTime>(
        json['deletedAt'],
        const DateTimeConverter().fromJson,
      ),
      encrypted: json['encrypted'] as bool? ?? false,
      iv: json['iv'] as String?,
      encMode: json['enc_mode'] as String?,
      text: json['text'] as String?,
      url: json['url'] as String?,
      textCategory: $enumDecodeNullable(
        _$TextCategoryEnumMap,
        json['textCategory'],
      ),
      fileName: json['fileName'] as String?,
      fileMimeType: json['fileMimeType'] as String?,
      fileExtension: json['fileExtension'] as String?,
      driveFileId: json['driveFileId'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      imgBlurHash: json['imgBlurHash'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      sourceApp: json['sourceApp'] as String?,
      os: $enumDecode(_$PlatformOSEnumMap, json['os']),
      serverCollectionId: (json['collectionId'] as num?)?.toInt(),
      copiedCount: (json['copiedCount'] as num?)?.toInt() ?? 0,
      lastCopied: _$JsonConverterFromJson<String, DateTime>(
        json['lastCopied'],
        const DateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$$ClipboardItemImplToJson(_$ClipboardItemImpl instance) =>
    <String, dynamic>{
      'created': const DateTimeConverter().toJson(instance.created),
      'modified': const DateTimeConverter().toJson(instance.modified),
      'deviceId': instance.deviceId,
      'type': _$ClipItemTypeEnumMap[instance.type]!,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const DateTimeConverter().toJson,
      ),
      'encrypted': instance.encrypted,
      'iv': instance.iv,
      'enc_mode': instance.encMode,
      'text': instance.text,
      'url': instance.url,
      'textCategory': _$TextCategoryEnumMap[instance.textCategory],
      'fileName': instance.fileName,
      'fileMimeType': instance.fileMimeType,
      'fileExtension': instance.fileExtension,
      'driveFileId': instance.driveFileId,
      'fileSize': instance.fileSize,
      'imgBlurHash': instance.imgBlurHash,
      'sourceUrl': instance.sourceUrl,
      'sourceApp': instance.sourceApp,
      'os': _$PlatformOSEnumMap[instance.os]!,
      'collectionId': instance.serverCollectionId,
      'copiedCount': instance.copiedCount,
      'lastCopied': _$JsonConverterToJson<String, DateTime>(
        instance.lastCopied,
        const DateTimeConverter().toJson,
      ),
    };

const _$ClipItemTypeEnumMap = {
  ClipItemType.text: 'text',
  ClipItemType.media: 'media',
  ClipItemType.file: 'file',
  ClipItemType.url: 'url',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$TextCategoryEnumMap = {
  TextCategory.color: 'color',
  TextCategory.email: 'email',
  TextCategory.phone: 'phone',
  TextCategory.struct: 'struct',
};

const _$PlatformOSEnumMap = {
  PlatformOS.android: 'android',
  PlatformOS.ios: 'ios',
  PlatformOS.macos: 'macos',
  PlatformOS.windows: 'windows',
  PlatformOS.linux: 'linux',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
