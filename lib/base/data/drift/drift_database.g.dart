// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $DriftAppConfigTableTable extends DriftAppConfigTable
    with TableInfo<$DriftAppConfigTableTable, DriftAppConfigEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftAppConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _enableSyncMeta = const VerificationMeta(
    'enableSync',
  );
  @override
  late final GeneratedColumn<bool> enableSync = GeneratedColumn<bool>(
    'enable_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _enableFileSyncMeta = const VerificationMeta(
    'enableFileSync',
  );
  @override
  late final GeneratedColumn<bool> enableFileSync = GeneratedColumn<bool>(
    'enable_file_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_file_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _layoutMeta = const VerificationMeta('layout');
  @override
  late final GeneratedColumn<String> layout = GeneratedColumn<String>(
    'layout',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('grid'),
  );
  static const VerificationMeta _viewMeta = const VerificationMeta('view');
  @override
  late final GeneratedColumn<String> view = GeneratedColumn<String>(
    'view',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('windowed'),
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _windowWidthMeta = const VerificationMeta(
    'windowWidth',
  );
  @override
  late final GeneratedColumn<double> windowWidth = GeneratedColumn<double>(
    'window_width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1280.0),
  );
  static const VerificationMeta _windowHeightMeta = const VerificationMeta(
    'windowHeight',
  );
  @override
  late final GeneratedColumn<double> windowHeight = GeneratedColumn<double>(
    'window_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(720.0),
  );
  static const VerificationMeta _sortByMeta = const VerificationMeta('sortBy');
  @override
  late final GeneratedColumn<String> sortBy = GeneratedColumn<String>(
    'sort_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('modified'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<String> sortOrder = GeneratedColumn<String>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('desc'),
  );
  static const VerificationMeta _dontUploadOverMeta = const VerificationMeta(
    'dontUploadOver',
  );
  @override
  late final GeneratedColumn<int> dontUploadOver = GeneratedColumn<int>(
    'dont_upload_over',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10485760),
  );
  static const VerificationMeta _dontCopyOverMeta = const VerificationMeta(
    'dontCopyOver',
  );
  @override
  late final GeneratedColumn<int> dontCopyOver = GeneratedColumn<int>(
    'dont_copy_over',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10485760),
  );
  static const VerificationMeta _pausedTillMeta = const VerificationMeta(
    'pausedTill',
  );
  @override
  late final GeneratedColumn<DateTime> pausedTill = GeneratedColumn<DateTime>(
    'paused_till',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncSpeedMeta = const VerificationMeta(
    'syncSpeed',
  );
  @override
  late final GeneratedColumn<String> syncSpeed = GeneratedColumn<String>(
    'sync_speed',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('balanced'),
  );
  static const VerificationMeta _toggleHotkeyMeta = const VerificationMeta(
    'toggleHotkey',
  );
  @override
  late final GeneratedColumn<String> toggleHotkey = GeneratedColumn<String>(
    'toggle_hotkey',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quickPasteHotkeyMeta = const VerificationMeta(
    'quickPasteHotkey',
  );
  @override
  late final GeneratedColumn<String> quickPasteHotkey = GeneratedColumn<String>(
    'quick_paste_hotkey',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pasteStackHotkeyMeta = const VerificationMeta(
    'pasteStackHotkey',
  );
  @override
  late final GeneratedColumn<String> pasteStackHotkey = GeneratedColumn<String>(
    'paste_stack_hotkey',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smartPasteMeta = const VerificationMeta(
    'smartPaste',
  );
  @override
  late final GeneratedColumn<bool> smartPaste = GeneratedColumn<bool>(
    'smart_paste',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("smart_paste" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _keepWindowOpenOnUnfocusMeta =
      const VerificationMeta('keepWindowOpenOnUnfocus');
  @override
  late final GeneratedColumn<bool> keepWindowOpenOnUnfocus =
      GeneratedColumn<bool>(
        'keep_window_open_on_unfocus',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("keep_window_open_on_unfocus" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _transformAsNewClipMeta =
      const VerificationMeta('transformAsNewClip');
  @override
  late final GeneratedColumn<bool> transformAsNewClip = GeneratedColumn<bool>(
    'transform_as_new_clip',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("transform_as_new_clip" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _launchAtStartupMeta = const VerificationMeta(
    'launchAtStartup',
  );
  @override
  late final GeneratedColumn<bool> launchAtStartup = GeneratedColumn<bool>(
    'launch_at_startup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("launch_at_startup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _enc2Meta = const VerificationMeta('enc2');
  @override
  late final GeneratedColumn<String> enc2 = GeneratedColumn<String>(
    'enc2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoEncryptMeta = const VerificationMeta(
    'autoEncrypt',
  );
  @override
  late final GeneratedColumn<bool> autoEncrypt = GeneratedColumn<bool>(
    'auto_encrypt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_encrypt" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _useEncryptionNonceMeta =
      const VerificationMeta('useEncryptionNonce');
  @override
  late final GeneratedColumn<bool> useEncryptionNonce = GeneratedColumn<bool>(
    'use_encryption_nonce',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_encryption_nonce" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExclusionRules?, String>
  exclusionRules =
      GeneratedColumn<String>(
        'exclusion_rules',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ExclusionRules?>(
        $DriftAppConfigTableTable.$converterexclusionRulesn,
      );
  static const VerificationMeta _themeColorMeta = const VerificationMeta(
    'themeColor',
  );
  @override
  late final GeneratedColumn<int> themeColor = GeneratedColumn<int>(
    'theme_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF322C57),
  );
  static const VerificationMeta _themeVariantMeta = const VerificationMeta(
    'themeVariant',
  );
  @override
  late final GeneratedColumn<String> themeVariant = GeneratedColumn<String>(
    'theme_variant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tonalSpot'),
  );
  static const VerificationMeta _enableDragNDropMeta = const VerificationMeta(
    'enableDragNDrop',
  );
  @override
  late final GeneratedColumn<bool> enableDragNDrop = GeneratedColumn<bool>(
    'enable_drag_n_drop',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_drag_n_drop" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _enablePasteStackMeta = const VerificationMeta(
    'enablePasteStack',
  );
  @override
  late final GeneratedColumn<bool> enablePasteStack = GeneratedColumn<bool>(
    'enable_paste_stack',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_paste_stack" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _androidBgListenerMeta = const VerificationMeta(
    'androidBgListener',
  );
  @override
  late final GeneratedColumn<bool> androidBgListener = GeneratedColumn<bool>(
    'android_bg_listener',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("android_bg_listener" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _richDataCaptureMeta = const VerificationMeta(
    'richDataCapture',
  );
  @override
  late final GeneratedColumn<bool> richDataCapture = GeneratedColumn<bool>(
    'rich_data_capture',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rich_data_capture" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onBoardCompleteMeta = const VerificationMeta(
    'onBoardComplete',
  );
  @override
  late final GeneratedColumn<bool> onBoardComplete = GeneratedColumn<bool>(
    'on_board_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_board_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reviewQualifyingEventCountMeta =
      const VerificationMeta('reviewQualifyingEventCount');
  @override
  late final GeneratedColumn<int> reviewQualifyingEventCount =
      GeneratedColumn<int>(
        'review_qualifying_event_count',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _lastReviewPromptDateMeta =
      const VerificationMeta('lastReviewPromptDate');
  @override
  late final GeneratedColumn<DateTime> lastReviewPromptDate =
      GeneratedColumn<DateTime>(
        'last_review_prompt_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reviewNeverAskMeta = const VerificationMeta(
    'reviewNeverAsk',
  );
  @override
  late final GeneratedColumn<bool> reviewNeverAsk = GeneratedColumn<bool>(
    'review_never_ask',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("review_never_ask" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lanInstantSyncMeta = const VerificationMeta(
    'lanInstantSync',
  );
  @override
  late final GeneratedColumn<bool> lanInstantSync = GeneratedColumn<bool>(
    'lan_instant_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lan_instant_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoWriteOnReceiveMeta =
      const VerificationMeta('autoWriteOnReceive');
  @override
  late final GeneratedColumn<bool> autoWriteOnReceive = GeneratedColumn<bool>(
    'auto_write_on_receive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_write_on_receive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _enableTypeToSearchMeta =
      const VerificationMeta('enableTypeToSearch');
  @override
  late final GeneratedColumn<bool> enableTypeToSearch = GeneratedColumn<bool>(
    'enable_type_to_search',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_type_to_search" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hideFromScreenCaptureMeta =
      const VerificationMeta('hideFromScreenCapture');
  @override
  late final GeneratedColumn<bool> hideFromScreenCapture =
      GeneratedColumn<bool>(
        'hide_from_screen_capture',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_from_screen_capture" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _showTrayIconMeta = const VerificationMeta(
    'showTrayIcon',
  );
  @override
  late final GeneratedColumn<bool> showTrayIcon = GeneratedColumn<bool>(
    'show_tray_icon',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_tray_icon" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _clipboardFeedbackModeMeta =
      const VerificationMeta('clipboardFeedbackMode');
  @override
  late final GeneratedColumn<String> clipboardFeedbackMode =
      GeneratedColumn<String>(
        'clipboard_feedback_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('toast'),
      );
  static const VerificationMeta _enableLocalAuthMeta = const VerificationMeta(
    'enableLocalAuth',
  );
  @override
  late final GeneratedColumn<bool> enableLocalAuth = GeneratedColumn<bool>(
    'enable_local_auth',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_local_auth" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localAuthTimeoutMinutesMeta =
      const VerificationMeta('localAuthTimeoutMinutes');
  @override
  late final GeneratedColumn<int> localAuthTimeoutMinutes =
      GeneratedColumn<int>(
        'local_auth_timeout_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      );
  static const VerificationMeta _showCollectionTipMeta = const VerificationMeta(
    'showCollectionTip',
  );
  @override
  late final GeneratedColumn<bool> showCollectionTip = GeneratedColumn<bool>(
    'show_collection_tip',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_collection_tip" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _searchIndexReadyMeta = const VerificationMeta(
    'searchIndexReady',
  );
  @override
  late final GeneratedColumn<bool> searchIndexReady = GeneratedColumn<bool>(
    'search_index_ready',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("search_index_ready" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
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
    pasteStackHotkey,
    smartPaste,
    keepWindowOpenOnUnfocus,
    transformAsNewClip,
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
    richDataCapture,
    onBoardComplete,
    reviewQualifyingEventCount,
    lastReviewPromptDate,
    reviewNeverAsk,
    lanInstantSync,
    autoWriteOnReceive,
    enableTypeToSearch,
    hideFromScreenCapture,
    showTrayIcon,
    clipboardFeedbackMode,
    enableLocalAuth,
    localAuthTimeoutMinutes,
    showCollectionTip,
    searchIndexReady,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftAppConfigEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('enable_sync')) {
      context.handle(
        _enableSyncMeta,
        enableSync.isAcceptableOrUnknown(data['enable_sync']!, _enableSyncMeta),
      );
    }
    if (data.containsKey('enable_file_sync')) {
      context.handle(
        _enableFileSyncMeta,
        enableFileSync.isAcceptableOrUnknown(
          data['enable_file_sync']!,
          _enableFileSyncMeta,
        ),
      );
    }
    if (data.containsKey('layout')) {
      context.handle(
        _layoutMeta,
        layout.isAcceptableOrUnknown(data['layout']!, _layoutMeta),
      );
    }
    if (data.containsKey('view')) {
      context.handle(
        _viewMeta,
        view.isAcceptableOrUnknown(data['view']!, _viewMeta),
      );
    }
    if (data.containsKey('pinned')) {
      context.handle(
        _pinnedMeta,
        pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta),
      );
    }
    if (data.containsKey('window_width')) {
      context.handle(
        _windowWidthMeta,
        windowWidth.isAcceptableOrUnknown(
          data['window_width']!,
          _windowWidthMeta,
        ),
      );
    }
    if (data.containsKey('window_height')) {
      context.handle(
        _windowHeightMeta,
        windowHeight.isAcceptableOrUnknown(
          data['window_height']!,
          _windowHeightMeta,
        ),
      );
    }
    if (data.containsKey('sort_by')) {
      context.handle(
        _sortByMeta,
        sortBy.isAcceptableOrUnknown(data['sort_by']!, _sortByMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('dont_upload_over')) {
      context.handle(
        _dontUploadOverMeta,
        dontUploadOver.isAcceptableOrUnknown(
          data['dont_upload_over']!,
          _dontUploadOverMeta,
        ),
      );
    }
    if (data.containsKey('dont_copy_over')) {
      context.handle(
        _dontCopyOverMeta,
        dontCopyOver.isAcceptableOrUnknown(
          data['dont_copy_over']!,
          _dontCopyOverMeta,
        ),
      );
    }
    if (data.containsKey('paused_till')) {
      context.handle(
        _pausedTillMeta,
        pausedTill.isAcceptableOrUnknown(data['paused_till']!, _pausedTillMeta),
      );
    }
    if (data.containsKey('sync_speed')) {
      context.handle(
        _syncSpeedMeta,
        syncSpeed.isAcceptableOrUnknown(data['sync_speed']!, _syncSpeedMeta),
      );
    }
    if (data.containsKey('toggle_hotkey')) {
      context.handle(
        _toggleHotkeyMeta,
        toggleHotkey.isAcceptableOrUnknown(
          data['toggle_hotkey']!,
          _toggleHotkeyMeta,
        ),
      );
    }
    if (data.containsKey('quick_paste_hotkey')) {
      context.handle(
        _quickPasteHotkeyMeta,
        quickPasteHotkey.isAcceptableOrUnknown(
          data['quick_paste_hotkey']!,
          _quickPasteHotkeyMeta,
        ),
      );
    }
    if (data.containsKey('paste_stack_hotkey')) {
      context.handle(
        _pasteStackHotkeyMeta,
        pasteStackHotkey.isAcceptableOrUnknown(
          data['paste_stack_hotkey']!,
          _pasteStackHotkeyMeta,
        ),
      );
    }
    if (data.containsKey('smart_paste')) {
      context.handle(
        _smartPasteMeta,
        smartPaste.isAcceptableOrUnknown(data['smart_paste']!, _smartPasteMeta),
      );
    }
    if (data.containsKey('keep_window_open_on_unfocus')) {
      context.handle(
        _keepWindowOpenOnUnfocusMeta,
        keepWindowOpenOnUnfocus.isAcceptableOrUnknown(
          data['keep_window_open_on_unfocus']!,
          _keepWindowOpenOnUnfocusMeta,
        ),
      );
    }
    if (data.containsKey('transform_as_new_clip')) {
      context.handle(
        _transformAsNewClipMeta,
        transformAsNewClip.isAcceptableOrUnknown(
          data['transform_as_new_clip']!,
          _transformAsNewClipMeta,
        ),
      );
    }
    if (data.containsKey('launch_at_startup')) {
      context.handle(
        _launchAtStartupMeta,
        launchAtStartup.isAcceptableOrUnknown(
          data['launch_at_startup']!,
          _launchAtStartupMeta,
        ),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('enc2')) {
      context.handle(
        _enc2Meta,
        enc2.isAcceptableOrUnknown(data['enc2']!, _enc2Meta),
      );
    }
    if (data.containsKey('auto_encrypt')) {
      context.handle(
        _autoEncryptMeta,
        autoEncrypt.isAcceptableOrUnknown(
          data['auto_encrypt']!,
          _autoEncryptMeta,
        ),
      );
    }
    if (data.containsKey('use_encryption_nonce')) {
      context.handle(
        _useEncryptionNonceMeta,
        useEncryptionNonce.isAcceptableOrUnknown(
          data['use_encryption_nonce']!,
          _useEncryptionNonceMeta,
        ),
      );
    }
    if (data.containsKey('theme_color')) {
      context.handle(
        _themeColorMeta,
        themeColor.isAcceptableOrUnknown(data['theme_color']!, _themeColorMeta),
      );
    }
    if (data.containsKey('theme_variant')) {
      context.handle(
        _themeVariantMeta,
        themeVariant.isAcceptableOrUnknown(
          data['theme_variant']!,
          _themeVariantMeta,
        ),
      );
    }
    if (data.containsKey('enable_drag_n_drop')) {
      context.handle(
        _enableDragNDropMeta,
        enableDragNDrop.isAcceptableOrUnknown(
          data['enable_drag_n_drop']!,
          _enableDragNDropMeta,
        ),
      );
    }
    if (data.containsKey('enable_paste_stack')) {
      context.handle(
        _enablePasteStackMeta,
        enablePasteStack.isAcceptableOrUnknown(
          data['enable_paste_stack']!,
          _enablePasteStackMeta,
        ),
      );
    }
    if (data.containsKey('android_bg_listener')) {
      context.handle(
        _androidBgListenerMeta,
        androidBgListener.isAcceptableOrUnknown(
          data['android_bg_listener']!,
          _androidBgListenerMeta,
        ),
      );
    }
    if (data.containsKey('rich_data_capture')) {
      context.handle(
        _richDataCaptureMeta,
        richDataCapture.isAcceptableOrUnknown(
          data['rich_data_capture']!,
          _richDataCaptureMeta,
        ),
      );
    }
    if (data.containsKey('on_board_complete')) {
      context.handle(
        _onBoardCompleteMeta,
        onBoardComplete.isAcceptableOrUnknown(
          data['on_board_complete']!,
          _onBoardCompleteMeta,
        ),
      );
    }
    if (data.containsKey('review_qualifying_event_count')) {
      context.handle(
        _reviewQualifyingEventCountMeta,
        reviewQualifyingEventCount.isAcceptableOrUnknown(
          data['review_qualifying_event_count']!,
          _reviewQualifyingEventCountMeta,
        ),
      );
    }
    if (data.containsKey('last_review_prompt_date')) {
      context.handle(
        _lastReviewPromptDateMeta,
        lastReviewPromptDate.isAcceptableOrUnknown(
          data['last_review_prompt_date']!,
          _lastReviewPromptDateMeta,
        ),
      );
    }
    if (data.containsKey('review_never_ask')) {
      context.handle(
        _reviewNeverAskMeta,
        reviewNeverAsk.isAcceptableOrUnknown(
          data['review_never_ask']!,
          _reviewNeverAskMeta,
        ),
      );
    }
    if (data.containsKey('lan_instant_sync')) {
      context.handle(
        _lanInstantSyncMeta,
        lanInstantSync.isAcceptableOrUnknown(
          data['lan_instant_sync']!,
          _lanInstantSyncMeta,
        ),
      );
    }
    if (data.containsKey('auto_write_on_receive')) {
      context.handle(
        _autoWriteOnReceiveMeta,
        autoWriteOnReceive.isAcceptableOrUnknown(
          data['auto_write_on_receive']!,
          _autoWriteOnReceiveMeta,
        ),
      );
    }
    if (data.containsKey('enable_type_to_search')) {
      context.handle(
        _enableTypeToSearchMeta,
        enableTypeToSearch.isAcceptableOrUnknown(
          data['enable_type_to_search']!,
          _enableTypeToSearchMeta,
        ),
      );
    }
    if (data.containsKey('hide_from_screen_capture')) {
      context.handle(
        _hideFromScreenCaptureMeta,
        hideFromScreenCapture.isAcceptableOrUnknown(
          data['hide_from_screen_capture']!,
          _hideFromScreenCaptureMeta,
        ),
      );
    }
    if (data.containsKey('show_tray_icon')) {
      context.handle(
        _showTrayIconMeta,
        showTrayIcon.isAcceptableOrUnknown(
          data['show_tray_icon']!,
          _showTrayIconMeta,
        ),
      );
    }
    if (data.containsKey('clipboard_feedback_mode')) {
      context.handle(
        _clipboardFeedbackModeMeta,
        clipboardFeedbackMode.isAcceptableOrUnknown(
          data['clipboard_feedback_mode']!,
          _clipboardFeedbackModeMeta,
        ),
      );
    }
    if (data.containsKey('enable_local_auth')) {
      context.handle(
        _enableLocalAuthMeta,
        enableLocalAuth.isAcceptableOrUnknown(
          data['enable_local_auth']!,
          _enableLocalAuthMeta,
        ),
      );
    }
    if (data.containsKey('local_auth_timeout_minutes')) {
      context.handle(
        _localAuthTimeoutMinutesMeta,
        localAuthTimeoutMinutes.isAcceptableOrUnknown(
          data['local_auth_timeout_minutes']!,
          _localAuthTimeoutMinutesMeta,
        ),
      );
    }
    if (data.containsKey('show_collection_tip')) {
      context.handle(
        _showCollectionTipMeta,
        showCollectionTip.isAcceptableOrUnknown(
          data['show_collection_tip']!,
          _showCollectionTipMeta,
        ),
      );
    }
    if (data.containsKey('search_index_ready')) {
      context.handle(
        _searchIndexReadyMeta,
        searchIndexReady.isAcceptableOrUnknown(
          data['search_index_ready']!,
          _searchIndexReadyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftAppConfigEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftAppConfigEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      enableSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_sync'],
      )!,
      enableFileSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_file_sync'],
      )!,
      layout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout'],
      )!,
      view: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}view'],
      )!,
      pinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pinned'],
      )!,
      windowWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}window_width'],
      )!,
      windowHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}window_height'],
      )!,
      sortBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_by'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_order'],
      )!,
      dontUploadOver: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dont_upload_over'],
      )!,
      dontCopyOver: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dont_copy_over'],
      )!,
      pausedTill: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paused_till'],
      ),
      syncSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_speed'],
      )!,
      toggleHotkey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toggle_hotkey'],
      ),
      quickPasteHotkey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quick_paste_hotkey'],
      ),
      pasteStackHotkey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paste_stack_hotkey'],
      ),
      smartPaste: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}smart_paste'],
      )!,
      keepWindowOpenOnUnfocus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}keep_window_open_on_unfocus'],
      )!,
      transformAsNewClip: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}transform_as_new_clip'],
      )!,
      launchAtStartup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}launch_at_startup'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      enc2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enc2'],
      ),
      autoEncrypt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_encrypt'],
      )!,
      useEncryptionNonce: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_encryption_nonce'],
      )!,
      exclusionRules: $DriftAppConfigTableTable.$converterexclusionRulesn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}exclusion_rules'],
            ),
          ),
      themeColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_color'],
      )!,
      themeVariant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_variant'],
      )!,
      enableDragNDrop: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_drag_n_drop'],
      )!,
      enablePasteStack: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_paste_stack'],
      )!,
      androidBgListener: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}android_bg_listener'],
      )!,
      richDataCapture: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rich_data_capture'],
      )!,
      onBoardComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_board_complete'],
      )!,
      reviewQualifyingEventCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_qualifying_event_count'],
      )!,
      lastReviewPromptDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_review_prompt_date'],
      ),
      reviewNeverAsk: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}review_never_ask'],
      )!,
      lanInstantSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lan_instant_sync'],
      )!,
      autoWriteOnReceive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_write_on_receive'],
      )!,
      enableTypeToSearch: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_type_to_search'],
      )!,
      hideFromScreenCapture: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hide_from_screen_capture'],
      )!,
      showTrayIcon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_tray_icon'],
      )!,
      clipboardFeedbackMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clipboard_feedback_mode'],
      )!,
      enableLocalAuth: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_local_auth'],
      )!,
      localAuthTimeoutMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_auth_timeout_minutes'],
      )!,
      showCollectionTip: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_collection_tip'],
      )!,
      searchIndexReady: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}search_index_ready'],
      )!,
    );
  }

  @override
  $DriftAppConfigTableTable createAlias(String alias) {
    return $DriftAppConfigTableTable(attachedDatabase, alias);
  }

  static TypeConverter<ExclusionRules, String> $converterexclusionRules =
      const ExclusionRulesConverter();
  static TypeConverter<ExclusionRules?, String?> $converterexclusionRulesn =
      NullAwareTypeConverter.wrap($converterexclusionRules);
}

