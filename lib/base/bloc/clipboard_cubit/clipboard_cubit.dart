import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/search_filter_state.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart'
    show ClipboardSortKey;
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:injectable/injectable.dart';

part 'clipboard_cubit.freezed.dart';
part 'clipboard_state.dart';

@injectable
class ClipboardCubit extends Cubit<ClipboardState> {
  final SyncEventBus syncEventBus;
  final ClipboardRepository repo;
  final AppConfigCubit _appConfigCubit;
  String? currentQuery;
  late StreamSubscription eventBusSubscription;

  ClipboardCubit(
    this.syncEventBus,
    @Named("local") this.repo,
    this._appConfigCubit,
  ) : super(
        ClipboardState.loaded(
          items: [],
          filterState: SearchFilterState(
            sortBy: _appConfigCubit.state.config.sortBy,
            sortOrder: _appConfigCubit.state.config.sortOrder,
          ),
        ),
      ) {
    eventBusSubscription = syncEventBus.where<ClipboardItem>().listen((event) {
      if (event is TypedSyncEvent<ClipboardItem>) {
        onSyncEvent(event.event);
      } else if (event is TypedSyncBatchEvent<ClipboardItem>) {
        onBatchSyncEvent(event.events);
      }
    });
  }

  void refresh() {
    if (state.loading) return;
    emit(state.copyWith(loading: true, offset: 0));
    fetch(fromTop: true, filterState: state.filterState, query: currentQuery);
  }

  void onBatchSyncEvent(List<ClipCrossSyncEvent> events) {
    if (events.isEmpty) return;
    // Deleted (Treat both true DELETE events and UPDATEs with deletedAt as deletions)
    final deleted = events
        .where((event) {
          final (type, item) = event;
          return type == CrossSyncEventType.delete || item.deletedAt != null;
        })
        .map((event) => event.$2)
        .toList();

    if (deleted.isNotEmpty) {
      deleteItem(deleted);
      fetch(limit: deleted.length);
    }

    if (currentQuery != null && currentQuery!.isNotEmpty) return;
    final filter = state.filterState;

    // Filter out items that are marked as deleted from the rest of the processing
    final activeEvents = events.where((e) => e.$2.deletedAt == null).toList();

    // Created
    final created = activeEvents
        .where((event) {
          final (type, item) = event;
          return type == CrossSyncEventType.create &&
              filter.matchedByFilter(item);
        })
        .map((event) => event.$2)
        .toList();
    if (created.isNotEmpty) {
      emit(state.copyWith(items: [...created, ...state.items]));
    }

    // Updates
    final updated = activeEvents
        .where((event) {
          final (type, item) = event;
          return type == CrossSyncEventType.update &&
              filter.matchedByFilter(item);
        })
        .map((event) => event.$2)
        .toList();
    if (updated.isEmpty) return;
    final updateIndexMap = <int, int>{};
    for (var i = 0; i < updated.length; i++) {
      final item = updated[i];
      updateIndexMap[item.id!] = i;
    }

    final replaced = <ClipboardItem>[];
    for (var i = 0; i < state.items.length; i++) {
      final item = state.items[i];
      final found = updateIndexMap[item.id];
      if (found != null) {
        replaced.add(updated[found]);
      } else {
        replaced.add(item);
      }
    }

    final sortedItems = _applySort(replaced);
    emit(state.copyWith(items: sortedItems));
  }

  void onSyncEvent(ClipCrossSyncEvent event) {
    final (type, item) = event;
    // deleted
    if (item.deletedAt != null || type == CrossSyncEventType.delete) {
      deleteItem([item]);
      return;
    }

    if (type == CrossSyncEventType.update) {
      put(item);
      return;
    }

    if (currentQuery != null && currentQuery!.isNotEmpty) return;
    final filter = state.filterState;
    if (filter.matchedByFilter(item)) {
      // put(item, isNew: type == CrossSyncEventType.create);
      refresh();
    }
  }

