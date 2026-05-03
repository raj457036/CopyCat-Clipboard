import 'dart:convert' show jsonDecode;
import 'package:clipboard/base/constants/numbers/file_sizes.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/encryption.dart';
import 'package:clipboard/base/domain/model/base.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

part 'appconfig.freezed.dart';
part 'appconfig.g.dart';

const int defaultThemeColor = 0xFF322C57;

enum AppLayout { grid, list }

enum SyncSpeed { realtime, balanced }

enum AppView { topDocked, bottomDocked, leftDocked, rightDocked, windowed }

@freezed
class AppConfig with _$AppConfig, Identifiable {
  AppConfig._();

  factory AppConfig({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool enableSync,
    @Default(true) bool enableFileSync,
    @Default(AppLayout.grid) AppLayout layout,
    @Default(AppView.windowed) AppView view,
    @Default(false) bool pinned,
    @Default(initialWindowWidth) double windowWidth,
    @Default(initialWindowHeight) double windowHeight,

    // Sorting settings
    @Default(ClipboardSortKey.modified) ClipboardSortKey sortBy,
    @Default(SortOrder.desc) SortOrder sortOrder,

    /// will prevent auto upload for files over 10 MB
    @Default($10MB) int dontUploadOver,

    /// will prevent auto copy for files over 10 MB
    @Default($10MB) int dontCopyOver,

    /// Pause auto copy for till pausedTill is reached.
    DateTime? pausedTill,

    // Auto Sync Interval
    @Default(SyncSpeed.balanced) SyncSpeed syncSpeed,

    // System show/hide toggle hotkey
    String? toggleHotkey,

    // Quick paste popup hotkey
    String? quickPasteHotkey,

    /// If enabled, the primary action on clips will be smartly selected.
    /// The primary action will be paste, which will directly paste the clip
    /// to the last focused cursor in the last window, and the clipboard will minimize.
    @Default(false) bool smartPaste,

    /// If enabled, transformed clips will be saved as new clips instead of
    /// being copied/pasted immediately.
    @Default(false) bool transformAsNewClip,

    /// If enabled, search runs while the user types in the search box.
    @Default(false) bool enableTypeToSearch,

    /// If enabled, the application will automatically start at startup.
    @Default(false) bool launchAtStartup,
    @Default("en") String locale,

    // Security
    String? enc2,
    @Default(false) bool autoEncrypt,
    @Default(false) bool useEncryptionNonce,
    @JsonKey(includeFromJson: false, includeToJson: false)
    ExclusionRules? exclusionRules,

    // Customization
    @Default(defaultThemeColor) int themeColor,
    @Default(DynamicSchemeVariant.tonalSpot) DynamicSchemeVariant themeVariant,

    // Exprimental
    @Default(false) bool enableDragNDrop,
    @Default(false) bool enablePasteStack,
    @Default(false) bool androidBgListener,
    @Default(false) bool duplicatePrevention,
    @Default(false) bool richDataCapture,

    // on boarding
    @Default(true)
    bool onBoardComplete, // On logout/unauth this will be set to true
    // In-App Review tracking
    @Default(0) int reviewQualifyingEventCount,
    DateTime? lastReviewPromptDate,
    @Default(false) bool reviewNeverAsk,

    //? Local App States
    /// last focus window id
    @JsonKey(includeFromJson: false, includeToJson: false)
    int? lastFocusedWindowId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool clockUnSynced,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Size get windowSize {
    final width = windowWidth.isNaN || windowWidth.isNegative
        ? initialWindowWidth
        : windowWidth;
    final height = windowHeight.isNaN || windowHeight.isNegative
        ? initialWindowHeight
        : windowHeight;
    return Size(width, height);
  }

  ExclusionRules get copyExclusionRules =>
      exclusionRules ?? ExclusionRules(enable: false);

  EncryptionSecret? get enc2Key =>
      enc2 != null ? EncryptionSecret.deserilize(enc2!) : null;

  String? decryptEnc2(String? enc1) {
    final enc2Key_ = enc2Key;
    if (enc2Key_ == null || enc1 == null) return null;
    final encMngr = EncryptionManager(enc2Key_);
    final enc1Decrypt = encMngr.decrypt(enc1);
    return enc1Decrypt;
  }

  HotKey? get getToggleHotkey =>
      toggleHotkey != null ? HotKey.fromJson(jsonDecode(toggleHotkey!)) : null;

  HotKey? get getQuickPasteHotkey => quickPasteHotkey != null
      ? HotKey.fromJson(jsonDecode(quickPasteHotkey!))
      : null;

  ColorScheme get lightThemeColorScheme {
    return ColorScheme.fromSeed(
      seedColor: Color(themeColor.isNegative ? defaultThemeColor : themeColor),
      dynamicSchemeVariant: themeVariant,
    );
  }

  ColorScheme get darkThemeColorScheme {
    return ColorScheme.fromSeed(
      seedColor: Color(themeColor.isNegative ? defaultThemeColor : themeColor),
      brightness: Brightness.dark,
      dynamicSchemeVariant: themeVariant,
    );
  }
}
