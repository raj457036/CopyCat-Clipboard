import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'clip_collection_cubit.freezed.dart';
part 'clip_collection_state.dart';

@Injectable(cache: true)
class ClipCollectionCubit extends Cubit<ClipCollectionState> {
  final SyncEventBus syncEventBus;
  final AuthCubit auth;
  final ClipCollectionRepository repo;
  final String deviceId;
  late StreamSubscription eventBusSubscription;

  ClipCollectionCubit(
    this.syncEventBus,
    this.auth,
    this.repo,
    @Named("device_id") this.deviceId,
  ) : super(const ClipCollectionState.loaded(collections: [])) {
    eventBusSubscription = syncEventBus.where<ClipCollection>().listen((event) {
      if (event is TypedSyncEvent<ClipCollection>) {
        onSyncEvent(event.event);
      } else if (event is TypedSyncBatchEvent<ClipCollection>) {
        onBatchSyncEvent(event.events);
      }
    });
  }

  void onBatchSyncEvent(List<CollectionCrossSyncEvent> events) {
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
      for (var d in deleted) {
        delete(d);
      }
    }

    // Created
    final created = events
        .where((event) {
          final (type, item) = event;
          return type == CrossSyncEventType.create && item.deletedAt == null;
        })
        .map((event) => event.$2)
        .toList();
    if (created.isNotEmpty) {
      emit(state.copyWith(collections: [...created, ...state.collections]));
    }

    // Updates
    final updated = events
        .where((event) {
          final (type, item) = event;
          return type == CrossSyncEventType.update && item.deletedAt == null;
        })
        .map((event) => event.$2)
        .toList();
    if (updated.isEmpty) return;
    final updateIndexMap = <int, int>{};
    for (var i = 0; i < updated.length; i++) {
      final collection = updated[i];
      updateIndexMap[collection.id!] = i;
    }

    final replaced = <ClipCollection>[];
    for (var i = 0; i < state.collections.length; i++) {
      final collection = state.collections[i];
      final found = updateIndexMap[collection.id];
      if (found != null) {
        replaced.add(updated[found]);
      } else {
        replaced.add(collection);
      }
    }
    emit(state.copyWith(collections: replaced));
  }

  void onSyncEvent(CollectionCrossSyncEvent event) {
    final (type, collection) = event;
    // deleted
    if (collection.deletedAt != null || type == CrossSyncEventType.delete) {
      delete(collection);
      return;
    }

    put(collection, isNew: type == CrossSyncEventType.create);
  }

  void put(ClipCollection collection, {bool isNew = false}) {
    if (isNew) {
      emit(state.copyWith(collections: [collection, ...state.collections]));
    } else {
      final collections = state.collections.replaceWhere(
        (it) => it.id == collection.id,
        collection,
      );
      emit(state.copyWith(collections: collections));
    }
  }

  Future<void> reset() async {
    emit(const ClipCollectionState.loaded(collections: []));
  }

  Future<ClipCollection?> get(int id) async {
    ClipCollection? collection = state.mapOrNull(
      loaded: (loaded) => loaded.collections.findFirst((e) => e.id == id),
    );

    if (collection == null) {
      final result = await repo.get(id: id);
      result.fold((l) => logger.e(l), (r) => collection = r);
    }
    return collection;
  }

  /// Maps serverId to localId
  Map<int, int> get serverMapping {
    return state.maybeMap(
      orElse: () => {},
      loaded: (loaded) {
        final map = <int, int>{};
        for (var collection in loaded.collections) {
          if (collection.serverId == null) continue;
          map[collection.serverId!] = collection.id!;
        }
        return map;
      },
    );
  }

  Future<void> delete(ClipCollection collection) async {
    await state.mapOrNull(
      loaded: (loaded) async {
        emit(loaded.copyWith(isLoading: true));
        await repo.delete(collection.copyWith(deviceId: deviceId));
        final items = loaded.collections.where((c) {
          final isLocallyDeleted = c.id != null && c.id == collection.id;
          final isRemotelyDeleted =
              c.serverId != null && c.serverId == collection.serverId;
          return !isLocallyDeleted && !isRemotelyDeleted;
        }).toList();

        final isDeleted = items.length < loaded.collections.length;
        emit(
          loaded.copyWith(
            collections: items,
            offset: isDeleted ? loaded.offset - 1 : loaded.offset,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<Failure?> upsert(ClipCollection collection) async {
    collection = collection.copyWith(deviceId: deviceId);
    final userId = auth.userId ?? kLocalUserId;

    collection = collection.copyWith(userId: userId);

    return await state.mapOrNull<Future<Failure?>>(
      loaded: (loaded) async {
        if (collection.isPersisted) {
          final updated = await repo.update(collection);
          return updated.fold((l) => l, (r) {
            emit(
              loaded.copyWith(
                collections: loaded.collections.replaceWhere(
                  (value) => value.id == r.id,
                  r,
                ),
              ),
            );
            return null;
          });
        } else {
          final created = await repo.create(collection);
          return created.fold((l) => l, (r) {
            emit(loaded.copyWith(collections: [r, ...loaded.collections]));
            return null;
          });
        }
      },
    );
  }

  Future<void> fetch({bool fromTop = false}) async {
    emit(state.copyWith(loading: true, offset: fromTop ? 0 : state.offset));

    final items = await repo.getList(
      limit: state.limit,
      offset: fromTop ? 0 : state.offset,
    );

    emit(
      items.fold(
        (l) => state.copyWith(failure: l, loading: false),
        (r) => state.copyWith(
          loading: false,
          collections: fromTop
              ? r.results
              : [...state.collections, ...r.results],
          offset: state.offset + r.results.length,
          limit: state.limit,
          hasMore: r.hasMore,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    eventBusSubscription.cancel();
    return super.close();
  }
}
