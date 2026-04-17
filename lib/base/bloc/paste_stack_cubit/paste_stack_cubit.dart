import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/widgets.dart';
import 'package:clipboard/utils/debounce.dart' show Debouncer;

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

class PasteStackCubit extends Cubit<PasteStackState> {
  static const Size stackWindowSize = Size(320, 720);

  final debouncer = Debouncer(milliseconds: 200);
  final AppConfigCubit appConfig;
  final WindowActionCubit windowAction;

  AppView? _previousView;
  Size? _previousWindowSize;
  bool _previousPinnedState = false;

  PasteStackCubit(this.appConfig, this.windowAction)
    : super(const PasteStackState.inactive());

  bool get isActive => state.active;

  void reverseStack() =>
      emit(state.copyWith(items: state.items.reversed.toList()));

  List<ClipboardItem> normalizeItems(List<ClipboardItem> items) {
    return items
        .where((item) => item.inCache && !item.encrypted)
        .toList(growable: false);
  }

  Future<void> activate([List<ClipboardItem> items = const []]) async {
    final normalized = normalizeItems(items);

    _snapshotCurrentState();
    emit(PasteStackState(active: true, items: normalized));

    if (_previousView == AppView.windowed) {
      windowAction.changeView(AppView.windowed, stackWindowSize);
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

  Future<void> replaceFromSelection(List<ClipboardItem> items) async {
    final normalized = normalizeItems(items);

    if (!state.active) {
      await activate(normalized);
      return;
    }

    emit(state.copyWith(items: normalized));
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

  void _clearSnapshot() {
    _previousView = null;
    _previousWindowSize = null;
    emit(const PasteStackState.inactive());
  }

  Future<void> toggle() async {
    if (state.active) {
      await deactivate();
    } else {
      await activate();
    }
  }

  void ingestCapturedItems(List<ClipboardItem> items) {
    if (!state.active || items.isEmpty) return;

    final normalized = normalizeItems(items);
    if (normalized.isEmpty) return;

    emit(state.copyWith(items: [...normalized.reversed, ...state.items]));
  }

  void completeCurrentPaste() {
    if (!state.active || state.items.isEmpty) return;
    emit(state.copyWith(items: state.items.skip(1).toList(growable: false)));
  }
}
