// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appconfig.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) {
  return _AppConfig.fromJson(json);
}

/// @nodoc
mixin _$AppConfig {
  @JsonKey(includeToJson: false, includeFromJson: false)
  int? get id => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  bool get enableSync => throw _privateConstructorUsedError;
  bool get enableFileSync => throw _privateConstructorUsedError;
  AppLayout get layout => throw _privateConstructorUsedError;
  AppView get view => throw _privateConstructorUsedError;
  bool get pinned => throw _privateConstructorUsedError;
  double get windowWidth => throw _privateConstructorUsedError;
  double get windowHeight =>
      throw _privateConstructorUsedError; // Sorting settings
  ClipboardSortKey get sortBy => throw _privateConstructorUsedError;
  SortOrder get sortOrder => throw _privateConstructorUsedError;

  /// will prevent auto upload for files over 10 MB
  int get dontUploadOver => throw _privateConstructorUsedError;

  /// will prevent auto copy for files over 10 MB
  int get dontCopyOver => throw _privateConstructorUsedError;

  /// Pause auto copy for till pausedTill is reached.
  DateTime? get pausedTill =>
      throw _privateConstructorUsedError; // Auto Sync Interval
  SyncSpeed get syncSpeed =>
      throw _privateConstructorUsedError; // System show/hide toggle hotkey
  String? get toggleHotkey =>
      throw _privateConstructorUsedError; // Quick paste popup hotkey
  String? get quickPasteHotkey => throw _privateConstructorUsedError;

  /// If enabled, the primary action on clips will be smartly selected.
  /// The primary action will be paste, which will directly paste the clip
  /// to the last focused cursor in the last window, and the clipboard will minimize.
  bool get smartPaste => throw _privateConstructorUsedError;

  /// If enabled, transformed clips will be saved as new clips instead of
  /// being copied/pasted immediately.
  bool get transformAsNewClip => throw _privateConstructorUsedError;

  /// If enabled, search runs while the user types in the search box.
  bool get enableTypeToSearch => throw _privateConstructorUsedError;

  /// If enabled, the application will automatically start at startup.
  bool get launchAtStartup => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError; // Security
  String? get enc2 => throw _privateConstructorUsedError;
  bool get autoEncrypt => throw _privateConstructorUsedError;
  bool get useEncryptionNonce => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ExclusionRules? get exclusionRules => throw _privateConstructorUsedError; // Customization
  int get themeColor => throw _privateConstructorUsedError;
  DynamicSchemeVariant get themeVariant =>
      throw _privateConstructorUsedError; // Exprimental
  bool get enableDragNDrop => throw _privateConstructorUsedError;
  bool get enablePasteStack => throw _privateConstructorUsedError;
  bool get androidBgListener => throw _privateConstructorUsedError;
  bool get duplicatePrevention => throw _privateConstructorUsedError;
  bool get richDataCapture =>
      throw _privateConstructorUsedError; // LAN Instant Sync
  bool get lanInstantSync => throw _privateConstructorUsedError;
  bool get lanAutoWrite => throw _privateConstructorUsedError; // on boarding
  bool get onBoardComplete =>
      throw _privateConstructorUsedError; // On logout/unauth this will be set to true
  // In-App Review tracking
  int get reviewQualifyingEventCount => throw _privateConstructorUsedError;
  DateTime? get lastReviewPromptDate => throw _privateConstructorUsedError;
  bool get reviewNeverAsk =>
      throw _privateConstructorUsedError; //? Local App States
  /// last focus window id
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? get lastFocusedWindowId => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get clockUnSynced => throw _privateConstructorUsedError;

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConfigCopyWith<AppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) then) =
      _$AppConfigCopyWithImpl<$Res, AppConfig>;
  @useResult
  $Res call({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    ThemeMode themeMode,
    bool enableSync,
    bool enableFileSync,
    AppLayout layout,
    AppView view,
    bool pinned,
    double windowWidth,
    double windowHeight,
    ClipboardSortKey sortBy,
    SortOrder sortOrder,
    int dontUploadOver,
    int dontCopyOver,
    DateTime? pausedTill,
    SyncSpeed syncSpeed,
    String? toggleHotkey,
    String? quickPasteHotkey,
    bool smartPaste,
    bool transformAsNewClip,
    bool enableTypeToSearch,
    bool launchAtStartup,
    String locale,
    String? enc2,
    bool autoEncrypt,
    bool useEncryptionNonce,
    @JsonKey(includeFromJson: false, includeToJson: false)
    ExclusionRules? exclusionRules,
    int themeColor,
    DynamicSchemeVariant themeVariant,
    bool enableDragNDrop,
    bool enablePasteStack,
    bool androidBgListener,
    bool duplicatePrevention,
    bool richDataCapture,
    bool lanInstantSync,
    bool lanAutoWrite,
    bool onBoardComplete,
    int reviewQualifyingEventCount,
    DateTime? lastReviewPromptDate,
    bool reviewNeverAsk,
    @JsonKey(includeFromJson: false, includeToJson: false)
    int? lastFocusedWindowId,
    @JsonKey(includeFromJson: false, includeToJson: false) bool clockUnSynced,
  });

  $ExclusionRulesCopyWith<$Res>? get exclusionRules;
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res, $Val extends AppConfig>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? themeMode = null,
    Object? enableSync = null,
    Object? enableFileSync = null,
    Object? layout = null,
    Object? view = null,
    Object? pinned = null,
    Object? windowWidth = null,
    Object? windowHeight = null,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? dontUploadOver = null,
    Object? dontCopyOver = null,
    Object? pausedTill = freezed,
    Object? syncSpeed = null,
    Object? toggleHotkey = freezed,
    Object? quickPasteHotkey = freezed,
    Object? smartPaste = null,
    Object? transformAsNewClip = null,
    Object? enableTypeToSearch = null,
    Object? launchAtStartup = null,
    Object? locale = null,
    Object? enc2 = freezed,
    Object? autoEncrypt = null,
    Object? useEncryptionNonce = null,
    Object? exclusionRules = freezed,
    Object? themeColor = null,
    Object? themeVariant = null,
    Object? enableDragNDrop = null,
    Object? enablePasteStack = null,
    Object? androidBgListener = null,
    Object? duplicatePrevention = null,
    Object? richDataCapture = null,
    Object? lanInstantSync = null,
    Object? lanAutoWrite = null,
    Object? onBoardComplete = null,
    Object? reviewQualifyingEventCount = null,
    Object? lastReviewPromptDate = freezed,
    Object? reviewNeverAsk = null,
    Object? lastFocusedWindowId = freezed,
    Object? clockUnSynced = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            enableSync: null == enableSync
                ? _value.enableSync
                : enableSync // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableFileSync: null == enableFileSync
                ? _value.enableFileSync
                : enableFileSync // ignore: cast_nullable_to_non_nullable
                      as bool,
            layout: null == layout
                ? _value.layout
                : layout // ignore: cast_nullable_to_non_nullable
                      as AppLayout,
            view: null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                      as AppView,
            pinned: null == pinned
                ? _value.pinned
                : pinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            windowWidth: null == windowWidth
                ? _value.windowWidth
                : windowWidth // ignore: cast_nullable_to_non_nullable
                      as double,
            windowHeight: null == windowHeight
                ? _value.windowHeight
                : windowHeight // ignore: cast_nullable_to_non_nullable
                      as double,
            sortBy: null == sortBy
                ? _value.sortBy
                : sortBy // ignore: cast_nullable_to_non_nullable
                      as ClipboardSortKey,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as SortOrder,
            dontUploadOver: null == dontUploadOver
                ? _value.dontUploadOver
                : dontUploadOver // ignore: cast_nullable_to_non_nullable
                      as int,
            dontCopyOver: null == dontCopyOver
                ? _value.dontCopyOver
                : dontCopyOver // ignore: cast_nullable_to_non_nullable
                      as int,
            pausedTill: freezed == pausedTill
                ? _value.pausedTill
                : pausedTill // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            syncSpeed: null == syncSpeed
                ? _value.syncSpeed
                : syncSpeed // ignore: cast_nullable_to_non_nullable
                      as SyncSpeed,
            toggleHotkey: freezed == toggleHotkey
                ? _value.toggleHotkey
                : toggleHotkey // ignore: cast_nullable_to_non_nullable
                      as String?,
            quickPasteHotkey: freezed == quickPasteHotkey
                ? _value.quickPasteHotkey
                : quickPasteHotkey // ignore: cast_nullable_to_non_nullable
                      as String?,
            smartPaste: null == smartPaste
                ? _value.smartPaste
                : smartPaste // ignore: cast_nullable_to_non_nullable
                      as bool,
            transformAsNewClip: null == transformAsNewClip
                ? _value.transformAsNewClip
                : transformAsNewClip // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableTypeToSearch: null == enableTypeToSearch
                ? _value.enableTypeToSearch
                : enableTypeToSearch // ignore: cast_nullable_to_non_nullable
                      as bool,
            launchAtStartup: null == launchAtStartup
                ? _value.launchAtStartup
                : launchAtStartup // ignore: cast_nullable_to_non_nullable
                      as bool,
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String,
            enc2: freezed == enc2
                ? _value.enc2
                : enc2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            autoEncrypt: null == autoEncrypt
                ? _value.autoEncrypt
                : autoEncrypt // ignore: cast_nullable_to_non_nullable
                      as bool,
            useEncryptionNonce: null == useEncryptionNonce
                ? _value.useEncryptionNonce
                : useEncryptionNonce // ignore: cast_nullable_to_non_nullable
                      as bool,
            exclusionRules: freezed == exclusionRules
                ? _value.exclusionRules
                : exclusionRules // ignore: cast_nullable_to_non_nullable
                      as ExclusionRules?,
            themeColor: null == themeColor
                ? _value.themeColor
                : themeColor // ignore: cast_nullable_to_non_nullable
                      as int,
            themeVariant: null == themeVariant
                ? _value.themeVariant
                : themeVariant // ignore: cast_nullable_to_non_nullable
                      as DynamicSchemeVariant,
            enableDragNDrop: null == enableDragNDrop
                ? _value.enableDragNDrop
                : enableDragNDrop // ignore: cast_nullable_to_non_nullable
                      as bool,
            enablePasteStack: null == enablePasteStack
                ? _value.enablePasteStack
                : enablePasteStack // ignore: cast_nullable_to_non_nullable
                      as bool,
            androidBgListener: null == androidBgListener
                ? _value.androidBgListener
                : androidBgListener // ignore: cast_nullable_to_non_nullable
                      as bool,
            duplicatePrevention: null == duplicatePrevention
                ? _value.duplicatePrevention
                : duplicatePrevention // ignore: cast_nullable_to_non_nullable
                      as bool,
            richDataCapture: null == richDataCapture
                ? _value.richDataCapture
                : richDataCapture // ignore: cast_nullable_to_non_nullable
                      as bool,
            lanInstantSync: null == lanInstantSync
                ? _value.lanInstantSync
                : lanInstantSync // ignore: cast_nullable_to_non_nullable
                      as bool,
            lanAutoWrite: null == lanAutoWrite
                ? _value.lanAutoWrite
                : lanAutoWrite // ignore: cast_nullable_to_non_nullable
                      as bool,
            onBoardComplete: null == onBoardComplete
                ? _value.onBoardComplete
                : onBoardComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
            reviewQualifyingEventCount: null == reviewQualifyingEventCount
                ? _value.reviewQualifyingEventCount
                : reviewQualifyingEventCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastReviewPromptDate: freezed == lastReviewPromptDate
                ? _value.lastReviewPromptDate
                : lastReviewPromptDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reviewNeverAsk: null == reviewNeverAsk
                ? _value.reviewNeverAsk
                : reviewNeverAsk // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastFocusedWindowId: freezed == lastFocusedWindowId
                ? _value.lastFocusedWindowId
                : lastFocusedWindowId // ignore: cast_nullable_to_non_nullable
                      as int?,
            clockUnSynced: null == clockUnSynced
                ? _value.clockUnSynced
                : clockUnSynced // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExclusionRulesCopyWith<$Res>? get exclusionRules {
    if (_value.exclusionRules == null) {
      return null;
    }

    return $ExclusionRulesCopyWith<$Res>(_value.exclusionRules!, (value) {
      return _then(_value.copyWith(exclusionRules: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppConfigImplCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory _$$AppConfigImplCopyWith(
    _$AppConfigImpl value,
    $Res Function(_$AppConfigImpl) then,
  ) = __$$AppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    ThemeMode themeMode,
    bool enableSync,
    bool enableFileSync,
    AppLayout layout,
    AppView view,
    bool pinned,
    double windowWidth,
    double windowHeight,
    ClipboardSortKey sortBy,
    SortOrder sortOrder,
    int dontUploadOver,
    int dontCopyOver,
    DateTime? pausedTill,
    SyncSpeed syncSpeed,
    String? toggleHotkey,
    String? quickPasteHotkey,
    bool smartPaste,
    bool transformAsNewClip,
    bool enableTypeToSearch,
    bool launchAtStartup,
    String locale,
    String? enc2,
    bool autoEncrypt,
    bool useEncryptionNonce,
    @JsonKey(includeFromJson: false, includeToJson: false)
    ExclusionRules? exclusionRules,
    int themeColor,
    DynamicSchemeVariant themeVariant,
    bool enableDragNDrop,
    bool enablePasteStack,
    bool androidBgListener,
    bool duplicatePrevention,
    bool richDataCapture,
    bool lanInstantSync,
    bool lanAutoWrite,
    bool onBoardComplete,
    int reviewQualifyingEventCount,
    DateTime? lastReviewPromptDate,
    bool reviewNeverAsk,
    @JsonKey(includeFromJson: false, includeToJson: false)
    int? lastFocusedWindowId,
    @JsonKey(includeFromJson: false, includeToJson: false) bool clockUnSynced,
  });

  @override
  $ExclusionRulesCopyWith<$Res>? get exclusionRules;
}

/// @nodoc
class __$$AppConfigImplCopyWithImpl<$Res>
    extends _$AppConfigCopyWithImpl<$Res, _$AppConfigImpl>
    implements _$$AppConfigImplCopyWith<$Res> {
  __$$AppConfigImplCopyWithImpl(
    _$AppConfigImpl _value,
    $Res Function(_$AppConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? themeMode = null,
    Object? enableSync = null,
    Object? enableFileSync = null,
    Object? layout = null,
    Object? view = null,
    Object? pinned = null,
    Object? windowWidth = null,
    Object? windowHeight = null,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? dontUploadOver = null,
    Object? dontCopyOver = null,
    Object? pausedTill = freezed,
    Object? syncSpeed = null,
    Object? toggleHotkey = freezed,
    Object? quickPasteHotkey = freezed,
    Object? smartPaste = null,
    Object? transformAsNewClip = null,
    Object? enableTypeToSearch = null,
    Object? launchAtStartup = null,
    Object? locale = null,
    Object? enc2 = freezed,
    Object? autoEncrypt = null,
    Object? useEncryptionNonce = null,
    Object? exclusionRules = freezed,
    Object? themeColor = null,
    Object? themeVariant = null,
    Object? enableDragNDrop = null,
    Object? enablePasteStack = null,
    Object? androidBgListener = null,
    Object? duplicatePrevention = null,
    Object? richDataCapture = null,
    Object? lanInstantSync = null,
    Object? lanAutoWrite = null,
    Object? onBoardComplete = null,
    Object? reviewQualifyingEventCount = null,
    Object? lastReviewPromptDate = freezed,
    Object? reviewNeverAsk = null,
    Object? lastFocusedWindowId = freezed,
    Object? clockUnSynced = null,
  }) {
    return _then(
      _$AppConfigImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        enableSync: null == enableSync
            ? _value.enableSync
            : enableSync // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableFileSync: null == enableFileSync
            ? _value.enableFileSync
            : enableFileSync // ignore: cast_nullable_to_non_nullable
                  as bool,
        layout: null == layout
            ? _value.layout
            : layout // ignore: cast_nullable_to_non_nullable
                  as AppLayout,
        view: null == view
            ? _value.view
            : view // ignore: cast_nullable_to_non_nullable
                  as AppView,
        pinned: null == pinned
            ? _value.pinned
            : pinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        windowWidth: null == windowWidth
            ? _value.windowWidth
            : windowWidth // ignore: cast_nullable_to_non_nullable
                  as double,
        windowHeight: null == windowHeight
            ? _value.windowHeight
            : windowHeight // ignore: cast_nullable_to_non_nullable
                  as double,
        sortBy: null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as ClipboardSortKey,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as SortOrder,
        dontUploadOver: null == dontUploadOver
            ? _value.dontUploadOver
            : dontUploadOver // ignore: cast_nullable_to_non_nullable
                  as int,
        dontCopyOver: null == dontCopyOver
            ? _value.dontCopyOver
            : dontCopyOver // ignore: cast_nullable_to_non_nullable
                  as int,
        pausedTill: freezed == pausedTill
            ? _value.pausedTill
            : pausedTill // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        syncSpeed: null == syncSpeed
            ? _value.syncSpeed
            : syncSpeed // ignore: cast_nullable_to_non_nullable
                  as SyncSpeed,
        toggleHotkey: freezed == toggleHotkey
            ? _value.toggleHotkey
            : toggleHotkey // ignore: cast_nullable_to_non_nullable
                  as String?,
        quickPasteHotkey: freezed == quickPasteHotkey
            ? _value.quickPasteHotkey
            : quickPasteHotkey // ignore: cast_nullable_to_non_nullable
                  as String?,
        smartPaste: null == smartPaste
            ? _value.smartPaste
            : smartPaste // ignore: cast_nullable_to_non_nullable
                  as bool,
        transformAsNewClip: null == transformAsNewClip
            ? _value.transformAsNewClip
            : transformAsNewClip // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableTypeToSearch: null == enableTypeToSearch
            ? _value.enableTypeToSearch
            : enableTypeToSearch // ignore: cast_nullable_to_non_nullable
                  as bool,
        launchAtStartup: null == launchAtStartup
            ? _value.launchAtStartup
            : launchAtStartup // ignore: cast_nullable_to_non_nullable
                  as bool,
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        enc2: freezed == enc2
            ? _value.enc2
            : enc2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        autoEncrypt: null == autoEncrypt
            ? _value.autoEncrypt
            : autoEncrypt // ignore: cast_nullable_to_non_nullable
                  as bool,
        useEncryptionNonce: null == useEncryptionNonce
            ? _value.useEncryptionNonce
            : useEncryptionNonce // ignore: cast_nullable_to_non_nullable
                  as bool,
        exclusionRules: freezed == exclusionRules
            ? _value.exclusionRules
            : exclusionRules // ignore: cast_nullable_to_non_nullable
                  as ExclusionRules?,
        themeColor: null == themeColor
            ? _value.themeColor
            : themeColor // ignore: cast_nullable_to_non_nullable
                  as int,
        themeVariant: null == themeVariant
            ? _value.themeVariant
            : themeVariant // ignore: cast_nullable_to_non_nullable
                  as DynamicSchemeVariant,
        enableDragNDrop: null == enableDragNDrop
            ? _value.enableDragNDrop
            : enableDragNDrop // ignore: cast_nullable_to_non_nullable
                  as bool,
        enablePasteStack: null == enablePasteStack
            ? _value.enablePasteStack
            : enablePasteStack // ignore: cast_nullable_to_non_nullable
                  as bool,
        androidBgListener: null == androidBgListener
            ? _value.androidBgListener
            : androidBgListener // ignore: cast_nullable_to_non_nullable
                  as bool,
        duplicatePrevention: null == duplicatePrevention
            ? _value.duplicatePrevention
            : duplicatePrevention // ignore: cast_nullable_to_non_nullable
                  as bool,
        richDataCapture: null == richDataCapture
            ? _value.richDataCapture
            : richDataCapture // ignore: cast_nullable_to_non_nullable
                  as bool,
        lanInstantSync: null == lanInstantSync
            ? _value.lanInstantSync
            : lanInstantSync // ignore: cast_nullable_to_non_nullable
                  as bool,
        lanAutoWrite: null == lanAutoWrite
            ? _value.lanAutoWrite
            : lanAutoWrite // ignore: cast_nullable_to_non_nullable
                  as bool,
        onBoardComplete: null == onBoardComplete
            ? _value.onBoardComplete
            : onBoardComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
        reviewQualifyingEventCount: null == reviewQualifyingEventCount
            ? _value.reviewQualifyingEventCount
            : reviewQualifyingEventCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastReviewPromptDate: freezed == lastReviewPromptDate
            ? _value.lastReviewPromptDate
            : lastReviewPromptDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewNeverAsk: null == reviewNeverAsk
            ? _value.reviewNeverAsk
            : reviewNeverAsk // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastFocusedWindowId: freezed == lastFocusedWindowId
            ? _value.lastFocusedWindowId
            : lastFocusedWindowId // ignore: cast_nullable_to_non_nullable
                  as int?,
        clockUnSynced: null == clockUnSynced
            ? _value.clockUnSynced
            : clockUnSynced // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppConfigImpl extends _AppConfig {
  _$AppConfigImpl({
    @JsonKey(includeToJson: false, includeFromJson: false) this.id,
    this.themeMode = ThemeMode.system,
    this.enableSync = true,
    this.enableFileSync = true,
    this.layout = AppLayout.grid,
    this.view = AppView.windowed,
    this.pinned = false,
    this.windowWidth = initialWindowWidth,
    this.windowHeight = initialWindowHeight,
    this.sortBy = ClipboardSortKey.modified,
    this.sortOrder = SortOrder.desc,
    this.dontUploadOver = $10MB,
    this.dontCopyOver = $10MB,
    this.pausedTill,
    this.syncSpeed = SyncSpeed.balanced,
    this.toggleHotkey,
    this.quickPasteHotkey,
    this.smartPaste = false,
    this.transformAsNewClip = false,
    this.enableTypeToSearch = false,
    this.launchAtStartup = false,
    this.locale = "en",
    this.enc2,
    this.autoEncrypt = false,
    this.useEncryptionNonce = false,
    @JsonKey(includeFromJson: false, includeToJson: false) this.exclusionRules,
    this.themeColor = defaultThemeColor,
    this.themeVariant = DynamicSchemeVariant.tonalSpot,
    this.enableDragNDrop = false,
    this.enablePasteStack = false,
    this.androidBgListener = false,
    this.duplicatePrevention = false,
    this.richDataCapture = false,
    this.lanInstantSync = false,
    this.lanAutoWrite = false,
    this.onBoardComplete = true,
    this.reviewQualifyingEventCount = 0,
    this.lastReviewPromptDate,
    this.reviewNeverAsk = false,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.lastFocusedWindowId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.clockUnSynced = false,
  }) : super._();

  factory _$AppConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppConfigImplFromJson(json);

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final int? id;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final bool enableSync;
  @override
  @JsonKey()
  final bool enableFileSync;
  @override
  @JsonKey()
  final AppLayout layout;
  @override
  @JsonKey()
  final AppView view;
  @override
  @JsonKey()
  final bool pinned;
  @override
  @JsonKey()
  final double windowWidth;
  @override
  @JsonKey()
  final double windowHeight;
  // Sorting settings
  @override
  @JsonKey()
  final ClipboardSortKey sortBy;
  @override
  @JsonKey()
  final SortOrder sortOrder;

  /// will prevent auto upload for files over 10 MB
  @override
  @JsonKey()
  final int dontUploadOver;

  /// will prevent auto copy for files over 10 MB
  @override
  @JsonKey()
  final int dontCopyOver;

  /// Pause auto copy for till pausedTill is reached.
  @override
  final DateTime? pausedTill;
  // Auto Sync Interval
  @override
  @JsonKey()
  final SyncSpeed syncSpeed;
  // System show/hide toggle hotkey
  @override
  final String? toggleHotkey;
  // Quick paste popup hotkey
  @override
  final String? quickPasteHotkey;

  /// If enabled, the primary action on clips will be smartly selected.
  /// The primary action will be paste, which will directly paste the clip
  /// to the last focused cursor in the last window, and the clipboard will minimize.
  @override
  @JsonKey()
  final bool smartPaste;

  /// If enabled, transformed clips will be saved as new clips instead of
  /// being copied/pasted immediately.
  @override
  @JsonKey()
  final bool transformAsNewClip;

  /// If enabled, search runs while the user types in the search box.
  @override
  @JsonKey()
  final bool enableTypeToSearch;

  /// If enabled, the application will automatically start at startup.
  @override
  @JsonKey()
  final bool launchAtStartup;
  @override
  @JsonKey()
  final String locale;
  // Security
  @override
  final String? enc2;
  @override
  @JsonKey()
  final bool autoEncrypt;
  @override
  @JsonKey()
  final bool useEncryptionNonce;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ExclusionRules? exclusionRules;
  // Customization
  @override
  @JsonKey()
  final int themeColor;
  @override
  @JsonKey()
  final DynamicSchemeVariant themeVariant;
  // Exprimental
  @override
  @JsonKey()
  final bool enableDragNDrop;
  @override
  @JsonKey()
  final bool enablePasteStack;
  @override
  @JsonKey()
  final bool androidBgListener;
  @override
  @JsonKey()
  final bool duplicatePrevention;
  @override
  @JsonKey()
  final bool richDataCapture;
  // LAN Instant Sync
  @override
  @JsonKey()
  final bool lanInstantSync;
  @override
  @JsonKey()
  final bool lanAutoWrite;
  // on boarding
  @override
  @JsonKey()
  final bool onBoardComplete;
  // On logout/unauth this will be set to true
  // In-App Review tracking
  @override
  @JsonKey()
  final int reviewQualifyingEventCount;
  @override
  final DateTime? lastReviewPromptDate;
  @override
  @JsonKey()
  final bool reviewNeverAsk;
  //? Local App States
  /// last focus window id
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int? lastFocusedWindowId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool clockUnSynced;

  @override
  String toString() {
    return 'AppConfig(id: $id, themeMode: $themeMode, enableSync: $enableSync, enableFileSync: $enableFileSync, layout: $layout, view: $view, pinned: $pinned, windowWidth: $windowWidth, windowHeight: $windowHeight, sortBy: $sortBy, sortOrder: $sortOrder, dontUploadOver: $dontUploadOver, dontCopyOver: $dontCopyOver, pausedTill: $pausedTill, syncSpeed: $syncSpeed, toggleHotkey: $toggleHotkey, quickPasteHotkey: $quickPasteHotkey, smartPaste: $smartPaste, transformAsNewClip: $transformAsNewClip, enableTypeToSearch: $enableTypeToSearch, launchAtStartup: $launchAtStartup, locale: $locale, enc2: $enc2, autoEncrypt: $autoEncrypt, useEncryptionNonce: $useEncryptionNonce, exclusionRules: $exclusionRules, themeColor: $themeColor, themeVariant: $themeVariant, enableDragNDrop: $enableDragNDrop, enablePasteStack: $enablePasteStack, androidBgListener: $androidBgListener, duplicatePrevention: $duplicatePrevention, richDataCapture: $richDataCapture, lanInstantSync: $lanInstantSync, lanAutoWrite: $lanAutoWrite, onBoardComplete: $onBoardComplete, reviewQualifyingEventCount: $reviewQualifyingEventCount, lastReviewPromptDate: $lastReviewPromptDate, reviewNeverAsk: $reviewNeverAsk, lastFocusedWindowId: $lastFocusedWindowId, clockUnSynced: $clockUnSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.enableSync, enableSync) ||
                other.enableSync == enableSync) &&
            (identical(other.enableFileSync, enableFileSync) ||
                other.enableFileSync == enableFileSync) &&
            (identical(other.layout, layout) || other.layout == layout) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.windowWidth, windowWidth) ||
                other.windowWidth == windowWidth) &&
            (identical(other.windowHeight, windowHeight) ||
                other.windowHeight == windowHeight) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.dontUploadOver, dontUploadOver) ||
                other.dontUploadOver == dontUploadOver) &&
            (identical(other.dontCopyOver, dontCopyOver) ||
                other.dontCopyOver == dontCopyOver) &&
            (identical(other.pausedTill, pausedTill) ||
                other.pausedTill == pausedTill) &&
            (identical(other.syncSpeed, syncSpeed) ||
                other.syncSpeed == syncSpeed) &&
            (identical(other.toggleHotkey, toggleHotkey) ||
                other.toggleHotkey == toggleHotkey) &&
            (identical(other.quickPasteHotkey, quickPasteHotkey) ||
                other.quickPasteHotkey == quickPasteHotkey) &&
            (identical(other.smartPaste, smartPaste) ||
                other.smartPaste == smartPaste) &&
            (identical(other.transformAsNewClip, transformAsNewClip) ||
                other.transformAsNewClip == transformAsNewClip) &&
            (identical(other.enableTypeToSearch, enableTypeToSearch) ||
                other.enableTypeToSearch == enableTypeToSearch) &&
            (identical(other.launchAtStartup, launchAtStartup) ||
                other.launchAtStartup == launchAtStartup) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.enc2, enc2) || other.enc2 == enc2) &&
            (identical(other.autoEncrypt, autoEncrypt) ||
                other.autoEncrypt == autoEncrypt) &&
            (identical(other.useEncryptionNonce, useEncryptionNonce) ||
                other.useEncryptionNonce == useEncryptionNonce) &&
            (identical(other.exclusionRules, exclusionRules) ||
                other.exclusionRules == exclusionRules) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.themeVariant, themeVariant) ||
                other.themeVariant == themeVariant) &&
            (identical(other.enableDragNDrop, enableDragNDrop) ||
                other.enableDragNDrop == enableDragNDrop) &&
            (identical(other.enablePasteStack, enablePasteStack) ||
                other.enablePasteStack == enablePasteStack) &&
            (identical(other.androidBgListener, androidBgListener) ||
                other.androidBgListener == androidBgListener) &&
            (identical(other.duplicatePrevention, duplicatePrevention) ||
                other.duplicatePrevention == duplicatePrevention) &&
            (identical(other.richDataCapture, richDataCapture) ||
                other.richDataCapture == richDataCapture) &&
            (identical(other.lanInstantSync, lanInstantSync) ||
                other.lanInstantSync == lanInstantSync) &&
            (identical(other.lanAutoWrite, lanAutoWrite) ||
                other.lanAutoWrite == lanAutoWrite) &&
            (identical(other.onBoardComplete, onBoardComplete) ||
                other.onBoardComplete == onBoardComplete) &&
            (identical(
                  other.reviewQualifyingEventCount,
                  reviewQualifyingEventCount,
                ) ||
                other.reviewQualifyingEventCount ==
                    reviewQualifyingEventCount) &&
            (identical(other.lastReviewPromptDate, lastReviewPromptDate) ||
                other.lastReviewPromptDate == lastReviewPromptDate) &&
            (identical(other.reviewNeverAsk, reviewNeverAsk) ||
                other.reviewNeverAsk == reviewNeverAsk) &&
            (identical(other.lastFocusedWindowId, lastFocusedWindowId) ||
                other.lastFocusedWindowId == lastFocusedWindowId) &&
            (identical(other.clockUnSynced, clockUnSynced) ||
                other.clockUnSynced == clockUnSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    themeMode,
    enableSync,
    enableFileSync,
    layout,
    view,
    pinned,
    windowWidth,
    windowHeight,
    sortBy,
    sortOrder,
    dontUploadOver,
    dontCopyOver,
    pausedTill,
    syncSpeed,
    toggleHotkey,
    quickPasteHotkey,
    smartPaste,
    transformAsNewClip,
    enableTypeToSearch,
    launchAtStartup,
    locale,
    enc2,
    autoEncrypt,
    useEncryptionNonce,
    exclusionRules,
    themeColor,
    themeVariant,
    enableDragNDrop,
    enablePasteStack,
    androidBgListener,
    duplicatePrevention,
    richDataCapture,
    lanInstantSync,
    lanAutoWrite,
    onBoardComplete,
    reviewQualifyingEventCount,
    lastReviewPromptDate,
    reviewNeverAsk,
    lastFocusedWindowId,
    clockUnSynced,
  ]);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      __$$AppConfigImplCopyWithImpl<_$AppConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppConfigImplToJson(this);
  }
}

