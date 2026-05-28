import 'dart:async';

import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/settings/pages/android_bg_clipboard/accessibility_service_notice.dart';
import 'package:clipboard/pages/settings/pages/android_bg_clipboard/detection_status_card.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/pages/settings/widgets/switches/auto_write_on_receive_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/lan_instant_sync_switch.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:clipboard/utils/color_extension.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/pro_tip_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AndroidBgClipboardSettings extends StatefulWidget {
  final AndroidBackgroundClipboard bgService;
  final String deviceId;

  const AndroidBgClipboardSettings({
    super.key,
    required this.bgService,
    required this.deviceId,
  });

  @override
  State<AndroidBgClipboardSettings> createState() =>
      _AndroidBgClipboardSettingsState();
}

class _AndroidBgClipboardSettingsState extends State<AndroidBgClipboardSettings>
    with WidgetsBindingObserver {
  late final MonetizationCubit monetizationCubit;
  late final AppConfigCubit appConfigCubit;
  String? enc1Key;

  bool loading = true;
  bool writingConfig = false;
  // service status
  bool isRunning = false;
  // required permissions
  bool notification = false;
  bool batteryOptimization = false;
  bool accessibility = false;
  bool enable = false;
  bool _awaitingAccessibilityRefresh = false;
  StreamSubscription<Map<String, String>>? _detectionStatusSubscription;
  Map<String, String>? _latestDetectionStatusPayload;
  String _detectionStatusState = 'inactive';
  String _detectionStatusOutcome = 'none';

  String _selectedMode = 'inactive';
  final List<(String, String)> _detectionModes = const [
    ('inactive', 'Select mode'),
    ("mode_1_ack_text", "Mode 1"),
    ("mode_2_aggressive", "Mode 2"),
  ];

  String _normalizeDetectionMode(String? mode) {
    final value = (mode ?? '').trim();
    final supported = _detectionModes.any((entry) => entry.$1 == value);
    return supported ? value : 'inactive';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    monetizationCubit = context.read();
    appConfigCubit = context.read();

    context.read<AuthCubit>().state.whenOrNull(
      authenticated: (user, _, _, _) {
        enc1Key = user.enc1;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.bgService.initStorage();
      _subscribeToDetectionStatus();
      await checkStatus();
      await setupConfiguration();
    });
  }

  @override
  void dispose() {
    _detectionStatusSubscription?.cancel();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    super.didChangeAppLifecycleState(appLifecycleState);
    logger.w(appLifecycleState);

    switch (appLifecycleState) {
      case AppLifecycleState.resumed:
        checkStatus();
      default:
    }
  }

  Future<void> checkStatus() async {
    setState(() {
      loading = true;
    });

    notification = await widget.bgService.isNotificationPermissionGranted();
    batteryOptimization = !await widget.bgService
        .isBatteryOptimizationEnabled();
    accessibility = await _readAccessibilityStatus();
    _awaitingAccessibilityRefresh = false;
    isRunning = await widget.bgService.isServiceRunning();

    if (!accessibility) {
      // Accessibility is off — reset mode to inactive so user picks fresh when they enable it.
      _selectedMode = 'inactive';
      await widget.bgService.setDetectionMode('inactive');
    } else {
      final storedMode = await widget.bgService.readShared<String>(
        'detectionMode',
      );
      _selectedMode = _normalizeDetectionMode(storedMode);
      if (storedMode != null &&
          storedMode.isNotEmpty &&
          storedMode != _selectedMode) {
        await widget.bgService.setDetectionMode(_selectedMode);
      }
    }

    if (!mounted) return;

    setState(() {
      if (!accessibility || _selectedMode == 'inactive') {
        _detectionStatusState = 'inactive';
        _detectionStatusOutcome = 'none';
      }
      loading = false;
    });

    _applyLatestDetectionStatus();
  }

  Future<bool> _readAccessibilityStatus() async {
    var granted = await widget.bgService.isAccessibilityPermissionGranted();
    if (granted || !_awaitingAccessibilityRefresh) {
      return granted;
    }

    for (var attempt = 0; attempt < 6; attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      granted = await widget.bgService.isAccessibilityPermissionGranted();
      if (granted) {
        return true;
      }
    }

    return false;
  }

  (String, String) _statusForMode(String mode) {
    return switch (mode) {
      'inactive' => ('inactive', 'none'),
      'mode_1_ack_text' => ('starting', 'pending'),
      'mode_2_aggressive' => ('running_aggressive', 'none'),
      _ => ('inactive', 'none'),
    };
  }

  void _setDisplayedDetectionStatus(String state, String outcome) {
    if (!mounted) return;
    if (state == _detectionStatusState && outcome == _detectionStatusOutcome) {
      return;
    }

    setState(() {
      _detectionStatusState = state;
      _detectionStatusOutcome = outcome;
    });
  }

  void _applyLatestDetectionStatus() {
    if (!accessibility || _selectedMode == 'inactive') {
      _setDisplayedDetectionStatus('inactive', 'none');
      return;
    }

    final payload = _latestDetectionStatusPayload;
    if (payload == null) {
      return;
    }

    final state = (payload['state'] ?? 'inactive').trim();
    final outcome = (payload['outcome'] ?? 'none').trim();
    _setDisplayedDetectionStatus(state, outcome);
  }

  void _subscribeToDetectionStatus() {
    _detectionStatusSubscription?.cancel();
    _detectionStatusSubscription = widget.bgService
        .detectionStatusStream()
        .listen((payload) {
          if (!mounted) return;

          _latestDetectionStatusPayload = {
            'state': (payload['state'] ?? 'inactive').trim(),
            'outcome': (payload['outcome'] ?? 'none').trim(),
          };
          _applyLatestDetectionStatus();
        });
  }

  Future<void> openNotificationSetting() async {
    await widget.bgService.requestNotificationPermission();
  }

  Future<void> openBatteryOptimizationSetting() async {
    await widget.bgService.requestUnrestrictedBatteryAccess();
  }

  Future<void> openAccessibilitySetting() async {
    if (!accessibility) {
      final agree = await const AccessibilityServiceNotice().show(context);

      if (!agree) {
        return;
      }
    }

    _awaitingAccessibilityRefresh = true;
    await widget.bgService.openAccessibilityService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> setupConfiguration() async {
    InAppNotificationService.i.notify(
      NotificationMessage(
        id: "bg_setup",
        body: context.locale.abc__ack__preparing,
      ),
    );
    setState(() {
      writingConfig = true;
    });
    try {
      final enc1Decrypt = await appConfigCubit.decryptEnc2(enc1Key);
      final useEncryptionNonce = appConfigCubit.state.config.useEncryptionNonce;
      final syncSpeed = appConfigCubit.state.config.syncSpeed.name;
      final syncInterval = monetizationCubit.active?.syncInterval ?? 45;
      final tkn = monetizationCubit.active?.tkn;
      if (tkn != null) {
        await widget.bgService.writeShared(
          "sharedAccessKey",
          tkn,
          secure: true,
        );
      }
      await widget.bgService.writeShared("syncEnabled", true);
      await widget.bgService.writeShared(
        "autoWriteOnReceive",
        appConfigCubit.state.config.autoWriteOnReceive,
      );
      await widget.bgService.writeShared(
        "dontCopyOver",
        appConfigCubit.state.config.dontCopyOver,
      );
      await widget.bgService.writeShared("syncSpeed", syncSpeed);
      await widget.bgService.writeShared("syncInterval", syncInterval);
      await widget.bgService.writeShared("deviceId", widget.deviceId);
      await widget.bgService.writeShared("showAckToast", true);
      await widget.bgService.writeShared("serviceEnabled", true);
      await widget.bgService.writeShared(
        "useEncryptionNonce",
        useEncryptionNonce,
      );
      await widget.bgService.writeShared(
        "projectKey",
        sl<String>(instanceName: "supabase_project_key"),
        secure: true,
      );
      if (enc1Decrypt != null) {
        await widget.bgService.writeShared(
          "e2e_key",
          enc1Decrypt,
          secure: true,
        );
      }
      await widget.bgService.writeShared(
        "projectApiKey",
        sl<String>(instanceName: "supabase_key"),
        secure: true,
      );
      await wait(1000);
      if (!mounted) return;

      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "bg_setup_success",
          body: context.locale.abc__ack__ready,
        ),
      );
    } catch (e) {
      logger.e(e);
    } finally {
      InAppNotificationService.i.dismiss("bg_setup");
    }
    setState(() {
      writingConfig = false;
    });
  }

  Future<void> _onModeChanged(String? newMode) async {
    if (newMode == null) return;

    final normalizedMode = _normalizeDetectionMode(newMode);
    if (normalizedMode == _selectedMode) {
      return;
    }

    final previousMode = _selectedMode;
    final previousStatusState = _detectionStatusState;
    final previousStatusOutcome = _detectionStatusOutcome;
    final nextStatus = _statusForMode(normalizedMode);

    setState(() {
      _selectedMode = normalizedMode;
      _detectionStatusState = nextStatus.$1;
      _detectionStatusOutcome = nextStatus.$2;
    });

    try {
      await widget.bgService.setDetectionMode(normalizedMode);
      if (normalizedMode == 'inactive') {
        setState(() {
          _detectionStatusState = 'inactive';
          _detectionStatusOutcome = 'none';
        });
      }

      if (!mounted) return;

      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "detection_mode_updated",
          body: normalizedMode == 'inactive'
              ? context.locale.abc__ack__detection_mode_cleared
              : context.locale.abc__ack__detection_mode_updated,
        ),
      );
    } catch (e) {
      logger.e("Failed to update detection mode: $e");
      if (!mounted) return;

      setState(() {
        _selectedMode = previousMode;
        _detectionStatusState = previousStatusState;
        _detectionStatusOutcome = previousStatusOutcome;
      });

      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "detection_mode_update_failed",
          body: context.locale.abc__ack__detection_mode_update_failed(
            message: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = context.theme.brightness == Brightness.light;
    final textTheme = context.textTheme;
    final colors = context.colors;
    final canChooseMode = accessibility && !writingConfig;
    final checked = const Icon(Icons.check).msp;
    final unchecked = const Icon(Icons.close).msp;

    final child = ListView(
      children: [
        TipTile(
          title: context.locale.abc__tip__why_title,
          tip: context.locale.abc__tip__why_subtitle,
        ),
        TipTile(
          icon: const Icon(Icons.warning, color: Colors.amber),
          bg: Colors.red.darker(50, isLight),
          title: context.locale.abc__tip__support_title,
          tip: context.locale.abc__tip__support_subtitle,
        ),
        height5,
        SettingHeader(name: context.locale.abc__heading__req_perm),
        SwitchListTile(
          title: Text(context.locale.abc__tile__notification_title),
          subtitle: Text(context.locale.abc__tile__notification_subtitle),
          value: notification,
          enableFeedback: true,
          thumbIcon: notification ? checked : unchecked,
          onChanged: writingConfig ? null : (_) => openNotificationSetting(),
        ),
        SwitchListTile(
          title: Text(context.locale.abc__tile__battery_opt_title),
          subtitle: Text(context.locale.abc__tile__battery_opt_subtitle),
          value: batteryOptimization,
          enableFeedback: true,
          thumbIcon: batteryOptimization ? checked : unchecked,
          onChanged: writingConfig || !notification
              ? null
              : (_) => openBatteryOptimizationSetting(),
        ),
        SwitchListTile(
          title: Text(context.locale.abc__tile__acc_title),
          subtitle: Text(context.locale.abc__tile__acc_subtitle),
          value: accessibility,
          enableFeedback: true,
          thumbIcon: accessibility ? checked : unchecked,
          onChanged: writingConfig || !notification || !batteryOptimization
              ? null
              : (_) => openAccessibilitySetting(),
        ),
        height5,
        ListTile(
          title: const Text("Detection Mode"),
          subtitle: Text(
            accessibility
                ? "Choose how CopyCat detects copy actions in other apps. "
                      "CopyCat stays inactive until you pick a mode."
                : "Enable accessibility service first, then choose a detection mode.",
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          trailing: SettingsMenuDropdown<String>(
            value: _normalizeDetectionMode(_selectedMode),
            maxWidth: 220,
            items: _detectionModes
                .map(
                  (mode) => SettingsDropdownItem(
                    value: mode.$1,
                    enabled: accessibility || mode.$1 == 'inactive',
                  ),
                )
                .toList(),
            itemBuilder: (context, value) {
              final label = _detectionModes
                  .firstWhere((mode) => mode.$1 == value)
                  .$2;
              return (leading: null, child: Text(label), trailing: null);
            },
            onSelected: canChooseMode ? _onModeChanged : null,
          ),
        ),
        height5,
        DetectionStatusCard(
          state: _detectionStatusState,
          outcome: _detectionStatusOutcome,
        ),
        height5,
        AutoWriteOnReceiveSwitchTile(
          enabled: !writingConfig && isRunning && accessibility,
          onChanged: (val) async {
            await widget.bgService.writeShared("autoWriteOnReceive", val);
          },
        ),
        height5,
        const SettingHeader(name: 'Network'),
        LanInstantSyncSwitchTile(serviceActive: isRunning && accessibility),
      ],
    );

    return PopScope(
      canPop: !writingConfig,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.locale.abc_title),
          scrolledUnderElevation: 0.0,
          backgroundColor: context.colors.surface,
        ),
        body: loading ? IgnorePointer(child: child) : child,
      ),
    );
  }
}
