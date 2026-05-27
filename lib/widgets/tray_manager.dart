import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/paste_stack.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener, ReadContext;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:intl/intl.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:universal_io/io.dart';

class TrayManager extends StatefulWidget {
  final Widget child;
  const TrayManager({super.key, required this.child});

  @override
  State<TrayManager> createState() => TrayManagerState();

  static Widget forPlatform({required Widget child}) {
    if (isMobilePlatform) {
      return child;
    }
    return TrayManager(child: child);
  }

  static TrayManagerState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<TrayManagerState>();
}

class TrayManagerState extends State<TrayManager> with TrayListener {
  late final Future<AppLocalizations> englishL10n;
  late final AppConfigCubit configCubit;
  bool paused = false;

  @override
  void initState() {
    englishL10n = lookupAppLocalizations(const Locale('en'));
    configCubit = context.read<AppConfigCubit>();

    if (configCubit.state is AppConfigLoaded) {
      final config = (configCubit.state as AppConfigLoaded).config;
      paused =
          config.pausedTill != null &&
          systemTime().isBefore(config.pausedTill!);
    }

    trayManager.addListener(this);
    super.initState();
    initTray();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  String get icon {
    if (paused) {
      return Platform.isWindows
          ? 'assets/images/icons/tray_icon_paused.ico'
          : 'assets/images/icons/tray_icon_paused.png';
    }
    return Platform.isWindows
        ? 'assets/images/icons/tray_icon.ico'
        : 'assets/images/icons/tray_icon.png';
  }

  void setPause(bool isPaused) {
    setState(() {
      paused = isPaused;
    });
    _setToolTip();
    initTray();
  }

  Future<void> _setToolTip() async {
    final locale = await englishL10n;
    if (paused) {
      final config = (configCubit.state as AppConfigLoaded).config;
      final pausedTill = DateFormat(
        'h:mm a',
      ).format(config.pausedTill!.toLocal());
      trayManager.setToolTip(
        locale.tray__tooltip__paused_till(time: pausedTill),
      );
      return;
    }
    trayManager.setToolTip(locale.app__name);
  }

  Future<void> initTray() async {
    final locale = await englishL10n;
    await trayManager.setIcon(icon);
    Menu menu = Menu(
      items: [
        MenuItem(key: "show_window", label: locale.app__name),
        MenuItem.checkbox(
          key: 'pause_copycat',
          label: paused
              ? locale.tray__menu__resume_copycat
              : locale.tray__menu__pause_copycat,
          checked: paused,
        ),
        MenuItem(key: 'paste_stack', label: "Paste Stack", disabled: paused),
        MenuItem.separator(),
        MenuItem(key: 'quit_app', label: locale.app__quit),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    final focusWindow = WindowFocusManager.of(context);
    await focusWindow?.toggleWindow();
  }

  @override
  Future<void> onTrayIconRightMouseDown() async {
    trayManager.popUpContextMenu();
  }

  Future<void> quitApp() async {
    final locale = await englishL10n;
    final result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: locale.app__name,
      text: locale.tray__dialog__quit__subtitle,
      positiveButtonTitle: locale.app__yes,
      negativeButtonTitle: locale.app__no,
    );

    if (result.name == "positiveButton") {
      await SystemNavigator.pop(animated: true);
      exit(0);
    }
  }

  @override
  Future<void> onTrayMenuItemClick(MenuItem menuItem) async {
    final windowAction = context.windowAction;
    switch (menuItem.key) {
      case "show_window":
        await windowAction?.show();

      case "pause_copycat":
        if (paused) {
          await configCubit.changePausedTill(null);
        } else {
          // pause till mid night
          final pauseTill = systemTime().copyWith(
            hour: 23,
            minute: 59,
            second: 59,
          );
          await configCubit.changePausedTill(pauseTill);
        }

      case "paste_stack":
        await togglePasteStack(context);

      case "quit_app":
        await quitApp();
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConfigCubit, AppConfigState>(
      listenWhen: (p, c) {
        if (p is AppConfigLoaded && c is AppConfigLoaded) {
          return p.config.pausedTill != c.config.pausedTill;
        }
        return false;
      },
      listener: (context, state) {
        final config = (state as AppConfigLoaded).config;
        final isPaused =
            config.pausedTill != null &&
            systemTime().isBefore(config.pausedTill!);
        setPause(isPaused);
      },
      child: widget.child,
    );
  }
}