class DriftAppConfigEntry extends DataClass
    implements Insertable<DriftAppConfigEntry> {
  final int id;
  final String themeMode;
  final bool enableSync;
  final bool enableFileSync;
  final String layout;
  final String view;
  final bool pinned;
  final double windowWidth;
  final double windowHeight;
  final String sortBy;
  final String sortOrder;
  final int dontUploadOver;
  final int dontCopyOver;
  final DateTime? pausedTill;
  final String syncSpeed;
  final String? toggleHotkey;
  final String? quickPasteHotkey;
  final String? pasteStackHotkey;
  final bool smartPaste;
  final bool keepWindowOpenOnUnfocus;
  final bool transformAsNewClip;
  final bool launchAtStartup;
  final String locale;
  final String? enc2;
  final bool autoEncrypt;
  final bool useEncryptionNonce;
  final ExclusionRules? exclusionRules;
  final int themeColor;
  final String themeVariant;
  final bool enableDragNDrop;
  final bool enablePasteStack;
  final bool androidBgListener;
  final bool richDataCapture;
  final bool onBoardComplete;
  final int reviewQualifyingEventCount;
  final DateTime? lastReviewPromptDate;
  final bool reviewNeverAsk;
  final bool lanInstantSync;
  final bool autoWriteOnReceive;
  final bool enableTypeToSearch;
  final bool hideFromScreenCapture;
  final bool showTrayIcon;
  final String clipboardFeedbackMode;
  final bool enableLocalAuth;
  final int localAuthTimeoutMinutes;
  final bool showCollectionTip;
  final bool searchIndexReady;
  const DriftAppConfigEntry({
    required this.id,
    required this.themeMode,
    required this.enableSync,
    required this.enableFileSync,
    required this.layout,
    required this.view,
    required this.pinned,
    required this.windowWidth,
    required this.windowHeight,
    required this.sortBy,
    required this.sortOrder,
    required this.dontUploadOver,
    required this.dontCopyOver,
    this.pausedTill,
    required this.syncSpeed,
    this.toggleHotkey,
    this.quickPasteHotkey,
    this.pasteStackHotkey,
    required this.smartPaste,
    required this.keepWindowOpenOnUnfocus,
    required this.transformAsNewClip,
    required this.launchAtStartup,
    required this.locale,
    this.enc2,
    required this.autoEncrypt,
    required this.useEncryptionNonce,
    this.exclusionRules,
    required this.themeColor,
    required this.themeVariant,
    required this.enableDragNDrop,
    required this.enablePasteStack,
    required this.androidBgListener,
    required this.richDataCapture,
    required this.onBoardComplete,
    required this.reviewQualifyingEventCount,
    this.lastReviewPromptDate,
    required this.reviewNeverAsk,
    required this.lanInstantSync,
    required this.autoWriteOnReceive,
    required this.enableTypeToSearch,
    required this.hideFromScreenCapture,
    required this.showTrayIcon,
    required this.clipboardFeedbackMode,
    required this.enableLocalAuth,
    required this.localAuthTimeoutMinutes,
    required this.showCollectionTip,
    required this.searchIndexReady,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['enable_sync'] = Variable<bool>(enableSync);
    map['enable_file_sync'] = Variable<bool>(enableFileSync);
    map['layout'] = Variable<String>(layout);
    map['view'] = Variable<String>(view);
    map['pinned'] = Variable<bool>(pinned);
    map['window_width'] = Variable<double>(windowWidth);
    map['window_height'] = Variable<double>(windowHeight);
    map['sort_by'] = Variable<String>(sortBy);
    map['sort_order'] = Variable<String>(sortOrder);
    map['dont_upload_over'] = Variable<int>(dontUploadOver);
    map['dont_copy_over'] = Variable<int>(dontCopyOver);
    if (!nullToAbsent || pausedTill != null) {
      map['paused_till'] = Variable<DateTime>(pausedTill);
    }
    map['sync_speed'] = Variable<String>(syncSpeed);
    if (!nullToAbsent || toggleHotkey != null) {
      map['toggle_hotkey'] = Variable<String>(toggleHotkey);
    }
    if (!nullToAbsent || quickPasteHotkey != null) {
      map['quick_paste_hotkey'] = Variable<String>(quickPasteHotkey);
    }
    if (!nullToAbsent || pasteStackHotkey != null) {
      map['paste_stack_hotkey'] = Variable<String>(pasteStackHotkey);
    }
    map['smart_paste'] = Variable<bool>(smartPaste);
    map['keep_window_open_on_unfocus'] = Variable<bool>(
      keepWindowOpenOnUnfocus,
    );
    map['transform_as_new_clip'] = Variable<bool>(transformAsNewClip);
    map['launch_at_startup'] = Variable<bool>(launchAtStartup);
    map['locale'] = Variable<String>(locale);
    if (!nullToAbsent || enc2 != null) {
      map['enc2'] = Variable<String>(enc2);
    }
    map['auto_encrypt'] = Variable<bool>(autoEncrypt);
    map['use_encryption_nonce'] = Variable<bool>(useEncryptionNonce);
    if (!nullToAbsent || exclusionRules != null) {
      map['exclusion_rules'] = Variable<String>(
        $DriftAppConfigTableTable.$converterexclusionRulesn.toSql(
          exclusionRules,
        ),
      );
    }
    map['theme_color'] = Variable<int>(themeColor);
    map['theme_variant'] = Variable<String>(themeVariant);
    map['enable_drag_n_drop'] = Variable<bool>(enableDragNDrop);
    map['enable_paste_stack'] = Variable<bool>(enablePasteStack);
    map['android_bg_listener'] = Variable<bool>(androidBgListener);
    map['rich_data_capture'] = Variable<bool>(richDataCapture);
    map['on_board_complete'] = Variable<bool>(onBoardComplete);
    map['review_qualifying_event_count'] = Variable<int>(
      reviewQualifyingEventCount,
    );
    if (!nullToAbsent || lastReviewPromptDate != null) {
      map['last_review_prompt_date'] = Variable<DateTime>(lastReviewPromptDate);
    }
    map['review_never_ask'] = Variable<bool>(reviewNeverAsk);
    map['lan_instant_sync'] = Variable<bool>(lanInstantSync);
    map['auto_write_on_receive'] = Variable<bool>(autoWriteOnReceive);
    map['enable_type_to_search'] = Variable<bool>(enableTypeToSearch);
    map['hide_from_screen_capture'] = Variable<bool>(hideFromScreenCapture);
    map['show_tray_icon'] = Variable<bool>(showTrayIcon);
    map['clipboard_feedback_mode'] = Variable<String>(clipboardFeedbackMode);
    map['enable_local_auth'] = Variable<bool>(enableLocalAuth);
    map['local_auth_timeout_minutes'] = Variable<int>(localAuthTimeoutMinutes);
    map['show_collection_tip'] = Variable<bool>(showCollectionTip);
    map['search_index_ready'] = Variable<bool>(searchIndexReady);
    return map;
  }

  DriftAppConfigTableCompanion toCompanion(bool nullToAbsent) {
    return DriftAppConfigTableCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      enableSync: Value(enableSync),
      enableFileSync: Value(enableFileSync),
      layout: Value(layout),
      view: Value(view),
      pinned: Value(pinned),
      windowWidth: Value(windowWidth),
      windowHeight: Value(windowHeight),
      sortBy: Value(sortBy),
      sortOrder: Value(sortOrder),
      dontUploadOver: Value(dontUploadOver),
      dontCopyOver: Value(dontCopyOver),
      pausedTill: pausedTill == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedTill),
      syncSpeed: Value(syncSpeed),
      toggleHotkey: toggleHotkey == null && nullToAbsent
          ? const Value.absent()
          : Value(toggleHotkey),
      quickPasteHotkey: quickPasteHotkey == null && nullToAbsent
          ? const Value.absent()
          : Value(quickPasteHotkey),
      pasteStackHotkey: pasteStackHotkey == null && nullToAbsent
          ? const Value.absent()
          : Value(pasteStackHotkey),
      smartPaste: Value(smartPaste),
      keepWindowOpenOnUnfocus: Value(keepWindowOpenOnUnfocus),
      transformAsNewClip: Value(transformAsNewClip),
      launchAtStartup: Value(launchAtStartup),
      locale: Value(locale),
      enc2: enc2 == null && nullToAbsent ? const Value.absent() : Value(enc2),
      autoEncrypt: Value(autoEncrypt),
      useEncryptionNonce: Value(useEncryptionNonce),
      exclusionRules: exclusionRules == null && nullToAbsent
          ? const Value.absent()
          : Value(exclusionRules),
      themeColor: Value(themeColor),
      themeVariant: Value(themeVariant),
      enableDragNDrop: Value(enableDragNDrop),
      enablePasteStack: Value(enablePasteStack),
      androidBgListener: Value(androidBgListener),
      richDataCapture: Value(richDataCapture),
      onBoardComplete: Value(onBoardComplete),
      reviewQualifyingEventCount: Value(reviewQualifyingEventCount),
      lastReviewPromptDate: lastReviewPromptDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewPromptDate),
      reviewNeverAsk: Value(reviewNeverAsk),
      lanInstantSync: Value(lanInstantSync),
      autoWriteOnReceive: Value(autoWriteOnReceive),
      enableTypeToSearch: Value(enableTypeToSearch),
      hideFromScreenCapture: Value(hideFromScreenCapture),
      showTrayIcon: Value(showTrayIcon),
      clipboardFeedbackMode: Value(clipboardFeedbackMode),
      enableLocalAuth: Value(enableLocalAuth),
      localAuthTimeoutMinutes: Value(localAuthTimeoutMinutes),
      showCollectionTip: Value(showCollectionTip),
      searchIndexReady: Value(searchIndexReady),
    );
  }

  factory DriftAppConfigEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftAppConfigEntry(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      enableSync: serializer.fromJson<bool>(json['enableSync']),
      enableFileSync: serializer.fromJson<bool>(json['enableFileSync']),
      layout: serializer.fromJson<String>(json['layout']),
      view: serializer.fromJson<String>(json['view']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      windowWidth: serializer.fromJson<double>(json['windowWidth']),
      windowHeight: serializer.fromJson<double>(json['windowHeight']),
      sortBy: serializer.fromJson<String>(json['sortBy']),
      sortOrder: serializer.fromJson<String>(json['sortOrder']),
      dontUploadOver: serializer.fromJson<int>(json['dontUploadOver']),
      dontCopyOver: serializer.fromJson<int>(json['dontCopyOver']),
      pausedTill: serializer.fromJson<DateTime?>(json['pausedTill']),
      syncSpeed: serializer.fromJson<String>(json['syncSpeed']),
      toggleHotkey: serializer.fromJson<String?>(json['toggleHotkey']),
      quickPasteHotkey: serializer.fromJson<String?>(json['quickPasteHotkey']),
      pasteStackHotkey: serializer.fromJson<String?>(json['pasteStackHotkey']),
      smartPaste: serializer.fromJson<bool>(json['smartPaste']),
      keepWindowOpenOnUnfocus: serializer.fromJson<bool>(
        json['keepWindowOpenOnUnfocus'],
      ),
      transformAsNewClip: serializer.fromJson<bool>(json['transformAsNewClip']),
      launchAtStartup: serializer.fromJson<bool>(json['launchAtStartup']),
      locale: serializer.fromJson<String>(json['locale']),
      enc2: serializer.fromJson<String?>(json['enc2']),
      autoEncrypt: serializer.fromJson<bool>(json['autoEncrypt']),
      useEncryptionNonce: serializer.fromJson<bool>(json['useEncryptionNonce']),
      exclusionRules: serializer.fromJson<ExclusionRules?>(
        json['exclusionRules'],
      ),
      themeColor: serializer.fromJson<int>(json['themeColor']),
      themeVariant: serializer.fromJson<String>(json['themeVariant']),
      enableDragNDrop: serializer.fromJson<bool>(json['enableDragNDrop']),
      enablePasteStack: serializer.fromJson<bool>(json['enablePasteStack']),
      androidBgListener: serializer.fromJson<bool>(json['androidBgListener']),
      richDataCapture: serializer.fromJson<bool>(json['richDataCapture']),
      onBoardComplete: serializer.fromJson<bool>(json['onBoardComplete']),
      reviewQualifyingEventCount: serializer.fromJson<int>(
        json['reviewQualifyingEventCount'],
      ),
      lastReviewPromptDate: serializer.fromJson<DateTime?>(
        json['lastReviewPromptDate'],
      ),
      reviewNeverAsk: serializer.fromJson<bool>(json['reviewNeverAsk']),
      lanInstantSync: serializer.fromJson<bool>(json['lanInstantSync']),
      autoWriteOnReceive: serializer.fromJson<bool>(json['autoWriteOnReceive']),
      enableTypeToSearch: serializer.fromJson<bool>(json['enableTypeToSearch']),
      hideFromScreenCapture: serializer.fromJson<bool>(
        json['hideFromScreenCapture'],
      ),
      showTrayIcon: serializer.fromJson<bool>(json['showTrayIcon']),
      clipboardFeedbackMode: serializer.fromJson<String>(
        json['clipboardFeedbackMode'],
      ),
      enableLocalAuth: serializer.fromJson<bool>(json['enableLocalAuth']),
      localAuthTimeoutMinutes: serializer.fromJson<int>(
        json['localAuthTimeoutMinutes'],
      ),
      showCollectionTip: serializer.fromJson<bool>(json['showCollectionTip']),
      searchIndexReady: serializer.fromJson<bool>(json['searchIndexReady']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'enableSync': serializer.toJson<bool>(enableSync),
      'enableFileSync': serializer.toJson<bool>(enableFileSync),
      'layout': serializer.toJson<String>(layout),
      'view': serializer.toJson<String>(view),
      'pinned': serializer.toJson<bool>(pinned),
      'windowWidth': serializer.toJson<double>(windowWidth),
      'windowHeight': serializer.toJson<double>(windowHeight),
      'sortBy': serializer.toJson<String>(sortBy),
      'sortOrder': serializer.toJson<String>(sortOrder),
      'dontUploadOver': serializer.toJson<int>(dontUploadOver),
      'dontCopyOver': serializer.toJson<int>(dontCopyOver),
      'pausedTill': serializer.toJson<DateTime?>(pausedTill),
      'syncSpeed': serializer.toJson<String>(syncSpeed),
      'toggleHotkey': serializer.toJson<String?>(toggleHotkey),
      'quickPasteHotkey': serializer.toJson<String?>(quickPasteHotkey),
      'pasteStackHotkey': serializer.toJson<String?>(pasteStackHotkey),
      'smartPaste': serializer.toJson<bool>(smartPaste),
      'keepWindowOpenOnUnfocus': serializer.toJson<bool>(
        keepWindowOpenOnUnfocus,
      ),
      'transformAsNewClip': serializer.toJson<bool>(transformAsNewClip),
      'launchAtStartup': serializer.toJson<bool>(launchAtStartup),
      'locale': serializer.toJson<String>(locale),
      'enc2': serializer.toJson<String?>(enc2),
      'autoEncrypt': serializer.toJson<bool>(autoEncrypt),
      'useEncryptionNonce': serializer.toJson<bool>(useEncryptionNonce),
      'exclusionRules': serializer.toJson<ExclusionRules?>(exclusionRules),
      'themeColor': serializer.toJson<int>(themeColor),
      'themeVariant': serializer.toJson<String>(themeVariant),
      'enableDragNDrop': serializer.toJson<bool>(enableDragNDrop),
      'enablePasteStack': serializer.toJson<bool>(enablePasteStack),
      'androidBgListener': serializer.toJson<bool>(androidBgListener),
      'richDataCapture': serializer.toJson<bool>(richDataCapture),
      'onBoardComplete': serializer.toJson<bool>(onBoardComplete),
      'reviewQualifyingEventCount': serializer.toJson<int>(
        reviewQualifyingEventCount,
      ),
      'lastReviewPromptDate': serializer.toJson<DateTime?>(
        lastReviewPromptDate,
      ),
      'reviewNeverAsk': serializer.toJson<bool>(reviewNeverAsk),
      'lanInstantSync': serializer.toJson<bool>(lanInstantSync),
      'autoWriteOnReceive': serializer.toJson<bool>(autoWriteOnReceive),
      'enableTypeToSearch': serializer.toJson<bool>(enableTypeToSearch),
      'hideFromScreenCapture': serializer.toJson<bool>(hideFromScreenCapture),
      'showTrayIcon': serializer.toJson<bool>(showTrayIcon),
      'clipboardFeedbackMode': serializer.toJson<String>(clipboardFeedbackMode),
      'enableLocalAuth': serializer.toJson<bool>(enableLocalAuth),
      'localAuthTimeoutMinutes': serializer.toJson<int>(
        localAuthTimeoutMinutes,
      ),
      'showCollectionTip': serializer.toJson<bool>(showCollectionTip),
      'searchIndexReady': serializer.toJson<bool>(searchIndexReady),
    };
  }

  DriftAppConfigEntry copyWith({
    int? id,
    String? themeMode,
    bool? enableSync,
    bool? enableFileSync,
    String? layout,
    String? view,
    bool? pinned,
    double? windowWidth,
    double? windowHeight,
    String? sortBy,
    String? sortOrder,
    int? dontUploadOver,
    int? dontCopyOver,
    Value<DateTime?> pausedTill = const Value.absent(),
    String? syncSpeed,
    Value<String?> toggleHotkey = const Value.absent(),
    Value<String?> quickPasteHotkey = const Value.absent(),
    Value<String?> pasteStackHotkey = const Value.absent(),
    bool? smartPaste,
    bool? keepWindowOpenOnUnfocus,
    bool? transformAsNewClip,
    bool? launchAtStartup,
    String? locale,
    Value<String?> enc2 = const Value.absent(),
    bool? autoEncrypt,
    bool? useEncryptionNonce,
    Value<ExclusionRules?> exclusionRules = const Value.absent(),
    int? themeColor,
    String? themeVariant,
    bool? enableDragNDrop,
    bool? enablePasteStack,
    bool? androidBgListener,
    bool? richDataCapture,
    bool? onBoardComplete,
    int? reviewQualifyingEventCount,
    Value<DateTime?> lastReviewPromptDate = const Value.absent(),
    bool? reviewNeverAsk,
    bool? lanInstantSync,
    bool? autoWriteOnReceive,
    bool? enableTypeToSearch,
    bool? hideFromScreenCapture,
    bool? showTrayIcon,
    String? clipboardFeedbackMode,
    bool? enableLocalAuth,
    int? localAuthTimeoutMinutes,
    bool? showCollectionTip,
    bool? searchIndexReady,
  }) => DriftAppConfigEntry(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    enableSync: enableSync ?? this.enableSync,
    enableFileSync: enableFileSync ?? this.enableFileSync,
    layout: layout ?? this.layout,
    view: view ?? this.view,
    pinned: pinned ?? this.pinned,
    windowWidth: windowWidth ?? this.windowWidth,
    windowHeight: windowHeight ?? this.windowHeight,
    sortBy: sortBy ?? this.sortBy,
    sortOrder: sortOrder ?? this.sortOrder,
    dontUploadOver: dontUploadOver ?? this.dontUploadOver,
    dontCopyOver: dontCopyOver ?? this.dontCopyOver,
    pausedTill: pausedTill.present ? pausedTill.value : this.pausedTill,
    syncSpeed: syncSpeed ?? this.syncSpeed,
    toggleHotkey: toggleHotkey.present ? toggleHotkey.value : this.toggleHotkey,
    quickPasteHotkey: quickPasteHotkey.present
        ? quickPasteHotkey.value
        : this.quickPasteHotkey,
    pasteStackHotkey: pasteStackHotkey.present
        ? pasteStackHotkey.value
        : this.pasteStackHotkey,
    smartPaste: smartPaste ?? this.smartPaste,
    keepWindowOpenOnUnfocus:
        keepWindowOpenOnUnfocus ?? this.keepWindowOpenOnUnfocus,
    transformAsNewClip: transformAsNewClip ?? this.transformAsNewClip,
    launchAtStartup: launchAtStartup ?? this.launchAtStartup,
    locale: locale ?? this.locale,
    enc2: enc2.present ? enc2.value : this.enc2,
    autoEncrypt: autoEncrypt ?? this.autoEncrypt,
    useEncryptionNonce: useEncryptionNonce ?? this.useEncryptionNonce,
    exclusionRules: exclusionRules.present
        ? exclusionRules.value
        : this.exclusionRules,
    themeColor: themeColor ?? this.themeColor,
    themeVariant: themeVariant ?? this.themeVariant,
    enableDragNDrop: enableDragNDrop ?? this.enableDragNDrop,
    enablePasteStack: enablePasteStack ?? this.enablePasteStack,
    androidBgListener: androidBgListener ?? this.androidBgListener,
    richDataCapture: richDataCapture ?? this.richDataCapture,
    onBoardComplete: onBoardComplete ?? this.onBoardComplete,
    reviewQualifyingEventCount:
        reviewQualifyingEventCount ?? this.reviewQualifyingEventCount,
    lastReviewPromptDate: lastReviewPromptDate.present
        ? lastReviewPromptDate.value
        : this.lastReviewPromptDate,
    reviewNeverAsk: reviewNeverAsk ?? this.reviewNeverAsk,
    lanInstantSync: lanInstantSync ?? this.lanInstantSync,
    autoWriteOnReceive: autoWriteOnReceive ?? this.autoWriteOnReceive,
    enableTypeToSearch: enableTypeToSearch ?? this.enableTypeToSearch,
    hideFromScreenCapture: hideFromScreenCapture ?? this.hideFromScreenCapture,
    showTrayIcon: showTrayIcon ?? this.showTrayIcon,
    clipboardFeedbackMode: clipboardFeedbackMode ?? this.clipboardFeedbackMode,
    enableLocalAuth: enableLocalAuth ?? this.enableLocalAuth,
    localAuthTimeoutMinutes:
        localAuthTimeoutMinutes ?? this.localAuthTimeoutMinutes,
    showCollectionTip: showCollectionTip ?? this.showCollectionTip,
    searchIndexReady: searchIndexReady ?? this.searchIndexReady,
  );
  DriftAppConfigEntry copyWithCompanion(DriftAppConfigTableCompanion data) {
    return DriftAppConfigEntry(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      enableSync: data.enableSync.present
          ? data.enableSync.value
          : this.enableSync,
      enableFileSync: data.enableFileSync.present
          ? data.enableFileSync.value
          : this.enableFileSync,
      layout: data.layout.present ? data.layout.value : this.layout,
      view: data.view.present ? data.view.value : this.view,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      windowWidth: data.windowWidth.present
          ? data.windowWidth.value
          : this.windowWidth,
      windowHeight: data.windowHeight.present
          ? data.windowHeight.value
          : this.windowHeight,
      sortBy: data.sortBy.present ? data.sortBy.value : this.sortBy,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      dontUploadOver: data.dontUploadOver.present
          ? data.dontUploadOver.value
          : this.dontUploadOver,
      dontCopyOver: data.dontCopyOver.present
          ? data.dontCopyOver.value
          : this.dontCopyOver,
      pausedTill: data.pausedTill.present
          ? data.pausedTill.value
          : this.pausedTill,
      syncSpeed: data.syncSpeed.present ? data.syncSpeed.value : this.syncSpeed,
      toggleHotkey: data.toggleHotkey.present
          ? data.toggleHotkey.value
          : this.toggleHotkey,
      quickPasteHotkey: data.quickPasteHotkey.present
          ? data.quickPasteHotkey.value
          : this.quickPasteHotkey,
      pasteStackHotkey: data.pasteStackHotkey.present
          ? data.pasteStackHotkey.value
          : this.pasteStackHotkey,
      smartPaste: data.smartPaste.present
          ? data.smartPaste.value
          : this.smartPaste,
      keepWindowOpenOnUnfocus: data.keepWindowOpenOnUnfocus.present
          ? data.keepWindowOpenOnUnfocus.value
          : this.keepWindowOpenOnUnfocus,
      transformAsNewClip: data.transformAsNewClip.present
          ? data.transformAsNewClip.value
          : this.transformAsNewClip,
      launchAtStartup: data.launchAtStartup.present
          ? data.launchAtStartup.value
          : this.launchAtStartup,
      locale: data.locale.present ? data.locale.value : this.locale,
      enc2: data.enc2.present ? data.enc2.value : this.enc2,
      autoEncrypt: data.autoEncrypt.present
          ? data.autoEncrypt.value
          : this.autoEncrypt,
      useEncryptionNonce: data.useEncryptionNonce.present
          ? data.useEncryptionNonce.value
          : this.useEncryptionNonce,
      exclusionRules: data.exclusionRules.present
          ? data.exclusionRules.value
          : this.exclusionRules,
      themeColor: data.themeColor.present
          ? data.themeColor.value
          : this.themeColor,
      themeVariant: data.themeVariant.present
          ? data.themeVariant.value
          : this.themeVariant,
      enableDragNDrop: data.enableDragNDrop.present
          ? data.enableDragNDrop.value
          : this.enableDragNDrop,
      enablePasteStack: data.enablePasteStack.present
          ? data.enablePasteStack.value
          : this.enablePasteStack,
      androidBgListener: data.androidBgListener.present
          ? data.androidBgListener.value
          : this.androidBgListener,
      richDataCapture: data.richDataCapture.present
          ? data.richDataCapture.value
          : this.richDataCapture,
      onBoardComplete: data.onBoardComplete.present
          ? data.onBoardComplete.value
          : this.onBoardComplete,
      reviewQualifyingEventCount: data.reviewQualifyingEventCount.present
          ? data.reviewQualifyingEventCount.value
          : this.reviewQualifyingEventCount,
      lastReviewPromptDate: data.lastReviewPromptDate.present
          ? data.lastReviewPromptDate.value
          : this.lastReviewPromptDate,
      reviewNeverAsk: data.reviewNeverAsk.present
          ? data.reviewNeverAsk.value
          : this.reviewNeverAsk,
      lanInstantSync: data.lanInstantSync.present
          ? data.lanInstantSync.value
          : this.lanInstantSync,
      autoWriteOnReceive: data.autoWriteOnReceive.present
          ? data.autoWriteOnReceive.value
          : this.autoWriteOnReceive,
      enableTypeToSearch: data.enableTypeToSearch.present
          ? data.enableTypeToSearch.value
          : this.enableTypeToSearch,
      hideFromScreenCapture: data.hideFromScreenCapture.present
          ? data.hideFromScreenCapture.value
          : this.hideFromScreenCapture,
      showTrayIcon: data.showTrayIcon.present
          ? data.showTrayIcon.value
          : this.showTrayIcon,
      clipboardFeedbackMode: data.clipboardFeedbackMode.present
          ? data.clipboardFeedbackMode.value
          : this.clipboardFeedbackMode,
      enableLocalAuth: data.enableLocalAuth.present
          ? data.enableLocalAuth.value
          : this.enableLocalAuth,
      localAuthTimeoutMinutes: data.localAuthTimeoutMinutes.present
          ? data.localAuthTimeoutMinutes.value
          : this.localAuthTimeoutMinutes,
      showCollectionTip: data.showCollectionTip.present
          ? data.showCollectionTip.value
          : this.showCollectionTip,
      searchIndexReady: data.searchIndexReady.present
          ? data.searchIndexReady.value
          : this.searchIndexReady,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftAppConfigEntry(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('enableSync: $enableSync, ')
          ..write('enableFileSync: $enableFileSync, ')
          ..write('layout: $layout, ')
          ..write('view: $view, ')
          ..write('pinned: $pinned, ')
          ..write('windowWidth: $windowWidth, ')
          ..write('windowHeight: $windowHeight, ')
          ..write('sortBy: $sortBy, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('dontUploadOver: $dontUploadOver, ')
          ..write('dontCopyOver: $dontCopyOver, ')
          ..write('pausedTill: $pausedTill, ')
          ..write('syncSpeed: $syncSpeed, ')
          ..write('toggleHotkey: $toggleHotkey, ')
          ..write('quickPasteHotkey: $quickPasteHotkey, ')
          ..write('pasteStackHotkey: $pasteStackHotkey, ')
          ..write('smartPaste: $smartPaste, ')
          ..write('keepWindowOpenOnUnfocus: $keepWindowOpenOnUnfocus, ')
          ..write('transformAsNewClip: $transformAsNewClip, ')
          ..write('launchAtStartup: $launchAtStartup, ')
          ..write('locale: $locale, ')
          ..write('enc2: $enc2, ')
          ..write('autoEncrypt: $autoEncrypt, ')
          ..write('useEncryptionNonce: $useEncryptionNonce, ')
          ..write('exclusionRules: $exclusionRules, ')
          ..write('themeColor: $themeColor, ')
          ..write('themeVariant: $themeVariant, ')
          ..write('enableDragNDrop: $enableDragNDrop, ')
          ..write('enablePasteStack: $enablePasteStack, ')
          ..write('androidBgListener: $androidBgListener, ')
          ..write('richDataCapture: $richDataCapture, ')
          ..write('onBoardComplete: $onBoardComplete, ')
          ..write('reviewQualifyingEventCount: $reviewQualifyingEventCount, ')
          ..write('lastReviewPromptDate: $lastReviewPromptDate, ')
          ..write('reviewNeverAsk: $reviewNeverAsk, ')
          ..write('lanInstantSync: $lanInstantSync, ')
          ..write('autoWriteOnReceive: $autoWriteOnReceive, ')
          ..write('enableTypeToSearch: $enableTypeToSearch, ')
          ..write('hideFromScreenCapture: $hideFromScreenCapture, ')
          ..write('showTrayIcon: $showTrayIcon, ')
          ..write('clipboardFeedbackMode: $clipboardFeedbackMode, ')
          ..write('enableLocalAuth: $enableLocalAuth, ')
          ..write('localAuthTimeoutMinutes: $localAuthTimeoutMinutes, ')
          ..write('showCollectionTip: $showCollectionTip, ')
          ..write('searchIndexReady: $searchIndexReady')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    pasteStackHotkey,
    smartPaste,
    keepWindowOpenOnUnfocus,
    transformAsNewClip,
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
    richDataCapture,
    onBoardComplete,
    reviewQualifyingEventCount,
    lastReviewPromptDate,
    reviewNeverAsk,
    lanInstantSync,
    autoWriteOnReceive,
    enableTypeToSearch,
    hideFromScreenCapture,
    showTrayIcon,
    clipboardFeedbackMode,
    enableLocalAuth,
    localAuthTimeoutMinutes,
    showCollectionTip,
    searchIndexReady,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftAppConfigEntry &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.enableSync == this.enableSync &&
          other.enableFileSync == this.enableFileSync &&
          other.layout == this.layout &&
          other.view == this.view &&
          other.pinned == this.pinned &&
          other.windowWidth == this.windowWidth &&
          other.windowHeight == this.windowHeight &&
          other.sortBy == this.sortBy &&
          other.sortOrder == this.sortOrder &&
          other.dontUploadOver == this.dontUploadOver &&
          other.dontCopyOver == this.dontCopyOver &&
          other.pausedTill == this.pausedTill &&
          other.syncSpeed == this.syncSpeed &&
          other.toggleHotkey == this.toggleHotkey &&
          other.quickPasteHotkey == this.quickPasteHotkey &&
          other.pasteStackHotkey == this.pasteStackHotkey &&
          other.smartPaste == this.smartPaste &&
          other.keepWindowOpenOnUnfocus == this.keepWindowOpenOnUnfocus &&
          other.transformAsNewClip == this.transformAsNewClip &&
          other.launchAtStartup == this.launchAtStartup &&
          other.locale == this.locale &&
          other.enc2 == this.enc2 &&
          other.autoEncrypt == this.autoEncrypt &&
          other.useEncryptionNonce == this.useEncryptionNonce &&
          other.exclusionRules == this.exclusionRules &&
          other.themeColor == this.themeColor &&
          other.themeVariant == this.themeVariant &&
          other.enableDragNDrop == this.enableDragNDrop &&
          other.enablePasteStack == this.enablePasteStack &&
          other.androidBgListener == this.androidBgListener &&
          other.richDataCapture == this.richDataCapture &&
          other.onBoardComplete == this.onBoardComplete &&
          other.reviewQualifyingEventCount == this.reviewQualifyingEventCount &&
          other.lastReviewPromptDate == this.lastReviewPromptDate &&
          other.reviewNeverAsk == this.reviewNeverAsk &&
          other.lanInstantSync == this.lanInstantSync &&
          other.autoWriteOnReceive == this.autoWriteOnReceive &&
          other.enableTypeToSearch == this.enableTypeToSearch &&
          other.hideFromScreenCapture == this.hideFromScreenCapture &&
          other.showTrayIcon == this.showTrayIcon &&
          other.clipboardFeedbackMode == this.clipboardFeedbackMode &&
          other.enableLocalAuth == this.enableLocalAuth &&
          other.localAuthTimeoutMinutes == this.localAuthTimeoutMinutes &&
          other.showCollectionTip == this.showCollectionTip &&
          other.searchIndexReady == this.searchIndexReady);
}

class DriftAppConfigTableCompanion
    extends UpdateCompanion<DriftAppConfigEntry> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<bool> enableSync;
  final Value<bool> enableFileSync;
  final Value<String> layout;
  final Value<String> view;
  final Value<bool> pinned;
  final Value<double> windowWidth;
  final Value<double> windowHeight;
  final Value<String> sortBy;
  final Value<String> sortOrder;
  final Value<int> dontUploadOver;
  final Value<int> dontCopyOver;
  final Value<DateTime?> pausedTill;
  final Value<String> syncSpeed;
  final Value<String?> toggleHotkey;
  final Value<String?> quickPasteHotkey;
  final Value<String?> pasteStackHotkey;
  final Value<bool> smartPaste;
  final Value<bool> keepWindowOpenOnUnfocus;
  final Value<bool> transformAsNewClip;
  final Value<bool> launchAtStartup;
  final Value<String> locale;
  final Value<String?> enc2;
  final Value<bool> autoEncrypt;
  final Value<bool> useEncryptionNonce;
  final Value<ExclusionRules?> exclusionRules;
  final Value<int> themeColor;
  final Value<String> themeVariant;
  final Value<bool> enableDragNDrop;
  final Value<bool> enablePasteStack;
  final Value<bool> androidBgListener;
  final Value<bool> richDataCapture;
  final Value<bool> onBoardComplete;
  final Value<int> reviewQualifyingEventCount;
  final Value<DateTime?> lastReviewPromptDate;
  final Value<bool> reviewNeverAsk;
  final Value<bool> lanInstantSync;
  final Value<bool> autoWriteOnReceive;
  final Value<bool> enableTypeToSearch;
  final Value<bool> hideFromScreenCapture;
  final Value<bool> showTrayIcon;
  final Value<String> clipboardFeedbackMode;
  final Value<bool> enableLocalAuth;
  final Value<int> localAuthTimeoutMinutes;
  final Value<bool> showCollectionTip;
  final Value<bool> searchIndexReady;
  const DriftAppConfigTableCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.enableSync = const Value.absent(),
    this.enableFileSync = const Value.absent(),
    this.layout = const Value.absent(),
    this.view = const Value.absent(),
    this.pinned = const Value.absent(),
    this.windowWidth = const Value.absent(),
    this.windowHeight = const Value.absent(),
    this.sortBy = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.dontUploadOver = const Value.absent(),
    this.dontCopyOver = const Value.absent(),
    this.pausedTill = const Value.absent(),
    this.syncSpeed = const Value.absent(),
    this.toggleHotkey = const Value.absent(),
    this.quickPasteHotkey = const Value.absent(),
    this.pasteStackHotkey = const Value.absent(),
    this.smartPaste = const Value.absent(),
    this.keepWindowOpenOnUnfocus = const Value.absent(),
    this.transformAsNewClip = const Value.absent(),
    this.launchAtStartup = const Value.absent(),
    this.locale = const Value.absent(),
    this.enc2 = const Value.absent(),
    this.autoEncrypt = const Value.absent(),
    this.useEncryptionNonce = const Value.absent(),
    this.exclusionRules = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.themeVariant = const Value.absent(),
    this.enableDragNDrop = const Value.absent(),
    this.enablePasteStack = const Value.absent(),
    this.androidBgListener = const Value.absent(),
    this.richDataCapture = const Value.absent(),
    this.onBoardComplete = const Value.absent(),
    this.reviewQualifyingEventCount = const Value.absent(),
    this.lastReviewPromptDate = const Value.absent(),
    this.reviewNeverAsk = const Value.absent(),
    this.lanInstantSync = const Value.absent(),
    this.autoWriteOnReceive = const Value.absent(),
    this.enableTypeToSearch = const Value.absent(),
    this.hideFromScreenCapture = const Value.absent(),
    this.showTrayIcon = const Value.absent(),
    this.clipboardFeedbackMode = const Value.absent(),
    this.enableLocalAuth = const Value.absent(),
    this.localAuthTimeoutMinutes = const Value.absent(),
    this.showCollectionTip = const Value.absent(),
    this.searchIndexReady = const Value.absent(),
  });
  DriftAppConfigTableCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.enableSync = const Value.absent(),
    this.enableFileSync = const Value.absent(),
    this.layout = const Value.absent(),
    this.view = const Value.absent(),
    this.pinned = const Value.absent(),
    this.windowWidth = const Value.absent(),
    this.windowHeight = const Value.absent(),
    this.sortBy = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.dontUploadOver = const Value.absent(),
    this.dontCopyOver = const Value.absent(),
    this.pausedTill = const Value.absent(),
    this.syncSpeed = const Value.absent(),
    this.toggleHotkey = const Value.absent(),
    this.quickPasteHotkey = const Value.absent(),
    this.pasteStackHotkey = const Value.absent(),
    this.smartPaste = const Value.absent(),
    this.keepWindowOpenOnUnfocus = const Value.absent(),
    this.transformAsNewClip = const Value.absent(),
    this.launchAtStartup = const Value.absent(),
    this.locale = const Value.absent(),
    this.enc2 = const Value.absent(),
    this.autoEncrypt = const Value.absent(),
    this.useEncryptionNonce = const Value.absent(),
    this.exclusionRules = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.themeVariant = const Value.absent(),
    this.enableDragNDrop = const Value.absent(),
    this.enablePasteStack = const Value.absent(),
    this.androidBgListener = const Value.absent(),
    this.richDataCapture = const Value.absent(),
    this.onBoardComplete = const Value.absent(),
    this.reviewQualifyingEventCount = const Value.absent(),
    this.lastReviewPromptDate = const Value.absent(),
    this.reviewNeverAsk = const Value.absent(),
    this.lanInstantSync = const Value.absent(),
    this.autoWriteOnReceive = const Value.absent(),
    this.enableTypeToSearch = const Value.absent(),
    this.hideFromScreenCapture = const Value.absent(),
    this.showTrayIcon = const Value.absent(),
    this.clipboardFeedbackMode = const Value.absent(),
    this.enableLocalAuth = const Value.absent(),
    this.localAuthTimeoutMinutes = const Value.absent(),
    this.showCollectionTip = const Value.absent(),
    this.searchIndexReady = const Value.absent(),
  });
  static Insertable<DriftAppConfigEntry> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<bool>? enableSync,
    Expression<bool>? enableFileSync,
    Expression<String>? layout,
    Expression<String>? view,
    Expression<bool>? pinned,
    Expression<double>? windowWidth,
    Expression<double>? windowHeight,
    Expression<String>? sortBy,
    Expression<String>? sortOrder,
    Expression<int>? dontUploadOver,
    Expression<int>? dontCopyOver,
    Expression<DateTime>? pausedTill,
    Expression<String>? syncSpeed,
    Expression<String>? toggleHotkey,
    Expression<String>? quickPasteHotkey,
    Expression<String>? pasteStackHotkey,
    Expression<bool>? smartPaste,
    Expression<bool>? keepWindowOpenOnUnfocus,
    Expression<bool>? transformAsNewClip,
    Expression<bool>? launchAtStartup,
    Expression<String>? locale,
    Expression<String>? enc2,
    Expression<bool>? autoEncrypt,
    Expression<bool>? useEncryptionNonce,
    Expression<String>? exclusionRules,
    Expression<int>? themeColor,
    Expression<String>? themeVariant,
    Expression<bool>? enableDragNDrop,
    Expression<bool>? enablePasteStack,
    Expression<bool>? androidBgListener,
    Expression<bool>? richDataCapture,
    Expression<bool>? onBoardComplete,
    Expression<int>? reviewQualifyingEventCount,
    Expression<DateTime>? lastReviewPromptDate,
    Expression<bool>? reviewNeverAsk,
    Expression<bool>? lanInstantSync,
    Expression<bool>? autoWriteOnReceive,
    Expression<bool>? enableTypeToSearch,
    Expression<bool>? hideFromScreenCapture,
    Expression<bool>? showTrayIcon,
    Expression<String>? clipboardFeedbackMode,
    Expression<bool>? enableLocalAuth,
    Expression<int>? localAuthTimeoutMinutes,
    Expression<bool>? showCollectionTip,
    Expression<bool>? searchIndexReady,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (enableSync != null) 'enable_sync': enableSync,
      if (enableFileSync != null) 'enable_file_sync': enableFileSync,
      if (layout != null) 'layout': layout,
      if (view != null) 'view': view,
      if (pinned != null) 'pinned': pinned,
      if (windowWidth != null) 'window_width': windowWidth,
      if (windowHeight != null) 'window_height': windowHeight,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (dontUploadOver != null) 'dont_upload_over': dontUploadOver,
      if (dontCopyOver != null) 'dont_copy_over': dontCopyOver,
      if (pausedTill != null) 'paused_till': pausedTill,
      if (syncSpeed != null) 'sync_speed': syncSpeed,
      if (toggleHotkey != null) 'toggle_hotkey': toggleHotkey,
      if (quickPasteHotkey != null) 'quick_paste_hotkey': quickPasteHotkey,
      if (pasteStackHotkey != null) 'paste_stack_hotkey': pasteStackHotkey,
      if (smartPaste != null) 'smart_paste': smartPaste,
      if (keepWindowOpenOnUnfocus != null)
        'keep_window_open_on_unfocus': keepWindowOpenOnUnfocus,
      if (transformAsNewClip != null)
        'transform_as_new_clip': transformAsNewClip,
      if (launchAtStartup != null) 'launch_at_startup': launchAtStartup,
      if (locale != null) 'locale': locale,
      if (enc2 != null) 'enc2': enc2,
      if (autoEncrypt != null) 'auto_encrypt': autoEncrypt,
      if (useEncryptionNonce != null)
        'use_encryption_nonce': useEncryptionNonce,
      if (exclusionRules != null) 'exclusion_rules': exclusionRules,
      if (themeColor != null) 'theme_color': themeColor,
      if (themeVariant != null) 'theme_variant': themeVariant,
      if (enableDragNDrop != null) 'enable_drag_n_drop': enableDragNDrop,
      if (enablePasteStack != null) 'enable_paste_stack': enablePasteStack,
      if (androidBgListener != null) 'android_bg_listener': androidBgListener,
      if (richDataCapture != null) 'rich_data_capture': richDataCapture,
      if (onBoardComplete != null) 'on_board_complete': onBoardComplete,
      if (reviewQualifyingEventCount != null)
        'review_qualifying_event_count': reviewQualifyingEventCount,
      if (lastReviewPromptDate != null)
        'last_review_prompt_date': lastReviewPromptDate,
      if (reviewNeverAsk != null) 'review_never_ask': reviewNeverAsk,
      if (lanInstantSync != null) 'lan_instant_sync': lanInstantSync,
      if (autoWriteOnReceive != null)
        'auto_write_on_receive': autoWriteOnReceive,
      if (enableTypeToSearch != null)
        'enable_type_to_search': enableTypeToSearch,
      if (hideFromScreenCapture != null)
        'hide_from_screen_capture': hideFromScreenCapture,
      if (showTrayIcon != null) 'show_tray_icon': showTrayIcon,
      if (clipboardFeedbackMode != null)
        'clipboard_feedback_mode': clipboardFeedbackMode,
      if (enableLocalAuth != null) 'enable_local_auth': enableLocalAuth,
      if (localAuthTimeoutMinutes != null)
        'local_auth_timeout_minutes': localAuthTimeoutMinutes,
      if (showCollectionTip != null) 'show_collection_tip': showCollectionTip,
      if (searchIndexReady != null) 'search_index_ready': searchIndexReady,
    });
  }

  DriftAppConfigTableCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<bool>? enableSync,
    Value<bool>? enableFileSync,
    Value<String>? layout,
    Value<String>? view,
    Value<bool>? pinned,
    Value<double>? windowWidth,
    Value<double>? windowHeight,
    Value<String>? sortBy,
    Value<String>? sortOrder,
    Value<int>? dontUploadOver,
    Value<int>? dontCopyOver,
    Value<DateTime?>? pausedTill,
    Value<String>? syncSpeed,
    Value<String?>? toggleHotkey,
    Value<String?>? quickPasteHotkey,
    Value<String?>? pasteStackHotkey,
    Value<bool>? smartPaste,
    Value<bool>? keepWindowOpenOnUnfocus,
    Value<bool>? transformAsNewClip,
    Value<bool>? launchAtStartup,
    Value<String>? locale,
    Value<String?>? enc2,
    Value<bool>? autoEncrypt,
    Value<bool>? useEncryptionNonce,
    Value<ExclusionRules?>? exclusionRules,
    Value<int>? themeColor,
    Value<String>? themeVariant,
    Value<bool>? enableDragNDrop,
    Value<bool>? enablePasteStack,
    Value<bool>? androidBgListener,
    Value<bool>? richDataCapture,
    Value<bool>? onBoardComplete,
    Value<int>? reviewQualifyingEventCount,
    Value<DateTime?>? lastReviewPromptDate,
    Value<bool>? reviewNeverAsk,
    Value<bool>? lanInstantSync,
    Value<bool>? autoWriteOnReceive,
    Value<bool>? enableTypeToSearch,
    Value<bool>? hideFromScreenCapture,
    Value<bool>? showTrayIcon,
    Value<String>? clipboardFeedbackMode,
    Value<bool>? enableLocalAuth,
    Value<int>? localAuthTimeoutMinutes,
    Value<bool>? showCollectionTip,
    Value<bool>? searchIndexReady,
  }) {
    return DriftAppConfigTableCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      enableSync: enableSync ?? this.enableSync,
      enableFileSync: enableFileSync ?? this.enableFileSync,
      layout: layout ?? this.layout,
      view: view ?? this.view,
      pinned: pinned ?? this.pinned,
      windowWidth: windowWidth ?? this.windowWidth,
      windowHeight: windowHeight ?? this.windowHeight,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      dontUploadOver: dontUploadOver ?? this.dontUploadOver,
      dontCopyOver: dontCopyOver ?? this.dontCopyOver,
      pausedTill: pausedTill ?? this.pausedTill,
      syncSpeed: syncSpeed ?? this.syncSpeed,
      toggleHotkey: toggleHotkey ?? this.toggleHotkey,
      quickPasteHotkey: quickPasteHotkey ?? this.quickPasteHotkey,
      pasteStackHotkey: pasteStackHotkey ?? this.pasteStackHotkey,
      smartPaste: smartPaste ?? this.smartPaste,
      keepWindowOpenOnUnfocus:
          keepWindowOpenOnUnfocus ?? this.keepWindowOpenOnUnfocus,
      transformAsNewClip: transformAsNewClip ?? this.transformAsNewClip,
      launchAtStartup: launchAtStartup ?? this.launchAtStartup,
      locale: locale ?? this.locale,
      enc2: enc2 ?? this.enc2,
      autoEncrypt: autoEncrypt ?? this.autoEncrypt,
      useEncryptionNonce: useEncryptionNonce ?? this.useEncryptionNonce,
      exclusionRules: exclusionRules ?? this.exclusionRules,
      themeColor: themeColor ?? this.themeColor,
      themeVariant: themeVariant ?? this.themeVariant,
      enableDragNDrop: enableDragNDrop ?? this.enableDragNDrop,
      enablePasteStack: enablePasteStack ?? this.enablePasteStack,
      androidBgListener: androidBgListener ?? this.androidBgListener,
      richDataCapture: richDataCapture ?? this.richDataCapture,
      onBoardComplete: onBoardComplete ?? this.onBoardComplete,
      reviewQualifyingEventCount:
          reviewQualifyingEventCount ?? this.reviewQualifyingEventCount,
      lastReviewPromptDate: lastReviewPromptDate ?? this.lastReviewPromptDate,
      reviewNeverAsk: reviewNeverAsk ?? this.reviewNeverAsk,
      lanInstantSync: lanInstantSync ?? this.lanInstantSync,
      autoWriteOnReceive: autoWriteOnReceive ?? this.autoWriteOnReceive,
      enableTypeToSearch: enableTypeToSearch ?? this.enableTypeToSearch,
      hideFromScreenCapture:
          hideFromScreenCapture ?? this.hideFromScreenCapture,
      showTrayIcon: showTrayIcon ?? this.showTrayIcon,
      clipboardFeedbackMode:
          clipboardFeedbackMode ?? this.clipboardFeedbackMode,
      enableLocalAuth: enableLocalAuth ?? this.enableLocalAuth,
      localAuthTimeoutMinutes:
          localAuthTimeoutMinutes ?? this.localAuthTimeoutMinutes,
      showCollectionTip: showCollectionTip ?? this.showCollectionTip,
      searchIndexReady: searchIndexReady ?? this.searchIndexReady,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (enableSync.present) {
      map['enable_sync'] = Variable<bool>(enableSync.value);
    }
    if (enableFileSync.present) {
      map['enable_file_sync'] = Variable<bool>(enableFileSync.value);
    }
    if (layout.present) {
      map['layout'] = Variable<String>(layout.value);
    }
    if (view.present) {
      map['view'] = Variable<String>(view.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (windowWidth.present) {
      map['window_width'] = Variable<double>(windowWidth.value);
    }
    if (windowHeight.present) {
      map['window_height'] = Variable<double>(windowHeight.value);
    }
    if (sortBy.present) {
      map['sort_by'] = Variable<String>(sortBy.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<String>(sortOrder.value);
    }
    if (dontUploadOver.present) {
      map['dont_upload_over'] = Variable<int>(dontUploadOver.value);
    }
    if (dontCopyOver.present) {
      map['dont_copy_over'] = Variable<int>(dontCopyOver.value);
    }
    if (pausedTill.present) {
      map['paused_till'] = Variable<DateTime>(pausedTill.value);
    }
    if (syncSpeed.present) {
      map['sync_speed'] = Variable<String>(syncSpeed.value);
    }
    if (toggleHotkey.present) {
      map['toggle_hotkey'] = Variable<String>(toggleHotkey.value);
    }
    if (quickPasteHotkey.present) {
      map['quick_paste_hotkey'] = Variable<String>(quickPasteHotkey.value);
    }
    if (pasteStackHotkey.present) {
      map['paste_stack_hotkey'] = Variable<String>(pasteStackHotkey.value);
    }
    if (smartPaste.present) {
      map['smart_paste'] = Variable<bool>(smartPaste.value);
    }
    if (keepWindowOpenOnUnfocus.present) {
      map['keep_window_open_on_unfocus'] = Variable<bool>(
        keepWindowOpenOnUnfocus.value,
      );
    }
    if (transformAsNewClip.present) {
      map['transform_as_new_clip'] = Variable<bool>(transformAsNewClip.value);
    }
    if (launchAtStartup.present) {
      map['launch_at_startup'] = Variable<bool>(launchAtStartup.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (enc2.present) {
      map['enc2'] = Variable<String>(enc2.value);
    }
    if (autoEncrypt.present) {
      map['auto_encrypt'] = Variable<bool>(autoEncrypt.value);
    }
    if (useEncryptionNonce.present) {
      map['use_encryption_nonce'] = Variable<bool>(useEncryptionNonce.value);
    }
    if (exclusionRules.present) {
      map['exclusion_rules'] = Variable<String>(
        $DriftAppConfigTableTable.$converterexclusionRulesn.toSql(
          exclusionRules.value,
        ),
      );
    }
    if (themeColor.present) {
      map['theme_color'] = Variable<int>(themeColor.value);
    }
    if (themeVariant.present) {
      map['theme_variant'] = Variable<String>(themeVariant.value);
    }
    if (enableDragNDrop.present) {
      map['enable_drag_n_drop'] = Variable<bool>(enableDragNDrop.value);
    }
    if (enablePasteStack.present) {
      map['enable_paste_stack'] = Variable<bool>(enablePasteStack.value);
    }
    if (androidBgListener.present) {
      map['android_bg_listener'] = Variable<bool>(androidBgListener.value);
    }
    if (richDataCapture.present) {
      map['rich_data_capture'] = Variable<bool>(richDataCapture.value);
    }
    if (onBoardComplete.present) {
      map['on_board_complete'] = Variable<bool>(onBoardComplete.value);
    }
    if (reviewQualifyingEventCount.present) {
      map['review_qualifying_event_count'] = Variable<int>(
        reviewQualifyingEventCount.value,
      );
    }
    if (lastReviewPromptDate.present) {
      map['last_review_prompt_date'] = Variable<DateTime>(
        lastReviewPromptDate.value,
      );
    }
    if (reviewNeverAsk.present) {
      map['review_never_ask'] = Variable<bool>(reviewNeverAsk.value);
    }
    if (lanInstantSync.present) {
      map['lan_instant_sync'] = Variable<bool>(lanInstantSync.value);
    }
    if (autoWriteOnReceive.present) {
      map['auto_write_on_receive'] = Variable<bool>(autoWriteOnReceive.value);
    }
    if (enableTypeToSearch.present) {
      map['enable_type_to_search'] = Variable<bool>(enableTypeToSearch.value);
    }
    if (hideFromScreenCapture.present) {
      map['hide_from_screen_capture'] = Variable<bool>(
        hideFromScreenCapture.value,
      );
    }
    if (showTrayIcon.present) {
      map['show_tray_icon'] = Variable<bool>(showTrayIcon.value);
    }
    if (clipboardFeedbackMode.present) {
      map['clipboard_feedback_mode'] = Variable<String>(
        clipboardFeedbackMode.value,
      );
    }
    if (enableLocalAuth.present) {
      map['enable_local_auth'] = Variable<bool>(enableLocalAuth.value);
    }
    if (localAuthTimeoutMinutes.present) {
      map['local_auth_timeout_minutes'] = Variable<int>(
        localAuthTimeoutMinutes.value,
      );
    }
    if (showCollectionTip.present) {
      map['show_collection_tip'] = Variable<bool>(showCollectionTip.value);
    }
    if (searchIndexReady.present) {
      map['search_index_ready'] = Variable<bool>(searchIndexReady.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftAppConfigTableCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('enableSync: $enableSync, ')
          ..write('enableFileSync: $enableFileSync, ')
          ..write('layout: $layout, ')
          ..write('view: $view, ')
          ..write('pinned: $pinned, ')
          ..write('windowWidth: $windowWidth, ')
          ..write('windowHeight: $windowHeight, ')
          ..write('sortBy: $sortBy, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('dontUploadOver: $dontUploadOver, ')
          ..write('dontCopyOver: $dontCopyOver, ')
          ..write('pausedTill: $pausedTill, ')
          ..write('syncSpeed: $syncSpeed, ')
          ..write('toggleHotkey: $toggleHotkey, ')
          ..write('quickPasteHotkey: $quickPasteHotkey, ')
          ..write('pasteStackHotkey: $pasteStackHotkey, ')
          ..write('smartPaste: $smartPaste, ')
          ..write('keepWindowOpenOnUnfocus: $keepWindowOpenOnUnfocus, ')
          ..write('transformAsNewClip: $transformAsNewClip, ')
          ..write('launchAtStartup: $launchAtStartup, ')
          ..write('locale: $locale, ')
          ..write('enc2: $enc2, ')
          ..write('autoEncrypt: $autoEncrypt, ')
          ..write('useEncryptionNonce: $useEncryptionNonce, ')
          ..write('exclusionRules: $exclusionRules, ')
          ..write('themeColor: $themeColor, ')
          ..write('themeVariant: $themeVariant, ')
          ..write('enableDragNDrop: $enableDragNDrop, ')
          ..write('enablePasteStack: $enablePasteStack, ')
          ..write('androidBgListener: $androidBgListener, ')
          ..write('richDataCapture: $richDataCapture, ')
          ..write('onBoardComplete: $onBoardComplete, ')
          ..write('reviewQualifyingEventCount: $reviewQualifyingEventCount, ')
          ..write('lastReviewPromptDate: $lastReviewPromptDate, ')
          ..write('reviewNeverAsk: $reviewNeverAsk, ')
          ..write('lanInstantSync: $lanInstantSync, ')
          ..write('autoWriteOnReceive: $autoWriteOnReceive, ')
          ..write('enableTypeToSearch: $enableTypeToSearch, ')
          ..write('hideFromScreenCapture: $hideFromScreenCapture, ')
          ..write('showTrayIcon: $showTrayIcon, ')
          ..write('clipboardFeedbackMode: $clipboardFeedbackMode, ')
          ..write('enableLocalAuth: $enableLocalAuth, ')
          ..write('localAuthTimeoutMinutes: $localAuthTimeoutMinutes, ')
          ..write('showCollectionTip: $showCollectionTip, ')
          ..write('searchIndexReady: $searchIndexReady')
          ..write(')'))
        .toString();
  }
}

class $DriftApplicationMetaTableTable extends DriftApplicationMetaTable
    with TableInfo<$DriftApplicationMetaTableTable, DriftApplicationMetaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftApplicationMetaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appFilePathMeta = const VerificationMeta(
    'appFilePath',
  );
  @override
  late final GeneratedColumn<String> appFilePath = GeneratedColumn<String>(
    'app_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _osMeta = const VerificationMeta('os');
  @override
  late final GeneratedColumn<String> os = GeneratedColumn<String>(
    'os',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconLocalPathMeta = const VerificationMeta(
    'iconLocalPath',
  );
  @override
  late final GeneratedColumn<String> iconLocalPath = GeneratedColumn<String>(
    'icon_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconRemotePathMeta = const VerificationMeta(
    'iconRemotePath',
  );
  @override
  late final GeneratedColumn<String> iconRemotePath = GeneratedColumn<String>(
    'icon_remote_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    identifier,
    appName,
    appFilePath,
    os,
    iconLocalPath,
    iconRemotePath,
    created,
    modified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'application_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftApplicationMetaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    }
    if (data.containsKey('app_file_path')) {
      context.handle(
        _appFilePathMeta,
        appFilePath.isAcceptableOrUnknown(
          data['app_file_path']!,
          _appFilePathMeta,
        ),
      );
    }
    if (data.containsKey('os')) {
      context.handle(_osMeta, os.isAcceptableOrUnknown(data['os']!, _osMeta));
    } else if (isInserting) {
      context.missing(_osMeta);
    }
    if (data.containsKey('icon_local_path')) {
      context.handle(
        _iconLocalPathMeta,
        iconLocalPath.isAcceptableOrUnknown(
          data['icon_local_path']!,
          _iconLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('icon_remote_path')) {
      context.handle(
        _iconRemotePathMeta,
        iconRemotePath.isAcceptableOrUnknown(
          data['icon_remote_path']!,
          _iconRemotePathMeta,
        ),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftApplicationMetaEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftApplicationMetaEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      identifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier'],
      ),
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      ),
      appFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_file_path'],
      ),
      os: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}os'],
      )!,
      iconLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_local_path'],
      ),
      iconRemotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_remote_path'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      modified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified'],
      )!,
    );
  }

  @override
  $DriftApplicationMetaTableTable createAlias(String alias) {
    return $DriftApplicationMetaTableTable(attachedDatabase, alias);
  }
}

class DriftApplicationMetaEntry extends DataClass
    implements Insertable<DriftApplicationMetaEntry> {
  final int id;
  final String sourceId;
  final String? identifier;
  final String? appName;
  final String? appFilePath;
  final String os;
  final String? iconLocalPath;
  final String? iconRemotePath;
  final DateTime created;
  final DateTime modified;
  const DriftApplicationMetaEntry({
    required this.id,
    required this.sourceId,
    this.identifier,
    this.appName,
    this.appFilePath,
    required this.os,
    this.iconLocalPath,
    this.iconRemotePath,
    required this.created,
    required this.modified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || identifier != null) {
      map['identifier'] = Variable<String>(identifier);
    }
    if (!nullToAbsent || appName != null) {
      map['app_name'] = Variable<String>(appName);
    }
    if (!nullToAbsent || appFilePath != null) {
      map['app_file_path'] = Variable<String>(appFilePath);
    }
    map['os'] = Variable<String>(os);
    if (!nullToAbsent || iconLocalPath != null) {
      map['icon_local_path'] = Variable<String>(iconLocalPath);
    }
    if (!nullToAbsent || iconRemotePath != null) {
      map['icon_remote_path'] = Variable<String>(iconRemotePath);
    }
    map['created'] = Variable<DateTime>(created);
    map['modified'] = Variable<DateTime>(modified);
    return map;
  }

  DriftApplicationMetaTableCompanion toCompanion(bool nullToAbsent) {
    return DriftApplicationMetaTableCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      appName: appName == null && nullToAbsent
          ? const Value.absent()
          : Value(appName),
      appFilePath: appFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(appFilePath),
      os: Value(os),
      iconLocalPath: iconLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconLocalPath),
      iconRemotePath: iconRemotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconRemotePath),
      created: Value(created),
      modified: Value(modified),
    );
  }

  factory DriftApplicationMetaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftApplicationMetaEntry(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      identifier: serializer.fromJson<String?>(json['identifier']),
      appName: serializer.fromJson<String?>(json['appName']),
      appFilePath: serializer.fromJson<String?>(json['appFilePath']),
      os: serializer.fromJson<String>(json['os']),
      iconLocalPath: serializer.fromJson<String?>(json['iconLocalPath']),
      iconRemotePath: serializer.fromJson<String?>(json['iconRemotePath']),
      created: serializer.fromJson<DateTime>(json['created']),
      modified: serializer.fromJson<DateTime>(json['modified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'identifier': serializer.toJson<String?>(identifier),
      'appName': serializer.toJson<String?>(appName),
      'appFilePath': serializer.toJson<String?>(appFilePath),
      'os': serializer.toJson<String>(os),
      'iconLocalPath': serializer.toJson<String?>(iconLocalPath),
      'iconRemotePath': serializer.toJson<String?>(iconRemotePath),
      'created': serializer.toJson<DateTime>(created),
      'modified': serializer.toJson<DateTime>(modified),
    };
  }

  DriftApplicationMetaEntry copyWith({
    int? id,
    String? sourceId,
    Value<String?> identifier = const Value.absent(),
    Value<String?> appName = const Value.absent(),
    Value<String?> appFilePath = const Value.absent(),
    String? os,
    Value<String?> iconLocalPath = const Value.absent(),
    Value<String?> iconRemotePath = const Value.absent(),
    DateTime? created,
    DateTime? modified,
  }) => DriftApplicationMetaEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    identifier: identifier.present ? identifier.value : this.identifier,
    appName: appName.present ? appName.value : this.appName,
    appFilePath: appFilePath.present ? appFilePath.value : this.appFilePath,
    os: os ?? this.os,
    iconLocalPath: iconLocalPath.present
        ? iconLocalPath.value
        : this.iconLocalPath,
    iconRemotePath: iconRemotePath.present
        ? iconRemotePath.value
        : this.iconRemotePath,
    created: created ?? this.created,
    modified: modified ?? this.modified,
  );
  DriftApplicationMetaEntry copyWithCompanion(
    DriftApplicationMetaTableCompanion data,
  ) {
    return DriftApplicationMetaEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      identifier: data.identifier.present
          ? data.identifier.value
          : this.identifier,
      appName: data.appName.present ? data.appName.value : this.appName,
      appFilePath: data.appFilePath.present
          ? data.appFilePath.value
          : this.appFilePath,
      os: data.os.present ? data.os.value : this.os,
      iconLocalPath: data.iconLocalPath.present
          ? data.iconLocalPath.value
          : this.iconLocalPath,
      iconRemotePath: data.iconRemotePath.present
          ? data.iconRemotePath.value
          : this.iconRemotePath,
      created: data.created.present ? data.created.value : this.created,
      modified: data.modified.present ? data.modified.value : this.modified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftApplicationMetaEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('identifier: $identifier, ')
          ..write('appName: $appName, ')
          ..write('appFilePath: $appFilePath, ')
          ..write('os: $os, ')
          ..write('iconLocalPath: $iconLocalPath, ')
          ..write('iconRemotePath: $iconRemotePath, ')
          ..write('created: $created, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    identifier,
    appName,
    appFilePath,
    os,
    iconLocalPath,
    iconRemotePath,
    created,
    modified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftApplicationMetaEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.identifier == this.identifier &&
          other.appName == this.appName &&
          other.appFilePath == this.appFilePath &&
          other.os == this.os &&
          other.iconLocalPath == this.iconLocalPath &&
          other.iconRemotePath == this.iconRemotePath &&
          other.created == this.created &&
          other.modified == this.modified);
}

