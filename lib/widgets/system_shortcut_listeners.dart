import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/data/services/quick_paste_service.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/paste_stack.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class SystemShortcutListener extends StatelessWidget {
  final Widget child;

  const SystemShortcutListener({super.key, required this.child});

  Future<void> toggleWindow(BuildContext context) async {
    final focusManager = WindowFocusManager.of(context);
    focusManager?.toggleWindow();
  }

  Future<void> showQuickPaste(BuildContext context) async {
    final quickPasteService = sl<QuickPasteService>();
    await quickPasteService.showQuickPastePopup();
  }

  Future<void> showPasteStack(BuildContext context) async {
    await togglePasteStack(context);
  }

  Future<void> _handleStateChange(
    BuildContext context,
    AppConfig config,
  ) async {
    final toggleHotKey = config.getToggleHotkey;
    final quickPasteHotKey = config.getQuickPasteHotkey;
    final pasteStackHotKey = config.getPasteStackHotkey;

    await hotKeyManager.unregisterAll();

    // Register toggle hotkey
    if (toggleHotKey != null) {
      await hotKeyManager.register(
        toggleHotKey,
        keyDownHandler: (hotKey_) async {
          if (toggleHotKey == hotKey_) toggleWindow(context);
        },
      );
    }

    // Register quick paste hotkey
    if (quickPasteHotKey != null) {
      await hotKeyManager.register(
        quickPasteHotKey,
        keyDownHandler: (hotKey_) async {
          if (quickPasteHotKey == hotKey_) showQuickPaste(context);
        },
      );
    }

    // Register paste stack hotkey
    if (pasteStackHotKey != null) {
      await hotKeyManager.register(
        pasteStackHotKey,
        keyDownHandler: (hotKey_) async {
          if (pasteStackHotKey == hotKey_) showPasteStack(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMobilePlatform) return child;

    _handleStateChange(context, sl<AppConfigCubit>().state.config);

    return BlocListener<AppConfigCubit, AppConfigState>(
      listenWhen: (previous, current) =>
          previous.config.toggleHotkey != current.config.toggleHotkey ||
          previous.config.quickPasteHotkey != current.config.quickPasteHotkey ||
          previous.config.pasteStackHotkey != current.config.pasteStackHotkey,
      listener: (context, state) async {
        await _handleStateChange(context, state.config);
      },
      child: child,
    );
  }
}
