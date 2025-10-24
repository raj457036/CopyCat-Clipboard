import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'collection_clips_cubit.freezed.dart';
part 'collection_clips_state.dart';

@injectable
class CollectionClipsCubit extends Cubit<CollectionClipsState> {
  final EventBusCubit eventBus;
  final ClipboardRepository repo;
  final ClipCollection collection;
  late StreamSubscription eventBusSubscription;

  String? currentQuery;

  CollectionClipsCubit(
    this.eventBus,
    @Named("local") this.repo, {
    @factoryParam required this.collection,
  }) : super(const CollectionClipsState.initial()) {
    eventBusSubscription = eventBus.stream.listen((state) {
      switch (state) {
        case EventBusClipCrossSyncEvent(:final event):
          onSyncEvent(event);
        case EventBusBatchClipCrossSyncEvent(:final events):
          onBatchSyncEvent(events);
      }
    });
  }

  Future<void> search([String? searchQuery, int? limit]) async {
    currentQuery = searchQuery;
    switch (state) {
      case InitialCollectionClipsState() || CollectionClipsErrorState():
        {
          emit(
            CollectionClipsState.searching(query: searchQuery),
          );

          final items = await repo.getList(
            limit: 50,
            search: searchQuery,
            collectionId: collection.id,
          );

          emit(
            items.fold(
              (l) => CollectionClipsState.error(
                failure: l,
              ),
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
          :final hasMore
        ):
        {
          final newQuery = searchQuery != null && query != searchQuery;
          if (!hasMore && !newQuery) return;
          emit(
            CollectionClipsState.searching(query: searchQuery ?? query),
          );
          final items = await repo.getList(
            limit: limit ?? 50,
            offset: newQuery ? 0 : offset,
            search: searchQuery ?? query,
            collectionId: collection.id,
          );

          final nextState = items.fold(
            (l) => CollectionClipsState.error(
              failure: l,
            ),
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
    state.mapOrNull(results: (result) {
      final ids = items.map((item) => item.id).toSet();
      final items_ =
          result.results.where((it) => !ids.contains(it.id)).toList();
      final isDeleted = items_.length < result.results.length;
      emit(
        result.copyWith(
          results: items_,
          offset: isDeleted ? result.offset - 1 : result.offset,
        ),
      );
      search(currentQuery, items.length);
    });
  }

  void put(ClipboardItem item) {
    if (item.collectionId != collection.id) {
      deleteItem([item]);
      return;
    }

    state.mapOrNull(results: (result) {
      final items = result.results.replaceWhere((it) => it.id == item.id, item);
      emit(
        result.copyWith(results: items),
      );
    });
  }

  void onBatchSyncEvent(List<ClipCrossSyncEvent> events) {
    if (state is! CollectionClipsResultsState) return;
    final currentState = state as CollectionClipsResultsState;
    // Deleted
    final deleted = events
        .where((event) {
          final (type, _) = event;
          return type == CrossSyncEventType.delete;
        })
        .map((event) => event.$2)
        .toList();
    deleteItem(deleted);

    if (currentQuery != null && currentQuery!.isNotEmpty) return;

    // Created
    final created = events
        .where((event) {
          final (type, _) = event;
          return type == CrossSyncEventType.create;
        })
        .map((event) => event.$2)
        .toList();
    if (created.isNotEmpty) {
      emit(currentState
          .copyWith(results: [...created, ...currentState.results]));
    }

    // Updates
    final updated = events
        .where((event) {
          final (type, _) = event;
          return type == CrossSyncEventType.update;
        })
        .map((event) => event.$2)
        .toList();
    if (updated.isEmpty) return;
    final updateIndexMap = <int, int>{};
    for (var i = 0; i < updated.length; i++) {
      final item = updated[i];
      updateIndexMap[item.id] = i;
    }

    final replaced = <ClipboardItem>[];
    for (var i = 0; i < currentState.results.length; i++) {
      final item = currentState.results[i];
      final found = updateIndexMap[item.id];
      if (found != null) {
        replaced.add(item);
      } else {
        replaced.add(item);
      }
    }
    emit(currentState.copyWith(results: replaced));
  }

  void onSyncEvent(ClipCrossSyncEvent event) {
    final (type, item) = event;
    // deleted
    if (item.deletedAt != null || type == CrossSyncEventType.delete) {
      deleteItem([item]);
      return;
    }

    if (currentQuery != null && currentQuery!.isNotEmpty) return;
    put(item);
  }

  @override
  Future<void> close() {
    eventBusSubscription.cancel();
    return super.close();
  }
}
