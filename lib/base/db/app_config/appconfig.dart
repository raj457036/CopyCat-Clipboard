import 'dart:convert' show jsonDecode;

import 'package:clipboard/base/constants/numbers/file_sizes.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/encryption.dart';
import 'package:clipboard/base/db/base.dart';
import 'package:clipboard/base/db/exclusion_rules/exclusion_rules.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:isar_community/isar.dart';

part 'appconfig.freezed.dart';
part 'appconfig.g.dart';

const int defaultThemeColor = 0xFF322C57;

enum AppLayout { grid, list }

enum SyncSpeed { realtime, balanced }

enum AppView {
  topDocked,
  bottomDocked,
  leftDocked,
  rightDocked,
  windowed,
}

@freezed
@Collection(ignore: {"copyWith"})
class AppConfig with _$AppConfig, IsarIdMixin {
  AppConfig._();

  factory AppConfig({
    @Default(ThemeMode.system) @Enumerated(EnumType.name) ThemeMode themeMode,
    @Default(true) bool enableSync,
    @Default(true) bool enableFileSync,
    @Default(AppLayout.grid) @Enumerated(EnumType.name) AppLayout layout,
    @Default(AppView.windowed) @Enumerated(EnumType.name) AppView view,
    @Default(false) bool pinned,
    @Default(initialWindowWidth) double windowWidth,
    @Default(initialWindowHeight) double windowHeight,

    /// will prevent auto upload for files over 10 MB
    @Default($10MB) int dontUploadOver,

    /// will prevent auto copy for files over 10 MB
    @Default($10MB) int dontCopyOver,

    /// Pause auto copy for till pausedTill is reached.
    DateTime? pausedTill,

    // Auto Sync Interval
    @Default(SyncSpeed.balanced) @Enumerated(EnumType.name) SyncSpeed syncSpeed,

    // System show/hide toggle hotkey
    String? toggleHotkey,

    /// If enabled, the primary action on clips will be smartly selected.
    /// The primary action will be paste, which will directly paste the clip
    /// to the last focused cursor in the last window, and the clipboard will minimize.
    @Default(false) bool smartPaste,

    /// If enabled, the application will automatically start at startup.
    @Default(false) bool launchAtStartup,
    @Default("en") String locale,

    // Security
    String? enc2,
    @Default(false) bool autoEncrypt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    ExclusionRules? exclusionRules,

    // Customization
    @Default(defaultThemeColor) int themeColor,
    @Default(DynamicSchemeVariant.tonalSpot)
    @Enumerated(EnumType.name)
    DynamicSchemeVariant themeVariant,

    // Exprimental
    @Default(false) bool enableDragNDrop,
    @Default(false) bool enablePasteStack,
    @Default(false) bool androidBgListener,
    @Default(false) bool duplicatePrevention,

    // on boarding
    @Default(true)
    bool onBoardComplete, // On logout/unauth this will be set to true

    //? Local App States
    /// last focus window id
    @ignore
    @JsonKey(includeFromJson: false, includeToJson: false)
    int? lastFocusedWindowId,
    @ignore @Default(false) bool clockUnSynced,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  @ignore
  Size get windowSize {
    final width = windowWidth.isNaN || windowWidth.isNegative
        ? initialWindowWidth
        : windowWidth;
    final height = windowHeight.isNaN || windowHeight.isNegative
        ? initialWindowHeight
        : windowHeight;
    return Size(width, height);
  }

  @ignore
  ExclusionRules get copyExclusionRules =>
      exclusionRules ?? ExclusionRules(enable: false);

  @ignore
  EncryptionSecret? get enc2Key =>
      enc2 != null ? EncryptionSecret.deserilize(enc2!) : null;

  String? decryptEnc2(String? enc1) {
    final enc2Key_ = enc2Key;
    if (enc2Key_ == null || enc1 == null) return null;
    final encMngr = EncryptionManager(enc2Key_);
    final enc1Decrypt = encMngr.decrypt(enc1);
    return enc1Decrypt;
  }

  @ignore
  HotKey? get getToggleHotkey =>
      toggleHotkey != null ? HotKey.fromJson(jsonDecode(toggleHotkey!)) : null;

  @ignore
  ColorScheme get lightThemeColorScheme {
    return ColorScheme.fromSeed(
      seedColor: Color(themeColor.isNegative ? defaultThemeColor : themeColor),
      dynamicSchemeVariant: themeVariant,
    );
  }

  @ignore
  ColorScheme get darkThemeColorScheme {
    return ColorScheme.fromSeed(
      seedColor: Color(themeColor.isNegative ? defaultThemeColor : themeColor),
      brightness: Brightness.dark,
      dynamicSchemeVariant: themeVariant,
    );
  }
}
