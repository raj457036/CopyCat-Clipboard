import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/settings/pages/android_bg_clipboard/accessibility_service_notice.dart';
import 'package:clipboard/pages/settings/pages/android_bg_clipboard/draw_over_other_app_notice.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/widgets/pro_tip_banner.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/bloc/auth_cubit/auth_cubit.dart';
import 'package:copycat_base/common/logging.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/color_extension.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:copycat_pro/bloc/monetization_cubit/monetization_cubit.dart';
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
  bool overlay = false;
  bool batteryOptimization = false;
  bool accessibility = false;
  bool strictCheck = true;
  bool enable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    monetizationCubit = context.read();
    appConfigCubit = context.read();

    context.read<AuthCubit>().state.whenOrNull(
      authenticated: (user, _) {
        enc1Key = user.enc1;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.bgService.initStorage();
      await checkStatus();
      await setupConfiguration();
    });
  }

  @override
  void dispose() {
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
    overlay = await widget.bgService.isOverlayPermissionGranted();
    batteryOptimization =
        !await widget.bgService.isBatteryOptimizationEnabled();
    accessibility = await widget.bgService.isAccessibilityPermissionGranted();
    isRunning = await widget.bgService.isServiceRunning();
    strictCheck =
        await widget.bgService.readShared<bool>("strictCheck") ?? true;

    setState(() {
      loading = false;
    });
  }

  Future<void> openNotificationSetting() async {
    await widget.bgService.requestNotificationPermission();
  }

  Future<void> openOverlaySetting() async {
    if (!overlay) {
      final agree = await const DrawOverOtherAppNotice().show(context);

      if (!agree) {
        return;
      }
    }
    await widget.bgService.requestOverlayPermission();
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

    await widget.bgService.openAccessibilityService();
  }

  Future<void> changeStrictCheck(bool value) async {
    final success =
        await widget.bgService.writeShared("strictCheck", strictCheck);

    if (!success) return;

    setState(() {
      strictCheck = value;
    });
  }

  Future<void> setupConfiguration() async {
    showTextSnackbar(context.locale.abc__ack__preparing, isLoading: true);
    setState(() {
      writingConfig = true;
    });
    try {
      final enc1Decrypt = appConfigCubit.state.config.decryptEnc2(enc1Key);
      final tkn = monetizationCubit.active?.tkn;
      if (tkn != null) {
        await widget.bgService
            .writeShared("sharedAccessKey", tkn, secure: true);
      }
      await widget.bgService.writeShared("syncEnabled", true);
      await widget.bgService.writeShared("deviceId", widget.deviceId);
      await widget.bgService.writeShared("showAckToast", true);
      await widget.bgService.writeShared("serviceEnabled", true);
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
      if (mounted) {
        showTextSnackbar(
          context.locale.abc__ack__ready,
          success: true,
          closePrevious: true,
        );
      }
    } catch (e) {
      logger.e(e);
      closeSnackbar();
    }
    setState(() {
      writingConfig = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = context.theme.brightness == Brightness.light;
    Widget child = const Center(
      child: CircularProgressIndicator(),
    );

    if (!loading) {
      final checked = const Icon(Icons.check).msp;
      final unchecked = const Icon(Icons.close).msp;

      child = ListView(
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
          SettingHeader(
            name: context.locale.abc__heading__req_perm,
          ),
          SwitchListTile(
            title: Text(
              context.locale.abc__tile__notification_title,
            ),
            subtitle: Text(
              context.locale.abc__tile__notification_subtitle,
            ),
            value: notification,
            enableFeedback: true,
            thumbIcon: notification ? checked : unchecked,
            onChanged: writingConfig ? null : (_) => openNotificationSetting(),
          ),
          SwitchListTile(
            title: Text(
              context.locale.abc__tile__battery_opt_title,
            ),
            subtitle: Text(
              context.locale.abc__tile__battery_opt_subtitle,
            ),
            value: batteryOptimization,
            enableFeedback: true,
            thumbIcon: batteryOptimization ? checked : unchecked,
            onChanged: writingConfig || !notification
                ? null
                : (_) => openBatteryOptimizationSetting(),
          ),
          SwitchListTile(
            title: Text(
              context.locale.abc__tile__overlay_title,
            ),
            subtitle: Text(
              context.locale.abc__tile__overlay_subtitle,
            ),
            value: overlay,
            enableFeedback: true,
            thumbIcon: overlay ? checked : unchecked,
            onChanged: writingConfig || !notification
                ? null
                : (_) => openOverlaySetting(),
          ),
          SwitchListTile(
            title: Text(
              context.locale.abc__tile__acc_title,
            ),
            subtitle: Text(
              context.locale.abc__tile__acc_subtitle,
            ),
            value: accessibility,
            enableFeedback: true,
            thumbIcon: accessibility ? checked : unchecked,
            onChanged: writingConfig ||
                    !notification ||
                    !overlay ||
                    !batteryOptimization
                ? null
                : (_) => openAccessibilitySetting(),
          ),
          height5,
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            initiallyExpanded: true,
            title:
                SettingHeader(name: context.locale.abc__other_setting__title),
            children: [
              SwitchListTile(
                title: Text(context.locale.abc__enhanced_clip_detection__title),
                subtitle:
                    Text(context.locale.abc__enhanced_clip_detection__subtitle),
                value: strictCheck,
                enableFeedback: true,
                thumbIcon: strictCheck ? checked : unchecked,
                onChanged: changeStrictCheck,
              ),
            ],
          ),
        ],
      );
    }

    return PopScope(
      canPop: !writingConfig,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.locale.abc_title),
        ),
        body: child,
      ),
    );
  }
}
