// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appconfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigImpl _$$AppConfigImplFromJson(
  Map<String, dynamic> json,
) => _$AppConfigImpl(
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  enableSync: json['enableSync'] as bool? ?? true,
  enableFileSync: json['enableFileSync'] as bool? ?? true,
  layout:
      $enumDecodeNullable(_$AppLayoutEnumMap, json['layout']) ?? AppLayout.grid,
  view: $enumDecodeNullable(_$AppViewEnumMap, json['view']) ?? AppView.windowed,
  pinned: json['pinned'] as bool? ?? false,
  windowWidth: (json['windowWidth'] as num?)?.toDouble() ?? initialWindowWidth,
  windowHeight:
      (json['windowHeight'] as num?)?.toDouble() ?? initialWindowHeight,
  sortBy:
      $enumDecodeNullable(_$ClipboardSortKeyEnumMap, json['sortBy']) ??
      ClipboardSortKey.created,
  sortOrder:
      $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder']) ??
      SortOrder.desc,
  dontUploadOver: (json['dontUploadOver'] as num?)?.toInt() ?? $10MB,
  dontCopyOver: (json['dontCopyOver'] as num?)?.toInt() ?? $10MB,
  pausedTill: json['pausedTill'] == null
      ? null
      : DateTime.parse(json['pausedTill'] as String),
  syncSpeed:
      $enumDecodeNullable(_$SyncSpeedEnumMap, json['syncSpeed']) ??
      SyncSpeed.balanced,
  toggleHotkey: json['toggleHotkey'] as String?,
  smartPaste: json['smartPaste'] as bool? ?? false,
  launchAtStartup: json['launchAtStartup'] as bool? ?? false,
  locale: json['locale'] as String? ?? "en",
  enc2: json['enc2'] as String?,
  autoEncrypt: json['autoEncrypt'] as bool? ?? false,
  themeColor: (json['themeColor'] as num?)?.toInt() ?? defaultThemeColor,
  themeVariant:
      $enumDecodeNullable(
        _$DynamicSchemeVariantEnumMap,
        json['themeVariant'],
      ) ??
      DynamicSchemeVariant.tonalSpot,
  enableDragNDrop: json['enableDragNDrop'] as bool? ?? false,
  enablePasteStack: json['enablePasteStack'] as bool? ?? false,
  androidBgListener: json['androidBgListener'] as bool? ?? false,
  duplicatePrevention: json['duplicatePrevention'] as bool? ?? false,
  onBoardComplete: json['onBoardComplete'] as bool? ?? true,
);

Map<String, dynamic> _$$AppConfigImplToJson(_$AppConfigImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'enableSync': instance.enableSync,
      'enableFileSync': instance.enableFileSync,
      'layout': _$AppLayoutEnumMap[instance.layout]!,
      'view': _$AppViewEnumMap[instance.view]!,
      'pinned': instance.pinned,
      'windowWidth': instance.windowWidth,
      'windowHeight': instance.windowHeight,
      'sortBy': _$ClipboardSortKeyEnumMap[instance.sortBy]!,
      'sortOrder': _$SortOrderEnumMap[instance.sortOrder]!,
      'dontUploadOver': instance.dontUploadOver,
      'dontCopyOver': instance.dontCopyOver,
      'pausedTill': instance.pausedTill?.toIso8601String(),
      'syncSpeed': _$SyncSpeedEnumMap[instance.syncSpeed]!,
      'toggleHotkey': instance.toggleHotkey,
      'smartPaste': instance.smartPaste,
      'launchAtStartup': instance.launchAtStartup,
      'locale': instance.locale,
      'enc2': instance.enc2,
      'autoEncrypt': instance.autoEncrypt,
      'themeColor': instance.themeColor,
      'themeVariant': _$DynamicSchemeVariantEnumMap[instance.themeVariant]!,
      'enableDragNDrop': instance.enableDragNDrop,
      'enablePasteStack': instance.enablePasteStack,
      'androidBgListener': instance.androidBgListener,
      'duplicatePrevention': instance.duplicatePrevention,
      'onBoardComplete': instance.onBoardComplete,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AppLayoutEnumMap = {AppLayout.grid: 'grid', AppLayout.list: 'list'};

const _$AppViewEnumMap = {
  AppView.topDocked: 'topDocked',
  AppView.bottomDocked: 'bottomDocked',
  AppView.leftDocked: 'leftDocked',
  AppView.rightDocked: 'rightDocked',
  AppView.windowed: 'windowed',
};

const _$ClipboardSortKeyEnumMap = {
  ClipboardSortKey.created: 'created',
  ClipboardSortKey.modified: 'modified',
  ClipboardSortKey.lastCopied: 'lastCopied',
  ClipboardSortKey.copyCount: 'copyCount',
};

const _$SortOrderEnumMap = {SortOrder.asc: 'asc', SortOrder.desc: 'desc'};

const _$SyncSpeedEnumMap = {
  SyncSpeed.realtime: 'realtime',
  SyncSpeed.balanced: 'balanced',
};

const _$DynamicSchemeVariantEnumMap = {
  DynamicSchemeVariant.tonalSpot: 'tonalSpot',
  DynamicSchemeVariant.fidelity: 'fidelity',
  DynamicSchemeVariant.monochrome: 'monochrome',
  DynamicSchemeVariant.neutral: 'neutral',
  DynamicSchemeVariant.vibrant: 'vibrant',
  DynamicSchemeVariant.expressive: 'expressive',
  DynamicSchemeVariant.content: 'content',
  DynamicSchemeVariant.rainbow: 'rainbow',
  DynamicSchemeVariant.fruitSalad: 'fruitSalad',
};
