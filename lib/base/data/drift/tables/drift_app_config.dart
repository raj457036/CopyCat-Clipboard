import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/tables/drift_exclusion_rules.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' hide Table;

@DataClassName('DriftAppConfigEntry')
class DriftAppConfigTable extends Table {
  @override
  String get tableName => 'app_config';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get enableSync => boolean().withDefault(const Constant(true))();
  BoolColumn get enableFileSync => boolean().withDefault(const Constant(true))();
  TextColumn get layout => text().withDefault(const Constant('grid'))();
  TextColumn get view => text().withDefault(const Constant('windowed'))();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  RealColumn get windowWidth => real().withDefault(const Constant(1280.0))();
  RealColumn get windowHeight => real().withDefault(const Constant(720.0))();

  TextColumn get sortBy => text().withDefault(const Constant('modified'))();
  TextColumn get sortOrder => text().withDefault(const Constant('desc'))();
  IntColumn get dontUploadOver => integer().withDefault(const Constant(10485760))();
  IntColumn get dontCopyOver => integer().withDefault(const Constant(10485760))();
  DateTimeColumn get pausedTill => dateTime().nullable()();
  TextColumn get syncSpeed => text().withDefault(const Constant('balanced'))();
  TextColumn get toggleHotkey => text().nullable()();
  TextColumn get quickPasteHotkey => text().nullable()();
  TextColumn get pasteStackHotkey => text().nullable()();
  BoolColumn get smartPaste => boolean().withDefault(const Constant(false))();
  BoolColumn get keepWindowOpenOnUnfocus => boolean().withDefault(const Constant(true))();
  BoolColumn get transformAsNewClip => boolean().withDefault(const Constant(false))();
  BoolColumn get launchAtStartup => boolean().withDefault(const Constant(false))();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  TextColumn get enc2 => text().nullable()();
  BoolColumn get autoEncrypt => boolean().withDefault(const Constant(false))();
  BoolColumn get useEncryptionNonce => boolean().withDefault(const Constant(false))();
  TextColumn get exclusionRules => text().map(const ExclusionRulesConverter()).nullable()();
  IntColumn get themeColor => integer().withDefault(const Constant(0xFF322C57))();
  TextColumn get themeVariant => text().withDefault(const Constant('tonalSpot'))();
  BoolColumn get enableDragNDrop => boolean().withDefault(const Constant(false))();
  BoolColumn get enablePasteStack => boolean().withDefault(const Constant(false))();
  BoolColumn get androidBgListener => boolean().withDefault(const Constant(false))();
  BoolColumn get richDataCapture => boolean().withDefault(const Constant(false))();
  BoolColumn get onBoardComplete => boolean().withDefault(const Constant(true))();
  IntColumn get reviewQualifyingEventCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewPromptDate => dateTime().nullable()();
  BoolColumn get reviewNeverAsk => boolean().withDefault(const Constant(false))();
  BoolColumn get lanInstantSync => boolean().withDefault(const Constant(false))();
  BoolColumn get autoWriteOnReceive => boolean().withDefault(const Constant(false))();
  BoolColumn get enableTypeToSearch => boolean().withDefault(const Constant(false))();
  BoolColumn get hideFromScreenCapture => boolean().withDefault(const Constant(true))();
  BoolColumn get showTrayIcon => boolean().withDefault(const Constant(true))();
  TextColumn get clipboardFeedbackMode => text().withDefault(const Constant('toast'))();
  BoolColumn get enableLocalAuth => boolean().withDefault(const Constant(false))();
  IntColumn get localAuthTimeoutMinutes => integer().withDefault(const Constant(1))();
  BoolColumn get showCollectionTip => boolean().withDefault(const Constant(true))();
  BoolColumn get searchIndexReady => boolean().withDefault(const Constant(false))();

