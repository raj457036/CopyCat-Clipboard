import 'package:copycat_base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Set<LogicalKeyboardKey> _metaSynonyms = LogicalKeyboardKey.expandSynonyms(
    <LogicalKeyboardKey>{LogicalKeyboardKey.meta, LogicalKeyboardKey.control});

class PasteByClipIndexShortcutActivator implements ShortcutActivator {
  void Function(int index)? onAccept;

  bool _shouldAcceptMetaModifiers(Set<LogicalKeyboardKey> pressed) {
    return pressed.intersection(_metaSynonyms).isNotEmpty;
  }

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) {
    final accepted = (event is KeyDownEvent || (event is! KeyRepeatEvent)) &&
        triggers.contains(event.logicalKey) &&
        _shouldAcceptMetaModifiers(state.logicalKeysPressed);

    if (accepted) {
      final num_ = int.parse(event.logicalKey.keyLabel);
      onAccept?.call(num_);
    }
    return accepted;
  }

  @override
  String debugDescribeKeys() {
    return 'Paste by clip index shortcut';
  }

  @override
  List<LogicalKeyboardKey> get triggers => [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.digit4,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.digit6,
        LogicalKeyboardKey.digit7,
        LogicalKeyboardKey.digit8,
        LogicalKeyboardKey.digit9,
      ];
}

// ignore: must_be_immutable
class PasteByClipIndexIntent extends Intent {
  int tappedIndex = -1;

  final PasteByClipIndexShortcutActivator activator;
  static final PasteByClipIndexIntent _instance = PasteByClipIndexIntent();

  static PasteByClipIndexIntent get i => _instance;

  PasteByClipIndexIntent() : activator = PasteByClipIndexShortcutActivator() {
    activator.onAccept = onAccept;
  }

  void onAccept(int index) {
    tappedIndex = index;
  }
}

class PasteByClipIndexAction extends ContextAction<PasteByClipIndexIntent> {
  @override
  Object? invoke(PasteByClipIndexIntent intent, [BuildContext? context]) {
    final eventBus = context?.read<EventBusCubit>();
    if (eventBus == null) return null;
    eventBus.indexPaste(intent.tappedIndex);
    return null;
  }
}
