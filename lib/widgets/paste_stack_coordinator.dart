import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:universal_io/io.dart';

class PasteStackCoordinator extends StatefulWidget {
  final Widget child;

  const PasteStackCoordinator({super.key, required this.child});

  @override
  State<PasteStackCoordinator> createState() => _PasteStackCoordinatorState();
}

class _PasteStackCoordinatorState extends State<PasteStackCoordinator> {
  late final HotKey pasteHotKey;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    pasteHotKey = HotKey(
      key: PhysicalKeyboardKey.keyV,
      modifiers: Platform.isMacOS
          ? [HotKeyModifier.meta]
          : [HotKeyModifier.control],
      scope: HotKeyScope.system,
    );
  }

  Future<void> registerPasteHotKey() async {
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) return;
    if (isRegistered) return;
    await hotKeyManager.register(
      pasteHotKey,
      keyDownHandler: (_) async => onPasteHotKey(),
    );
    isRegistered = true;
  }

  Future<void> unregisterPasteHotKey() async {
    if (!isRegistered) return;
    await hotKeyManager.unregister(pasteHotKey);
    isRegistered = false;
  }

  Future<void> onPasteHotKey() async {
    final context = rootNavKey.currentContext;
    if (context == null || !mounted) return;

    final pasteStack = context.read<PasteStackCubit>();
    final offlinePersistence = context.read<OfflinePersistenceCubit>();
    final windowAction = context.read<WindowActionCubit>();
    final focusManager = WindowFocusManager.of(context);

    await unregisterPasteHotKey();

    final item = pasteStack.state.currentItem;
    if (item == null) {
      await pasteStack.deactivate();
      return;
    }

    if (focusManager == null) return;

    final copied = await offlinePersistence.copyToClipboard(item);
    if (!copied) return;

    final isAppFocused = windowAction.isFocused;
    if (isAppFocused) {
      // windowAction.blur();
      await Future.delayed(Durations.short1);
    }
    await focusManager.pasteOnFocusedWindow();
    pasteStack.completeCurrentPaste();
    if (pasteStack.state.items.isEmpty) {
      await pasteStack.deactivate();
    } else {
      await registerPasteHotKey();
    }
  }

  @override
  void dispose() {
    unregisterPasteHotKey();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasteStackCubit, PasteStackState>(
      listenWhen: (previous, current) =>
          previous.active != current.active || previous.count < current.count,
      listener: (context, state) async {
        if (state.active) {
          rootNavKey.currentContext?.goNamed(RouteConstants.home);

          if (state.count > 0) {
            await registerPasteHotKey();
          } else {
            await unregisterPasteHotKey();
          }
        } else {
          await unregisterPasteHotKey();
        }
      },
      child: widget.child,
    );
  }
}
