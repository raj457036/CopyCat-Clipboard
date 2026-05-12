import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/logging.dart';
import 'package:flutter/widgets.dart';
import 'package:clipboard/utils/debounce.dart' show Debouncer;
import 'package:injectable/injectable.dart';

@immutable
class PasteStackState {
  final bool active;
  final List<ClipboardItem> items;

  const PasteStackState({required this.active, required this.items});

  const PasteStackState.inactive() : this(active: false, items: const []);

  ClipboardItem? get currentItem => items.firstOrNull;
  ClipboardItem? get nextItem => items.length > 1 ? items[1] : null;
  int get count => items.length;

  PasteStackState copyWith({bool? active, List<ClipboardItem>? items}) {
    return PasteStackState(
      active: active ?? this.active,
      items: items ?? this.items,
    );
  }
}

@lazySingleton
class PasteStackCubit extends Cubit<PasteStackState> {
  static const Size stackWindowSize = Size(320, 720);

  final debouncer = Debouncer(milliseconds: 200);
  final AppConfigCubit appConfig;
  final WindowActionCubit windowAction;
  final MonetizationCubit monetizationCubit;

  AppView? _previousView;
  Size? _previousWindowSize;
  bool _previousPinnedState = false;

  PasteStackCubit(this.appConfig, this.windowAction, this.monetizationCubit)
    : super(const PasteStackState.inactive());

  bool get isActive => state.active;

  int get maxItemCountAllowed => monetizationCubit.state.when(
    unknown: () => 10,
    active: (subscription) => subscription.pasteStackLimit,
  );

  void reverseStack() =>
      emit(state.copyWith(items: state.items.reversed.toList()));

  void reorderItem(int oldIndex, int newIndex) {
    final items = List<ClipboardItem>.from(state.items);
    if (newIndex > oldIndex) newIndex--;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    emit(state.copyWith(items: items));
  }

  List<ClipboardItem> normalizeItems(List<ClipboardItem> items) {
    return items
        .where((item) => item.inCache && !item.encrypted)
        .toList(growable: false);
  }

  Future<void> activate() async {
    _snapshotCurrentState();
    emit(const PasteStackState(active: true, items: []));

    if (_previousView == AppView.windowed) {
      await windowAction.changeView(AppView.windowed, stackWindowSize);
    }

    await appConfig.setPinned(true);
    await windowAction.blur();
  }

  void _snapshotCurrentState() {
    final config = appConfig.state.config;
    _previousView ??= config.view;
    _previousWindowSize ??= config.windowSize;
    _previousPinnedState = config.pinned;
  }

  Future<void> deactivate() async {
    final view = _previousView;
    final size = _previousWindowSize;
    final pinned = _previousPinnedState;

    _clearSnapshot();

    if (view == AppView.windowed) {
      await windowAction.changeView(view!, size);
    }

    if (view != null) {
      await windowAction.focus();
    }

    await appConfig.setPinned(pinned);
  }

  /// Deactivates the paste stack without restoring focus to the clipboard app.
  /// Use this after a paste-all operation where the user intends to stay in
  /// the target application.
  Future<void> deactivateSilent() async {
    final view = _previousView;
    final size = _previousWindowSize;
    final pinned = _previousPinnedState;

    _clearSnapshot();

    if (view == AppView.windowed) {
      await windowAction.changeView(view!, size);
    }

    await appConfig.setPinned(pinned);
  }

  void _clearSnapshot() {
    _previousView = null;
    _previousWindowSize = null;
    emit(const PasteStackState.inactive());
  }

  /// Pushes new items to the paste stack. If the stack exceeds the maximum allowed
  /// items, the excess items will be discarded and not added to the stack.
  void pushItems(List<ClipboardItem> items) {
    if (!state.active || items.isEmpty) return;

    final normalized = normalizeItems(items);
    if (normalized.isEmpty) return;

    final currentCount = state.items.length;
    if (currentCount >= maxItemCountAllowed) return;
    final availableSlots = maxItemCountAllowed - currentCount;

    final toAdd = normalized.take(availableSlots).toList(growable: false);
    final combined = [...toAdd, ...state.items];

    if (toAdd.length < normalized.length) {
      // Some items were discarded due to overlimit
      logger.w(
        'Paste stack overlimit: ${normalized.length} items provided,'
        ' but only ${toAdd.length} were added.',
      );
    }

    emit(state.copyWith(items: combined));
  }

  void completeCurrentPaste() {
    if (!state.active || state.items.isEmpty) return;
    emit(state.copyWith(items: state.items.skip(1).toList(growable: false)));
  }
}