abstract class _AppConfig extends AppConfig {
  factory _AppConfig({
    @JsonKey(includeToJson: false, includeFromJson: false) final int? id,
    final ThemeMode themeMode,
    final bool enableSync,
    final bool enableFileSync,
    final AppLayout layout,
    final AppView view,
    final bool pinned,
    final double windowWidth,
    final double windowHeight,
    final ClipboardSortKey sortBy,
    final SortOrder sortOrder,
    final int dontUploadOver,
    final int dontCopyOver,
    final DateTime? pausedTill,
    final SyncSpeed syncSpeed,
    final String? toggleHotkey,
    final String? quickPasteHotkey,
    final bool smartPaste,
    final bool transformAsNewClip,
    final bool enableTypeToSearch,
    final bool launchAtStartup,
    final String locale,
    final String? enc2,
    final bool autoEncrypt,
    final bool useEncryptionNonce,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final ExclusionRules? exclusionRules,
    final int themeColor,
    final DynamicSchemeVariant themeVariant,
    final bool enableDragNDrop,
    final bool enablePasteStack,
    final bool androidBgListener,
    final bool duplicatePrevention,
    final bool richDataCapture,
    final bool lanInstantSync,
    final bool lanAutoWrite,
    final bool onBoardComplete,
    final int reviewQualifyingEventCount,
    final DateTime? lastReviewPromptDate,
    final bool reviewNeverAsk,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final int? lastFocusedWindowId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final bool clockUnSynced,
  }) = _$AppConfigImpl;
  _AppConfig._() : super._();

