import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'collection_clips_cubit.freezed.dart';
part 'collection_clips_state.dart';

@injectable
class CollectionClipsCubit extends Cubit<CollectionClipsState> {
  final SyncEventBus syncEventBus;
  final ClipboardRepository repo;
  final ClipCollection collection;
  late StreamSubscription eventBusSubscription;

  String? currentQuery;

  CollectionClipsCubit(
    this.syncEventBus,
    @Named("local") this.repo, {
    @factoryParam required this.collection,
  }) : super(const CollectionClipsState.initial()) {
    eventBusSubscription = syncEventBus.where<ClipboardItem>().listen((event) {
      if (event is TypedSyncEvent<ClipboardItem>) {
        onSyncEvent(event.event);
      } else if (event is TypedSyncBatchEvent<ClipboardItem>) {
        onBatchSyncEvent(event.events);
      }
    });
  }

  Future<void> fetch([String? searchQuery, int? limit]) async {
    currentQuery = searchQuery;
    switch (state) {
      case InitialCollectionClipsState() || CollectionClipsErrorState():
        {
          emit(CollectionClipsState.searching(query: searchQuery));

          final items = await repo.getList(
            limit: 50,
            search: searchQuery,
            collectionId: collection.id,
          );

          emit(
            items.fold(
              (l) => CollectionClipsState.error(failure: l),
              (r) => CollectionClipsState.results(
                query: searchQuery,
                isLoading: false,
                results: r.results,
                offset: r.results.length,
                hasMore: r.hasMore,
              ),
            ),
          );
        }

      case CollectionClipsResultsState(
        :final query,
        :final results,
        :final offset,
        :final hasMore,
      ):
        {
          final newQuery = searchQuery != null && query != searchQuery;
          if (!hasMore && !newQuery) return;
          emit(CollectionClipsState.searching(query: searchQuery ?? query));
          final items = await repo.getList(
            limit: limit ?? 50,
            offset: newQuery ? 0 : offset,
            search: searchQuery ?? query,
            collectionId: collection.id,
          );

          final nextState = items.fold(
            (l) => CollectionClipsState.error(failure: l),
            (r) => CollectionClipsState.results(
              query: searchQuery ?? query,
              results: newQuery ? r.results : [...results, ...r.results],
              offset: r.results.length + (newQuery ? 0 : offset),
              hasMore: r.hasMore,
            ),
          );
          emit(nextState);
        }
      case _:
    }
  }

  Future<void> deleteItem(List<ClipboardItem> items) async {
    state.mapOrNull(
      results: (result) {
        final ids = items.map((item) => item.id).toSet();
        final items_ = result.results
            .where((it) => !ids.contains(it.id))
            .toList();
        final isDeleted = items_.length < result.results.length;
        emit(
          result.copyWith(
            results: items_,
            offset: isDeleted ? result.offset - 1 : result.offset,
          ),
        );
        fetch(currentQuery, items.length);
      },
    );
  }

  void put(ClipboardItem item, {bool isNew = false}) {
    if (item.collectionId != collection.id) {
      deleteItem([item]);
      return;
    }

    state.mapOrNull(
      results: (result) {
        final index = _findItemIndex(result.results, item);
        if (index == -1) {
          if (!isNew) return;
          final items = List<ClipboardItem>.from(result.results);
          items.insert(0, item);
          emit(result.copyWith(results: items));
          return;
        }

        if (result.results[index] == item) return;
        final items = List<ClipboardItem>.from(result.results);
        items[index] = item;
        emit(result.copyWith(results: items));
      },
    );
  }

  void onBatchSyncEvent(List<ClipCrossSyncEvent> events) {
    if (state is! CollectionClipsResultsState) return;
    final currentState = state as CollectionClipsResultsState;
    final hasSearch = currentQuery != null && currentQuery!.isNotEmpty;

    final next = List<ClipboardItem>.from(currentState.results);
    var deletedCount = 0;
    var changed = false;

    for (final event in events) {
      final (type, item) = event;
      final deleted =
          item.deletedAt != null || type == CrossSyncEventType.delete;
      final belongsToCurrentCollection = item.collectionId == collection.id;
      final index = _findItemIndex(next, item);

      if (deleted || !belongsToCurrentCollection) {
        if (index != -1) {
          next.removeAt(index);
          deletedCount++;
          changed = true;
        }
        continue;
      }

      if (hasSearch) continue;

      if (type == CrossSyncEventType.create ||
          type == CrossSyncEventType.update) {
        if (index != -1) {
          if (next[index] != item) {
            next[index] = item;
            changed = true;
          }
        } else {
          next.insert(0, item);
          changed = true;
        }
        continue;
      }
    }

    if (changed) {
      emit(currentState.copyWith(results: next));
    }
    if (deletedCount > 0) {
      unawaited(fetch(currentQuery, deletedCount));
    }
  }

  void onSyncEvent(ClipCrossSyncEvent event) {
    final (type, item) = event;
    // deleted
    if (item.deletedAt != null || type == CrossSyncEventType.delete) {
      deleteItem([item]);
      return;
    }

    if (currentQuery != null && currentQuery!.isNotEmpty) return;

    if (type == CrossSyncEventType.create ||
        type == CrossSyncEventType.update) {
      put(item, isNew: true);
      return;
    }
  }

  bool _isSameItem(ClipboardItem left, ClipboardItem right) {
    if (left.id != null && right.id != null && left.id == right.id) return true;
    if (left.serverId != null &&
        right.serverId != null &&
        left.serverId == right.serverId) {
      return true;
    }
    if (left.originId != null &&
        right.originId != null &&
        left.originId == right.originId) {
      return true;
    }
    return false;
  }

  int _findItemIndex(List<ClipboardItem> items, ClipboardItem item) {
    return items.indexWhere((it) => _isSameItem(it, item));
  }

  @override
  Future<void> close() {
    eventBusSubscription.cancel();
    return super.close();
  }
}
