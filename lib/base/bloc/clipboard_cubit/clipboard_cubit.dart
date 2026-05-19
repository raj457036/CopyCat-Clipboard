import 'dart:async';
import 'dart:collection';

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

@Injectable(cache: true)
class ClipboardCubit extends Cubit<ClipboardState> {
  final SyncEventBus syncEventBus;
  final ClipboardRepository repo;
  final AppConfigCubit _appConfigCubit;
  late StreamSubscription eventBusSubscription;
  bool _isFetching = false;
  final List<ClipboardItem> _items = [];

  List<ClipboardItem> get items => UnmodifiableListView(_items);

  ClipboardCubit(
    this.syncEventBus,
    @Named("local") this.repo,
    this._appConfigCubit,
  ) : super(
        ClipboardState.loaded(
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

  void setBackgrounded(bool isBackgrounded) {
    if (isBackgrounded) {
      _items.clear();
      emit(
        state.copyWith(offset: 0, hasMore: true, revision: state.revision + 1),
      );
      return;
    }
    refresh();
  }

  /// Refresh the current list of clipboard items.
  void refresh() {
    if (state.loading) return;
    fetch(fromTop: true);
  }

  /// Update the active search query and refresh results from the top.
  Future<void> search(String query) => fetch(query: query, fromTop: true);

  /// Apply a new filter state and refresh results from the top.
  Future<void> applyFilters(SearchFilterState filters) =>
      fetch(filterState: filters, fromTop: true);

  /// Filter clips to those belonging to the given collection, or show all if null.
  Future<void> filterByCollection(int? id) {
    final current = state.filterState;
    return fetch(
      filterState: SearchFilterState(
        from: current.from,
        to: current.to,
        typeIncludes: current.typeIncludes,
        textCategories: current.textCategories,
        sortBy: current.sortBy,
        sortOrder: current.sortOrder,
        collectionId: id,
      ),
      fromTop: true,
    );
  }

  /// Clear both the query and all active filters.
  Future<void> clearSearch() => fetch(
    query: '',
    filterState: SearchFilterState(
      sortBy: _appConfigCubit.state.config.sortBy,
      sortOrder: _appConfigCubit.state.config.sortOrder,
    ),
    fromTop: true,
  );

  void onBatchSyncEvent(List<ClipCrossSyncEvent> events) {
    if (events.isEmpty) return;

    final deleted = <ClipboardItem>[];
    final created = <ClipboardItem>[];
    final updated = <ClipboardItem>[];

    final hasSearch = state.query.isNotEmpty;
    final filter = state.filterState;

    // Single pass: classify each event into deleted / created / updated.
    for (final event in events) {
      final (type, item) = event;
      if (type == CrossSyncEventType.delete || item.deletedAt != null) {
        deleted.add(item);
        continue;
      }
      if (hasSearch) continue; // create/update processing skipped under search
      if (type == CrossSyncEventType.create && filter.matchedByFilter(item)) {
        created.add(item);
      } else if (type == CrossSyncEventType.update &&
          filter.matchedByFilter(item)) {
        updated.add(item);
      }
    }

    if (deleted.isNotEmpty) {
      deleteItem(deleted);
      fetch(limit: deleted.length);
    }

    if (created.isNotEmpty) {
      _items.insertAll(0, created);
      emit(state.copyWith(revision: state.revision + 1));
    }

    if (updated.isNotEmpty) {
      final updateMap = {for (final e in updated) e.id: e};
      for (var i = 0; i < _items.length; i++) {
        final current = _items[i];
        final replacement = updateMap[current.id];
        if (replacement != null) _items[i] = replacement;
      }
      final sorted = _applySort(_items);
      _items
        ..clear()
        ..addAll(sorted);
      emit(state.copyWith(revision: state.revision + 1));
    }
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

    if (state.query.isNotEmpty) return;
    final filter = state.filterState;
    if (filter.matchedByFilter(item)) {
      // put(item, isNew: type == CrossSyncEventType.create);
      refresh();
    }
  }

  void reset() {
    _isFetching = false;
    _items.clear();
    emit(const ClipboardState.loaded(loading: false));
  }

  void put(ClipboardItem item, {bool isNew = false}) {
    if (isNew) {
      _items.insert(0, item);
    } else {
      final updated = _items.replaceWhere((it) => it.id == item.id, item);
      _items
        ..clear()
        ..addAll(updated);
    }
    final sortedItems = _applySort(_items);
    _items
      ..clear()
      ..addAll(sortedItems);
    emit(state.copyWith(revision: state.revision + 1));
  }

  List<ClipboardItem> _applySort(List<ClipboardItem> items) {
    final sorted = List<ClipboardItem>.from(items);
    final sortBy = state.filterState.sortBy ?? ClipboardSortKey.modified;
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
    if (_items.length <= 50) {
      fetch(fromTop: true);
      return true;
    }
    return false;
  }

  void resetFilters() => clearSearch();

  Future<void> fetch({
    bool fromTop = false,
    String? query,
    SearchFilterState? filterState,
    int? limit,
  }) async {
    if (_isFetching) return;
    if (!fromTop && !state.hasMore) return;

    _isFetching = true;

    final resolvedQuery = query ?? state.query;

    /// Use provided filterState if available, otherwise preserve current filters.
    /// This ensures filters are only reset when explicitly cleared via clearSearch().
    final resolvedFilter = filterState ?? state.filterState;

    try {
      emit(
        state.copyWith(
          loading: true,
          query: resolvedQuery,
          offset: fromTop ? 0 : state.offset,
          filterState: resolvedFilter,
          limit: limit ?? 50,
        ),
      );

      final items = await repo.getList(
        limit: state.limit,
        offset: fromTop ? 0 : state.offset,
        search: resolvedQuery.isEmpty ? null : resolvedQuery,
        types: state.filterState.typeIncludes,
        category: state.filterState.textCategories,
        from: state.filterState.from,
        to: state.filterState.to,
        order: state.filterState.sortOrder ?? SortOrder.desc,
        sortBy: state.filterState.sortBy,
        collectionId: state.filterState.collectionId,
      );

      emit(
        items.fold((l) => state.copyWith(failure: l, loading: false), (r) {
          if (fromTop) {
            _items
              ..clear()
              ..addAll(r.results);
          } else {
            _items.addAll(r.results);
          }
          return state.copyWith(
            loading: false,
            offset: fromTop
                ? r.results.length
                : state.offset + r.results.length,
            limit: state.limit,
            hasMore: r.hasMore,
            revision: state.revision + 1,
          );
        }),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> deleteItem(List<ClipboardItem> items) async {
    final ids = items.map((item) => item.id).whereType<int>().toSet();
    final serverIds = items
        .map((item) => item.serverId)
        .whereType<int>()
        .toSet();

    final before = _items.length;
    _items.removeWhere((it) {
      final isLocallyDeleted = it.id != null && ids.contains(it.id);
      final isRemotelyDeleted =
          it.serverId != null && serverIds.contains(it.serverId);
      return isLocallyDeleted || isRemotelyDeleted;
    });

    final isDeleted = _items.length < before;
    if (!isDeleted) return;

    emit(
      state.copyWith(
        offset: state.offset > 0 ? state.offset - 1 : 0,
        revision: state.revision + 1,
      ),
    );
  }

  @override
  Future<void> close() {
    eventBusSubscription.cancel();
    return super.close();
  }
}