  factory _AppConfig.fromJson(Map<String, dynamic> json) =
      _$AppConfigImpl.fromJson;

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  int? get id;
  @override
  ThemeMode get themeMode;
  @override
  bool get enableSync;
  @override
  bool get enableFileSync;
  @override
  AppLayout get layout;
  @override
  AppView get view;
  @override
  bool get pinned;
  @override
  double get windowWidth;
  @override
  double get windowHeight; // Sorting settings
  @override
  ClipboardSortKey get sortBy;
  @override
  SortOrder get sortOrder;

  /// will prevent auto upload for files over 10 MB
  @override
  int get dontUploadOver;

  /// will prevent auto copy for files over 10 MB
  @override
  int get dontCopyOver;

  /// Pause auto copy for till pausedTill is reached.
  @override
  DateTime? get pausedTill; // Auto Sync Interval
  @override
  SyncSpeed get syncSpeed; // System show/hide toggle hotkey
  @override
  String? get toggleHotkey; // Quick paste popup hotkey
  @override
  String? get quickPasteHotkey;

  /// If enabled, the primary action on clips will be smartly selected.
  /// The primary action will be paste, which will directly paste the clip
  /// to the last focused cursor in the last window, and the clipboard will minimize.
  @override
  bool get smartPaste;

  /// If enabled, transformed clips will be saved as new clips instead of
  /// being copied/pasted immediately.
  @override
  bool get transformAsNewClip;

  /// If enabled, search runs while the user types in the search box.
  @override
  bool get enableTypeToSearch;

  /// If enabled, the application will automatically start at startup.
  @override
  bool get launchAtStartup;
  @override
  String get locale; // Security
  @override
  String? get enc2;
  @override
  bool get autoEncrypt;
  @override
  bool get useEncryptionNonce;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  ExclusionRules? get exclusionRules; // Customization
  @override
  int get themeColor;
  @override
  DynamicSchemeVariant get themeVariant; // Exprimental
  @override
  bool get enableDragNDrop;
  @override
  bool get enablePasteStack;
  @override
  bool get androidBgListener;
  @override
  bool get duplicatePrevention;
  @override
  bool get richDataCapture; // LAN Instant Sync
  @override
  bool get lanInstantSync;
  @override
  bool get lanAutoWrite; // on boarding
  @override
  bool get onBoardComplete; // On logout/unauth this will be set to true
  // In-App Review tracking
  @override
  int get reviewQualifyingEventCount;
  @override
  DateTime? get lastReviewPromptDate;
  @override
  bool get reviewNeverAsk; //? Local App States
  /// last focus window id
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? get lastFocusedWindowId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get clockUnSynced;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
