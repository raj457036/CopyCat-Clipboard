import 'dart:async';
import 'dart:math' show max;

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/logging.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:clipboard/utils/debounce.dart' show Debouncer;
import 'package:injectable/injectable.dart';

@immutable
class PasteStackState extends Equatable {
  final List<ClipboardItem> items;

  const PasteStackState({required this.items});

  const PasteStackState.inactive() : this(items: const []);

  @override
  List<Object?> get props => [items];

  ClipboardItem? get currentItem => items.firstOrNull;
  ClipboardItem? get nextItem => items.length > 1 ? items[1] : null;
  int get count => items.length;

  PasteStackState copyWith({List<ClipboardItem>? items}) {
    return PasteStackState(items: items ?? this.items);
  }
}

@Injectable(cache: true)
class PasteStackCubit extends Cubit<PasteStackState> {
  final debouncer = Debouncer(milliseconds: 200);
  final AppConfigCubit appConfig;
  final WindowActionCubit windowAction;
  final MonetizationCubit monetizationCubit;
  final OfflinePersistenceCubit offlinePersistenceCubit;

  AppView? _previousView;
  Size? _previousWindowSize;

  StreamSubscription? _offlinePersistenceSub;

  PasteStackCubit(
    this.appConfig,
    this.windowAction,
    this.monetizationCubit,
    this.offlinePersistenceCubit,
  ) : super(const PasteStackState.inactive()) {
    _offlinePersistenceSub = offlinePersistenceCubit.newClipboardItemStream
        .listen((item) => pushItems([item]));
  }

  int get maxItemCountAllowed => monetizationCubit.state.when(
    unknown: () => defaultPasteStackLimit,
    active: (subscription) =>
        max(defaultMaxPasteStackLimit, subscription.pasteStackLimit),
  );

  void reverseStack() =>
      emit(state.copyWith(items: state.items.reversed.toList()));

  void reorderItem(int oldIndex, int newIndex) {
    final items = List<ClipboardItem>.from(state.items);
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
    emit(const PasteStackState(items: []));
    if (_previousView == AppView.windowed) {
      await windowAction.showPasteStackView();
    } else {
      await windowAction.show();
      await windowAction.focus();
    }
  }

  Future<void> deactivate() async {
    final view = _previousView;
    final size = _previousWindowSize;

    windowAction.clearPasteStackBackgroundToggleMode();
    _clearSnapshot();

    if (view == AppView.windowed) {
      await windowAction.changeView(view!, size);
    }

    if (view != null) {
      await windowAction.focus();
    }

    final isPinned = appConfig.state.config.pinned;
    await windowAction.alwaysOnTop(isPinned);
  }

  void _snapshotCurrentState() {
    final config = appConfig.state.config;
    _previousView ??= config.view;
    _previousWindowSize ??= config.windowSize;
  }

  void _clearSnapshot() {
    _previousView = null;
    _previousWindowSize = null;
    emit(const PasteStackState.inactive());
  }

  /// Pushes new items to the paste stack. If the stack exceeds the maximum allowed
  /// items, the excess items will be discarded and not added to the stack.
  void pushItems(List<ClipboardItem> items) {
    if (items.isEmpty) return;

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
    if (state.items.isEmpty) return;
    emit(state.copyWith(items: state.items.skip(1).toList(growable: false)));
  }

  @override
  Future<void> close() {
    _offlinePersistenceSub?.cancel();
    return super.close();
  }
}