  void reset() => emit(const ClipboardState.loaded(items: []));

  void put(ClipboardItem item, {bool isNew = false}) {
    if (isNew) {
      final items = [item, ...state.items];
      final sortedItems = _applySort(items);
      emit(state.copyWith(items: sortedItems));
    } else {
      final items = state.items.replaceWhere((it) => it.id == item.id, item);
      final sortedItems = _applySort(items);
      emit(state.copyWith(items: sortedItems));
    }
  }

  List<ClipboardItem> _applySort(List<ClipboardItem> items) {
    final sorted = List<ClipboardItem>.from(items);
    final sortBy = state.filterState.sortBy ?? ClipboardSortKey.created;
    final order = state.filterState.sortOrder ?? SortOrder.desc;

    sorted.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case ClipboardSortKey.created:
          comparison = a.created.compareTo(b.created);
        case ClipboardSortKey.modified:
          comparison = a.modified.compareTo(b.modified);
        case ClipboardSortKey.lastCopied:
          comparison = (a.lastCopied ?? a.created).compareTo(
            b.lastCopied ?? b.created,
          );
        case ClipboardSortKey.copyCount:
          comparison = a.copiedCount.compareTo(b.copiedCount);
      }
      return order == SortOrder.desc ? -comparison : comparison;
    });
    return sorted;
  }

  bool fetchIfInitBatch() {
    if (state.items.length <= 50) {
      fetch(fromTop: true);
      return true;
    }
    return false;
  }

  void resetFilters() {
    emit(
      state.copyWith(
        filterState: SearchFilterState(
          sortBy: _appConfigCubit.state.config.sortBy,
          sortOrder: _appConfigCubit.state.config.sortOrder,
        ),
      ),
    );
    refresh();
  }

  Future<void> fetch({
    bool fromTop = false,
    String? query,
    SearchFilterState? filterState,
    int? limit,
  }) async {
    currentQuery = query;
    emit(
      state.copyWith(
        loading: true,
        offset: fromTop ? 0 : state.offset,
        filterState: fromTop
            ? filterState ??
                  SearchFilterState(
                    sortBy: _appConfigCubit.state.config.sortBy,
                    sortOrder: _appConfigCubit.state.config.sortOrder,
                  )
            : state.filterState,
        limit: limit ?? 50,
      ),
    );

    final items = await repo.getList(
      limit: state.limit,
      offset: fromTop ? 0 : state.offset,
      search: query,
      types: state.filterState.typeIncludes,
      category: state.filterState.textCategories,
      from: state.filterState.from,
      to: state.filterState.to,
      order: state.filterState.sortOrder ?? SortOrder.desc,
      sortBy: state.filterState.sortBy,
    );

    emit(
      items.fold(
        (l) => state.copyWith(failure: l, loading: false),
        (r) => state.copyWith(
          loading: false,
          items: fromTop ? r.results : [...state.items, ...r.results],
          offset: state.offset + r.results.length,
          limit: state.limit,
          hasMore: r.hasMore,
        ),
      ),
    );
  }

  Future<void> deleteItem(List<ClipboardItem> items) async {
    state.mapOrNull(
      loaded: (result) {
        final ids = items.map((item) => item.id).whereType<int>().toSet();
        final serverIds = items
            .map((item) => item.serverId)
            .whereType<int>()
            .toSet();

        final items_ = result.items.where((it) {
          final isLocallyDeleted = it.id != null && ids.contains(it.id);
          final isRemotelyDeleted =
              it.serverId != null && serverIds.contains(it.serverId);
          return !isLocallyDeleted && !isRemotelyDeleted;
        }).toList();

        final isDeleted = items_.length < result.items.length;
        emit(
          result.copyWith(
            items: items_,
            offset: isDeleted ? result.offset - 1 : result.offset,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    eventBusSubscription.cancel();
    return super.close();
  }
}