class DriftApplicationMetaTableCompanion
    extends UpdateCompanion<DriftApplicationMetaEntry> {
  final Value<int> id;
  final Value<String> sourceId;
  final Value<String?> identifier;
  final Value<String?> appName;
  final Value<String?> appFilePath;
  final Value<String> os;
  final Value<String?> iconLocalPath;
  final Value<String?> iconRemotePath;
  final Value<DateTime> created;
  final Value<DateTime> modified;
  const DriftApplicationMetaTableCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.identifier = const Value.absent(),
    this.appName = const Value.absent(),
    this.appFilePath = const Value.absent(),
    this.os = const Value.absent(),
    this.iconLocalPath = const Value.absent(),
    this.iconRemotePath = const Value.absent(),
    this.created = const Value.absent(),
    this.modified = const Value.absent(),
  });
  DriftApplicationMetaTableCompanion.insert({
    this.id = const Value.absent(),
    required String sourceId,
    this.identifier = const Value.absent(),
    this.appName = const Value.absent(),
    this.appFilePath = const Value.absent(),
    required String os,
    this.iconLocalPath = const Value.absent(),
    this.iconRemotePath = const Value.absent(),
    required DateTime created,
    required DateTime modified,
  }) : sourceId = Value(sourceId),
       os = Value(os),
       created = Value(created),
       modified = Value(modified);
  static Insertable<DriftApplicationMetaEntry> custom({
    Expression<int>? id,
    Expression<String>? sourceId,
    Expression<String>? identifier,
    Expression<String>? appName,
    Expression<String>? appFilePath,
    Expression<String>? os,
    Expression<String>? iconLocalPath,
    Expression<String>? iconRemotePath,
    Expression<DateTime>? created,
    Expression<DateTime>? modified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (identifier != null) 'identifier': identifier,
      if (appName != null) 'app_name': appName,
      if (appFilePath != null) 'app_file_path': appFilePath,
      if (os != null) 'os': os,
      if (iconLocalPath != null) 'icon_local_path': iconLocalPath,
      if (iconRemotePath != null) 'icon_remote_path': iconRemotePath,
      if (created != null) 'created': created,
      if (modified != null) 'modified': modified,
    });
  }

  DriftApplicationMetaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? sourceId,
    Value<String?>? identifier,
    Value<String?>? appName,
    Value<String?>? appFilePath,
    Value<String>? os,
    Value<String?>? iconLocalPath,
    Value<String?>? iconRemotePath,
    Value<DateTime>? created,
    Value<DateTime>? modified,
  }) {
    return DriftApplicationMetaTableCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      identifier: identifier ?? this.identifier,
      appName: appName ?? this.appName,
      appFilePath: appFilePath ?? this.appFilePath,
      os: os ?? this.os,
      iconLocalPath: iconLocalPath ?? this.iconLocalPath,
      iconRemotePath: iconRemotePath ?? this.iconRemotePath,
      created: created ?? this.created,
      modified: modified ?? this.modified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (appFilePath.present) {
      map['app_file_path'] = Variable<String>(appFilePath.value);
    }
    if (os.present) {
      map['os'] = Variable<String>(os.value);
    }
    if (iconLocalPath.present) {
      map['icon_local_path'] = Variable<String>(iconLocalPath.value);
    }
    if (iconRemotePath.present) {
      map['icon_remote_path'] = Variable<String>(iconRemotePath.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftApplicationMetaTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('identifier: $identifier, ')
          ..write('appName: $appName, ')
          ..write('appFilePath: $appFilePath, ')
          ..write('os: $os, ')
          ..write('iconLocalPath: $iconLocalPath, ')
          ..write('iconRemotePath: $iconRemotePath, ')
          ..write('created: $created, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }
}

class $DriftClipCollectionTableTable extends DriftClipCollectionTable
    with TableInfo<$DriftClipCollectionTableTable, DriftClipCollectionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftClipCollectionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedMeta = const VerificationMeta(
    'lastSynced',
  );
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
    'last_synced',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    lastSynced,
    created,
    modified,
    userId,
    deletedAt,
    deviceId,
    title,
    description,
    emoji,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clip_collection';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftClipCollectionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('last_synced')) {
      context.handle(
        _lastSyncedMeta,
        lastSynced.isAcceptableOrUnknown(data['last_synced']!, _lastSyncedMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftClipCollectionEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftClipCollectionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      lastSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      modified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
    );
  }

  @override
  $DriftClipCollectionTableTable createAlias(String alias) {
    return $DriftClipCollectionTableTable(attachedDatabase, alias);
  }
}

class DriftClipCollectionEntry extends DataClass
    implements Insertable<DriftClipCollectionEntry> {
  final int id;
  final int? serverId;
  final DateTime? lastSynced;
  final DateTime created;
  final DateTime modified;
  final String userId;
  final DateTime? deletedAt;
  final String? deviceId;
  final String title;
  final String? description;
  final String emoji;
  const DriftClipCollectionEntry({
    required this.id,
    this.serverId,
    this.lastSynced,
    required this.created,
    required this.modified,
    required this.userId,
    this.deletedAt,
    this.deviceId,
    required this.title,
    this.description,
    required this.emoji,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime>(lastSynced);
    }
    map['created'] = Variable<DateTime>(created);
    map['modified'] = Variable<DateTime>(modified);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['emoji'] = Variable<String>(emoji);
    return map;
  }

  DriftClipCollectionTableCompanion toCompanion(bool nullToAbsent) {
    return DriftClipCollectionTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
      created: Value(created),
      modified: Value(modified),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      emoji: Value(emoji),
    );
  }

  factory DriftClipCollectionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftClipCollectionEntry(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
      created: serializer.fromJson<DateTime>(json['created']),
      modified: serializer.fromJson<DateTime>(json['modified']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      emoji: serializer.fromJson<String>(json['emoji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
      'created': serializer.toJson<DateTime>(created),
      'modified': serializer.toJson<DateTime>(modified),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'emoji': serializer.toJson<String>(emoji),
    };
  }

  DriftClipCollectionEntry copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    Value<DateTime?> lastSynced = const Value.absent(),
    DateTime? created,
    DateTime? modified,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    String? emoji,
  }) => DriftClipCollectionEntry(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    lastSynced: lastSynced.present ? lastSynced.value : this.lastSynced,
    created: created ?? this.created,
    modified: modified ?? this.modified,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    emoji: emoji ?? this.emoji,
  );
  DriftClipCollectionEntry copyWithCompanion(
    DriftClipCollectionTableCompanion data,
  ) {
    return DriftClipCollectionEntry(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      lastSynced: data.lastSynced.present
          ? data.lastSynced.value
          : this.lastSynced,
      created: data.created.present ? data.created.value : this.created,
      modified: data.modified.present ? data.modified.value : this.modified,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftClipCollectionEntry(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('created: $created, ')
          ..write('modified: $modified, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    lastSynced,
    created,
    modified,
    userId,
    deletedAt,
    deviceId,
    title,
    description,
    emoji,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftClipCollectionEntry &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.lastSynced == this.lastSynced &&
          other.created == this.created &&
          other.modified == this.modified &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.title == this.title &&
          other.description == this.description &&
          other.emoji == this.emoji);
}

class DriftClipCollectionTableCompanion
    extends UpdateCompanion<DriftClipCollectionEntry> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<DateTime?> lastSynced;
  final Value<DateTime> created;
  final Value<DateTime> modified;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> emoji;
  const DriftClipCollectionTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.created = const Value.absent(),
    this.modified = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.emoji = const Value.absent(),
  });
  DriftClipCollectionTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSynced = const Value.absent(),
    required DateTime created,
    required DateTime modified,
    required String userId,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String emoji,
  }) : created = Value(created),
       modified = Value(modified),
       userId = Value(userId),
       title = Value(title),
       emoji = Value(emoji);
  static Insertable<DriftClipCollectionEntry> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<DateTime>? lastSynced,
    Expression<DateTime>? created,
    Expression<DateTime>? modified,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? emoji,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (created != null) 'created': created,
      if (modified != null) 'modified': modified,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (emoji != null) 'emoji': emoji,
    });
  }

  DriftClipCollectionTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<DateTime?>? lastSynced,
    Value<DateTime>? created,
    Value<DateTime>? modified,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? emoji,
  }) {
    return DriftClipCollectionTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      lastSynced: lastSynced ?? this.lastSynced,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftClipCollectionTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('created: $created, ')
          ..write('modified: $modified, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }
}

class $DriftClipboardItemTableTable extends DriftClipboardItemTable
    with TableInfo<$DriftClipboardItemTableTable, DriftClipboardItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftClipboardItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedMeta = const VerificationMeta(
    'lastSynced',
  );
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
    'last_synced',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lockedMeta = const VerificationMeta('locked');
  @override
  late final GeneratedColumn<bool> locked = GeneratedColumn<bool>(
    'locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _encryptedMeta = const VerificationMeta(
    'encrypted',
  );
  @override
  late final GeneratedColumn<bool> encrypted = GeneratedColumn<bool>(
    'encrypted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("encrypted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ivMeta = const VerificationMeta('iv');
  @override
  late final GeneratedColumn<String> iv = GeneratedColumn<String>(
    'iv',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _encModeMeta = const VerificationMeta(
    'encMode',
  );
  @override
  late final GeneratedColumn<String> encMode = GeneratedColumn<String>(
    'enc_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _richDataMeta = const VerificationMeta(
    'richData',
  );
  @override
  late final GeneratedColumn<String> richData = GeneratedColumn<String>(
    'rich_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textCategoryMeta = const VerificationMeta(
    'textCategory',
  );
  @override
  late final GeneratedColumn<String> textCategory = GeneratedColumn<String>(
    'text_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkPreviewTitleMeta = const VerificationMeta(
    'linkPreviewTitle',
  );
  @override
  late final GeneratedColumn<String> linkPreviewTitle = GeneratedColumn<String>(
    'link_preview_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkPreviewDescriptionMeta =
      const VerificationMeta('linkPreviewDescription');
  @override
  late final GeneratedColumn<String> linkPreviewDescription =
      GeneratedColumn<String>(
        'link_preview_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _linkPreviewImageUrlMeta =
      const VerificationMeta('linkPreviewImageUrl');
  @override
  late final GeneratedColumn<String> linkPreviewImageUrl =
      GeneratedColumn<String>(
        'link_preview_image_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileMimeTypeMeta = const VerificationMeta(
    'fileMimeType',
  );
  @override
  late final GeneratedColumn<String> fileMimeType = GeneratedColumn<String>(
    'file_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileExtensionMeta = const VerificationMeta(
    'fileExtension',
  );
  @override
  late final GeneratedColumn<String> fileExtension = GeneratedColumn<String>(
    'file_extension',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _driveFileIdMeta = const VerificationMeta(
    'driveFileId',
  );
  @override
  late final GeneratedColumn<String> driveFileId = GeneratedColumn<String>(
    'drive_file_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imgBlurHashMeta = const VerificationMeta(
    'imgBlurHash',
  );
  @override
  late final GeneratedColumn<String> imgBlurHash = GeneratedColumn<String>(
    'img_blur_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceAppMeta = const VerificationMeta(
    'sourceApp',
  );
  @override
  late final GeneratedColumn<String> sourceApp = GeneratedColumn<String>(
    'source_app',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _osMeta = const VerificationMeta('os');
  @override
  late final GeneratedColumn<String> os = GeneratedColumn<String>(
    'os',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverCollectionIdMeta =
      const VerificationMeta('serverCollectionId');
  @override
  late final GeneratedColumn<int> serverCollectionId = GeneratedColumn<int>(
    'server_collection_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localOnlyMeta = const VerificationMeta(
    'localOnly',
  );
  @override
  late final GeneratedColumn<bool> localOnly = GeneratedColumn<bool>(
    'local_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("local_only" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _copiedCountMeta = const VerificationMeta(
    'copiedCount',
  );
  @override
  late final GeneratedColumn<int> copiedCount = GeneratedColumn<int>(
    'copied_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCopiedMeta = const VerificationMeta(
    'lastCopied',
  );
  @override
  late final GeneratedColumn<DateTime> lastCopied = GeneratedColumn<DateTime>(
    'last_copied',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originIdMeta = const VerificationMeta(
    'originId',
  );
  @override
  late final GeneratedColumn<String> originId = GeneratedColumn<String>(
    'origin_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _searchTokensMeta = const VerificationMeta(
    'searchTokens',
  );
  @override
  late final GeneratedColumn<String> searchTokens = GeneratedColumn<String>(
    'search_tokens',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    lastSynced,
    localPath,
    created,
    modified,
    deviceId,
    type,
    userId,
    title,
    description,
    deletedAt,
    locked,
    encrypted,
    iv,
    encMode,
    textContent,
    richData,
    url,
    textCategory,
    linkPreviewTitle,
    linkPreviewDescription,
    linkPreviewImageUrl,
    fileName,
    fileMimeType,
    fileExtension,
    driveFileId,
    fileSize,
    imgBlurHash,
    sourceUrl,
    sourceApp,
    sourceId,
    os,
    serverCollectionId,
    collectionId,
    localOnly,
    copiedCount,
    lastCopied,
    originId,
    searchTokens,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clipboard_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftClipboardItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('last_synced')) {
      context.handle(
        _lastSyncedMeta,
        lastSynced.isAcceptableOrUnknown(data['last_synced']!, _lastSyncedMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('locked')) {
      context.handle(
        _lockedMeta,
        locked.isAcceptableOrUnknown(data['locked']!, _lockedMeta),
      );
    }
    if (data.containsKey('encrypted')) {
      context.handle(
        _encryptedMeta,
        encrypted.isAcceptableOrUnknown(data['encrypted']!, _encryptedMeta),
      );
    }
    if (data.containsKey('iv')) {
      context.handle(_ivMeta, iv.isAcceptableOrUnknown(data['iv']!, _ivMeta));
    }
    if (data.containsKey('enc_mode')) {
      context.handle(
        _encModeMeta,
        encMode.isAcceptableOrUnknown(data['enc_mode']!, _encModeMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(data['text']!, _textContentMeta),
      );
    }
    if (data.containsKey('rich_data')) {
      context.handle(
        _richDataMeta,
        richData.isAcceptableOrUnknown(data['rich_data']!, _richDataMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('text_category')) {
      context.handle(
        _textCategoryMeta,
        textCategory.isAcceptableOrUnknown(
          data['text_category']!,
          _textCategoryMeta,
        ),
      );
    }
    if (data.containsKey('link_preview_title')) {
      context.handle(
        _linkPreviewTitleMeta,
        linkPreviewTitle.isAcceptableOrUnknown(
          data['link_preview_title']!,
          _linkPreviewTitleMeta,
        ),
      );
    }
    if (data.containsKey('link_preview_description')) {
      context.handle(
        _linkPreviewDescriptionMeta,
        linkPreviewDescription.isAcceptableOrUnknown(
          data['link_preview_description']!,
          _linkPreviewDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('link_preview_image_url')) {
      context.handle(
        _linkPreviewImageUrlMeta,
        linkPreviewImageUrl.isAcceptableOrUnknown(
          data['link_preview_image_url']!,
          _linkPreviewImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    }
    if (data.containsKey('file_mime_type')) {
      context.handle(
        _fileMimeTypeMeta,
        fileMimeType.isAcceptableOrUnknown(
          data['file_mime_type']!,
          _fileMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('file_extension')) {
      context.handle(
        _fileExtensionMeta,
        fileExtension.isAcceptableOrUnknown(
          data['file_extension']!,
          _fileExtensionMeta,
        ),
      );
    }
    if (data.containsKey('drive_file_id')) {
      context.handle(
        _driveFileIdMeta,
        driveFileId.isAcceptableOrUnknown(
          data['drive_file_id']!,
          _driveFileIdMeta,
        ),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('img_blur_hash')) {
      context.handle(
        _imgBlurHashMeta,
        imgBlurHash.isAcceptableOrUnknown(
          data['img_blur_hash']!,
          _imgBlurHashMeta,
        ),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('source_app')) {
      context.handle(
        _sourceAppMeta,
        sourceApp.isAcceptableOrUnknown(data['source_app']!, _sourceAppMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('os')) {
      context.handle(_osMeta, os.isAcceptableOrUnknown(data['os']!, _osMeta));
    } else if (isInserting) {
      context.missing(_osMeta);
    }
    if (data.containsKey('server_collection_id')) {
      context.handle(
        _serverCollectionIdMeta,
        serverCollectionId.isAcceptableOrUnknown(
          data['server_collection_id']!,
          _serverCollectionIdMeta,
        ),
      );
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    }
    if (data.containsKey('local_only')) {
      context.handle(
        _localOnlyMeta,
        localOnly.isAcceptableOrUnknown(data['local_only']!, _localOnlyMeta),
      );
    }
    if (data.containsKey('copied_count')) {
      context.handle(
        _copiedCountMeta,
        copiedCount.isAcceptableOrUnknown(
          data['copied_count']!,
          _copiedCountMeta,
        ),
      );
    }
    if (data.containsKey('last_copied')) {
      context.handle(
        _lastCopiedMeta,
        lastCopied.isAcceptableOrUnknown(data['last_copied']!, _lastCopiedMeta),
      );
    }
    if (data.containsKey('origin_id')) {
      context.handle(
        _originIdMeta,
        originId.isAcceptableOrUnknown(data['origin_id']!, _originIdMeta),
      );
    }
    if (data.containsKey('search_tokens')) {
      context.handle(
        _searchTokensMeta,
        searchTokens.isAcceptableOrUnknown(
          data['search_tokens']!,
          _searchTokensMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftClipboardItemEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftClipboardItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      lastSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      modified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      locked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}locked'],
      )!,
      encrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}encrypted'],
      )!,
      iv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iv'],
      ),
      encMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enc_mode'],
      ),
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      ),
      richData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rich_data'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      textCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_category'],
      ),
      linkPreviewTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_preview_title'],
      ),
      linkPreviewDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_preview_description'],
      ),
      linkPreviewImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_preview_image_url'],
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      ),
      fileMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_mime_type'],
      ),
      fileExtension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_extension'],
      ),
      driveFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_file_id'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      imgBlurHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}img_blur_hash'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      sourceApp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_app'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      os: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}os'],
      )!,
      serverCollectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_collection_id'],
      ),
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      ),
      localOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}local_only'],
      )!,
      copiedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}copied_count'],
      )!,
      lastCopied: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_copied'],
      ),
      originId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_id'],
      ),
      searchTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_tokens'],
      ),
    );
  }

  @override
  $DriftClipboardItemTableTable createAlias(String alias) {
    return $DriftClipboardItemTableTable(attachedDatabase, alias);
  }
}

