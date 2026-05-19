import 'dart:async';

import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/routes/routes.dart' show rootNavigationKey;
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:universal_io/io.dart';

class PasteStackCoordinator extends StatefulWidget {
  final BlocWidgetBuilder<PasteStackState> builder;
  final List<ClipboardItem>? initialItems;

  const PasteStackCoordinator({
    super.key,
    required this.builder,
    required this.initialItems,
  });

  @override
  State<PasteStackCoordinator> createState() => _PasteStackCoordinatorState();
}

class _PasteStackCoordinatorState extends State<PasteStackCoordinator> {
  late final HotKey pasteHotKey;
  late final PasteStackCubit pasteStack;
  late final OfflinePersistenceCubit offlinePersistence;

  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    pasteStack = context.read<PasteStackCubit>();
    offlinePersistence = context.read<OfflinePersistenceCubit>();
    unawaited(pasteStack.activate());
    pasteStack.pushItems(widget.initialItems ?? const []);
    pasteHotKey = HotKey(
      key: PhysicalKeyboardKey.keyV,
      modifiers: Platform.isMacOS
          ? [HotKeyModifier.meta]
          : [HotKeyModifier.control],
      scope: HotKeyScope.system,
    );

    registerPasteHotKey();
  }

  Future<void> registerPasteHotKey() async {
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) return;
    if (isRegistered) return;

    await hotKeyManager.register(
      pasteHotKey,
      keyDownHandler: (_) => runWhileHotKeyUnregistered(onPasteHotKey),
    );
    isRegistered = true;
  }

  Future<void> unregisterPasteHotKey() async {
    await hotKeyManager.unregister(pasteHotKey);
    isRegistered = false;
  }

  Future<void> runWhileHotKeyUnregistered(
    Future<void> Function() action,
  ) async {
    await unregisterPasteHotKey();
    await action();
    if (pasteStack.state.items.isEmpty) return;
    await registerPasteHotKey();
  }

  Future<void> onPasteHotKey() async {
    final context = rootNavigationKey.currentContext;

    if (context == null || !mounted) return;
    final focusManager = WindowFocusManager.of(context);
    final windowAction = context.read<WindowActionCubit>();

    final item = pasteStack.state.currentItem;

    if (item == null) return;
    if (focusManager == null) return;

    final copied = await focusManager.widget.clipboardService
        .runWithCaptureSuppressed(
          () => offlinePersistence.copyToClipboard([item]),
        );
    if (!copied) return;

    final isAppFocused = windowAction.isFocused;
    if (isAppFocused) {
      // windowAction.blur();
      await Future.delayed(Durations.short1);
    }
    await focusManager.pasteOnFocusedWindow();
    pasteStack.completeCurrentPaste();
  }

  @override
  void dispose() {
    unregisterPasteHotKey();
    pasteStack.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasteStackCubit, PasteStackState>(
      listenWhen: (previous, current) => current.count > previous.count,
      listener: (context, state) async {
        await registerPasteHotKey();
      },
      buildWhen: (previous, current) => previous.count != current.count,
      builder: widget.builder,
    );
  }
}