  static AppConfig toDomain(DriftAppConfigEntry entry) => AppConfig(
        id: entry.id,
        themeMode: ThemeMode.values.firstWhere((e) => e.name == entry.themeMode, orElse: () => ThemeMode.system),
        enableSync: entry.enableSync,
        enableFileSync: entry.enableFileSync,
        layout: AppLayout.values.firstWhere((e) => e.name == entry.layout, orElse: () => AppLayout.grid),
        view: AppView.values.firstWhere((e) => e.name == entry.view, orElse: () => AppView.windowed),
        pinned: entry.pinned,
        windowWidth: entry.windowWidth,
        windowHeight: entry.windowHeight,
        dontUploadOver: entry.dontUploadOver,
        dontCopyOver: entry.dontCopyOver,
        pausedTill: entry.pausedTill,
        sortBy: ClipboardSortKey.values.firstWhere((e) => e.name == entry.sortBy, orElse: () => ClipboardSortKey.modified),
        sortOrder: SortOrder.values.firstWhere((e) => e.name == entry.sortOrder, orElse: () => SortOrder.desc),
        syncSpeed: SyncSpeed.values.firstWhere((e) => e.name == entry.syncSpeed, orElse: () => SyncSpeed.balanced),
        toggleHotkey: entry.toggleHotkey,
        quickPasteHotkey: entry.quickPasteHotkey,
        pasteStackHotkey: entry.pasteStackHotkey,
        smartPaste: entry.smartPaste,
        keepWindowOpenOnUnfocus: entry.keepWindowOpenOnUnfocus,
        transformAsNewClip: entry.transformAsNewClip,
        launchAtStartup: entry.launchAtStartup,
        locale: entry.locale,
        enc2: entry.enc2,
        autoEncrypt: entry.autoEncrypt,
        useEncryptionNonce: entry.useEncryptionNonce,
        exclusionRules: entry.exclusionRules,
        themeColor: entry.themeColor,
        themeVariant: DynamicSchemeVariant.values.firstWhere((e) => e.name == entry.themeVariant, orElse: () => DynamicSchemeVariant.tonalSpot),
        enableDragNDrop: entry.enableDragNDrop,
        enablePasteStack: entry.enablePasteStack,
        androidBgListener: entry.androidBgListener,
        richDataCapture: entry.richDataCapture,
        onBoardComplete: entry.onBoardComplete,
        reviewQualifyingEventCount: entry.reviewQualifyingEventCount,
        lastReviewPromptDate: entry.lastReviewPromptDate,
        reviewNeverAsk: entry.reviewNeverAsk,
        lanInstantSync: entry.lanInstantSync,
        autoWriteOnReceive: entry.autoWriteOnReceive,
        enableLocalAuth: entry.enableLocalAuth,
        localAuthTimeoutMinutes: entry.localAuthTimeoutMinutes,
        showCollectionTip: entry.showCollectionTip,
        enableTypeToSearch: entry.enableTypeToSearch,
        hideFromScreenCapture: entry.hideFromScreenCapture,
        showTrayIcon: entry.showTrayIcon,
        searchIndexReady: entry.searchIndexReady,
        clipboardFeedbackMode: ClipboardFeedbackMode.values.firstWhere((e) => e.name == entry.clipboardFeedbackMode, orElse: () => ClipboardFeedbackMode.toast),
      );

  static DriftAppConfigTableCompanion fromDomain(AppConfig config) => DriftAppConfigTableCompanion.insert(
        id: config.id != null ? Value(config.id!) : const Value.absent(),
        themeMode: Value(config.themeMode.name),
        enableSync: Value(config.enableSync),
        enableFileSync: Value(config.enableFileSync),
        layout: Value(config.layout.name),
        view: Value(config.view.name),
        pinned: Value(config.pinned),
        windowWidth: Value(config.windowWidth),
        windowHeight: Value(config.windowHeight),
        dontUploadOver: Value(config.dontUploadOver),
        dontCopyOver: Value(config.dontCopyOver),
        pausedTill: Value(config.pausedTill),
        sortBy: Value(config.sortBy.name),
        sortOrder: Value(config.sortOrder.name),
        syncSpeed: Value(config.syncSpeed.name),
        toggleHotkey: Value(config.toggleHotkey),
        quickPasteHotkey: Value(config.quickPasteHotkey),
        pasteStackHotkey: Value(config.pasteStackHotkey),
        smartPaste: Value(config.smartPaste),
        keepWindowOpenOnUnfocus: Value(config.keepWindowOpenOnUnfocus),
        transformAsNewClip: Value(config.transformAsNewClip),
        launchAtStartup: Value(config.launchAtStartup),
        locale: Value(config.locale),
        enc2: Value(config.enc2),
        autoEncrypt: Value(config.autoEncrypt),
        useEncryptionNonce: Value(config.useEncryptionNonce),
        exclusionRules: Value(config.exclusionRules),
        themeColor: Value(config.themeColor),
        themeVariant: Value(config.themeVariant.name),
        enableDragNDrop: Value(config.enableDragNDrop),
        enablePasteStack: Value(config.enablePasteStack),
        androidBgListener: Value(config.androidBgListener),
        richDataCapture: Value(config.richDataCapture),
        onBoardComplete: Value(config.onBoardComplete),
        reviewQualifyingEventCount: Value(config.reviewQualifyingEventCount),
        lastReviewPromptDate: Value(config.lastReviewPromptDate),
        reviewNeverAsk: Value(config.reviewNeverAsk),
        lanInstantSync: Value(config.lanInstantSync),
        autoWriteOnReceive: Value(config.autoWriteOnReceive),
        enableTypeToSearch: Value(config.enableTypeToSearch),
        hideFromScreenCapture: Value(config.hideFromScreenCapture),
        showTrayIcon: Value(config.showTrayIcon),
        clipboardFeedbackMode: Value(config.clipboardFeedbackMode.name),
        enableLocalAuth: Value(config.enableLocalAuth),
        localAuthTimeoutMinutes: Value(config.localAuthTimeoutMinutes),
        showCollectionTip: Value(config.showCollectionTip),
        searchIndexReady: Value(config.searchIndexReady),
      );
}