class DriftClipboardItemEntry extends DataClass
    implements Insertable<DriftClipboardItemEntry> {
  final int id;
  final int? serverId;
  final DateTime? lastSynced;
  final String? localPath;
  final DateTime created;
  final DateTime modified;
  final String? deviceId;
  final String type;
  final String userId;
  final String? title;
  final String? description;
  final DateTime? deletedAt;
  final bool locked;
  final bool encrypted;
  final String? iv;
  final String? encMode;
  final String? textContent;
  final String? richData;
  final String? url;
  final String? textCategory;
  final String? linkPreviewTitle;
  final String? linkPreviewDescription;
  final String? linkPreviewImageUrl;
  final String? fileName;
  final String? fileMimeType;
  final String? fileExtension;
  final String? driveFileId;
  final int? fileSize;
  final String? imgBlurHash;
  final String? sourceUrl;
  final String? sourceApp;
  final String? sourceId;
  final String os;
  final int? serverCollectionId;
  final int? collectionId;
  final bool localOnly;
  final int copiedCount;
  final DateTime? lastCopied;
  final String? originId;
  final String? searchTokens;
  const DriftClipboardItemEntry({
    required this.id,
    this.serverId,
    this.lastSynced,
    this.localPath,
    required this.created,
    required this.modified,
    this.deviceId,
    required this.type,
    required this.userId,
    this.title,
    this.description,
    this.deletedAt,
    required this.locked,
    required this.encrypted,
    this.iv,
    this.encMode,
    this.textContent,
    this.richData,
    this.url,
    this.textCategory,
    this.linkPreviewTitle,
    this.linkPreviewDescription,
    this.linkPreviewImageUrl,
    this.fileName,
    this.fileMimeType,
    this.fileExtension,
    this.driveFileId,
    this.fileSize,
    this.imgBlurHash,
    this.sourceUrl,
    this.sourceApp,
    this.sourceId,
    required this.os,
    this.serverCollectionId,
    this.collectionId,
    required this.localOnly,
    required this.copiedCount,
    this.lastCopied,
    this.originId,
    this.searchTokens,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime>(lastSynced);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['created'] = Variable<DateTime>(created);
    map['modified'] = Variable<DateTime>(modified);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['type'] = Variable<String>(type);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['locked'] = Variable<bool>(locked);
    map['encrypted'] = Variable<bool>(encrypted);
    if (!nullToAbsent || iv != null) {
      map['iv'] = Variable<String>(iv);
    }
    if (!nullToAbsent || encMode != null) {
      map['enc_mode'] = Variable<String>(encMode);
    }
    if (!nullToAbsent || textContent != null) {
      map['text'] = Variable<String>(textContent);
    }
    if (!nullToAbsent || richData != null) {
      map['rich_data'] = Variable<String>(richData);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || textCategory != null) {
      map['text_category'] = Variable<String>(textCategory);
    }
    if (!nullToAbsent || linkPreviewTitle != null) {
      map['link_preview_title'] = Variable<String>(linkPreviewTitle);
    }
    if (!nullToAbsent || linkPreviewDescription != null) {
      map['link_preview_description'] = Variable<String>(
        linkPreviewDescription,
      );
    }
    if (!nullToAbsent || linkPreviewImageUrl != null) {
      map['link_preview_image_url'] = Variable<String>(linkPreviewImageUrl);
    }
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || fileMimeType != null) {
      map['file_mime_type'] = Variable<String>(fileMimeType);
    }
    if (!nullToAbsent || fileExtension != null) {
      map['file_extension'] = Variable<String>(fileExtension);
    }
    if (!nullToAbsent || driveFileId != null) {
      map['drive_file_id'] = Variable<String>(driveFileId);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    if (!nullToAbsent || imgBlurHash != null) {
      map['img_blur_hash'] = Variable<String>(imgBlurHash);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || sourceApp != null) {
      map['source_app'] = Variable<String>(sourceApp);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['os'] = Variable<String>(os);
    if (!nullToAbsent || serverCollectionId != null) {
      map['server_collection_id'] = Variable<int>(serverCollectionId);
    }
    if (!nullToAbsent || collectionId != null) {
      map['collection_id'] = Variable<int>(collectionId);
    }
    map['local_only'] = Variable<bool>(localOnly);
    map['copied_count'] = Variable<int>(copiedCount);
    if (!nullToAbsent || lastCopied != null) {
      map['last_copied'] = Variable<DateTime>(lastCopied);
    }
    if (!nullToAbsent || originId != null) {
      map['origin_id'] = Variable<String>(originId);
    }
    if (!nullToAbsent || searchTokens != null) {
      map['search_tokens'] = Variable<String>(searchTokens);
    }
    return map;
  }

  DriftClipboardItemTableCompanion toCompanion(bool nullToAbsent) {
    return DriftClipboardItemTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      created: Value(created),
      modified: Value(modified),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      type: Value(type),
      userId: Value(userId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      locked: Value(locked),
      encrypted: Value(encrypted),
      iv: iv == null && nullToAbsent ? const Value.absent() : Value(iv),
      encMode: encMode == null && nullToAbsent
          ? const Value.absent()
          : Value(encMode),
      textContent: textContent == null && nullToAbsent
          ? const Value.absent()
          : Value(textContent),
      richData: richData == null && nullToAbsent
          ? const Value.absent()
          : Value(richData),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      textCategory: textCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(textCategory),
      linkPreviewTitle: linkPreviewTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(linkPreviewTitle),
      linkPreviewDescription: linkPreviewDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(linkPreviewDescription),
      linkPreviewImageUrl: linkPreviewImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(linkPreviewImageUrl),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      fileMimeType: fileMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileMimeType),
      fileExtension: fileExtension == null && nullToAbsent
          ? const Value.absent()
          : Value(fileExtension),
      driveFileId: driveFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(driveFileId),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      imgBlurHash: imgBlurHash == null && nullToAbsent
          ? const Value.absent()
          : Value(imgBlurHash),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      sourceApp: sourceApp == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceApp),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      os: Value(os),
      serverCollectionId: serverCollectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverCollectionId),
      collectionId: collectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(collectionId),
      localOnly: Value(localOnly),
      copiedCount: Value(copiedCount),
      lastCopied: lastCopied == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCopied),
      originId: originId == null && nullToAbsent
          ? const Value.absent()
          : Value(originId),
      searchTokens: searchTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(searchTokens),
    );
  }

  factory DriftClipboardItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftClipboardItemEntry(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      created: serializer.fromJson<DateTime>(json['created']),
      modified: serializer.fromJson<DateTime>(json['modified']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      type: serializer.fromJson<String>(json['type']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String?>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      locked: serializer.fromJson<bool>(json['locked']),
      encrypted: serializer.fromJson<bool>(json['encrypted']),
      iv: serializer.fromJson<String?>(json['iv']),
      encMode: serializer.fromJson<String?>(json['encMode']),
      textContent: serializer.fromJson<String?>(json['textContent']),
      richData: serializer.fromJson<String?>(json['richData']),
      url: serializer.fromJson<String?>(json['url']),
      textCategory: serializer.fromJson<String?>(json['textCategory']),
      linkPreviewTitle: serializer.fromJson<String?>(json['linkPreviewTitle']),
      linkPreviewDescription: serializer.fromJson<String?>(
        json['linkPreviewDescription'],
      ),
      linkPreviewImageUrl: serializer.fromJson<String?>(
        json['linkPreviewImageUrl'],
      ),
      fileName: serializer.fromJson<String?>(json['fileName']),
      fileMimeType: serializer.fromJson<String?>(json['fileMimeType']),
      fileExtension: serializer.fromJson<String?>(json['fileExtension']),
      driveFileId: serializer.fromJson<String?>(json['driveFileId']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      imgBlurHash: serializer.fromJson<String?>(json['imgBlurHash']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      sourceApp: serializer.fromJson<String?>(json['sourceApp']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      os: serializer.fromJson<String>(json['os']),
      serverCollectionId: serializer.fromJson<int?>(json['serverCollectionId']),
      collectionId: serializer.fromJson<int?>(json['collectionId']),
      localOnly: serializer.fromJson<bool>(json['localOnly']),
      copiedCount: serializer.fromJson<int>(json['copiedCount']),
      lastCopied: serializer.fromJson<DateTime?>(json['lastCopied']),
      originId: serializer.fromJson<String?>(json['originId']),
      searchTokens: serializer.fromJson<String?>(json['searchTokens']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
      'localPath': serializer.toJson<String?>(localPath),
      'created': serializer.toJson<DateTime>(created),
      'modified': serializer.toJson<DateTime>(modified),
      'deviceId': serializer.toJson<String?>(deviceId),
      'type': serializer.toJson<String>(type),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String?>(title),
      'description': serializer.toJson<String?>(description),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'locked': serializer.toJson<bool>(locked),
      'encrypted': serializer.toJson<bool>(encrypted),
      'iv': serializer.toJson<String?>(iv),
      'encMode': serializer.toJson<String?>(encMode),
      'textContent': serializer.toJson<String?>(textContent),
      'richData': serializer.toJson<String?>(richData),
      'url': serializer.toJson<String?>(url),
      'textCategory': serializer.toJson<String?>(textCategory),
      'linkPreviewTitle': serializer.toJson<String?>(linkPreviewTitle),
      'linkPreviewDescription': serializer.toJson<String?>(
        linkPreviewDescription,
      ),
      'linkPreviewImageUrl': serializer.toJson<String?>(linkPreviewImageUrl),
      'fileName': serializer.toJson<String?>(fileName),
      'fileMimeType': serializer.toJson<String?>(fileMimeType),
      'fileExtension': serializer.toJson<String?>(fileExtension),
      'driveFileId': serializer.toJson<String?>(driveFileId),
      'fileSize': serializer.toJson<int?>(fileSize),
      'imgBlurHash': serializer.toJson<String?>(imgBlurHash),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'sourceApp': serializer.toJson<String?>(sourceApp),
      'sourceId': serializer.toJson<String?>(sourceId),
      'os': serializer.toJson<String>(os),
      'serverCollectionId': serializer.toJson<int?>(serverCollectionId),
      'collectionId': serializer.toJson<int?>(collectionId),
      'localOnly': serializer.toJson<bool>(localOnly),
      'copiedCount': serializer.toJson<int>(copiedCount),
      'lastCopied': serializer.toJson<DateTime?>(lastCopied),
      'originId': serializer.toJson<String?>(originId),
      'searchTokens': serializer.toJson<String?>(searchTokens),
    };
  }

  DriftClipboardItemEntry copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    Value<DateTime?> lastSynced = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    DateTime? created,
    DateTime? modified,
    Value<String?> deviceId = const Value.absent(),
    String? type,
    String? userId,
    Value<String?> title = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? locked,
    bool? encrypted,
    Value<String?> iv = const Value.absent(),
    Value<String?> encMode = const Value.absent(),
    Value<String?> textContent = const Value.absent(),
    Value<String?> richData = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> textCategory = const Value.absent(),
    Value<String?> linkPreviewTitle = const Value.absent(),
    Value<String?> linkPreviewDescription = const Value.absent(),
    Value<String?> linkPreviewImageUrl = const Value.absent(),
    Value<String?> fileName = const Value.absent(),
    Value<String?> fileMimeType = const Value.absent(),
    Value<String?> fileExtension = const Value.absent(),
    Value<String?> driveFileId = const Value.absent(),
    Value<int?> fileSize = const Value.absent(),
    Value<String?> imgBlurHash = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    Value<String?> sourceApp = const Value.absent(),
    Value<String?> sourceId = const Value.absent(),
    String? os,
    Value<int?> serverCollectionId = const Value.absent(),
    Value<int?> collectionId = const Value.absent(),
    bool? localOnly,
    int? copiedCount,
    Value<DateTime?> lastCopied = const Value.absent(),
    Value<String?> originId = const Value.absent(),
    Value<String?> searchTokens = const Value.absent(),
  }) => DriftClipboardItemEntry(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    lastSynced: lastSynced.present ? lastSynced.value : this.lastSynced,
    localPath: localPath.present ? localPath.value : this.localPath,
    created: created ?? this.created,
    modified: modified ?? this.modified,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    type: type ?? this.type,
    userId: userId ?? this.userId,
    title: title.present ? title.value : this.title,
    description: description.present ? description.value : this.description,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    locked: locked ?? this.locked,
    encrypted: encrypted ?? this.encrypted,
    iv: iv.present ? iv.value : this.iv,
    encMode: encMode.present ? encMode.value : this.encMode,
    textContent: textContent.present ? textContent.value : this.textContent,
    richData: richData.present ? richData.value : this.richData,
    url: url.present ? url.value : this.url,
    textCategory: textCategory.present ? textCategory.value : this.textCategory,
    linkPreviewTitle: linkPreviewTitle.present
        ? linkPreviewTitle.value
        : this.linkPreviewTitle,
    linkPreviewDescription: linkPreviewDescription.present
        ? linkPreviewDescription.value
        : this.linkPreviewDescription,
    linkPreviewImageUrl: linkPreviewImageUrl.present
        ? linkPreviewImageUrl.value
        : this.linkPreviewImageUrl,
    fileName: fileName.present ? fileName.value : this.fileName,
    fileMimeType: fileMimeType.present ? fileMimeType.value : this.fileMimeType,
    fileExtension: fileExtension.present
        ? fileExtension.value
        : this.fileExtension,
    driveFileId: driveFileId.present ? driveFileId.value : this.driveFileId,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    imgBlurHash: imgBlurHash.present ? imgBlurHash.value : this.imgBlurHash,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    sourceApp: sourceApp.present ? sourceApp.value : this.sourceApp,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    os: os ?? this.os,
    serverCollectionId: serverCollectionId.present
        ? serverCollectionId.value
        : this.serverCollectionId,
    collectionId: collectionId.present ? collectionId.value : this.collectionId,
    localOnly: localOnly ?? this.localOnly,
    copiedCount: copiedCount ?? this.copiedCount,
    lastCopied: lastCopied.present ? lastCopied.value : this.lastCopied,
    originId: originId.present ? originId.value : this.originId,
    searchTokens: searchTokens.present ? searchTokens.value : this.searchTokens,
  );
  DriftClipboardItemEntry copyWithCompanion(
    DriftClipboardItemTableCompanion data,
  ) {
    return DriftClipboardItemEntry(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      lastSynced: data.lastSynced.present
          ? data.lastSynced.value
          : this.lastSynced,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      created: data.created.present ? data.created.value : this.created,
      modified: data.modified.present ? data.modified.value : this.modified,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      type: data.type.present ? data.type.value : this.type,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      locked: data.locked.present ? data.locked.value : this.locked,
      encrypted: data.encrypted.present ? data.encrypted.value : this.encrypted,
      iv: data.iv.present ? data.iv.value : this.iv,
      encMode: data.encMode.present ? data.encMode.value : this.encMode,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      richData: data.richData.present ? data.richData.value : this.richData,
      url: data.url.present ? data.url.value : this.url,
      textCategory: data.textCategory.present
          ? data.textCategory.value
          : this.textCategory,
      linkPreviewTitle: data.linkPreviewTitle.present
          ? data.linkPreviewTitle.value
          : this.linkPreviewTitle,
      linkPreviewDescription: data.linkPreviewDescription.present
          ? data.linkPreviewDescription.value
          : this.linkPreviewDescription,
      linkPreviewImageUrl: data.linkPreviewImageUrl.present
          ? data.linkPreviewImageUrl.value
          : this.linkPreviewImageUrl,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileMimeType: data.fileMimeType.present
          ? data.fileMimeType.value
          : this.fileMimeType,
      fileExtension: data.fileExtension.present
          ? data.fileExtension.value
          : this.fileExtension,
      driveFileId: data.driveFileId.present
          ? data.driveFileId.value
          : this.driveFileId,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      imgBlurHash: data.imgBlurHash.present
          ? data.imgBlurHash.value
          : this.imgBlurHash,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      sourceApp: data.sourceApp.present ? data.sourceApp.value : this.sourceApp,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      os: data.os.present ? data.os.value : this.os,
      serverCollectionId: data.serverCollectionId.present
          ? data.serverCollectionId.value
          : this.serverCollectionId,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      localOnly: data.localOnly.present ? data.localOnly.value : this.localOnly,
      copiedCount: data.copiedCount.present
          ? data.copiedCount.value
          : this.copiedCount,
      lastCopied: data.lastCopied.present
          ? data.lastCopied.value
          : this.lastCopied,
      originId: data.originId.present ? data.originId.value : this.originId,
      searchTokens: data.searchTokens.present
          ? data.searchTokens.value
          : this.searchTokens,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftClipboardItemEntry(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('localPath: $localPath, ')
          ..write('created: $created, ')
          ..write('modified: $modified, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('locked: $locked, ')
          ..write('encrypted: $encrypted, ')
          ..write('iv: $iv, ')
          ..write('encMode: $encMode, ')
          ..write('textContent: $textContent, ')
          ..write('richData: $richData, ')
          ..write('url: $url, ')
          ..write('textCategory: $textCategory, ')
          ..write('linkPreviewTitle: $linkPreviewTitle, ')
          ..write('linkPreviewDescription: $linkPreviewDescription, ')
          ..write('linkPreviewImageUrl: $linkPreviewImageUrl, ')
          ..write('fileName: $fileName, ')
          ..write('fileMimeType: $fileMimeType, ')
          ..write('fileExtension: $fileExtension, ')
          ..write('driveFileId: $driveFileId, ')
          ..write('fileSize: $fileSize, ')
          ..write('imgBlurHash: $imgBlurHash, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceApp: $sourceApp, ')
          ..write('sourceId: $sourceId, ')
          ..write('os: $os, ')
          ..write('serverCollectionId: $serverCollectionId, ')
          ..write('collectionId: $collectionId, ')
          ..write('localOnly: $localOnly, ')
          ..write('copiedCount: $copiedCount, ')
          ..write('lastCopied: $lastCopied, ')
          ..write('originId: $originId, ')
          ..write('searchTokens: $searchTokens')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    lastSynced,
    localPath,
    created,
    modified,
    deviceId,
    type,
    userId,
    title,
    description,
    deletedAt,
    locked,
    encrypted,
    iv,
    encMode,
    textContent,
    richData,
    url,
    textCategory,
    linkPreviewTitle,
    linkPreviewDescription,
    linkPreviewImageUrl,
    fileName,
    fileMimeType,
    fileExtension,
    driveFileId,
    fileSize,
    imgBlurHash,
    sourceUrl,
    sourceApp,
    sourceId,
    os,
    serverCollectionId,
    collectionId,
    localOnly,
    copiedCount,
    lastCopied,
    originId,
    searchTokens,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftClipboardItemEntry &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.lastSynced == this.lastSynced &&
          other.localPath == this.localPath &&
          other.created == this.created &&
          other.modified == this.modified &&
          other.deviceId == this.deviceId &&
          other.type == this.type &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.deletedAt == this.deletedAt &&
          other.locked == this.locked &&
          other.encrypted == this.encrypted &&
          other.iv == this.iv &&
          other.encMode == this.encMode &&
          other.textContent == this.textContent &&
          other.richData == this.richData &&
          other.url == this.url &&
          other.textCategory == this.textCategory &&
          other.linkPreviewTitle == this.linkPreviewTitle &&
          other.linkPreviewDescription == this.linkPreviewDescription &&
          other.linkPreviewImageUrl == this.linkPreviewImageUrl &&
          other.fileName == this.fileName &&
          other.fileMimeType == this.fileMimeType &&
          other.fileExtension == this.fileExtension &&
          other.driveFileId == this.driveFileId &&
          other.fileSize == this.fileSize &&
          other.imgBlurHash == this.imgBlurHash &&
          other.sourceUrl == this.sourceUrl &&
          other.sourceApp == this.sourceApp &&
          other.sourceId == this.sourceId &&
          other.os == this.os &&
          other.serverCollectionId == this.serverCollectionId &&
          other.collectionId == this.collectionId &&
          other.localOnly == this.localOnly &&
          other.copiedCount == this.copiedCount &&
          other.lastCopied == this.lastCopied &&
          other.originId == this.originId &&
          other.searchTokens == this.searchTokens);
}

class DriftClipboardItemTableCompanion
    extends UpdateCompanion<DriftClipboardItemEntry> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<DateTime?> lastSynced;
  final Value<String?> localPath;
  final Value<DateTime> created;
  final Value<DateTime> modified;
  final Value<String?> deviceId;
  final Value<String> type;
  final Value<String> userId;
  final Value<String?> title;
  final Value<String?> description;
  final Value<DateTime?> deletedAt;
  final Value<bool> locked;
  final Value<bool> encrypted;
  final Value<String?> iv;
  final Value<String?> encMode;
  final Value<String?> textContent;
  final Value<String?> richData;
  final Value<String?> url;
  final Value<String?> textCategory;
  final Value<String?> linkPreviewTitle;
  final Value<String?> linkPreviewDescription;
  final Value<String?> linkPreviewImageUrl;
  final Value<String?> fileName;
  final Value<String?> fileMimeType;
  final Value<String?> fileExtension;
  final Value<String?> driveFileId;
  final Value<int?> fileSize;
  final Value<String?> imgBlurHash;
  final Value<String?> sourceUrl;
  final Value<String?> sourceApp;
  final Value<String?> sourceId;
  final Value<String> os;
  final Value<int?> serverCollectionId;
  final Value<int?> collectionId;
  final Value<bool> localOnly;
  final Value<int> copiedCount;
  final Value<DateTime?> lastCopied;
  final Value<String?> originId;
  final Value<String?> searchTokens;
  const DriftClipboardItemTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.localPath = const Value.absent(),
    this.created = const Value.absent(),
    this.modified = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.type = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.locked = const Value.absent(),
    this.encrypted = const Value.absent(),
    this.iv = const Value.absent(),
    this.encMode = const Value.absent(),
    this.textContent = const Value.absent(),
    this.richData = const Value.absent(),
    this.url = const Value.absent(),
    this.textCategory = const Value.absent(),
    this.linkPreviewTitle = const Value.absent(),
    this.linkPreviewDescription = const Value.absent(),
    this.linkPreviewImageUrl = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileMimeType = const Value.absent(),
    this.fileExtension = const Value.absent(),
    this.driveFileId = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.imgBlurHash = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.sourceApp = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.os = const Value.absent(),
    this.serverCollectionId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.localOnly = const Value.absent(),
    this.copiedCount = const Value.absent(),
    this.lastCopied = const Value.absent(),
    this.originId = const Value.absent(),
    this.searchTokens = const Value.absent(),
  });
  DriftClipboardItemTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.localPath = const Value.absent(),
    required DateTime created,
    required DateTime modified,
    this.deviceId = const Value.absent(),
    required String type,
    required String userId,
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.locked = const Value.absent(),
    this.encrypted = const Value.absent(),
    this.iv = const Value.absent(),
    this.encMode = const Value.absent(),
    this.textContent = const Value.absent(),
    this.richData = const Value.absent(),
    this.url = const Value.absent(),
    this.textCategory = const Value.absent(),
    this.linkPreviewTitle = const Value.absent(),
    this.linkPreviewDescription = const Value.absent(),
    this.linkPreviewImageUrl = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileMimeType = const Value.absent(),
    this.fileExtension = const Value.absent(),
    this.driveFileId = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.imgBlurHash = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.sourceApp = const Value.absent(),
    this.sourceId = const Value.absent(),
    required String os,
    this.serverCollectionId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.localOnly = const Value.absent(),
    this.copiedCount = const Value.absent(),
    this.lastCopied = const Value.absent(),
    this.originId = const Value.absent(),
    this.searchTokens = const Value.absent(),
  }) : created = Value(created),
       modified = Value(modified),
       type = Value(type),
       userId = Value(userId),
       os = Value(os);
  static Insertable<DriftClipboardItemEntry> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<DateTime>? lastSynced,
    Expression<String>? localPath,
    Expression<DateTime>? created,
    Expression<DateTime>? modified,
    Expression<String>? deviceId,
    Expression<String>? type,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? deletedAt,
    Expression<bool>? locked,
    Expression<bool>? encrypted,
    Expression<String>? iv,
    Expression<String>? encMode,
    Expression<String>? textContent,
    Expression<String>? richData,
    Expression<String>? url,
    Expression<String>? textCategory,
    Expression<String>? linkPreviewTitle,
    Expression<String>? linkPreviewDescription,
    Expression<String>? linkPreviewImageUrl,
    Expression<String>? fileName,
    Expression<String>? fileMimeType,
    Expression<String>? fileExtension,
    Expression<String>? driveFileId,
    Expression<int>? fileSize,
    Expression<String>? imgBlurHash,
    Expression<String>? sourceUrl,
    Expression<String>? sourceApp,
    Expression<String>? sourceId,
    Expression<String>? os,
    Expression<int>? serverCollectionId,
    Expression<int>? collectionId,
    Expression<bool>? localOnly,
    Expression<int>? copiedCount,
    Expression<DateTime>? lastCopied,
    Expression<String>? originId,
    Expression<String>? searchTokens,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (localPath != null) 'local_path': localPath,
      if (created != null) 'created': created,
      if (modified != null) 'modified': modified,
      if (deviceId != null) 'device_id': deviceId,
      if (type != null) 'type': type,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (locked != null) 'locked': locked,
      if (encrypted != null) 'encrypted': encrypted,
      if (iv != null) 'iv': iv,
      if (encMode != null) 'enc_mode': encMode,
      if (textContent != null) 'text': textContent,
      if (richData != null) 'rich_data': richData,
      if (url != null) 'url': url,
      if (textCategory != null) 'text_category': textCategory,
      if (linkPreviewTitle != null) 'link_preview_title': linkPreviewTitle,
      if (linkPreviewDescription != null)
        'link_preview_description': linkPreviewDescription,
      if (linkPreviewImageUrl != null)
        'link_preview_image_url': linkPreviewImageUrl,
      if (fileName != null) 'file_name': fileName,
      if (fileMimeType != null) 'file_mime_type': fileMimeType,
      if (fileExtension != null) 'file_extension': fileExtension,
      if (driveFileId != null) 'drive_file_id': driveFileId,
      if (fileSize != null) 'file_size': fileSize,
      if (imgBlurHash != null) 'img_blur_hash': imgBlurHash,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (sourceApp != null) 'source_app': sourceApp,
      if (sourceId != null) 'source_id': sourceId,
      if (os != null) 'os': os,
      if (serverCollectionId != null)
        'server_collection_id': serverCollectionId,
      if (collectionId != null) 'collection_id': collectionId,
      if (localOnly != null) 'local_only': localOnly,
      if (copiedCount != null) 'copied_count': copiedCount,
      if (lastCopied != null) 'last_copied': lastCopied,
      if (originId != null) 'origin_id': originId,
      if (searchTokens != null) 'search_tokens': searchTokens,
    });
  }

  DriftClipboardItemTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<DateTime?>? lastSynced,
    Value<String?>? localPath,
    Value<DateTime>? created,
    Value<DateTime>? modified,
    Value<String?>? deviceId,
    Value<String>? type,
    Value<String>? userId,
    Value<String?>? title,
    Value<String?>? description,
    Value<DateTime?>? deletedAt,
    Value<bool>? locked,
    Value<bool>? encrypted,
    Value<String?>? iv,
    Value<String?>? encMode,
    Value<String?>? textContent,
    Value<String?>? richData,
    Value<String?>? url,
    Value<String?>? textCategory,
    Value<String?>? linkPreviewTitle,
    Value<String?>? linkPreviewDescription,
    Value<String?>? linkPreviewImageUrl,
    Value<String?>? fileName,
    Value<String?>? fileMimeType,
    Value<String?>? fileExtension,
    Value<String?>? driveFileId,
    Value<int?>? fileSize,
    Value<String?>? imgBlurHash,
    Value<String?>? sourceUrl,
    Value<String?>? sourceApp,
    Value<String?>? sourceId,
    Value<String>? os,
    Value<int?>? serverCollectionId,
    Value<int?>? collectionId,
    Value<bool>? localOnly,
    Value<int>? copiedCount,
    Value<DateTime?>? lastCopied,
    Value<String?>? originId,
    Value<String?>? searchTokens,
  }) {
    return DriftClipboardItemTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      lastSynced: lastSynced ?? this.lastSynced,
      localPath: localPath ?? this.localPath,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      deletedAt: deletedAt ?? this.deletedAt,
      locked: locked ?? this.locked,
      encrypted: encrypted ?? this.encrypted,
      iv: iv ?? this.iv,
      encMode: encMode ?? this.encMode,
      textContent: textContent ?? this.textContent,
      richData: richData ?? this.richData,
      url: url ?? this.url,
      textCategory: textCategory ?? this.textCategory,
      linkPreviewTitle: linkPreviewTitle ?? this.linkPreviewTitle,
      linkPreviewDescription:
          linkPreviewDescription ?? this.linkPreviewDescription,
      linkPreviewImageUrl: linkPreviewImageUrl ?? this.linkPreviewImageUrl,
      fileName: fileName ?? this.fileName,
      fileMimeType: fileMimeType ?? this.fileMimeType,
      fileExtension: fileExtension ?? this.fileExtension,
      driveFileId: driveFileId ?? this.driveFileId,
      fileSize: fileSize ?? this.fileSize,
      imgBlurHash: imgBlurHash ?? this.imgBlurHash,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceApp: sourceApp ?? this.sourceApp,
      sourceId: sourceId ?? this.sourceId,
      os: os ?? this.os,
      serverCollectionId: serverCollectionId ?? this.serverCollectionId,
      collectionId: collectionId ?? this.collectionId,
      localOnly: localOnly ?? this.localOnly,
      copiedCount: copiedCount ?? this.copiedCount,
      lastCopied: lastCopied ?? this.lastCopied,
      originId: originId ?? this.originId,
      searchTokens: searchTokens ?? this.searchTokens,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (locked.present) {
      map['locked'] = Variable<bool>(locked.value);
    }
    if (encrypted.present) {
      map['encrypted'] = Variable<bool>(encrypted.value);
    }
    if (iv.present) {
      map['iv'] = Variable<String>(iv.value);
    }
    if (encMode.present) {
      map['enc_mode'] = Variable<String>(encMode.value);
    }
    if (textContent.present) {
      map['text'] = Variable<String>(textContent.value);
    }
    if (richData.present) {
      map['rich_data'] = Variable<String>(richData.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (textCategory.present) {
      map['text_category'] = Variable<String>(textCategory.value);
    }
    if (linkPreviewTitle.present) {
      map['link_preview_title'] = Variable<String>(linkPreviewTitle.value);
    }
    if (linkPreviewDescription.present) {
      map['link_preview_description'] = Variable<String>(
        linkPreviewDescription.value,
      );
    }
    if (linkPreviewImageUrl.present) {
      map['link_preview_image_url'] = Variable<String>(
        linkPreviewImageUrl.value,
      );
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileMimeType.present) {
      map['file_mime_type'] = Variable<String>(fileMimeType.value);
    }
    if (fileExtension.present) {
      map['file_extension'] = Variable<String>(fileExtension.value);
    }
    if (driveFileId.present) {
      map['drive_file_id'] = Variable<String>(driveFileId.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (imgBlurHash.present) {
      map['img_blur_hash'] = Variable<String>(imgBlurHash.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (sourceApp.present) {
      map['source_app'] = Variable<String>(sourceApp.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (os.present) {
      map['os'] = Variable<String>(os.value);
    }
    if (serverCollectionId.present) {
      map['server_collection_id'] = Variable<int>(serverCollectionId.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (localOnly.present) {
      map['local_only'] = Variable<bool>(localOnly.value);
    }
    if (copiedCount.present) {
      map['copied_count'] = Variable<int>(copiedCount.value);
    }
    if (lastCopied.present) {
      map['last_copied'] = Variable<DateTime>(lastCopied.value);
    }
    if (originId.present) {
      map['origin_id'] = Variable<String>(originId.value);
    }
    if (searchTokens.present) {
      map['search_tokens'] = Variable<String>(searchTokens.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftClipboardItemTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('localPath: $localPath, ')
          ..write('created: $created, ')
          ..write('modified: $modified, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('locked: $locked, ')
          ..write('encrypted: $encrypted, ')
          ..write('iv: $iv, ')
          ..write('encMode: $encMode, ')
          ..write('textContent: $textContent, ')
          ..write('richData: $richData, ')
          ..write('url: $url, ')
          ..write('textCategory: $textCategory, ')
          ..write('linkPreviewTitle: $linkPreviewTitle, ')
          ..write('linkPreviewDescription: $linkPreviewDescription, ')
          ..write('linkPreviewImageUrl: $linkPreviewImageUrl, ')
          ..write('fileName: $fileName, ')
          ..write('fileMimeType: $fileMimeType, ')
          ..write('fileExtension: $fileExtension, ')
          ..write('driveFileId: $driveFileId, ')
          ..write('fileSize: $fileSize, ')
          ..write('imgBlurHash: $imgBlurHash, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceApp: $sourceApp, ')
          ..write('sourceId: $sourceId, ')
          ..write('os: $os, ')
          ..write('serverCollectionId: $serverCollectionId, ')
          ..write('collectionId: $collectionId, ')
          ..write('localOnly: $localOnly, ')
          ..write('copiedCount: $copiedCount, ')
          ..write('lastCopied: $lastCopied, ')
          ..write('originId: $originId, ')
          ..write('searchTokens: $searchTokens')
          ..write(')'))
        .toString();
  }
}

class $DriftSubscriptionTableTable extends DriftSubscriptionTable
    with TableInfo<$DriftSubscriptionTableTable, DriftSubscriptionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftSubscriptionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planNameMeta = const VerificationMeta(
    'planName',
  );
  @override
  late final GeneratedColumn<String> planName = GeneratedColumn<String>(
    'plan_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subIdMeta = const VerificationMeta('subId');
  @override
  late final GeneratedColumn<String> subId = GeneratedColumn<String>(
    'sub_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trialStartMeta = const VerificationMeta(
    'trialStart',
  );
  @override
  late final GeneratedColumn<DateTime> trialStart = GeneratedColumn<DateTime>(
    'trial_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialEndMeta = const VerificationMeta(
    'trialEnd',
  );
  @override
  late final GeneratedColumn<DateTime> trialEnd = GeneratedColumn<DateTime>(
    'trial_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _collectionsMeta = const VerificationMeta(
    'collections',
  );
  @override
  late final GeneratedColumn<int> collections = GeneratedColumn<int>(
    'collections',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _itemsPerCollectionMeta =
      const VerificationMeta('itemsPerCollection');
  @override
  late final GeneratedColumn<int> itemsPerCollection = GeneratedColumn<int>(
    'items_per_collection',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _dragNdropMeta = const VerificationMeta(
    'dragNdrop',
  );
  @override
  late final GeneratedColumn<bool> dragNdrop = GeneratedColumn<bool>(
    'drag_ndrop',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("drag_ndrop" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _themingMeta = const VerificationMeta(
    'theming',
  );
  @override
  late final GeneratedColumn<bool> theming = GeneratedColumn<bool>(
    'theming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("theming" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncHoursMeta = const VerificationMeta(
    'syncHours',
  );
  @override
  late final GeneratedColumn<int> syncHours = GeneratedColumn<int>(
    'sync_hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(24),
  );
  static const VerificationMeta _adsMeta = const VerificationMeta('ads');
  @override
  late final GeneratedColumn<bool> ads = GeneratedColumn<bool>(
    'ads',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ads" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncIntervalMeta = const VerificationMeta(
    'syncInterval',
  );
  @override
  late final GeneratedColumn<int> syncInterval = GeneratedColumn<int>(
    'sync_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(45),
  );
  static const VerificationMeta _editMeta = const VerificationMeta('edit');
  @override
  late final GeneratedColumn<bool> edit = GeneratedColumn<bool>(
    'edit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("edit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeTillMeta = const VerificationMeta(
    'activeTill',
  );
  @override
  late final GeneratedColumn<DateTime> activeTill = GeneratedColumn<DateTime>(
    'active_till',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxSyncDevicesMeta = const VerificationMeta(
    'maxSyncDevices',
  );
  @override
  late final GeneratedColumn<int> maxSyncDevices = GeneratedColumn<int>(
    'max_sync_devices',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _customExclusionRulesMeta =
      const VerificationMeta('customExclusionRules');
  @override
  late final GeneratedColumn<bool> customExclusionRules = GeneratedColumn<bool>(
    'custom_exclusion_rules',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("custom_exclusion_rules" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pasteStackLimitMeta = const VerificationMeta(
    'pasteStackLimit',
  );
  @override
  late final GeneratedColumn<int> pasteStackLimit = GeneratedColumn<int>(
    'paste_stack_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _grantsMeta = const VerificationMeta('grants');
  @override
  late final GeneratedColumn<int> grants = GeneratedColumn<int>(
    'grants',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tknMeta = const VerificationMeta('tkn');
  @override
  late final GeneratedColumn<String> tkn = GeneratedColumn<String>(
    'tkn',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    created,
    modified,
    userId,
    planName,
    subId,
    source,
    trialStart,
    trialEnd,
    collections,
    itemsPerCollection,
    dragNdrop,
    theming,
    syncHours,
    ads,
    syncInterval,
    edit,
    activeTill,
    maxSyncDevices,
    customExclusionRules,
    pasteStackLimit,
    grants,
    tkn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftSubscriptionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('plan_name')) {
      context.handle(
        _planNameMeta,
        planName.isAcceptableOrUnknown(data['plan_name']!, _planNameMeta),
      );
    } else if (isInserting) {
      context.missing(_planNameMeta);
    }
    if (data.containsKey('sub_id')) {
      context.handle(
        _subIdMeta,
        subId.isAcceptableOrUnknown(data['sub_id']!, _subIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('trial_start')) {
      context.handle(
        _trialStartMeta,
        trialStart.isAcceptableOrUnknown(data['trial_start']!, _trialStartMeta),
      );
    }
    if (data.containsKey('trial_end')) {
      context.handle(
        _trialEndMeta,
        trialEnd.isAcceptableOrUnknown(data['trial_end']!, _trialEndMeta),
      );
    }
    if (data.containsKey('collections')) {
      context.handle(
        _collectionsMeta,
        collections.isAcceptableOrUnknown(
          data['collections']!,
          _collectionsMeta,
        ),
      );
    }
    if (data.containsKey('items_per_collection')) {
      context.handle(
        _itemsPerCollectionMeta,
        itemsPerCollection.isAcceptableOrUnknown(
          data['items_per_collection']!,
          _itemsPerCollectionMeta,
        ),
      );
    }
    if (data.containsKey('drag_ndrop')) {
      context.handle(
        _dragNdropMeta,
        dragNdrop.isAcceptableOrUnknown(data['drag_ndrop']!, _dragNdropMeta),
      );
    }
    if (data.containsKey('theming')) {
      context.handle(
        _themingMeta,
        theming.isAcceptableOrUnknown(data['theming']!, _themingMeta),
      );
    }
    if (data.containsKey('sync_hours')) {
      context.handle(
        _syncHoursMeta,
        syncHours.isAcceptableOrUnknown(data['sync_hours']!, _syncHoursMeta),
      );
    }
    if (data.containsKey('ads')) {
      context.handle(
        _adsMeta,
        ads.isAcceptableOrUnknown(data['ads']!, _adsMeta),
      );
    }
    if (data.containsKey('sync_interval')) {
      context.handle(
        _syncIntervalMeta,
        syncInterval.isAcceptableOrUnknown(
          data['sync_interval']!,
          _syncIntervalMeta,
        ),
      );
    }
    if (data.containsKey('edit')) {
      context.handle(
        _editMeta,
        edit.isAcceptableOrUnknown(data['edit']!, _editMeta),
      );
    }
    if (data.containsKey('active_till')) {
      context.handle(
        _activeTillMeta,
        activeTill.isAcceptableOrUnknown(data['active_till']!, _activeTillMeta),
      );
    }
    if (data.containsKey('max_sync_devices')) {
      context.handle(
        _maxSyncDevicesMeta,
        maxSyncDevices.isAcceptableOrUnknown(
          data['max_sync_devices']!,
          _maxSyncDevicesMeta,
        ),
      );
    }
    if (data.containsKey('custom_exclusion_rules')) {
      context.handle(
        _customExclusionRulesMeta,
        customExclusionRules.isAcceptableOrUnknown(
          data['custom_exclusion_rules']!,
          _customExclusionRulesMeta,
        ),
      );
    }
    if (data.containsKey('paste_stack_limit')) {
      context.handle(
        _pasteStackLimitMeta,
        pasteStackLimit.isAcceptableOrUnknown(
          data['paste_stack_limit']!,
          _pasteStackLimitMeta,
        ),
      );
    }
    if (data.containsKey('grants')) {
      context.handle(
        _grantsMeta,
        grants.isAcceptableOrUnknown(data['grants']!, _grantsMeta),
      );
    }
    if (data.containsKey('tkn')) {
      context.handle(
        _tknMeta,
        tkn.isAcceptableOrUnknown(data['tkn']!, _tknMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftSubscriptionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftSubscriptionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      modified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      planName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_name'],
      )!,
      subId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      trialStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_start'],
      ),
      trialEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_end'],
      ),
      collections: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collections'],
      )!,
      itemsPerCollection: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_per_collection'],
      )!,
      dragNdrop: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}drag_ndrop'],
      )!,
      theming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}theming'],
      )!,
      syncHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_hours'],
      )!,
      ads: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ads'],
      )!,
      syncInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_interval'],
      )!,
      edit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}edit'],
      )!,
      activeTill: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}active_till'],
      ),
      maxSyncDevices: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_sync_devices'],
      )!,
      customExclusionRules: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}custom_exclusion_rules'],
      )!,
      pasteStackLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paste_stack_limit'],
      )!,
      grants: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grants'],
      )!,
      tkn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tkn'],
      ),
    );
  }

  @override
  $DriftSubscriptionTableTable createAlias(String alias) {
    return $DriftSubscriptionTableTable(attachedDatabase, alias);
  }
}

class DriftSubscriptionEntry extends DataClass
    implements Insertable<DriftSubscriptionEntry> {
  final int id;
  final int? serverId;
  final DateTime created;
  final DateTime modified;
  final String userId;
  final String planName;
  final String subId;
  final String source;
  final DateTime? trialStart;
  final DateTime? trialEnd;
  final int collections;
  final int itemsPerCollection;
  final bool dragNdrop;
  final bool theming;
  final int syncHours;
  final bool ads;
  final int syncInterval;
  final bool edit;
  final DateTime? activeTill;
  final int maxSyncDevices;
  final bool customExclusionRules;
  final int pasteStackLimit;
  final int grants;
  final String? tkn;
  const DriftSubscriptionEntry({
    required this.id,
    this.serverId,
    required this.created,
    required this.modified,
    required this.userId,
    required this.planName,
    required this.subId,
    required this.source,
    this.trialStart,
    this.trialEnd,
    required this.collections,
    required this.itemsPerCollection,
    required this.dragNdrop,
    required this.theming,
    required this.syncHours,
    required this.ads,
    required this.syncInterval,
    required this.edit,
    this.activeTill,
    required this.maxSyncDevices,
    required this.customExclusionRules,
    required this.pasteStackLimit,
    required this.grants,
    this.tkn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['modified'] = Variable<DateTime>(modified);
    map['user_id'] = Variable<String>(userId);
    map['plan_name'] = Variable<String>(planName);
    map['sub_id'] = Variable<String>(subId);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || trialStart != null) {
      map['trial_start'] = Variable<DateTime>(trialStart);
    }
    if (!nullToAbsent || trialEnd != null) {
      map['trial_end'] = Variable<DateTime>(trialEnd);
    }
    map['collections'] = Variable<int>(collections);
    map['items_per_collection'] = Variable<int>(itemsPerCollection);
    map['drag_ndrop'] = Variable<bool>(dragNdrop);
    map['theming'] = Variable<bool>(theming);
    map['sync_hours'] = Variable<int>(syncHours);
    map['ads'] = Variable<bool>(ads);
    map['sync_interval'] = Variable<int>(syncInterval);
    map['edit'] = Variable<bool>(edit);
    if (!nullToAbsent || activeTill != null) {
      map['active_till'] = Variable<DateTime>(activeTill);
    }
    map['max_sync_devices'] = Variable<int>(maxSyncDevices);
    map['custom_exclusion_rules'] = Variable<bool>(customExclusionRules);
    map['paste_stack_limit'] = Variable<int>(pasteStackLimit);
    map['grants'] = Variable<int>(grants);
    if (!nullToAbsent || tkn != null) {
      map['tkn'] = Variable<String>(tkn);
    }
    return map;
  }

  DriftSubscriptionTableCompanion toCompanion(bool nullToAbsent) {
    return DriftSubscriptionTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      modified: Value(modified),
      userId: Value(userId),
      planName: Value(planName),
      subId: Value(subId),
      source: Value(source),
      trialStart: trialStart == null && nullToAbsent
          ? const Value.absent()
          : Value(trialStart),
      trialEnd: trialEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(trialEnd),
      collections: Value(collections),
      itemsPerCollection: Value(itemsPerCollection),
      dragNdrop: Value(dragNdrop),
      theming: Value(theming),
      syncHours: Value(syncHours),
      ads: Value(ads),
      syncInterval: Value(syncInterval),
      edit: Value(edit),
      activeTill: activeTill == null && nullToAbsent
          ? const Value.absent()
          : Value(activeTill),
      maxSyncDevices: Value(maxSyncDevices),
      customExclusionRules: Value(customExclusionRules),
      pasteStackLimit: Value(pasteStackLimit),
      grants: Value(grants),
      tkn: tkn == null && nullToAbsent ? const Value.absent() : Value(tkn),
    );
  }

  factory DriftSubscriptionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftSubscriptionEntry(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      modified: serializer.fromJson<DateTime>(json['modified']),
      userId: serializer.fromJson<String>(json['userId']),
      planName: serializer.fromJson<String>(json['planName']),
      subId: serializer.fromJson<String>(json['subId']),
      source: serializer.fromJson<String>(json['source']),
      trialStart: serializer.fromJson<DateTime?>(json['trialStart']),
      trialEnd: serializer.fromJson<DateTime?>(json['trialEnd']),
      collections: serializer.fromJson<int>(json['collections']),
      itemsPerCollection: serializer.fromJson<int>(json['itemsPerCollection']),
      dragNdrop: serializer.fromJson<bool>(json['dragNdrop']),
      theming: serializer.fromJson<bool>(json['theming']),
      syncHours: serializer.fromJson<int>(json['syncHours']),
      ads: serializer.fromJson<bool>(json['ads']),
      syncInterval: serializer.fromJson<int>(json['syncInterval']),
      edit: serializer.fromJson<bool>(json['edit']),
      activeTill: serializer.fromJson<DateTime?>(json['activeTill']),
      maxSyncDevices: serializer.fromJson<int>(json['maxSyncDevices']),
      customExclusionRules: serializer.fromJson<bool>(
        json['customExclusionRules'],
      ),
      pasteStackLimit: serializer.fromJson<int>(json['pasteStackLimit']),
      grants: serializer.fromJson<int>(json['grants']),
      tkn: serializer.fromJson<String?>(json['tkn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'modified': serializer.toJson<DateTime>(modified),
      'userId': serializer.toJson<String>(userId),
      'planName': serializer.toJson<String>(planName),
      'subId': serializer.toJson<String>(subId),
      'source': serializer.toJson<String>(source),
      'trialStart': serializer.toJson<DateTime?>(trialStart),
      'trialEnd': serializer.toJson<DateTime?>(trialEnd),
      'collections': serializer.toJson<int>(collections),
      'itemsPerCollection': serializer.toJson<int>(itemsPerCollection),
      'dragNdrop': serializer.toJson<bool>(dragNdrop),
      'theming': serializer.toJson<bool>(theming),
      'syncHours': serializer.toJson<int>(syncHours),
      'ads': serializer.toJson<bool>(ads),
      'syncInterval': serializer.toJson<int>(syncInterval),
      'edit': serializer.toJson<bool>(edit),
      'activeTill': serializer.toJson<DateTime?>(activeTill),
      'maxSyncDevices': serializer.toJson<int>(maxSyncDevices),
      'customExclusionRules': serializer.toJson<bool>(customExclusionRules),
      'pasteStackLimit': serializer.toJson<int>(pasteStackLimit),
      'grants': serializer.toJson<int>(grants),
      'tkn': serializer.toJson<String?>(tkn),
    };
  }

  DriftSubscriptionEntry copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    DateTime? modified,
    String? userId,
    String? planName,
    String? subId,
    String? source,
    Value<DateTime?> trialStart = const Value.absent(),
    Value<DateTime?> trialEnd = const Value.absent(),
    int? collections,
    int? itemsPerCollection,
    bool? dragNdrop,
    bool? theming,
    int? syncHours,
    bool? ads,
    int? syncInterval,
    bool? edit,
    Value<DateTime?> activeTill = const Value.absent(),
    int? maxSyncDevices,
    bool? customExclusionRules,
    int? pasteStackLimit,
    int? grants,
    Value<String?> tkn = const Value.absent(),
  }) => DriftSubscriptionEntry(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    modified: modified ?? this.modified,
    userId: userId ?? this.userId,
    planName: planName ?? this.planName,
    subId: subId ?? this.subId,
    source: source ?? this.source,
    trialStart: trialStart.present ? trialStart.value : this.trialStart,
    trialEnd: trialEnd.present ? trialEnd.value : this.trialEnd,
    collections: collections ?? this.collections,
    itemsPerCollection: itemsPerCollection ?? this.itemsPerCollection,
    dragNdrop: dragNdrop ?? this.dragNdrop,
    theming: theming ?? this.theming,
    syncHours: syncHours ?? this.syncHours,
    ads: ads ?? this.ads,
    syncInterval: syncInterval ?? this.syncInterval,
    edit: edit ?? this.edit,
    activeTill: activeTill.present ? activeTill.value : this.activeTill,
    maxSyncDevices: maxSyncDevices ?? this.maxSyncDevices,
    customExclusionRules: customExclusionRules ?? this.customExclusionRules,
    pasteStackLimit: pasteStackLimit ?? this.pasteStackLimit,
    grants: grants ?? this.grants,
    tkn: tkn.present ? tkn.value : this.tkn,
  );
  DriftSubscriptionEntry copyWithCompanion(
    DriftSubscriptionTableCompanion data,
  ) {
    return DriftSubscriptionEntry(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      modified: data.modified.present ? data.modified.value : this.modified,
      userId: data.userId.present ? data.userId.value : this.userId,
      planName: data.planName.present ? data.planName.value : this.planName,
      subId: data.subId.present ? data.subId.value : this.subId,
      source: data.source.present ? data.source.value : this.source,
      trialStart: data.trialStart.present
          ? data.trialStart.value
          : this.trialStart,
      trialEnd: data.trialEnd.present ? data.trialEnd.value : this.trialEnd,
      collections: data.collections.present
          ? data.collections.value
          : this.collections,
      itemsPerCollection: data.itemsPerCollection.present
          ? data.itemsPerCollection.value
          : this.itemsPerCollection,
      dragNdrop: data.dragNdrop.present ? data.dragNdrop.value : this.dragNdrop,
      theming: data.theming.present ? data.theming.value : this.theming,
      syncHours: data.syncHours.present ? data.syncHours.value : this.syncHours,
      ads: data.ads.present ? data.ads.value : this.ads,
      syncInterval: data.syncInterval.present
          ? data.syncInterval.value
          : this.syncInterval,
      edit: data.edit.present ? data.edit.value : this.edit,
      activeTill: data.activeTill.present
          ? data.activeTill.value
          : this.activeTill,
      maxSyncDevices: data.maxSyncDevices.present
          ? data.maxSyncDevices.value
          : this.maxSyncDevices,
      customExclusionRules: data.customExclusionRules.present
          ? data.customExclusionRules.value
          : this.customExclusionRules,
      pasteStackLimit: data.pasteStackLimit.present
          ? data.pasteStackLimit.value
          : this.pasteStackLimit,
      grants: data.grants.present ? data.grants.value : this.grants,
      tkn: data.tkn.present ? data.tkn.value : this.tkn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftSubscriptionEntry(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('modified: $modified, ')
          ..write('userId: $userId, ')
          ..write('planName: $planName, ')
          ..write('subId: $subId, ')
          ..write('source: $source, ')
          ..write('trialStart: $trialStart, ')
          ..write('trialEnd: $trialEnd, ')
          ..write('collections: $collections, ')
          ..write('itemsPerCollection: $itemsPerCollection, ')
          ..write('dragNdrop: $dragNdrop, ')
          ..write('theming: $theming, ')
          ..write('syncHours: $syncHours, ')
          ..write('ads: $ads, ')
          ..write('syncInterval: $syncInterval, ')
          ..write('edit: $edit, ')
          ..write('activeTill: $activeTill, ')
          ..write('maxSyncDevices: $maxSyncDevices, ')
          ..write('customExclusionRules: $customExclusionRules, ')
          ..write('pasteStackLimit: $pasteStackLimit, ')
          ..write('grants: $grants, ')
          ..write('tkn: $tkn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    created,
    modified,
    userId,
    planName,
    subId,
    source,
    trialStart,
    trialEnd,
    collections,
    itemsPerCollection,
    dragNdrop,
    theming,
    syncHours,
    ads,
    syncInterval,
    edit,
    activeTill,
    maxSyncDevices,
    customExclusionRules,
    pasteStackLimit,
    grants,
    tkn,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftSubscriptionEntry &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.modified == this.modified &&
          other.userId == this.userId &&
          other.planName == this.planName &&
          other.subId == this.subId &&
          other.source == this.source &&
          other.trialStart == this.trialStart &&
          other.trialEnd == this.trialEnd &&
          other.collections == this.collections &&
          other.itemsPerCollection == this.itemsPerCollection &&
          other.dragNdrop == this.dragNdrop &&
          other.theming == this.theming &&
          other.syncHours == this.syncHours &&
          other.ads == this.ads &&
          other.syncInterval == this.syncInterval &&
          other.edit == this.edit &&
          other.activeTill == this.activeTill &&
          other.maxSyncDevices == this.maxSyncDevices &&
          other.customExclusionRules == this.customExclusionRules &&
          other.pasteStackLimit == this.pasteStackLimit &&
          other.grants == this.grants &&
          other.tkn == this.tkn);
}

class DriftSubscriptionTableCompanion
    extends UpdateCompanion<DriftSubscriptionEntry> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<DateTime> modified;
  final Value<String> userId;
  final Value<String> planName;
  final Value<String> subId;
  final Value<String> source;
  final Value<DateTime?> trialStart;
  final Value<DateTime?> trialEnd;
  final Value<int> collections;
  final Value<int> itemsPerCollection;
  final Value<bool> dragNdrop;
  final Value<bool> theming;
  final Value<int> syncHours;
  final Value<bool> ads;
  final Value<int> syncInterval;
  final Value<bool> edit;
  final Value<DateTime?> activeTill;
  final Value<int> maxSyncDevices;
  final Value<bool> customExclusionRules;
  final Value<int> pasteStackLimit;
  final Value<int> grants;
  final Value<String?> tkn;
  const DriftSubscriptionTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.modified = const Value.absent(),
    this.userId = const Value.absent(),
    this.planName = const Value.absent(),
    this.subId = const Value.absent(),
    this.source = const Value.absent(),
    this.trialStart = const Value.absent(),
    this.trialEnd = const Value.absent(),
    this.collections = const Value.absent(),
    this.itemsPerCollection = const Value.absent(),
    this.dragNdrop = const Value.absent(),
    this.theming = const Value.absent(),
    this.syncHours = const Value.absent(),
    this.ads = const Value.absent(),
    this.syncInterval = const Value.absent(),
    this.edit = const Value.absent(),
    this.activeTill = const Value.absent(),
    this.maxSyncDevices = const Value.absent(),
    this.customExclusionRules = const Value.absent(),
    this.pasteStackLimit = const Value.absent(),
    this.grants = const Value.absent(),
    this.tkn = const Value.absent(),
  });
  DriftSubscriptionTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required DateTime modified,
    required String userId,
    required String planName,
    required String subId,
    required String source,
    this.trialStart = const Value.absent(),
    this.trialEnd = const Value.absent(),
    this.collections = const Value.absent(),
    this.itemsPerCollection = const Value.absent(),
    this.dragNdrop = const Value.absent(),
    this.theming = const Value.absent(),
    this.syncHours = const Value.absent(),
    this.ads = const Value.absent(),
    this.syncInterval = const Value.absent(),
    this.edit = const Value.absent(),
    this.activeTill = const Value.absent(),
    this.maxSyncDevices = const Value.absent(),
    this.customExclusionRules = const Value.absent(),
    this.pasteStackLimit = const Value.absent(),
    this.grants = const Value.absent(),
    this.tkn = const Value.absent(),
  }) : created = Value(created),
       modified = Value(modified),
       userId = Value(userId),
       planName = Value(planName),
       subId = Value(subId),
       source = Value(source);
  static Insertable<DriftSubscriptionEntry> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<DateTime>? modified,
    Expression<String>? userId,
    Expression<String>? planName,
    Expression<String>? subId,
    Expression<String>? source,
    Expression<DateTime>? trialStart,
    Expression<DateTime>? trialEnd,
    Expression<int>? collections,
    Expression<int>? itemsPerCollection,
    Expression<bool>? dragNdrop,
    Expression<bool>? theming,
    Expression<int>? syncHours,
    Expression<bool>? ads,
    Expression<int>? syncInterval,
    Expression<bool>? edit,
    Expression<DateTime>? activeTill,
    Expression<int>? maxSyncDevices,
    Expression<bool>? customExclusionRules,
    Expression<int>? pasteStackLimit,
    Expression<int>? grants,
    Expression<String>? tkn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (modified != null) 'modified': modified,
      if (userId != null) 'user_id': userId,
      if (planName != null) 'plan_name': planName,
      if (subId != null) 'sub_id': subId,
      if (source != null) 'source': source,
      if (trialStart != null) 'trial_start': trialStart,
      if (trialEnd != null) 'trial_end': trialEnd,
      if (collections != null) 'collections': collections,
      if (itemsPerCollection != null)
        'items_per_collection': itemsPerCollection,
      if (dragNdrop != null) 'drag_ndrop': dragNdrop,
      if (theming != null) 'theming': theming,
      if (syncHours != null) 'sync_hours': syncHours,
      if (ads != null) 'ads': ads,
      if (syncInterval != null) 'sync_interval': syncInterval,
      if (edit != null) 'edit': edit,
      if (activeTill != null) 'active_till': activeTill,
      if (maxSyncDevices != null) 'max_sync_devices': maxSyncDevices,
      if (customExclusionRules != null)
        'custom_exclusion_rules': customExclusionRules,
      if (pasteStackLimit != null) 'paste_stack_limit': pasteStackLimit,
      if (grants != null) 'grants': grants,
      if (tkn != null) 'tkn': tkn,
    });
  }

  DriftSubscriptionTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<DateTime>? modified,
    Value<String>? userId,
    Value<String>? planName,
    Value<String>? subId,
    Value<String>? source,
    Value<DateTime?>? trialStart,
    Value<DateTime?>? trialEnd,
    Value<int>? collections,
    Value<int>? itemsPerCollection,
    Value<bool>? dragNdrop,
    Value<bool>? theming,
    Value<int>? syncHours,
    Value<bool>? ads,
    Value<int>? syncInterval,
    Value<bool>? edit,
    Value<DateTime?>? activeTill,
    Value<int>? maxSyncDevices,
    Value<bool>? customExclusionRules,
    Value<int>? pasteStackLimit,
    Value<int>? grants,
    Value<String?>? tkn,
  }) {
    return DriftSubscriptionTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      userId: userId ?? this.userId,
      planName: planName ?? this.planName,
      subId: subId ?? this.subId,
      source: source ?? this.source,
      trialStart: trialStart ?? this.trialStart,
      trialEnd: trialEnd ?? this.trialEnd,
      collections: collections ?? this.collections,
      itemsPerCollection: itemsPerCollection ?? this.itemsPerCollection,
      dragNdrop: dragNdrop ?? this.dragNdrop,
      theming: theming ?? this.theming,
      syncHours: syncHours ?? this.syncHours,
      ads: ads ?? this.ads,
      syncInterval: syncInterval ?? this.syncInterval,
      edit: edit ?? this.edit,
      activeTill: activeTill ?? this.activeTill,
      maxSyncDevices: maxSyncDevices ?? this.maxSyncDevices,
      customExclusionRules: customExclusionRules ?? this.customExclusionRules,
      pasteStackLimit: pasteStackLimit ?? this.pasteStackLimit,
      grants: grants ?? this.grants,
      tkn: tkn ?? this.tkn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (planName.present) {
      map['plan_name'] = Variable<String>(planName.value);
    }
    if (subId.present) {
      map['sub_id'] = Variable<String>(subId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (trialStart.present) {
      map['trial_start'] = Variable<DateTime>(trialStart.value);
    }
    if (trialEnd.present) {
      map['trial_end'] = Variable<DateTime>(trialEnd.value);
    }
    if (collections.present) {
      map['collections'] = Variable<int>(collections.value);
    }
    if (itemsPerCollection.present) {
      map['items_per_collection'] = Variable<int>(itemsPerCollection.value);
    }
    if (dragNdrop.present) {
      map['drag_ndrop'] = Variable<bool>(dragNdrop.value);
    }
    if (theming.present) {
      map['theming'] = Variable<bool>(theming.value);
    }
    if (syncHours.present) {
      map['sync_hours'] = Variable<int>(syncHours.value);
    }
    if (ads.present) {
      map['ads'] = Variable<bool>(ads.value);
    }
    if (syncInterval.present) {
      map['sync_interval'] = Variable<int>(syncInterval.value);
    }
    if (edit.present) {
      map['edit'] = Variable<bool>(edit.value);
    }
    if (activeTill.present) {
      map['active_till'] = Variable<DateTime>(activeTill.value);
    }
    if (maxSyncDevices.present) {
      map['max_sync_devices'] = Variable<int>(maxSyncDevices.value);
    }
    if (customExclusionRules.present) {
      map['custom_exclusion_rules'] = Variable<bool>(
        customExclusionRules.value,
      );
    }
    if (pasteStackLimit.present) {
      map['paste_stack_limit'] = Variable<int>(pasteStackLimit.value);
    }
    if (grants.present) {
      map['grants'] = Variable<int>(grants.value);
    }
    if (tkn.present) {
      map['tkn'] = Variable<String>(tkn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftSubscriptionTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('modified: $modified, ')
          ..write('userId: $userId, ')
          ..write('planName: $planName, ')
          ..write('subId: $subId, ')
          ..write('source: $source, ')
          ..write('trialStart: $trialStart, ')
          ..write('trialEnd: $trialEnd, ')
          ..write('collections: $collections, ')
          ..write('itemsPerCollection: $itemsPerCollection, ')
          ..write('dragNdrop: $dragNdrop, ')
          ..write('theming: $theming, ')
          ..write('syncHours: $syncHours, ')
          ..write('ads: $ads, ')
          ..write('syncInterval: $syncInterval, ')
          ..write('edit: $edit, ')
          ..write('activeTill: $activeTill, ')
          ..write('maxSyncDevices: $maxSyncDevices, ')
          ..write('customExclusionRules: $customExclusionRules, ')
          ..write('pasteStackLimit: $pasteStackLimit, ')
          ..write('grants: $grants, ')
          ..write('tkn: $tkn')
          ..write(')'))
        .toString();
  }
}

class $DriftSyncCursorTableTable extends DriftSyncCursorTable
    with TableInfo<$DriftSyncCursorTableTable, DriftSyncCursorEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftSyncCursorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOffsetMeta = const VerificationMeta(
    'lastOffset',
  );
  @override
  late final GeneratedColumn<int> lastOffset = GeneratedColumn<int>(
    'last_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    lastSyncedAt,
    lastOffset,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursor';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftSyncCursorEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    if (data.containsKey('last_offset')) {
      context.handle(
        _lastOffsetMeta,
        lastOffset.isAcceptableOrUnknown(data['last_offset']!, _lastOffsetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftSyncCursorEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftSyncCursorEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      )!,
      lastOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_offset'],
      )!,
    );
  }

  @override
  $DriftSyncCursorTableTable createAlias(String alias) {
    return $DriftSyncCursorTableTable(attachedDatabase, alias);
  }
}

