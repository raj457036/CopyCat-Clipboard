import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/isar/adapters/isar_exclusion_rules.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'isar_app_config.g.dart';

@Name("AppConfig")
@Collection()
class IsarAppConfig {
  Id isarId = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  ThemeMode themeMode = ThemeMode.system;
  bool enableSync = true;
  bool enableFileSync = true;
  @Enumerated(EnumType.name)
  AppLayout layout = AppLayout.grid;
  @Enumerated(EnumType.name)
  AppView view = AppView.windowed;
  bool pinned = false;
  double windowWidth = initialWindowWidth;
  double windowHeight = initialWindowHeight;

  @Enumerated(EnumType.name)
  ClipboardSortKey sortBy = ClipboardSortKey.modified;
  @Enumerated(EnumType.name)
  SortOrder sortOrder = SortOrder.desc;
  int dontUploadOver = 10485760;
  int dontCopyOver = 10485760;
  DateTime? pausedTill;
  @Enumerated(EnumType.name)
  SyncSpeed syncSpeed = SyncSpeed.balanced;
  String? toggleHotkey;
  String? quickPasteHotkey;
  String? pasteStackHotkey;
  bool smartPaste = false;
  bool transformAsNewClip = false;
  bool launchAtStartup = false;
  String locale = "en";
  String? enc2;
  bool autoEncrypt = false;
  bool useEncryptionNonce = false;
  IsarExclusionRules? exclusionRules;
  int themeColor = 0xFF322C57;
  @Enumerated(EnumType.name)
  DynamicSchemeVariant themeVariant = DynamicSchemeVariant.tonalSpot;
  bool enableDragNDrop = false;
  bool enablePasteStack = false;
  bool androidBgListener = false;
  bool richDataCapture = false;
  bool onBoardComplete = true;
  int reviewQualifyingEventCount = 0;
  DateTime? lastReviewPromptDate;
  bool reviewNeverAsk = false;
  bool lanInstantSync = false;
  bool autoWriteOnReceive = false;

  static int _sanitizeCounter(int value) => value < 0 ? 0 : value;

  AppConfig toDomain() => AppConfig(
    id: isarId == Isar.autoIncrement ? null : isarId,
    themeMode: themeMode,
    enableSync: enableSync,
    enableFileSync: enableFileSync,
    layout: layout,
    view: view,
    pinned: pinned,
    windowWidth: windowWidth,
    windowHeight: windowHeight,
    dontUploadOver: dontUploadOver,
    dontCopyOver: dontCopyOver,
    pausedTill: pausedTill,
    sortBy: sortBy,
    sortOrder: sortOrder,
    syncSpeed: syncSpeed,
    toggleHotkey: toggleHotkey,
    quickPasteHotkey: quickPasteHotkey,
    pasteStackHotkey: pasteStackHotkey,
    smartPaste: smartPaste,
    transformAsNewClip: transformAsNewClip,
    launchAtStartup: launchAtStartup,
    locale: locale,
    enc2: enc2,
    autoEncrypt: autoEncrypt,
    useEncryptionNonce: useEncryptionNonce,
    exclusionRules: exclusionRules?.toDomain(),
    themeColor: themeColor,
    themeVariant: themeVariant,
    enableDragNDrop: enableDragNDrop,
    enablePasteStack: enablePasteStack,
    androidBgListener: androidBgListener,
    richDataCapture: richDataCapture,
    onBoardComplete: onBoardComplete,
    reviewQualifyingEventCount: _sanitizeCounter(reviewQualifyingEventCount),
    lastReviewPromptDate: lastReviewPromptDate,
    reviewNeverAsk: reviewNeverAsk,
    lanInstantSync: lanInstantSync,
    autoWriteOnReceive: autoWriteOnReceive,
  );

  static IsarAppConfig fromDomain(AppConfig config) => IsarAppConfig()
    ..isarId = config.id ?? Isar.autoIncrement
    ..themeMode = config.themeMode
    ..enableSync = config.enableSync
    ..enableFileSync = config.enableFileSync
    ..layout = config.layout
    ..view = config.view
    ..pinned = config.pinned
    ..windowWidth = config.windowWidth
    ..windowHeight = config.windowHeight
    ..dontUploadOver = config.dontUploadOver
    ..dontCopyOver = config.dontCopyOver
    ..pausedTill = config.pausedTill
    ..sortBy = config.sortBy
    ..sortOrder = config.sortOrder
    ..syncSpeed = config.syncSpeed
    ..toggleHotkey = config.toggleHotkey
    ..quickPasteHotkey = config.quickPasteHotkey
    ..pasteStackHotkey = config.pasteStackHotkey
    ..smartPaste = config.smartPaste
    ..transformAsNewClip = config.transformAsNewClip
    ..launchAtStartup = config.launchAtStartup
    ..locale = config.locale
    ..enc2 = config.enc2
    ..autoEncrypt = config.autoEncrypt
    ..useEncryptionNonce = config.useEncryptionNonce
    ..exclusionRules = config.exclusionRules != null
        ? IsarExclusionRules.fromDomain(config.exclusionRules!)
        : null
    ..themeColor = config.themeColor
    ..themeVariant = config.themeVariant
    ..enableDragNDrop = config.enableDragNDrop
    ..enablePasteStack = config.enablePasteStack
    ..androidBgListener = config.androidBgListener
    ..richDataCapture = config.richDataCapture
    ..onBoardComplete = config.onBoardComplete
    ..reviewQualifyingEventCount = _sanitizeCounter(
      config.reviewQualifyingEventCount,
    )
    ..lastReviewPromptDate = config.lastReviewPromptDate
    ..reviewNeverAsk = config.reviewNeverAsk
    ..lanInstantSync = config.lanInstantSync
    ..autoWriteOnReceive = config.autoWriteOnReceive;
}
