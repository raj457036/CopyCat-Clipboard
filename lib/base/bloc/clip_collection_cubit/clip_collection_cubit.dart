import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
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
  final MonetizationCubit monetizationCubit;
  late StreamSubscription eventBusSubscription;
  late StreamSubscription<MonetizationState> _monetizationSub;
  Future<void> _batchSyncQueue = Future.value();

  /// Resolves the active collection limit from a [MonetizationState].
  static int _limitFromMonetization(MonetizationState monetizationState) =>
      monetizationState.whenOrNull(active: (sub) => sub.collections) ??
      defaultCollectionCount;

  ClipCollectionCubit(
    this.syncEventBus,
    this.auth,
    this.repo,
    @Named("device_id") this.deviceId,
    this.monetizationCubit,
  ) : super(
        ClipCollectionState.loaded(
          collections: [],
          activeLimit: _limitFromMonetization(monetizationCubit.state),
        ),
      ) {
    _monetizationSub = monetizationCubit.stream.listen(_applyPlanLimit);
    eventBusSubscription = syncEventBus.where<ClipCollection>().listen((event) {
      if (event is TypedSyncEvent<ClipCollection>) {
        onSyncEvent(event.event);
      } else if (event is TypedSyncBatchEvent<ClipCollection>) {
        _batchSyncQueue = _batchSyncQueue
            .then((_) => onBatchSyncEvent(event.events))
            .catchError((error, stackTrace) {
              logger.e(
                'ClipCollectionCubit batch sync failed: $error',
                stackTrace: stackTrace,
              );
            });
      }
    });
  }

  Future<void> onBatchSyncEvent(List<CollectionCrossSyncEvent> events) async {
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
      await _deleteFromSyncEvents(deleted);
    }

    final upserts = events
        .where((event) {
          final (type, item) = event;
          return (type == CrossSyncEventType.create ||
                  type == CrossSyncEventType.update) &&
              item.deletedAt == null;
        })
        .map((event) => event.$2)
        .toList();
    if (upserts.isEmpty) return;

    var collections = List<ClipCollection>.from(state.collections);
    var changed = false;
    for (final collection in upserts) {
      final result = _upsertLocal(collections, collection);
      collections = result.collections;
      changed = result.changed || changed;
    }

    if (changed) {
      emit(state.copyWith(collections: collections));
    }
  }

  void onSyncEvent(CollectionCrossSyncEvent event) {
    final (type, collection) = event;
    // deleted
    if (collection.deletedAt != null || type == CrossSyncEventType.delete) {
      unawaited(_deleteFromSyncEvents([collection]));
      return;
    }

    final result = _upsertLocal(state.collections, collection);
    if (result.changed) {
      emit(state.copyWith(collections: result.collections));
    }
  }

  ({List<ClipCollection> collections, bool changed}) _upsertLocal(
    List<ClipCollection> collections,
    ClipCollection collection,
  ) {
    final next = List<ClipCollection>.from(collections);
    final index = next.indexWhere((it) => _isSameCollection(it, collection));
    if (index == -1) {
      next.insert(0, collection);
      return (collections: next, changed: true);
    }

    if (next[index] == collection) {
      return (collections: next, changed: false);
    }

    next[index] = collection;
    return (collections: next, changed: true);
  }

  bool _isSameCollection(ClipCollection left, ClipCollection right) {
    if (left.id != null && right.id != null && left.id == right.id) {
      return true;
    }

    if (left.serverId != null &&
        right.serverId != null &&
        left.serverId == right.serverId) {
      return true;
    }

    return false;
  }

  // MARK: - Plan limit

  void _applyPlanLimit(MonetizationState monetizationState) {
    emit(
      state.copyWith(activeLimit: _limitFromMonetization(monetizationState)),
    );
  }

  /// Returns true when [collection] is beyond the plan's active-collection
  /// limit, meaning it is read-only on the current plan.
  bool isReadOnly(ClipCollection collection) =>
      state.mapOrNull(loaded: (s) => s.isReadOnly(collection)) ?? false;

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

        final removedCount = loaded.collections.length - items.length;
        final nextOffset = (loaded.offset - removedCount)
            .clamp(0, items.length)
            .toInt();
        emit(
          loaded.copyWith(
            collections: items,
            offset: nextOffset,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> _deleteFromSyncEvents(List<ClipCollection> collections) async {
    if (collections.isEmpty) return;
    final deletedIds = collections.map((c) => c.id).whereType<int>().toSet();
    final deletedServerIds = collections
        .map((c) => c.serverId)
        .whereType<int>()
        .toSet();

    await state.mapOrNull(
      loaded: (loaded) async {
        emit(loaded.copyWith(isLoading: true));
        final items = loaded.collections.where((c) {
          final isLocallyDeleted = c.id != null && deletedIds.contains(c.id);
          final isRemotelyDeleted =
              c.serverId != null && deletedServerIds.contains(c.serverId);
          return !isLocallyDeleted && !isRemotelyDeleted;
        }).toList();

        final removedCount = loaded.collections.length - items.length;
        final nextOffset = (loaded.offset - removedCount)
            .clamp(0, items.length)
            .toInt();
        emit(
          loaded.copyWith(
            collections: items,
            offset: nextOffset,
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
    _monetizationSub.cancel();
    eventBusSubscription.cancel();
    return super.close();
  }
}