class DriftSyncCursorEntry extends DataClass
    implements Insertable<DriftSyncCursorEntry> {
  final int id;
  final String entityType;
  final DateTime lastSyncedAt;
  final int lastOffset;
  const DriftSyncCursorEntry({
    required this.id,
    required this.entityType,
    required this.lastSyncedAt,
    required this.lastOffset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    map['last_offset'] = Variable<int>(lastOffset);
    return map;
  }

  DriftSyncCursorTableCompanion toCompanion(bool nullToAbsent) {
    return DriftSyncCursorTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      lastSyncedAt: Value(lastSyncedAt),
      lastOffset: Value(lastOffset),
    );
  }

  factory DriftSyncCursorEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftSyncCursorEntry(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
      lastOffset: serializer.fromJson<int>(json['lastOffset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
      'lastOffset': serializer.toJson<int>(lastOffset),
    };
  }

  DriftSyncCursorEntry copyWith({
    int? id,
    String? entityType,
    DateTime? lastSyncedAt,
    int? lastOffset,
  }) => DriftSyncCursorEntry(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    lastOffset: lastOffset ?? this.lastOffset,
  );
  DriftSyncCursorEntry copyWithCompanion(DriftSyncCursorTableCompanion data) {
    return DriftSyncCursorEntry(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastOffset: data.lastOffset.present
          ? data.lastOffset.value
          : this.lastOffset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftSyncCursorEntry(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOffset: $lastOffset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, lastSyncedAt, lastOffset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftSyncCursorEntry &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastOffset == this.lastOffset);
}

class DriftSyncCursorTableCompanion
    extends UpdateCompanion<DriftSyncCursorEntry> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<DateTime> lastSyncedAt;
  final Value<int> lastOffset;
  const DriftSyncCursorTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOffset = const Value.absent(),
  });
  DriftSyncCursorTableCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required DateTime lastSyncedAt,
    this.lastOffset = const Value.absent(),
  }) : entityType = Value(entityType),
       lastSyncedAt = Value(lastSyncedAt);
  static Insertable<DriftSyncCursorEntry> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? lastOffset,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastOffset != null) 'last_offset': lastOffset,
    });
  }

  DriftSyncCursorTableCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<DateTime>? lastSyncedAt,
    Value<int>? lastOffset,
  }) {
    return DriftSyncCursorTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastOffset: lastOffset ?? this.lastOffset,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (lastOffset.present) {
      map['last_offset'] = Variable<int>(lastOffset.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftSyncCursorTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOffset: $lastOffset')
          ..write(')'))
        .toString();
  }
}

