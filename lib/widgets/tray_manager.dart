import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener, ReadContext;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:intl/intl.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:universal_io/io.dart';

class TrayManager extends StatefulWidget {
  final Widget child;
  const TrayManager({
    super.key,
    required this.child,
  });

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
  late final AppConfigCubit configCubit;
  bool paused = false;

  @override
  void initState() {
    configCubit = context.read<AppConfigCubit>();

    if (configCubit.state is AppConfigLoaded) {
      final config = (configCubit.state as AppConfigLoaded).config;
      paused = config.pausedTill != null && now().isBefore(config.pausedTill!);
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
    if (paused) {
      final config = (configCubit.state as AppConfigLoaded).config;
      final pausedTill =
          DateFormat("h:mm a").format(config.pausedTill!.toLocal());
      trayManager.setToolTip('CopyCat Clipboard - Paused till $pausedTill');
    } else {
      trayManager.setToolTip('CopyCat Clipboard');
    }
    initTray();
  }

  Future<void> initTray() async {
    await trayManager.setIcon(icon);
    Menu menu = Menu(
      items: [
        MenuItem(disabled: true, label: "CopyCat Clipboard"),
        MenuItem(
          key: 'pause_copycat',
          label: paused ? '▶️ Resume CopyCat' : '⏸️ Pause CopyCat',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'quit_app',
          label: 'Quit',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    final focusWindow = WindowFocusManager.of(context);
    await focusWindow?.toggleWindow();
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayIconRightMouseDown() async {
    trayManager.popUpContextMenu();
  }

  Future<void> quitApp() async {
    final result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: 'CopyCat Clipboard',
      text: 'Are you sure you want to quit?',
      positiveButtonTitle: "Yes",
      negativeButtonTitle: "No",
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
          final pauseTill = now().copyWith(hour: 23, minute: 59, second: 59);
          await configCubit.changePausedTill(pauseTill);
        }

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
            config.pausedTill != null && now().isBefore(config.pausedTill!);
        setPause(isPaused);
      },
      child: widget.child,
    );
  }
}