class $DriftSyncOutboxEntryTableTable extends DriftSyncOutboxEntryTable
    with
        TableInfo<$DriftSyncOutboxEntryTableTable, DriftSyncOutboxEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftSyncOutboxEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    localId,
    action,
    createdAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox_entry';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftSyncOutboxEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftSyncOutboxEntryRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftSyncOutboxEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $DriftSyncOutboxEntryTableTable createAlias(String alias) {
    return $DriftSyncOutboxEntryTableTable(attachedDatabase, alias);
  }
}

class DriftSyncOutboxEntryRecord extends DataClass
    implements Insertable<DriftSyncOutboxEntryRecord> {
  final int id;
  final String entityType;
  final int localId;
  final String action;
  final DateTime createdAt;
  final String? lastError;
  const DriftSyncOutboxEntryRecord({
    required this.id,
    required this.entityType,
    required this.localId,
    required this.action,
    required this.createdAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['local_id'] = Variable<int>(localId);
    map['action'] = Variable<String>(action);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  DriftSyncOutboxEntryTableCompanion toCompanion(bool nullToAbsent) {
    return DriftSyncOutboxEntryTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      localId: Value(localId),
      action: Value(action),
      createdAt: Value(createdAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory DriftSyncOutboxEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftSyncOutboxEntryRecord(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      localId: serializer.fromJson<int>(json['localId']),
      action: serializer.fromJson<String>(json['action']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'localId': serializer.toJson<int>(localId),
      'action': serializer.toJson<String>(action),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  DriftSyncOutboxEntryRecord copyWith({
    int? id,
    String? entityType,
    int? localId,
    String? action,
    DateTime? createdAt,
    Value<String?> lastError = const Value.absent(),
  }) => DriftSyncOutboxEntryRecord(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    localId: localId ?? this.localId,
    action: action ?? this.action,
    createdAt: createdAt ?? this.createdAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  DriftSyncOutboxEntryRecord copyWithCompanion(
    DriftSyncOutboxEntryTableCompanion data,
  ) {
    return DriftSyncOutboxEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      localId: data.localId.present ? data.localId.value : this.localId,
      action: data.action.present ? data.action.value : this.action,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftSyncOutboxEntryRecord(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('localId: $localId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, localId, action, createdAt, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftSyncOutboxEntryRecord &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.localId == this.localId &&
          other.action == this.action &&
          other.createdAt == this.createdAt &&
          other.lastError == this.lastError);
}

class DriftSyncOutboxEntryTableCompanion
    extends UpdateCompanion<DriftSyncOutboxEntryRecord> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> localId;
  final Value<String> action;
  final Value<DateTime> createdAt;
  final Value<String?> lastError;
  const DriftSyncOutboxEntryTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.localId = const Value.absent(),
    this.action = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  DriftSyncOutboxEntryTableCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int localId,
    required String action,
    required DateTime createdAt,
    this.lastError = const Value.absent(),
  }) : entityType = Value(entityType),
       localId = Value(localId),
       action = Value(action),
       createdAt = Value(createdAt);
  static Insertable<DriftSyncOutboxEntryRecord> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? localId,
    Expression<String>? action,
    Expression<DateTime>? createdAt,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (localId != null) 'local_id': localId,
      if (action != null) 'action': action,
      if (createdAt != null) 'created_at': createdAt,
      if (lastError != null) 'last_error': lastError,
    });
  }

  DriftSyncOutboxEntryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int>? localId,
    Value<String>? action,
    Value<DateTime>? createdAt,
    Value<String?>? lastError,
  }) {
    return DriftSyncOutboxEntryTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      localId: localId ?? this.localId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftSyncOutboxEntryTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('localId: $localId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $DriftSyncStatusTableTable extends DriftSyncStatusTable
    with TableInfo<$DriftSyncStatusTableTable, DriftSyncStatusEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftSyncStatusTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lastSyncPointMeta = const VerificationMeta(
    'lastSyncPoint',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncPoint =
      GeneratedColumn<DateTime>(
        'last_sync_point',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSyncStartPointMeta =
      const VerificationMeta('lastSyncStartPoint');
  @override
  late final GeneratedColumn<DateTime> lastSyncStartPoint =
      GeneratedColumn<DateTime>(
        'last_sync_start_point',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastKnownSyncCountMeta =
      const VerificationMeta('lastKnownSyncCount');
  @override
  late final GeneratedColumn<int> lastKnownSyncCount = GeneratedColumn<int>(
    'last_known_sync_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastKnownTotalCountMeta =
      const VerificationMeta('lastKnownTotalCount');
  @override
  late final GeneratedColumn<int> lastKnownTotalCount = GeneratedColumn<int>(
    'last_known_total_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restorationPendingMeta =
      const VerificationMeta('restorationPending');
  @override
  late final GeneratedColumn<bool> restorationPending = GeneratedColumn<bool>(
    'restoration_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("restoration_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSyncPoint,
    lastSyncStartPoint,
    lastKnownSyncCount,
    lastKnownTotalCount,
    restorationPending,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftSyncStatusEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_sync_point')) {
      context.handle(
        _lastSyncPointMeta,
        lastSyncPoint.isAcceptableOrUnknown(
          data['last_sync_point']!,
          _lastSyncPointMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_start_point')) {
      context.handle(
        _lastSyncStartPointMeta,
        lastSyncStartPoint.isAcceptableOrUnknown(
          data['last_sync_start_point']!,
          _lastSyncStartPointMeta,
        ),
      );
    }
    if (data.containsKey('last_known_sync_count')) {
      context.handle(
        _lastKnownSyncCountMeta,
        lastKnownSyncCount.isAcceptableOrUnknown(
          data['last_known_sync_count']!,
          _lastKnownSyncCountMeta,
        ),
      );
    }
    if (data.containsKey('last_known_total_count')) {
      context.handle(
        _lastKnownTotalCountMeta,
        lastKnownTotalCount.isAcceptableOrUnknown(
          data['last_known_total_count']!,
          _lastKnownTotalCountMeta,
        ),
      );
    }
    if (data.containsKey('restoration_pending')) {
      context.handle(
        _restorationPendingMeta,
        restorationPending.isAcceptableOrUnknown(
          data['restoration_pending']!,
          _restorationPendingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftSyncStatusEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftSyncStatusEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSyncPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_point'],
      ),
      lastSyncStartPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_start_point'],
      ),
      lastKnownSyncCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_known_sync_count'],
      ),
      lastKnownTotalCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_known_total_count'],
      ),
      restorationPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}restoration_pending'],
      )!,
    );
  }

  @override
  $DriftSyncStatusTableTable createAlias(String alias) {
    return $DriftSyncStatusTableTable(attachedDatabase, alias);
  }
}

class DriftSyncStatusEntry extends DataClass
    implements Insertable<DriftSyncStatusEntry> {
  final int id;
  final DateTime? lastSyncPoint;
  final DateTime? lastSyncStartPoint;
  final int? lastKnownSyncCount;
  final int? lastKnownTotalCount;
  final bool restorationPending;
  const DriftSyncStatusEntry({
    required this.id,
    this.lastSyncPoint,
    this.lastSyncStartPoint,
    this.lastKnownSyncCount,
    this.lastKnownTotalCount,
    required this.restorationPending,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSyncPoint != null) {
      map['last_sync_point'] = Variable<DateTime>(lastSyncPoint);
    }
    if (!nullToAbsent || lastSyncStartPoint != null) {
      map['last_sync_start_point'] = Variable<DateTime>(lastSyncStartPoint);
    }
    if (!nullToAbsent || lastKnownSyncCount != null) {
      map['last_known_sync_count'] = Variable<int>(lastKnownSyncCount);
    }
    if (!nullToAbsent || lastKnownTotalCount != null) {
      map['last_known_total_count'] = Variable<int>(lastKnownTotalCount);
    }
    map['restoration_pending'] = Variable<bool>(restorationPending);
    return map;
  }

  DriftSyncStatusTableCompanion toCompanion(bool nullToAbsent) {
    return DriftSyncStatusTableCompanion(
      id: Value(id),
      lastSyncPoint: lastSyncPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncPoint),
      lastSyncStartPoint: lastSyncStartPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncStartPoint),
      lastKnownSyncCount: lastKnownSyncCount == null && nullToAbsent
          ? const Value.absent()
          : Value(lastKnownSyncCount),
      lastKnownTotalCount: lastKnownTotalCount == null && nullToAbsent
          ? const Value.absent()
          : Value(lastKnownTotalCount),
      restorationPending: Value(restorationPending),
    );
  }

  factory DriftSyncStatusEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftSyncStatusEntry(
      id: serializer.fromJson<int>(json['id']),
      lastSyncPoint: serializer.fromJson<DateTime?>(json['lastSyncPoint']),
      lastSyncStartPoint: serializer.fromJson<DateTime?>(
        json['lastSyncStartPoint'],
      ),
      lastKnownSyncCount: serializer.fromJson<int?>(json['lastKnownSyncCount']),
      lastKnownTotalCount: serializer.fromJson<int?>(
        json['lastKnownTotalCount'],
      ),
      restorationPending: serializer.fromJson<bool>(json['restorationPending']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSyncPoint': serializer.toJson<DateTime?>(lastSyncPoint),
      'lastSyncStartPoint': serializer.toJson<DateTime?>(lastSyncStartPoint),
      'lastKnownSyncCount': serializer.toJson<int?>(lastKnownSyncCount),
      'lastKnownTotalCount': serializer.toJson<int?>(lastKnownTotalCount),
      'restorationPending': serializer.toJson<bool>(restorationPending),
    };
  }

  DriftSyncStatusEntry copyWith({
    int? id,
    Value<DateTime?> lastSyncPoint = const Value.absent(),
    Value<DateTime?> lastSyncStartPoint = const Value.absent(),
    Value<int?> lastKnownSyncCount = const Value.absent(),
    Value<int?> lastKnownTotalCount = const Value.absent(),
    bool? restorationPending,
  }) => DriftSyncStatusEntry(
    id: id ?? this.id,
    lastSyncPoint: lastSyncPoint.present
        ? lastSyncPoint.value
        : this.lastSyncPoint,
    lastSyncStartPoint: lastSyncStartPoint.present
        ? lastSyncStartPoint.value
        : this.lastSyncStartPoint,
    lastKnownSyncCount: lastKnownSyncCount.present
        ? lastKnownSyncCount.value
        : this.lastKnownSyncCount,
    lastKnownTotalCount: lastKnownTotalCount.present
        ? lastKnownTotalCount.value
        : this.lastKnownTotalCount,
    restorationPending: restorationPending ?? this.restorationPending,
  );
  DriftSyncStatusEntry copyWithCompanion(DriftSyncStatusTableCompanion data) {
    return DriftSyncStatusEntry(
      id: data.id.present ? data.id.value : this.id,
      lastSyncPoint: data.lastSyncPoint.present
          ? data.lastSyncPoint.value
          : this.lastSyncPoint,
      lastSyncStartPoint: data.lastSyncStartPoint.present
          ? data.lastSyncStartPoint.value
          : this.lastSyncStartPoint,
      lastKnownSyncCount: data.lastKnownSyncCount.present
          ? data.lastKnownSyncCount.value
          : this.lastKnownSyncCount,
      lastKnownTotalCount: data.lastKnownTotalCount.present
          ? data.lastKnownTotalCount.value
          : this.lastKnownTotalCount,
      restorationPending: data.restorationPending.present
          ? data.restorationPending.value
          : this.restorationPending,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftSyncStatusEntry(')
          ..write('id: $id, ')
          ..write('lastSyncPoint: $lastSyncPoint, ')
          ..write('lastSyncStartPoint: $lastSyncStartPoint, ')
          ..write('lastKnownSyncCount: $lastKnownSyncCount, ')
          ..write('lastKnownTotalCount: $lastKnownTotalCount, ')
          ..write('restorationPending: $restorationPending')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastSyncPoint,
    lastSyncStartPoint,
    lastKnownSyncCount,
    lastKnownTotalCount,
    restorationPending,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftSyncStatusEntry &&
          other.id == this.id &&
          other.lastSyncPoint == this.lastSyncPoint &&
          other.lastSyncStartPoint == this.lastSyncStartPoint &&
          other.lastKnownSyncCount == this.lastKnownSyncCount &&
          other.lastKnownTotalCount == this.lastKnownTotalCount &&
          other.restorationPending == this.restorationPending);
}

class DriftSyncStatusTableCompanion
    extends UpdateCompanion<DriftSyncStatusEntry> {
  final Value<int> id;
  final Value<DateTime?> lastSyncPoint;
  final Value<DateTime?> lastSyncStartPoint;
  final Value<int?> lastKnownSyncCount;
  final Value<int?> lastKnownTotalCount;
  final Value<bool> restorationPending;
  const DriftSyncStatusTableCompanion({
    this.id = const Value.absent(),
    this.lastSyncPoint = const Value.absent(),
    this.lastSyncStartPoint = const Value.absent(),
    this.lastKnownSyncCount = const Value.absent(),
    this.lastKnownTotalCount = const Value.absent(),
    this.restorationPending = const Value.absent(),
  });
  DriftSyncStatusTableCompanion.insert({
    this.id = const Value.absent(),
    this.lastSyncPoint = const Value.absent(),
    this.lastSyncStartPoint = const Value.absent(),
    this.lastKnownSyncCount = const Value.absent(),
    this.lastKnownTotalCount = const Value.absent(),
    this.restorationPending = const Value.absent(),
  });
  static Insertable<DriftSyncStatusEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? lastSyncPoint,
    Expression<DateTime>? lastSyncStartPoint,
    Expression<int>? lastKnownSyncCount,
    Expression<int>? lastKnownTotalCount,
    Expression<bool>? restorationPending,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncPoint != null) 'last_sync_point': lastSyncPoint,
      if (lastSyncStartPoint != null)
        'last_sync_start_point': lastSyncStartPoint,
      if (lastKnownSyncCount != null)
        'last_known_sync_count': lastKnownSyncCount,
      if (lastKnownTotalCount != null)
        'last_known_total_count': lastKnownTotalCount,
      if (restorationPending != null) 'restoration_pending': restorationPending,
    });
  }

  DriftSyncStatusTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? lastSyncPoint,
    Value<DateTime?>? lastSyncStartPoint,
    Value<int?>? lastKnownSyncCount,
    Value<int?>? lastKnownTotalCount,
    Value<bool>? restorationPending,
  }) {
    return DriftSyncStatusTableCompanion(
      id: id ?? this.id,
      lastSyncPoint: lastSyncPoint ?? this.lastSyncPoint,
      lastSyncStartPoint: lastSyncStartPoint ?? this.lastSyncStartPoint,
      lastKnownSyncCount: lastKnownSyncCount ?? this.lastKnownSyncCount,
      lastKnownTotalCount: lastKnownTotalCount ?? this.lastKnownTotalCount,
      restorationPending: restorationPending ?? this.restorationPending,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncPoint.present) {
      map['last_sync_point'] = Variable<DateTime>(lastSyncPoint.value);
    }
    if (lastSyncStartPoint.present) {
      map['last_sync_start_point'] = Variable<DateTime>(
        lastSyncStartPoint.value,
      );
    }
    if (lastKnownSyncCount.present) {
      map['last_known_sync_count'] = Variable<int>(lastKnownSyncCount.value);
    }
    if (lastKnownTotalCount.present) {
      map['last_known_total_count'] = Variable<int>(lastKnownTotalCount.value);
    }
    if (restorationPending.present) {
      map['restoration_pending'] = Variable<bool>(restorationPending.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftSyncStatusTableCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncPoint: $lastSyncPoint, ')
          ..write('lastSyncStartPoint: $lastSyncStartPoint, ')
          ..write('lastKnownSyncCount: $lastKnownSyncCount, ')
          ..write('lastKnownTotalCount: $lastKnownTotalCount, ')
          ..write('restorationPending: $restorationPending')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DriftAppConfigTableTable driftAppConfigTable =
      $DriftAppConfigTableTable(this);
  late final $DriftApplicationMetaTableTable driftApplicationMetaTable =
      $DriftApplicationMetaTableTable(this);
  late final $DriftClipCollectionTableTable driftClipCollectionTable =
      $DriftClipCollectionTableTable(this);
  late final $DriftClipboardItemTableTable driftClipboardItemTable =
      $DriftClipboardItemTableTable(this);
  late final $DriftSubscriptionTableTable driftSubscriptionTable =
      $DriftSubscriptionTableTable(this);
  late final $DriftSyncCursorTableTable driftSyncCursorTable =
      $DriftSyncCursorTableTable(this);
  late final $DriftSyncOutboxEntryTableTable driftSyncOutboxEntryTable =
      $DriftSyncOutboxEntryTableTable(this);
  late final $DriftSyncStatusTableTable driftSyncStatusTable =
      $DriftSyncStatusTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    driftAppConfigTable,
    driftApplicationMetaTable,
    driftClipCollectionTable,
    driftClipboardItemTable,
    driftSubscriptionTable,
    driftSyncCursorTable,
    driftSyncOutboxEntryTable,
    driftSyncStatusTable,
  ];
}

typedef $$DriftAppConfigTableTableCreateCompanionBuilder =
    DriftAppConfigTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<bool> enableSync,
      Value<bool> enableFileSync,
      Value<String> layout,
      Value<String> view,
      Value<bool> pinned,
      Value<double> windowWidth,
      Value<double> windowHeight,
      Value<String> sortBy,
      Value<String> sortOrder,
      Value<int> dontUploadOver,
      Value<int> dontCopyOver,
      Value<DateTime?> pausedTill,
      Value<String> syncSpeed,
      Value<String?> toggleHotkey,
      Value<String?> quickPasteHotkey,
      Value<String?> pasteStackHotkey,
      Value<bool> smartPaste,
      Value<bool> keepWindowOpenOnUnfocus,
      Value<bool> transformAsNewClip,
      Value<bool> launchAtStartup,
      Value<String> locale,
      Value<String?> enc2,
      Value<bool> autoEncrypt,
      Value<bool> useEncryptionNonce,
      Value<ExclusionRules?> exclusionRules,
      Value<int> themeColor,
      Value<String> themeVariant,
      Value<bool> enableDragNDrop,
      Value<bool> enablePasteStack,
      Value<bool> androidBgListener,
      Value<bool> richDataCapture,
      Value<bool> onBoardComplete,
      Value<int> reviewQualifyingEventCount,
      Value<DateTime?> lastReviewPromptDate,
      Value<bool> reviewNeverAsk,
      Value<bool> lanInstantSync,
      Value<bool> autoWriteOnReceive,
      Value<bool> enableTypeToSearch,
      Value<bool> hideFromScreenCapture,
      Value<bool> showTrayIcon,
      Value<String> clipboardFeedbackMode,
      Value<bool> enableLocalAuth,
      Value<int> localAuthTimeoutMinutes,
      Value<bool> showCollectionTip,
      Value<bool> searchIndexReady,
    });
typedef $$DriftAppConfigTableTableUpdateCompanionBuilder =
    DriftAppConfigTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<bool> enableSync,
      Value<bool> enableFileSync,
      Value<String> layout,
      Value<String> view,
      Value<bool> pinned,
      Value<double> windowWidth,
      Value<double> windowHeight,
      Value<String> sortBy,
      Value<String> sortOrder,
      Value<int> dontUploadOver,
      Value<int> dontCopyOver,
      Value<DateTime?> pausedTill,
      Value<String> syncSpeed,
      Value<String?> toggleHotkey,
      Value<String?> quickPasteHotkey,
      Value<String?> pasteStackHotkey,
      Value<bool> smartPaste,
      Value<bool> keepWindowOpenOnUnfocus,
      Value<bool> transformAsNewClip,
      Value<bool> launchAtStartup,
      Value<String> locale,
      Value<String?> enc2,
      Value<bool> autoEncrypt,
      Value<bool> useEncryptionNonce,
      Value<ExclusionRules?> exclusionRules,
      Value<int> themeColor,
      Value<String> themeVariant,
      Value<bool> enableDragNDrop,
      Value<bool> enablePasteStack,
      Value<bool> androidBgListener,
      Value<bool> richDataCapture,
      Value<bool> onBoardComplete,
      Value<int> reviewQualifyingEventCount,
      Value<DateTime?> lastReviewPromptDate,
      Value<bool> reviewNeverAsk,
      Value<bool> lanInstantSync,
      Value<bool> autoWriteOnReceive,
      Value<bool> enableTypeToSearch,
      Value<bool> hideFromScreenCapture,
      Value<bool> showTrayIcon,
      Value<String> clipboardFeedbackMode,
      Value<bool> enableLocalAuth,
      Value<int> localAuthTimeoutMinutes,
      Value<bool> showCollectionTip,
      Value<bool> searchIndexReady,
    });

class $$DriftAppConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftAppConfigTableTable> {
  $$DriftAppConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableSync => $composableBuilder(
    column: $table.enableSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableFileSync => $composableBuilder(
    column: $table.enableFileSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layout => $composableBuilder(
    column: $table.layout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get view => $composableBuilder(
    column: $table.view,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get windowWidth => $composableBuilder(
    column: $table.windowWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get windowHeight => $composableBuilder(
    column: $table.windowHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortBy => $composableBuilder(
    column: $table.sortBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dontUploadOver => $composableBuilder(
    column: $table.dontUploadOver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dontCopyOver => $composableBuilder(
    column: $table.dontCopyOver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pausedTill => $composableBuilder(
    column: $table.pausedTill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncSpeed => $composableBuilder(
    column: $table.syncSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toggleHotkey => $composableBuilder(
    column: $table.toggleHotkey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quickPasteHotkey => $composableBuilder(
    column: $table.quickPasteHotkey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pasteStackHotkey => $composableBuilder(
    column: $table.pasteStackHotkey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get smartPaste => $composableBuilder(
    column: $table.smartPaste,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get keepWindowOpenOnUnfocus => $composableBuilder(
    column: $table.keepWindowOpenOnUnfocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get transformAsNewClip => $composableBuilder(
    column: $table.transformAsNewClip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get launchAtStartup => $composableBuilder(
    column: $table.launchAtStartup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enc2 => $composableBuilder(
    column: $table.enc2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoEncrypt => $composableBuilder(
    column: $table.autoEncrypt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useEncryptionNonce => $composableBuilder(
    column: $table.useEncryptionNonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExclusionRules?, ExclusionRules, String>
  get exclusionRules => $composableBuilder(
    column: $table.exclusionRules,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeVariant => $composableBuilder(
    column: $table.themeVariant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableDragNDrop => $composableBuilder(
    column: $table.enableDragNDrop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enablePasteStack => $composableBuilder(
    column: $table.enablePasteStack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get androidBgListener => $composableBuilder(
    column: $table.androidBgListener,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get richDataCapture => $composableBuilder(
    column: $table.richDataCapture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onBoardComplete => $composableBuilder(
    column: $table.onBoardComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewQualifyingEventCount => $composableBuilder(
    column: $table.reviewQualifyingEventCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewPromptDate => $composableBuilder(
    column: $table.lastReviewPromptDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reviewNeverAsk => $composableBuilder(
    column: $table.reviewNeverAsk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lanInstantSync => $composableBuilder(
    column: $table.lanInstantSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoWriteOnReceive => $composableBuilder(
    column: $table.autoWriteOnReceive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableTypeToSearch => $composableBuilder(
    column: $table.enableTypeToSearch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hideFromScreenCapture => $composableBuilder(
    column: $table.hideFromScreenCapture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showTrayIcon => $composableBuilder(
    column: $table.showTrayIcon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clipboardFeedbackMode => $composableBuilder(
    column: $table.clipboardFeedbackMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableLocalAuth => $composableBuilder(
    column: $table.enableLocalAuth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localAuthTimeoutMinutes => $composableBuilder(
    column: $table.localAuthTimeoutMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showCollectionTip => $composableBuilder(
    column: $table.showCollectionTip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get searchIndexReady => $composableBuilder(
    column: $table.searchIndexReady,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftAppConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftAppConfigTableTable> {
  $$DriftAppConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableSync => $composableBuilder(
    column: $table.enableSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableFileSync => $composableBuilder(
    column: $table.enableFileSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layout => $composableBuilder(
    column: $table.layout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get view => $composableBuilder(
    column: $table.view,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get windowWidth => $composableBuilder(
    column: $table.windowWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get windowHeight => $composableBuilder(
    column: $table.windowHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortBy => $composableBuilder(
    column: $table.sortBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dontUploadOver => $composableBuilder(
    column: $table.dontUploadOver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dontCopyOver => $composableBuilder(
    column: $table.dontCopyOver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pausedTill => $composableBuilder(
    column: $table.pausedTill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncSpeed => $composableBuilder(
    column: $table.syncSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toggleHotkey => $composableBuilder(
    column: $table.toggleHotkey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quickPasteHotkey => $composableBuilder(
    column: $table.quickPasteHotkey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pasteStackHotkey => $composableBuilder(
    column: $table.pasteStackHotkey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get smartPaste => $composableBuilder(
    column: $table.smartPaste,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get keepWindowOpenOnUnfocus => $composableBuilder(
    column: $table.keepWindowOpenOnUnfocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get transformAsNewClip => $composableBuilder(
    column: $table.transformAsNewClip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get launchAtStartup => $composableBuilder(
    column: $table.launchAtStartup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enc2 => $composableBuilder(
    column: $table.enc2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoEncrypt => $composableBuilder(
    column: $table.autoEncrypt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useEncryptionNonce => $composableBuilder(
    column: $table.useEncryptionNonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exclusionRules => $composableBuilder(
    column: $table.exclusionRules,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeVariant => $composableBuilder(
    column: $table.themeVariant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableDragNDrop => $composableBuilder(
    column: $table.enableDragNDrop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enablePasteStack => $composableBuilder(
    column: $table.enablePasteStack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get androidBgListener => $composableBuilder(
    column: $table.androidBgListener,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get richDataCapture => $composableBuilder(
    column: $table.richDataCapture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onBoardComplete => $composableBuilder(
    column: $table.onBoardComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewQualifyingEventCount => $composableBuilder(
    column: $table.reviewQualifyingEventCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewPromptDate => $composableBuilder(
    column: $table.lastReviewPromptDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reviewNeverAsk => $composableBuilder(
    column: $table.reviewNeverAsk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lanInstantSync => $composableBuilder(
    column: $table.lanInstantSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoWriteOnReceive => $composableBuilder(
    column: $table.autoWriteOnReceive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableTypeToSearch => $composableBuilder(
    column: $table.enableTypeToSearch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hideFromScreenCapture => $composableBuilder(
    column: $table.hideFromScreenCapture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showTrayIcon => $composableBuilder(
    column: $table.showTrayIcon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clipboardFeedbackMode => $composableBuilder(
    column: $table.clipboardFeedbackMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableLocalAuth => $composableBuilder(
    column: $table.enableLocalAuth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localAuthTimeoutMinutes => $composableBuilder(
    column: $table.localAuthTimeoutMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showCollectionTip => $composableBuilder(
    column: $table.showCollectionTip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get searchIndexReady => $composableBuilder(
    column: $table.searchIndexReady,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftAppConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftAppConfigTableTable> {
  $$DriftAppConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get enableSync => $composableBuilder(
    column: $table.enableSync,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableFileSync => $composableBuilder(
    column: $table.enableFileSync,
    builder: (column) => column,
  );

  GeneratedColumn<String> get layout =>
      $composableBuilder(column: $table.layout, builder: (column) => column);

  GeneratedColumn<String> get view =>
      $composableBuilder(column: $table.view, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<double> get windowWidth => $composableBuilder(
    column: $table.windowWidth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get windowHeight => $composableBuilder(
    column: $table.windowHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sortBy =>
      $composableBuilder(column: $table.sortBy, builder: (column) => column);

  GeneratedColumn<String> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get dontUploadOver => $composableBuilder(
    column: $table.dontUploadOver,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dontCopyOver => $composableBuilder(
    column: $table.dontCopyOver,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pausedTill => $composableBuilder(
    column: $table.pausedTill,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncSpeed =>
      $composableBuilder(column: $table.syncSpeed, builder: (column) => column);

  GeneratedColumn<String> get toggleHotkey => $composableBuilder(
    column: $table.toggleHotkey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quickPasteHotkey => $composableBuilder(
    column: $table.quickPasteHotkey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pasteStackHotkey => $composableBuilder(
    column: $table.pasteStackHotkey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get smartPaste => $composableBuilder(
    column: $table.smartPaste,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get keepWindowOpenOnUnfocus => $composableBuilder(
    column: $table.keepWindowOpenOnUnfocus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get transformAsNewClip => $composableBuilder(
    column: $table.transformAsNewClip,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get launchAtStartup => $composableBuilder(
    column: $table.launchAtStartup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get enc2 =>
      $composableBuilder(column: $table.enc2, builder: (column) => column);

  GeneratedColumn<bool> get autoEncrypt => $composableBuilder(
    column: $table.autoEncrypt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get useEncryptionNonce => $composableBuilder(
    column: $table.useEncryptionNonce,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ExclusionRules?, String>
  get exclusionRules => $composableBuilder(
    column: $table.exclusionRules,
    builder: (column) => column,
  );

  GeneratedColumn<int> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeVariant => $composableBuilder(
    column: $table.themeVariant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableDragNDrop => $composableBuilder(
    column: $table.enableDragNDrop,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enablePasteStack => $composableBuilder(
    column: $table.enablePasteStack,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get androidBgListener => $composableBuilder(
    column: $table.androidBgListener,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get richDataCapture => $composableBuilder(
    column: $table.richDataCapture,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onBoardComplete => $composableBuilder(
    column: $table.onBoardComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewQualifyingEventCount => $composableBuilder(
    column: $table.reviewQualifyingEventCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReviewPromptDate => $composableBuilder(
    column: $table.lastReviewPromptDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reviewNeverAsk => $composableBuilder(
    column: $table.reviewNeverAsk,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get lanInstantSync => $composableBuilder(
    column: $table.lanInstantSync,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoWriteOnReceive => $composableBuilder(
    column: $table.autoWriteOnReceive,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableTypeToSearch => $composableBuilder(
    column: $table.enableTypeToSearch,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hideFromScreenCapture => $composableBuilder(
    column: $table.hideFromScreenCapture,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showTrayIcon => $composableBuilder(
    column: $table.showTrayIcon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clipboardFeedbackMode => $composableBuilder(
    column: $table.clipboardFeedbackMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableLocalAuth => $composableBuilder(
    column: $table.enableLocalAuth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localAuthTimeoutMinutes => $composableBuilder(
    column: $table.localAuthTimeoutMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showCollectionTip => $composableBuilder(
    column: $table.showCollectionTip,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get searchIndexReady => $composableBuilder(
    column: $table.searchIndexReady,
    builder: (column) => column,
  );
}

class $$DriftAppConfigTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftAppConfigTableTable,
          DriftAppConfigEntry,
          $$DriftAppConfigTableTableFilterComposer,
          $$DriftAppConfigTableTableOrderingComposer,
          $$DriftAppConfigTableTableAnnotationComposer,
          $$DriftAppConfigTableTableCreateCompanionBuilder,
          $$DriftAppConfigTableTableUpdateCompanionBuilder,
          (
            DriftAppConfigEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftAppConfigTableTable,
              DriftAppConfigEntry
            >,
          ),
          DriftAppConfigEntry,
          PrefetchHooks Function()
        > {
  $$DriftAppConfigTableTableTableManager(
    _$AppDatabase db,
    $DriftAppConfigTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftAppConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftAppConfigTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftAppConfigTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> enableSync = const Value.absent(),
                Value<bool> enableFileSync = const Value.absent(),
                Value<String> layout = const Value.absent(),
                Value<String> view = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<double> windowWidth = const Value.absent(),
                Value<double> windowHeight = const Value.absent(),
                Value<String> sortBy = const Value.absent(),
                Value<String> sortOrder = const Value.absent(),
                Value<int> dontUploadOver = const Value.absent(),
                Value<int> dontCopyOver = const Value.absent(),
                Value<DateTime?> pausedTill = const Value.absent(),
                Value<String> syncSpeed = const Value.absent(),
                Value<String?> toggleHotkey = const Value.absent(),
                Value<String?> quickPasteHotkey = const Value.absent(),
                Value<String?> pasteStackHotkey = const Value.absent(),
                Value<bool> smartPaste = const Value.absent(),
                Value<bool> keepWindowOpenOnUnfocus = const Value.absent(),
                Value<bool> transformAsNewClip = const Value.absent(),
                Value<bool> launchAtStartup = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String?> enc2 = const Value.absent(),
                Value<bool> autoEncrypt = const Value.absent(),
                Value<bool> useEncryptionNonce = const Value.absent(),
                Value<ExclusionRules?> exclusionRules = const Value.absent(),
                Value<int> themeColor = const Value.absent(),
                Value<String> themeVariant = const Value.absent(),
                Value<bool> enableDragNDrop = const Value.absent(),
                Value<bool> enablePasteStack = const Value.absent(),
                Value<bool> androidBgListener = const Value.absent(),
                Value<bool> richDataCapture = const Value.absent(),
                Value<bool> onBoardComplete = const Value.absent(),
                Value<int> reviewQualifyingEventCount = const Value.absent(),
                Value<DateTime?> lastReviewPromptDate = const Value.absent(),
                Value<bool> reviewNeverAsk = const Value.absent(),
                Value<bool> lanInstantSync = const Value.absent(),
                Value<bool> autoWriteOnReceive = const Value.absent(),
                Value<bool> enableTypeToSearch = const Value.absent(),
                Value<bool> hideFromScreenCapture = const Value.absent(),
                Value<bool> showTrayIcon = const Value.absent(),
                Value<String> clipboardFeedbackMode = const Value.absent(),
                Value<bool> enableLocalAuth = const Value.absent(),
                Value<int> localAuthTimeoutMinutes = const Value.absent(),
                Value<bool> showCollectionTip = const Value.absent(),
                Value<bool> searchIndexReady = const Value.absent(),
              }) => DriftAppConfigTableCompanion(
                id: id,
                themeMode: themeMode,
                enableSync: enableSync,
                enableFileSync: enableFileSync,
                layout: layout,
                view: view,
                pinned: pinned,
                windowWidth: windowWidth,
                windowHeight: windowHeight,
                sortBy: sortBy,
                sortOrder: sortOrder,
                dontUploadOver: dontUploadOver,
                dontCopyOver: dontCopyOver,
                pausedTill: pausedTill,
                syncSpeed: syncSpeed,
                toggleHotkey: toggleHotkey,
                quickPasteHotkey: quickPasteHotkey,
                pasteStackHotkey: pasteStackHotkey,
                smartPaste: smartPaste,
                keepWindowOpenOnUnfocus: keepWindowOpenOnUnfocus,
                transformAsNewClip: transformAsNewClip,
                launchAtStartup: launchAtStartup,
                locale: locale,
                enc2: enc2,
                autoEncrypt: autoEncrypt,
                useEncryptionNonce: useEncryptionNonce,
                exclusionRules: exclusionRules,
                themeColor: themeColor,
                themeVariant: themeVariant,
                enableDragNDrop: enableDragNDrop,
                enablePasteStack: enablePasteStack,
                androidBgListener: androidBgListener,
                richDataCapture: richDataCapture,
                onBoardComplete: onBoardComplete,
                reviewQualifyingEventCount: reviewQualifyingEventCount,
                lastReviewPromptDate: lastReviewPromptDate,
                reviewNeverAsk: reviewNeverAsk,
                lanInstantSync: lanInstantSync,
                autoWriteOnReceive: autoWriteOnReceive,
                enableTypeToSearch: enableTypeToSearch,
                hideFromScreenCapture: hideFromScreenCapture,
                showTrayIcon: showTrayIcon,
                clipboardFeedbackMode: clipboardFeedbackMode,
                enableLocalAuth: enableLocalAuth,
                localAuthTimeoutMinutes: localAuthTimeoutMinutes,
                showCollectionTip: showCollectionTip,
                searchIndexReady: searchIndexReady,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> enableSync = const Value.absent(),
                Value<bool> enableFileSync = const Value.absent(),
                Value<String> layout = const Value.absent(),
                Value<String> view = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<double> windowWidth = const Value.absent(),
                Value<double> windowHeight = const Value.absent(),
                Value<String> sortBy = const Value.absent(),
                Value<String> sortOrder = const Value.absent(),
                Value<int> dontUploadOver = const Value.absent(),
                Value<int> dontCopyOver = const Value.absent(),
                Value<DateTime?> pausedTill = const Value.absent(),
                Value<String> syncSpeed = const Value.absent(),
                Value<String?> toggleHotkey = const Value.absent(),
                Value<String?> quickPasteHotkey = const Value.absent(),
                Value<String?> pasteStackHotkey = const Value.absent(),
                Value<bool> smartPaste = const Value.absent(),
                Value<bool> keepWindowOpenOnUnfocus = const Value.absent(),
                Value<bool> transformAsNewClip = const Value.absent(),
                Value<bool> launchAtStartup = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String?> enc2 = const Value.absent(),
                Value<bool> autoEncrypt = const Value.absent(),
                Value<bool> useEncryptionNonce = const Value.absent(),
                Value<ExclusionRules?> exclusionRules = const Value.absent(),
                Value<int> themeColor = const Value.absent(),
                Value<String> themeVariant = const Value.absent(),
                Value<bool> enableDragNDrop = const Value.absent(),
                Value<bool> enablePasteStack = const Value.absent(),
                Value<bool> androidBgListener = const Value.absent(),
                Value<bool> richDataCapture = const Value.absent(),
                Value<bool> onBoardComplete = const Value.absent(),
                Value<int> reviewQualifyingEventCount = const Value.absent(),
                Value<DateTime?> lastReviewPromptDate = const Value.absent(),
                Value<bool> reviewNeverAsk = const Value.absent(),
                Value<bool> lanInstantSync = const Value.absent(),
                Value<bool> autoWriteOnReceive = const Value.absent(),
                Value<bool> enableTypeToSearch = const Value.absent(),
                Value<bool> hideFromScreenCapture = const Value.absent(),
                Value<bool> showTrayIcon = const Value.absent(),
                Value<String> clipboardFeedbackMode = const Value.absent(),
                Value<bool> enableLocalAuth = const Value.absent(),
                Value<int> localAuthTimeoutMinutes = const Value.absent(),
                Value<bool> showCollectionTip = const Value.absent(),
                Value<bool> searchIndexReady = const Value.absent(),
              }) => DriftAppConfigTableCompanion.insert(
                id: id,
                themeMode: themeMode,
                enableSync: enableSync,
                enableFileSync: enableFileSync,
                layout: layout,
                view: view,
                pinned: pinned,
                windowWidth: windowWidth,
                windowHeight: windowHeight,
                sortBy: sortBy,
                sortOrder: sortOrder,
                dontUploadOver: dontUploadOver,
                dontCopyOver: dontCopyOver,
                pausedTill: pausedTill,
                syncSpeed: syncSpeed,
                toggleHotkey: toggleHotkey,
                quickPasteHotkey: quickPasteHotkey,
                pasteStackHotkey: pasteStackHotkey,
                smartPaste: smartPaste,
                keepWindowOpenOnUnfocus: keepWindowOpenOnUnfocus,
                transformAsNewClip: transformAsNewClip,
                launchAtStartup: launchAtStartup,
                locale: locale,
                enc2: enc2,
                autoEncrypt: autoEncrypt,
                useEncryptionNonce: useEncryptionNonce,
                exclusionRules: exclusionRules,
                themeColor: themeColor,
                themeVariant: themeVariant,
                enableDragNDrop: enableDragNDrop,
                enablePasteStack: enablePasteStack,
                androidBgListener: androidBgListener,
                richDataCapture: richDataCapture,
                onBoardComplete: onBoardComplete,
                reviewQualifyingEventCount: reviewQualifyingEventCount,
                lastReviewPromptDate: lastReviewPromptDate,
                reviewNeverAsk: reviewNeverAsk,
                lanInstantSync: lanInstantSync,
                autoWriteOnReceive: autoWriteOnReceive,
                enableTypeToSearch: enableTypeToSearch,
                hideFromScreenCapture: hideFromScreenCapture,
                showTrayIcon: showTrayIcon,
                clipboardFeedbackMode: clipboardFeedbackMode,
                enableLocalAuth: enableLocalAuth,
                localAuthTimeoutMinutes: localAuthTimeoutMinutes,
                showCollectionTip: showCollectionTip,
                searchIndexReady: searchIndexReady,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftAppConfigTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftAppConfigTableTable,
      DriftAppConfigEntry,
      $$DriftAppConfigTableTableFilterComposer,
      $$DriftAppConfigTableTableOrderingComposer,
      $$DriftAppConfigTableTableAnnotationComposer,
      $$DriftAppConfigTableTableCreateCompanionBuilder,
      $$DriftAppConfigTableTableUpdateCompanionBuilder,
      (
        DriftAppConfigEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftAppConfigTableTable,
          DriftAppConfigEntry
        >,
      ),
      DriftAppConfigEntry,
      PrefetchHooks Function()
    >;
typedef $$DriftApplicationMetaTableTableCreateCompanionBuilder =
    DriftApplicationMetaTableCompanion Function({
      Value<int> id,
      required String sourceId,
      Value<String?> identifier,
      Value<String?> appName,
      Value<String?> appFilePath,
      required String os,
      Value<String?> iconLocalPath,
      Value<String?> iconRemotePath,
      required DateTime created,
      required DateTime modified,
    });
typedef $$DriftApplicationMetaTableTableUpdateCompanionBuilder =
    DriftApplicationMetaTableCompanion Function({
      Value<int> id,
      Value<String> sourceId,
      Value<String?> identifier,
      Value<String?> appName,
      Value<String?> appFilePath,
      Value<String> os,
      Value<String?> iconLocalPath,
      Value<String?> iconRemotePath,
      Value<DateTime> created,
      Value<DateTime> modified,
    });

class $$DriftApplicationMetaTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftApplicationMetaTableTable> {
  $$DriftApplicationMetaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appFilePath => $composableBuilder(
    column: $table.appFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get os => $composableBuilder(
    column: $table.os,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconLocalPath => $composableBuilder(
    column: $table.iconLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconRemotePath => $composableBuilder(
    column: $table.iconRemotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftApplicationMetaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftApplicationMetaTableTable> {
  $$DriftApplicationMetaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appFilePath => $composableBuilder(
    column: $table.appFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get os => $composableBuilder(
    column: $table.os,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconLocalPath => $composableBuilder(
    column: $table.iconLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconRemotePath => $composableBuilder(
    column: $table.iconRemotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftApplicationMetaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftApplicationMetaTableTable> {
  $$DriftApplicationMetaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get appFilePath => $composableBuilder(
    column: $table.appFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get os =>
      $composableBuilder(column: $table.os, builder: (column) => column);

  GeneratedColumn<String> get iconLocalPath => $composableBuilder(
    column: $table.iconLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconRemotePath => $composableBuilder(
    column: $table.iconRemotePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<DateTime> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);
}

class $$DriftApplicationMetaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftApplicationMetaTableTable,
          DriftApplicationMetaEntry,
          $$DriftApplicationMetaTableTableFilterComposer,
          $$DriftApplicationMetaTableTableOrderingComposer,
          $$DriftApplicationMetaTableTableAnnotationComposer,
          $$DriftApplicationMetaTableTableCreateCompanionBuilder,
          $$DriftApplicationMetaTableTableUpdateCompanionBuilder,
          (
            DriftApplicationMetaEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftApplicationMetaTableTable,
              DriftApplicationMetaEntry
            >,
          ),
          DriftApplicationMetaEntry,
          PrefetchHooks Function()
        > {
  $$DriftApplicationMetaTableTableTableManager(
    _$AppDatabase db,
    $DriftApplicationMetaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftApplicationMetaTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriftApplicationMetaTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftApplicationMetaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String?> identifier = const Value.absent(),
                Value<String?> appName = const Value.absent(),
                Value<String?> appFilePath = const Value.absent(),
                Value<String> os = const Value.absent(),
                Value<String?> iconLocalPath = const Value.absent(),
                Value<String?> iconRemotePath = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
              }) => DriftApplicationMetaTableCompanion(
                id: id,
                sourceId: sourceId,
                identifier: identifier,
                appName: appName,
                appFilePath: appFilePath,
                os: os,
                iconLocalPath: iconLocalPath,
                iconRemotePath: iconRemotePath,
                created: created,
                modified: modified,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sourceId,
                Value<String?> identifier = const Value.absent(),
                Value<String?> appName = const Value.absent(),
                Value<String?> appFilePath = const Value.absent(),
                required String os,
                Value<String?> iconLocalPath = const Value.absent(),
                Value<String?> iconRemotePath = const Value.absent(),
                required DateTime created,
                required DateTime modified,
              }) => DriftApplicationMetaTableCompanion.insert(
                id: id,
                sourceId: sourceId,
                identifier: identifier,
                appName: appName,
                appFilePath: appFilePath,
                os: os,
                iconLocalPath: iconLocalPath,
                iconRemotePath: iconRemotePath,
                created: created,
                modified: modified,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftApplicationMetaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftApplicationMetaTableTable,
      DriftApplicationMetaEntry,
      $$DriftApplicationMetaTableTableFilterComposer,
      $$DriftApplicationMetaTableTableOrderingComposer,
      $$DriftApplicationMetaTableTableAnnotationComposer,
      $$DriftApplicationMetaTableTableCreateCompanionBuilder,
      $$DriftApplicationMetaTableTableUpdateCompanionBuilder,
      (
        DriftApplicationMetaEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftApplicationMetaTableTable,
          DriftApplicationMetaEntry
        >,
      ),
      DriftApplicationMetaEntry,
      PrefetchHooks Function()
    >;
typedef $$DriftClipCollectionTableTableCreateCompanionBuilder =
    DriftClipCollectionTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<DateTime?> lastSynced,
      required DateTime created,
      required DateTime modified,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      required String title,
      Value<String?> description,
      required String emoji,
    });
typedef $$DriftClipCollectionTableTableUpdateCompanionBuilder =
    DriftClipCollectionTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<DateTime?> lastSynced,
      Value<DateTime> created,
      Value<DateTime> modified,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      Value<String> title,
      Value<String?> description,
      Value<String> emoji,
    });

class $$DriftClipCollectionTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftClipCollectionTableTable> {
  $$DriftClipCollectionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftClipCollectionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftClipCollectionTableTable> {
  $$DriftClipCollectionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftClipCollectionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftClipCollectionTableTable> {
  $$DriftClipCollectionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<DateTime> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);
}

class $$DriftClipCollectionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftClipCollectionTableTable,
          DriftClipCollectionEntry,
          $$DriftClipCollectionTableTableFilterComposer,
          $$DriftClipCollectionTableTableOrderingComposer,
          $$DriftClipCollectionTableTableAnnotationComposer,
          $$DriftClipCollectionTableTableCreateCompanionBuilder,
          $$DriftClipCollectionTableTableUpdateCompanionBuilder,
          (
            DriftClipCollectionEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftClipCollectionTableTable,
              DriftClipCollectionEntry
            >,
          ),
          DriftClipCollectionEntry,
          PrefetchHooks Function()
        > {
  $$DriftClipCollectionTableTableTableManager(
    _$AppDatabase db,
    $DriftClipCollectionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftClipCollectionTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriftClipCollectionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftClipCollectionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime?> lastSynced = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> emoji = const Value.absent(),
              }) => DriftClipCollectionTableCompanion(
                id: id,
                serverId: serverId,
                lastSynced: lastSynced,
                created: created,
                modified: modified,
                userId: userId,
                deletedAt: deletedAt,
                deviceId: deviceId,
                title: title,
                description: description,
                emoji: emoji,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime?> lastSynced = const Value.absent(),
                required DateTime created,
                required DateTime modified,
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required String emoji,
              }) => DriftClipCollectionTableCompanion.insert(
                id: id,
                serverId: serverId,
                lastSynced: lastSynced,
                created: created,
                modified: modified,
                userId: userId,
                deletedAt: deletedAt,
                deviceId: deviceId,
                title: title,
                description: description,
                emoji: emoji,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftClipCollectionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftClipCollectionTableTable,
      DriftClipCollectionEntry,
      $$DriftClipCollectionTableTableFilterComposer,
      $$DriftClipCollectionTableTableOrderingComposer,
      $$DriftClipCollectionTableTableAnnotationComposer,
      $$DriftClipCollectionTableTableCreateCompanionBuilder,
      $$DriftClipCollectionTableTableUpdateCompanionBuilder,
      (
        DriftClipCollectionEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftClipCollectionTableTable,
          DriftClipCollectionEntry
        >,
      ),
      DriftClipCollectionEntry,
      PrefetchHooks Function()
    >;
typedef $$DriftClipboardItemTableTableCreateCompanionBuilder =
    DriftClipboardItemTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<DateTime?> lastSynced,
      Value<String?> localPath,
      required DateTime created,
      required DateTime modified,
      Value<String?> deviceId,
      required String type,
      required String userId,
      Value<String?> title,
      Value<String?> description,
      Value<DateTime?> deletedAt,
      Value<bool> locked,
      Value<bool> encrypted,
      Value<String?> iv,
      Value<String?> encMode,
      Value<String?> textContent,
      Value<String?> richData,
      Value<String?> url,
      Value<String?> textCategory,
      Value<String?> linkPreviewTitle,
      Value<String?> linkPreviewDescription,
      Value<String?> linkPreviewImageUrl,
      Value<String?> fileName,
      Value<String?> fileMimeType,
      Value<String?> fileExtension,
      Value<String?> driveFileId,
      Value<int?> fileSize,
      Value<String?> imgBlurHash,
      Value<String?> sourceUrl,
      Value<String?> sourceApp,
      Value<String?> sourceId,
      required String os,
      Value<int?> serverCollectionId,
      Value<int?> collectionId,
      Value<bool> localOnly,
      Value<int> copiedCount,
      Value<DateTime?> lastCopied,
      Value<String?> originId,
      Value<String?> searchTokens,
    });
typedef $$DriftClipboardItemTableTableUpdateCompanionBuilder =
    DriftClipboardItemTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<DateTime?> lastSynced,
      Value<String?> localPath,
      Value<DateTime> created,
      Value<DateTime> modified,
      Value<String?> deviceId,
      Value<String> type,
      Value<String> userId,
      Value<String?> title,
      Value<String?> description,
      Value<DateTime?> deletedAt,
      Value<bool> locked,
      Value<bool> encrypted,
      Value<String?> iv,
      Value<String?> encMode,
      Value<String?> textContent,
      Value<String?> richData,
      Value<String?> url,
      Value<String?> textCategory,
      Value<String?> linkPreviewTitle,
      Value<String?> linkPreviewDescription,
      Value<String?> linkPreviewImageUrl,
      Value<String?> fileName,
      Value<String?> fileMimeType,
      Value<String?> fileExtension,
      Value<String?> driveFileId,
      Value<int?> fileSize,
      Value<String?> imgBlurHash,
      Value<String?> sourceUrl,
      Value<String?> sourceApp,
      Value<String?> sourceId,
      Value<String> os,
      Value<int?> serverCollectionId,
      Value<int?> collectionId,
      Value<bool> localOnly,
      Value<int> copiedCount,
      Value<DateTime?> lastCopied,
      Value<String?> originId,
      Value<String?> searchTokens,
    });

class $$DriftClipboardItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftClipboardItemTableTable> {
  $$DriftClipboardItemTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get encrypted => $composableBuilder(
    column: $table.encrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iv => $composableBuilder(
    column: $table.iv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encMode => $composableBuilder(
    column: $table.encMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get richData => $composableBuilder(
    column: $table.richData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textCategory => $composableBuilder(
    column: $table.textCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkPreviewTitle => $composableBuilder(
    column: $table.linkPreviewTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkPreviewDescription => $composableBuilder(
    column: $table.linkPreviewDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkPreviewImageUrl => $composableBuilder(
    column: $table.linkPreviewImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileMimeType => $composableBuilder(
    column: $table.fileMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileExtension => $composableBuilder(
    column: $table.fileExtension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imgBlurHash => $composableBuilder(
    column: $table.imgBlurHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceApp => $composableBuilder(
    column: $table.sourceApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get os => $composableBuilder(
    column: $table.os,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverCollectionId => $composableBuilder(
    column: $table.serverCollectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get collectionId => $composableBuilder(
    column: $table.collectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get localOnly => $composableBuilder(
    column: $table.localOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get copiedCount => $composableBuilder(
    column: $table.copiedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCopied => $composableBuilder(
    column: $table.lastCopied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originId => $composableBuilder(
    column: $table.originId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchTokens => $composableBuilder(
    column: $table.searchTokens,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftClipboardItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftClipboardItemTableTable> {
  $$DriftClipboardItemTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get encrypted => $composableBuilder(
    column: $table.encrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iv => $composableBuilder(
    column: $table.iv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encMode => $composableBuilder(
    column: $table.encMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get richData => $composableBuilder(
    column: $table.richData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textCategory => $composableBuilder(
    column: $table.textCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkPreviewTitle => $composableBuilder(
    column: $table.linkPreviewTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkPreviewDescription => $composableBuilder(
    column: $table.linkPreviewDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkPreviewImageUrl => $composableBuilder(
    column: $table.linkPreviewImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileMimeType => $composableBuilder(
    column: $table.fileMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileExtension => $composableBuilder(
    column: $table.fileExtension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imgBlurHash => $composableBuilder(
    column: $table.imgBlurHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceApp => $composableBuilder(
    column: $table.sourceApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get os => $composableBuilder(
    column: $table.os,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverCollectionId => $composableBuilder(
    column: $table.serverCollectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get collectionId => $composableBuilder(
    column: $table.collectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get localOnly => $composableBuilder(
    column: $table.localOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get copiedCount => $composableBuilder(
    column: $table.copiedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCopied => $composableBuilder(
    column: $table.lastCopied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originId => $composableBuilder(
    column: $table.originId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchTokens => $composableBuilder(
    column: $table.searchTokens,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftClipboardItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftClipboardItemTableTable> {
  $$DriftClipboardItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<DateTime> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get locked =>
      $composableBuilder(column: $table.locked, builder: (column) => column);

  GeneratedColumn<bool> get encrypted =>
      $composableBuilder(column: $table.encrypted, builder: (column) => column);

  GeneratedColumn<String> get iv =>
      $composableBuilder(column: $table.iv, builder: (column) => column);

  GeneratedColumn<String> get encMode =>
      $composableBuilder(column: $table.encMode, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get richData =>
      $composableBuilder(column: $table.richData, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get textCategory => $composableBuilder(
    column: $table.textCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkPreviewTitle => $composableBuilder(
    column: $table.linkPreviewTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkPreviewDescription => $composableBuilder(
    column: $table.linkPreviewDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkPreviewImageUrl => $composableBuilder(
    column: $table.linkPreviewImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileMimeType => $composableBuilder(
    column: $table.fileMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileExtension => $composableBuilder(
    column: $table.fileExtension,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get imgBlurHash => $composableBuilder(
    column: $table.imgBlurHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceApp =>
      $composableBuilder(column: $table.sourceApp, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get os =>
      $composableBuilder(column: $table.os, builder: (column) => column);

  GeneratedColumn<int> get serverCollectionId => $composableBuilder(
    column: $table.serverCollectionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get collectionId => $composableBuilder(
    column: $table.collectionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get localOnly =>
      $composableBuilder(column: $table.localOnly, builder: (column) => column);

  GeneratedColumn<int> get copiedCount => $composableBuilder(
    column: $table.copiedCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCopied => $composableBuilder(
    column: $table.lastCopied,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originId =>
      $composableBuilder(column: $table.originId, builder: (column) => column);

  GeneratedColumn<String> get searchTokens => $composableBuilder(
    column: $table.searchTokens,
    builder: (column) => column,
  );
}

class $$DriftClipboardItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftClipboardItemTableTable,
          DriftClipboardItemEntry,
          $$DriftClipboardItemTableTableFilterComposer,
          $$DriftClipboardItemTableTableOrderingComposer,
          $$DriftClipboardItemTableTableAnnotationComposer,
          $$DriftClipboardItemTableTableCreateCompanionBuilder,
          $$DriftClipboardItemTableTableUpdateCompanionBuilder,
          (
            DriftClipboardItemEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftClipboardItemTableTable,
              DriftClipboardItemEntry
            >,
          ),
          DriftClipboardItemEntry,
          PrefetchHooks Function()
        > {
  $$DriftClipboardItemTableTableTableManager(
    _$AppDatabase db,
    $DriftClipboardItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftClipboardItemTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriftClipboardItemTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftClipboardItemTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime?> lastSynced = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> locked = const Value.absent(),
                Value<bool> encrypted = const Value.absent(),
                Value<String?> iv = const Value.absent(),
                Value<String?> encMode = const Value.absent(),
                Value<String?> textContent = const Value.absent(),
                Value<String?> richData = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> textCategory = const Value.absent(),
                Value<String?> linkPreviewTitle = const Value.absent(),
                Value<String?> linkPreviewDescription = const Value.absent(),
                Value<String?> linkPreviewImageUrl = const Value.absent(),
                Value<String?> fileName = const Value.absent(),
                Value<String?> fileMimeType = const Value.absent(),
                Value<String?> fileExtension = const Value.absent(),
                Value<String?> driveFileId = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<String?> imgBlurHash = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> sourceApp = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> os = const Value.absent(),
                Value<int?> serverCollectionId = const Value.absent(),
                Value<int?> collectionId = const Value.absent(),
                Value<bool> localOnly = const Value.absent(),
                Value<int> copiedCount = const Value.absent(),
                Value<DateTime?> lastCopied = const Value.absent(),
                Value<String?> originId = const Value.absent(),
                Value<String?> searchTokens = const Value.absent(),
              }) => DriftClipboardItemTableCompanion(
                id: id,
                serverId: serverId,
                lastSynced: lastSynced,
                localPath: localPath,
                created: created,
                modified: modified,
                deviceId: deviceId,
                type: type,
                userId: userId,
                title: title,
                description: description,
                deletedAt: deletedAt,
                locked: locked,
                encrypted: encrypted,
                iv: iv,
                encMode: encMode,
                textContent: textContent,
                richData: richData,
                url: url,
                textCategory: textCategory,
                linkPreviewTitle: linkPreviewTitle,
                linkPreviewDescription: linkPreviewDescription,
                linkPreviewImageUrl: linkPreviewImageUrl,
                fileName: fileName,
                fileMimeType: fileMimeType,
                fileExtension: fileExtension,
                driveFileId: driveFileId,
                fileSize: fileSize,
                imgBlurHash: imgBlurHash,
                sourceUrl: sourceUrl,
                sourceApp: sourceApp,
                sourceId: sourceId,
                os: os,
                serverCollectionId: serverCollectionId,
                collectionId: collectionId,
                localOnly: localOnly,
                copiedCount: copiedCount,
                lastCopied: lastCopied,
                originId: originId,
                searchTokens: searchTokens,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime?> lastSynced = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                required DateTime created,
                required DateTime modified,
                Value<String?> deviceId = const Value.absent(),
                required String type,
                required String userId,
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> locked = const Value.absent(),
                Value<bool> encrypted = const Value.absent(),
                Value<String?> iv = const Value.absent(),
                Value<String?> encMode = const Value.absent(),
                Value<String?> textContent = const Value.absent(),
                Value<String?> richData = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> textCategory = const Value.absent(),
                Value<String?> linkPreviewTitle = const Value.absent(),
                Value<String?> linkPreviewDescription = const Value.absent(),
                Value<String?> linkPreviewImageUrl = const Value.absent(),
                Value<String?> fileName = const Value.absent(),
                Value<String?> fileMimeType = const Value.absent(),
                Value<String?> fileExtension = const Value.absent(),
                Value<String?> driveFileId = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<String?> imgBlurHash = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> sourceApp = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                required String os,
                Value<int?> serverCollectionId = const Value.absent(),
                Value<int?> collectionId = const Value.absent(),
                Value<bool> localOnly = const Value.absent(),
                Value<int> copiedCount = const Value.absent(),
                Value<DateTime?> lastCopied = const Value.absent(),
                Value<String?> originId = const Value.absent(),
                Value<String?> searchTokens = const Value.absent(),
              }) => DriftClipboardItemTableCompanion.insert(
                id: id,
                serverId: serverId,
                lastSynced: lastSynced,
                localPath: localPath,
                created: created,
                modified: modified,
                deviceId: deviceId,
                type: type,
                userId: userId,
                title: title,
                description: description,
                deletedAt: deletedAt,
                locked: locked,
                encrypted: encrypted,
                iv: iv,
                encMode: encMode,
                textContent: textContent,
                richData: richData,
                url: url,
                textCategory: textCategory,
                linkPreviewTitle: linkPreviewTitle,
                linkPreviewDescription: linkPreviewDescription,
                linkPreviewImageUrl: linkPreviewImageUrl,
                fileName: fileName,
                fileMimeType: fileMimeType,
                fileExtension: fileExtension,
                driveFileId: driveFileId,
                fileSize: fileSize,
                imgBlurHash: imgBlurHash,
                sourceUrl: sourceUrl,
                sourceApp: sourceApp,
                sourceId: sourceId,
                os: os,
                serverCollectionId: serverCollectionId,
                collectionId: collectionId,
                localOnly: localOnly,
                copiedCount: copiedCount,
                lastCopied: lastCopied,
                originId: originId,
                searchTokens: searchTokens,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftClipboardItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftClipboardItemTableTable,
      DriftClipboardItemEntry,
      $$DriftClipboardItemTableTableFilterComposer,
      $$DriftClipboardItemTableTableOrderingComposer,
      $$DriftClipboardItemTableTableAnnotationComposer,
      $$DriftClipboardItemTableTableCreateCompanionBuilder,
      $$DriftClipboardItemTableTableUpdateCompanionBuilder,
      (
        DriftClipboardItemEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftClipboardItemTableTable,
          DriftClipboardItemEntry
        >,
      ),
      DriftClipboardItemEntry,
      PrefetchHooks Function()
    >;
typedef $$DriftSubscriptionTableTableCreateCompanionBuilder =
    DriftSubscriptionTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required DateTime created,
      required DateTime modified,
      required String userId,
      required String planName,
      required String subId,
      required String source,
      Value<DateTime?> trialStart,
      Value<DateTime?> trialEnd,
      Value<int> collections,
      Value<int> itemsPerCollection,
      Value<bool> dragNdrop,
      Value<bool> theming,
      Value<int> syncHours,
      Value<bool> ads,
      Value<int> syncInterval,
      Value<bool> edit,
      Value<DateTime?> activeTill,
      Value<int> maxSyncDevices,
      Value<bool> customExclusionRules,
      Value<int> pasteStackLimit,
      Value<int> grants,
      Value<String?> tkn,
    });
typedef $$DriftSubscriptionTableTableUpdateCompanionBuilder =
    DriftSubscriptionTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<DateTime> modified,
      Value<String> userId,
      Value<String> planName,
      Value<String> subId,
      Value<String> source,
      Value<DateTime?> trialStart,
      Value<DateTime?> trialEnd,
      Value<int> collections,
      Value<int> itemsPerCollection,
      Value<bool> dragNdrop,
      Value<bool> theming,
      Value<int> syncHours,
      Value<bool> ads,
      Value<int> syncInterval,
      Value<bool> edit,
      Value<DateTime?> activeTill,
      Value<int> maxSyncDevices,
      Value<bool> customExclusionRules,
      Value<int> pasteStackLimit,
      Value<int> grants,
      Value<String?> tkn,
    });

class $$DriftSubscriptionTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftSubscriptionTableTable> {
  $$DriftSubscriptionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subId => $composableBuilder(
    column: $table.subId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialStart => $composableBuilder(
    column: $table.trialStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialEnd => $composableBuilder(
    column: $table.trialEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get collections => $composableBuilder(
    column: $table.collections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsPerCollection => $composableBuilder(
    column: $table.itemsPerCollection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dragNdrop => $composableBuilder(
    column: $table.dragNdrop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get theming => $composableBuilder(
    column: $table.theming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncHours => $composableBuilder(
    column: $table.syncHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ads => $composableBuilder(
    column: $table.ads,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncInterval => $composableBuilder(
    column: $table.syncInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get edit => $composableBuilder(
    column: $table.edit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activeTill => $composableBuilder(
    column: $table.activeTill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSyncDevices => $composableBuilder(
    column: $table.maxSyncDevices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get customExclusionRules => $composableBuilder(
    column: $table.customExclusionRules,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pasteStackLimit => $composableBuilder(
    column: $table.pasteStackLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grants => $composableBuilder(
    column: $table.grants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tkn => $composableBuilder(
    column: $table.tkn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftSubscriptionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftSubscriptionTableTable> {
  $$DriftSubscriptionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subId => $composableBuilder(
    column: $table.subId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialStart => $composableBuilder(
    column: $table.trialStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialEnd => $composableBuilder(
    column: $table.trialEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get collections => $composableBuilder(
    column: $table.collections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsPerCollection => $composableBuilder(
    column: $table.itemsPerCollection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dragNdrop => $composableBuilder(
    column: $table.dragNdrop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get theming => $composableBuilder(
    column: $table.theming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncHours => $composableBuilder(
    column: $table.syncHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ads => $composableBuilder(
    column: $table.ads,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncInterval => $composableBuilder(
    column: $table.syncInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get edit => $composableBuilder(
    column: $table.edit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activeTill => $composableBuilder(
    column: $table.activeTill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSyncDevices => $composableBuilder(
    column: $table.maxSyncDevices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get customExclusionRules => $composableBuilder(
    column: $table.customExclusionRules,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pasteStackLimit => $composableBuilder(
    column: $table.pasteStackLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grants => $composableBuilder(
    column: $table.grants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tkn => $composableBuilder(
    column: $table.tkn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftSubscriptionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftSubscriptionTableTable> {
  $$DriftSubscriptionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<DateTime> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get planName =>
      $composableBuilder(column: $table.planName, builder: (column) => column);

  GeneratedColumn<String> get subId =>
      $composableBuilder(column: $table.subId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get trialStart => $composableBuilder(
    column: $table.trialStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get trialEnd =>
      $composableBuilder(column: $table.trialEnd, builder: (column) => column);

  GeneratedColumn<int> get collections => $composableBuilder(
    column: $table.collections,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemsPerCollection => $composableBuilder(
    column: $table.itemsPerCollection,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dragNdrop =>
      $composableBuilder(column: $table.dragNdrop, builder: (column) => column);

  GeneratedColumn<bool> get theming =>
      $composableBuilder(column: $table.theming, builder: (column) => column);

  GeneratedColumn<int> get syncHours =>
      $composableBuilder(column: $table.syncHours, builder: (column) => column);

  GeneratedColumn<bool> get ads =>
      $composableBuilder(column: $table.ads, builder: (column) => column);

  GeneratedColumn<int> get syncInterval => $composableBuilder(
    column: $table.syncInterval,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get edit =>
      $composableBuilder(column: $table.edit, builder: (column) => column);

  GeneratedColumn<DateTime> get activeTill => $composableBuilder(
    column: $table.activeTill,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxSyncDevices => $composableBuilder(
    column: $table.maxSyncDevices,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get customExclusionRules => $composableBuilder(
    column: $table.customExclusionRules,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pasteStackLimit => $composableBuilder(
    column: $table.pasteStackLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grants =>
      $composableBuilder(column: $table.grants, builder: (column) => column);

  GeneratedColumn<String> get tkn =>
      $composableBuilder(column: $table.tkn, builder: (column) => column);
}

class $$DriftSubscriptionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftSubscriptionTableTable,
          DriftSubscriptionEntry,
          $$DriftSubscriptionTableTableFilterComposer,
          $$DriftSubscriptionTableTableOrderingComposer,
          $$DriftSubscriptionTableTableAnnotationComposer,
          $$DriftSubscriptionTableTableCreateCompanionBuilder,
          $$DriftSubscriptionTableTableUpdateCompanionBuilder,
          (
            DriftSubscriptionEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftSubscriptionTableTable,
              DriftSubscriptionEntry
            >,
          ),
          DriftSubscriptionEntry,
          PrefetchHooks Function()
        > {
  $$DriftSubscriptionTableTableTableManager(
    _$AppDatabase db,
    $DriftSubscriptionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftSubscriptionTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriftSubscriptionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftSubscriptionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> planName = const Value.absent(),
                Value<String> subId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime?> trialStart = const Value.absent(),
                Value<DateTime?> trialEnd = const Value.absent(),
                Value<int> collections = const Value.absent(),
                Value<int> itemsPerCollection = const Value.absent(),
                Value<bool> dragNdrop = const Value.absent(),
                Value<bool> theming = const Value.absent(),
                Value<int> syncHours = const Value.absent(),
                Value<bool> ads = const Value.absent(),
                Value<int> syncInterval = const Value.absent(),
                Value<bool> edit = const Value.absent(),
                Value<DateTime?> activeTill = const Value.absent(),
                Value<int> maxSyncDevices = const Value.absent(),
                Value<bool> customExclusionRules = const Value.absent(),
                Value<int> pasteStackLimit = const Value.absent(),
                Value<int> grants = const Value.absent(),
                Value<String?> tkn = const Value.absent(),
              }) => DriftSubscriptionTableCompanion(
                id: id,
                serverId: serverId,
                created: created,
                modified: modified,
                userId: userId,
                planName: planName,
                subId: subId,
                source: source,
                trialStart: trialStart,
                trialEnd: trialEnd,
                collections: collections,
                itemsPerCollection: itemsPerCollection,
                dragNdrop: dragNdrop,
                theming: theming,
                syncHours: syncHours,
                ads: ads,
                syncInterval: syncInterval,
                edit: edit,
                activeTill: activeTill,
                maxSyncDevices: maxSyncDevices,
                customExclusionRules: customExclusionRules,
                pasteStackLimit: pasteStackLimit,
                grants: grants,
                tkn: tkn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required DateTime modified,
                required String userId,
                required String planName,
                required String subId,
                required String source,
                Value<DateTime?> trialStart = const Value.absent(),
                Value<DateTime?> trialEnd = const Value.absent(),
                Value<int> collections = const Value.absent(),
                Value<int> itemsPerCollection = const Value.absent(),
                Value<bool> dragNdrop = const Value.absent(),
                Value<bool> theming = const Value.absent(),
                Value<int> syncHours = const Value.absent(),
                Value<bool> ads = const Value.absent(),
                Value<int> syncInterval = const Value.absent(),
                Value<bool> edit = const Value.absent(),
                Value<DateTime?> activeTill = const Value.absent(),
                Value<int> maxSyncDevices = const Value.absent(),
                Value<bool> customExclusionRules = const Value.absent(),
                Value<int> pasteStackLimit = const Value.absent(),
                Value<int> grants = const Value.absent(),
                Value<String?> tkn = const Value.absent(),
              }) => DriftSubscriptionTableCompanion.insert(
                id: id,
                serverId: serverId,
                created: created,
                modified: modified,
                userId: userId,
                planName: planName,
                subId: subId,
                source: source,
                trialStart: trialStart,
                trialEnd: trialEnd,
                collections: collections,
                itemsPerCollection: itemsPerCollection,
                dragNdrop: dragNdrop,
                theming: theming,
                syncHours: syncHours,
                ads: ads,
                syncInterval: syncInterval,
                edit: edit,
                activeTill: activeTill,
                maxSyncDevices: maxSyncDevices,
                customExclusionRules: customExclusionRules,
                pasteStackLimit: pasteStackLimit,
                grants: grants,
                tkn: tkn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftSubscriptionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftSubscriptionTableTable,
      DriftSubscriptionEntry,
      $$DriftSubscriptionTableTableFilterComposer,
      $$DriftSubscriptionTableTableOrderingComposer,
      $$DriftSubscriptionTableTableAnnotationComposer,
      $$DriftSubscriptionTableTableCreateCompanionBuilder,
      $$DriftSubscriptionTableTableUpdateCompanionBuilder,
      (
        DriftSubscriptionEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftSubscriptionTableTable,
          DriftSubscriptionEntry
        >,
      ),
      DriftSubscriptionEntry,
      PrefetchHooks Function()
    >;
typedef $$DriftSyncCursorTableTableCreateCompanionBuilder =
    DriftSyncCursorTableCompanion Function({
      Value<int> id,
      required String entityType,
      required DateTime lastSyncedAt,
      Value<int> lastOffset,
    });
typedef $$DriftSyncCursorTableTableUpdateCompanionBuilder =
    DriftSyncCursorTableCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<DateTime> lastSyncedAt,
      Value<int> lastOffset,
    });

class $$DriftSyncCursorTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftSyncCursorTableTable> {
  $$DriftSyncCursorTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastOffset => $composableBuilder(
    column: $table.lastOffset,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftSyncCursorTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftSyncCursorTableTable> {
  $$DriftSyncCursorTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastOffset => $composableBuilder(
    column: $table.lastOffset,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftSyncCursorTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftSyncCursorTableTable> {
  $$DriftSyncCursorTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastOffset => $composableBuilder(
    column: $table.lastOffset,
    builder: (column) => column,
  );
}

class $$DriftSyncCursorTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftSyncCursorTableTable,
          DriftSyncCursorEntry,
          $$DriftSyncCursorTableTableFilterComposer,
          $$DriftSyncCursorTableTableOrderingComposer,
          $$DriftSyncCursorTableTableAnnotationComposer,
          $$DriftSyncCursorTableTableCreateCompanionBuilder,
          $$DriftSyncCursorTableTableUpdateCompanionBuilder,
          (
            DriftSyncCursorEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftSyncCursorTableTable,
              DriftSyncCursorEntry
            >,
          ),
          DriftSyncCursorEntry,
          PrefetchHooks Function()
        > {
  $$DriftSyncCursorTableTableTableManager(
    _$AppDatabase db,
    $DriftSyncCursorTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftSyncCursorTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftSyncCursorTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftSyncCursorTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<DateTime> lastSyncedAt = const Value.absent(),
                Value<int> lastOffset = const Value.absent(),
              }) => DriftSyncCursorTableCompanion(
                id: id,
                entityType: entityType,
                lastSyncedAt: lastSyncedAt,
                lastOffset: lastOffset,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required DateTime lastSyncedAt,
                Value<int> lastOffset = const Value.absent(),
              }) => DriftSyncCursorTableCompanion.insert(
                id: id,
                entityType: entityType,
                lastSyncedAt: lastSyncedAt,
                lastOffset: lastOffset,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftSyncCursorTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftSyncCursorTableTable,
      DriftSyncCursorEntry,
      $$DriftSyncCursorTableTableFilterComposer,
      $$DriftSyncCursorTableTableOrderingComposer,
      $$DriftSyncCursorTableTableAnnotationComposer,
      $$DriftSyncCursorTableTableCreateCompanionBuilder,
      $$DriftSyncCursorTableTableUpdateCompanionBuilder,
      (
        DriftSyncCursorEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftSyncCursorTableTable,
          DriftSyncCursorEntry
        >,
      ),
      DriftSyncCursorEntry,
      PrefetchHooks Function()
    >;
typedef $$DriftSyncOutboxEntryTableTableCreateCompanionBuilder =
    DriftSyncOutboxEntryTableCompanion Function({
      Value<int> id,
      required String entityType,
      required int localId,
      required String action,
      required DateTime createdAt,
      Value<String?> lastError,
    });
typedef $$DriftSyncOutboxEntryTableTableUpdateCompanionBuilder =
    DriftSyncOutboxEntryTableCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int> localId,
      Value<String> action,
      Value<DateTime> createdAt,
      Value<String?> lastError,
    });

class $$DriftSyncOutboxEntryTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftSyncOutboxEntryTableTable> {
  $$DriftSyncOutboxEntryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftSyncOutboxEntryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftSyncOutboxEntryTableTable> {
  $$DriftSyncOutboxEntryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftSyncOutboxEntryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftSyncOutboxEntryTableTable> {
  $$DriftSyncOutboxEntryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$DriftSyncOutboxEntryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftSyncOutboxEntryTableTable,
          DriftSyncOutboxEntryRecord,
          $$DriftSyncOutboxEntryTableTableFilterComposer,
          $$DriftSyncOutboxEntryTableTableOrderingComposer,
          $$DriftSyncOutboxEntryTableTableAnnotationComposer,
          $$DriftSyncOutboxEntryTableTableCreateCompanionBuilder,
          $$DriftSyncOutboxEntryTableTableUpdateCompanionBuilder,
          (
            DriftSyncOutboxEntryRecord,
            BaseReferences<
              _$AppDatabase,
              $DriftSyncOutboxEntryTableTable,
              DriftSyncOutboxEntryRecord
            >,
          ),
          DriftSyncOutboxEntryRecord,
          PrefetchHooks Function()
        > {
  $$DriftSyncOutboxEntryTableTableTableManager(
    _$AppDatabase db,
    $DriftSyncOutboxEntryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftSyncOutboxEntryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriftSyncOutboxEntryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftSyncOutboxEntryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> localId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => DriftSyncOutboxEntryTableCompanion(
                id: id,
                entityType: entityType,
                localId: localId,
                action: action,
                createdAt: createdAt,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required int localId,
                required String action,
                required DateTime createdAt,
                Value<String?> lastError = const Value.absent(),
              }) => DriftSyncOutboxEntryTableCompanion.insert(
                id: id,
                entityType: entityType,
                localId: localId,
                action: action,
                createdAt: createdAt,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftSyncOutboxEntryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftSyncOutboxEntryTableTable,
      DriftSyncOutboxEntryRecord,
      $$DriftSyncOutboxEntryTableTableFilterComposer,
      $$DriftSyncOutboxEntryTableTableOrderingComposer,
      $$DriftSyncOutboxEntryTableTableAnnotationComposer,
      $$DriftSyncOutboxEntryTableTableCreateCompanionBuilder,
      $$DriftSyncOutboxEntryTableTableUpdateCompanionBuilder,
      (
        DriftSyncOutboxEntryRecord,
        BaseReferences<
          _$AppDatabase,
          $DriftSyncOutboxEntryTableTable,
          DriftSyncOutboxEntryRecord
        >,
      ),
      DriftSyncOutboxEntryRecord,
      PrefetchHooks Function()
    >;
typedef $$DriftSyncStatusTableTableCreateCompanionBuilder =
    DriftSyncStatusTableCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSyncPoint,
      Value<DateTime?> lastSyncStartPoint,
      Value<int?> lastKnownSyncCount,
      Value<int?> lastKnownTotalCount,
      Value<bool> restorationPending,
    });
typedef $$DriftSyncStatusTableTableUpdateCompanionBuilder =
    DriftSyncStatusTableCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSyncPoint,
      Value<DateTime?> lastSyncStartPoint,
      Value<int?> lastKnownSyncCount,
      Value<int?> lastKnownTotalCount,
      Value<bool> restorationPending,
    });

class $$DriftSyncStatusTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriftSyncStatusTableTable> {
  $$DriftSyncStatusTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncPoint => $composableBuilder(
    column: $table.lastSyncPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncStartPoint => $composableBuilder(
    column: $table.lastSyncStartPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastKnownSyncCount => $composableBuilder(
    column: $table.lastKnownSyncCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastKnownTotalCount => $composableBuilder(
    column: $table.lastKnownTotalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get restorationPending => $composableBuilder(
    column: $table.restorationPending,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftSyncStatusTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftSyncStatusTableTable> {
  $$DriftSyncStatusTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncPoint => $composableBuilder(
    column: $table.lastSyncPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncStartPoint => $composableBuilder(
    column: $table.lastSyncStartPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastKnownSyncCount => $composableBuilder(
    column: $table.lastKnownSyncCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastKnownTotalCount => $composableBuilder(
    column: $table.lastKnownTotalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get restorationPending => $composableBuilder(
    column: $table.restorationPending,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftSyncStatusTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftSyncStatusTableTable> {
  $$DriftSyncStatusTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncPoint => $composableBuilder(
    column: $table.lastSyncPoint,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncStartPoint => $composableBuilder(
    column: $table.lastSyncStartPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastKnownSyncCount => $composableBuilder(
    column: $table.lastKnownSyncCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastKnownTotalCount => $composableBuilder(
    column: $table.lastKnownTotalCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get restorationPending => $composableBuilder(
    column: $table.restorationPending,
    builder: (column) => column,
  );
}

class $$DriftSyncStatusTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriftSyncStatusTableTable,
          DriftSyncStatusEntry,
          $$DriftSyncStatusTableTableFilterComposer,
          $$DriftSyncStatusTableTableOrderingComposer,
          $$DriftSyncStatusTableTableAnnotationComposer,
          $$DriftSyncStatusTableTableCreateCompanionBuilder,
          $$DriftSyncStatusTableTableUpdateCompanionBuilder,
          (
            DriftSyncStatusEntry,
            BaseReferences<
              _$AppDatabase,
              $DriftSyncStatusTableTable,
              DriftSyncStatusEntry
            >,
          ),
          DriftSyncStatusEntry,
          PrefetchHooks Function()
        > {
  $$DriftSyncStatusTableTableTableManager(
    _$AppDatabase db,
    $DriftSyncStatusTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftSyncStatusTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftSyncStatusTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriftSyncStatusTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSyncPoint = const Value.absent(),
                Value<DateTime?> lastSyncStartPoint = const Value.absent(),
                Value<int?> lastKnownSyncCount = const Value.absent(),
                Value<int?> lastKnownTotalCount = const Value.absent(),
                Value<bool> restorationPending = const Value.absent(),
              }) => DriftSyncStatusTableCompanion(
                id: id,
                lastSyncPoint: lastSyncPoint,
                lastSyncStartPoint: lastSyncStartPoint,
                lastKnownSyncCount: lastKnownSyncCount,
                lastKnownTotalCount: lastKnownTotalCount,
                restorationPending: restorationPending,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSyncPoint = const Value.absent(),
                Value<DateTime?> lastSyncStartPoint = const Value.absent(),
                Value<int?> lastKnownSyncCount = const Value.absent(),
                Value<int?> lastKnownTotalCount = const Value.absent(),
                Value<bool> restorationPending = const Value.absent(),
              }) => DriftSyncStatusTableCompanion.insert(
                id: id,
                lastSyncPoint: lastSyncPoint,
                lastSyncStartPoint: lastSyncStartPoint,
                lastKnownSyncCount: lastKnownSyncCount,
                lastKnownTotalCount: lastKnownTotalCount,
                restorationPending: restorationPending,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftSyncStatusTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriftSyncStatusTableTable,
      DriftSyncStatusEntry,
      $$DriftSyncStatusTableTableFilterComposer,
      $$DriftSyncStatusTableTableOrderingComposer,
      $$DriftSyncStatusTableTableAnnotationComposer,
      $$DriftSyncStatusTableTableCreateCompanionBuilder,
      $$DriftSyncStatusTableTableUpdateCompanionBuilder,
      (
        DriftSyncStatusEntry,
        BaseReferences<
          _$AppDatabase,
          $DriftSyncStatusTableTable,
          DriftSyncStatusEntry
        >,
      ),
      DriftSyncStatusEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DriftAppConfigTableTableTableManager get driftAppConfigTable =>
      $$DriftAppConfigTableTableTableManager(_db, _db.driftAppConfigTable);
  $$DriftApplicationMetaTableTableTableManager get driftApplicationMetaTable =>
      $$DriftApplicationMetaTableTableTableManager(
        _db,
        _db.driftApplicationMetaTable,
      );
  $$DriftClipCollectionTableTableTableManager get driftClipCollectionTable =>
      $$DriftClipCollectionTableTableTableManager(
        _db,
        _db.driftClipCollectionTable,
      );
  $$DriftClipboardItemTableTableTableManager get driftClipboardItemTable =>
      $$DriftClipboardItemTableTableTableManager(
        _db,
        _db.driftClipboardItemTable,
      );
  $$DriftSubscriptionTableTableTableManager get driftSubscriptionTable =>
      $$DriftSubscriptionTableTableTableManager(
        _db,
        _db.driftSubscriptionTable,
      );
  $$DriftSyncCursorTableTableTableManager get driftSyncCursorTable =>
      $$DriftSyncCursorTableTableTableManager(_db, _db.driftSyncCursorTable);
  $$DriftSyncOutboxEntryTableTableTableManager get driftSyncOutboxEntryTable =>
      $$DriftSyncOutboxEntryTableTableTableManager(
        _db,
        _db.driftSyncOutboxEntryTable,
      );
  $$DriftSyncStatusTableTableTableManager get driftSyncStatusTable =>
      $$DriftSyncStatusTableTableTableManager(_db, _db.driftSyncStatusTable);
}
