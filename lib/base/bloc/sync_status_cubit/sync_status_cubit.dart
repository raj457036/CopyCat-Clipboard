import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sync_status_cubit.freezed.dart';
part 'sync_status_state.dart';

class SyncAllParams {
  final bool force;
  const SyncAllParams({this.force = false});
}

class SyncProgressInitParams {
  final Map<String, int> totalCounts;
  const SyncProgressInitParams(this.totalCounts);
}

@injectable
class SyncStatusCubit extends Cubit<SyncStatusState> {
  final SyncOrchestrator orchestrator;
  final SyncEventBus eventBus;
  StreamSubscription? _eventSub;
  final Set<String> _busyEngines = {};
  bool _isManualSyncing = false;

  SyncStatusCubit(this.orchestrator, this.eventBus)
    : super(const SyncStatusState.unknown()) {
    _subscribeToEvents();
  }

  void initializeProgress(SyncProgressInitParams params) {
    final progress = params.totalCounts.map(
      (key, value) => MapEntry(key, SyncProgress(synced: 0, total: value)),
    );
    emit(SyncStatusState.syncing(progress: progress));
  }

  void _subscribeToEvents() {
    _eventSub?.cancel();
    _eventSub = eventBus.stream.listen((event) {
      if (event is SyncProgressEvent) {
        final currentProgress = state.maybeWhen(
          syncing: (progress) => Map<String, SyncProgress>.from(progress),
          orElse: () => <String, SyncProgress>{},
        );

        final p = event.params;
        final existing = currentProgress[p.entityType];

        currentProgress[p.entityType] = SyncProgress(
          synced: p.syncedCount,
          total: p.totalCount ?? existing?.total ?? 0,
        );

        emit(SyncStatusState.syncing(progress: currentProgress));
      } else if (event is SyncEngineStatusUpdateEvent) {
        if (event.isBusy) {
          _busyEngines.add(event.entityType);
          if (state is! SyncingStatus) {
            emit(const SyncStatusState.syncing());
          }
        } else {
          _busyEngines.remove(event.entityType);
          _checkCompletion();
        }
      }
    });
  }

  void _checkCompletion() {
    if (_busyEngines.isEmpty && !_isManualSyncing) {
      // Small delay to handle transitions between engines or tasks
      Future.delayed(const Duration(milliseconds: 500), () {
        if (isClosed) return;
        if (_busyEngines.isEmpty &&
            !_isManualSyncing &&
            state is SyncingStatus) {
          emit(const SyncStatusState.complete());
        }
      });
    }
  }

  Future<void> syncAll(SyncAllParams params) async {
    _isManualSyncing = true;
    if (state is! SyncingStatus) {
      emit(const SyncStatusState.syncing());
    }
    try {
      final success = await orchestrator.syncAll(force: params.force);
      if (success) {
        emit(const SyncStatusState.complete());
      } else {
        emit(
          const SyncStatusState.failed(
            Failure(
              message: 'Sync failed. Please try again.',
              code: 'sync_failed',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        SyncStatusState.failed(
          Failure(message: e.toString(), code: 'sync_error'),
        ),
      );
    } finally {
      _isManualSyncing = false;
      _checkCompletion();
    }
  }

  void start() => orchestrator.start();
  void stop() => orchestrator.stop();

  @override
  Future<void> close() {
    _eventSub?.cancel();
    return super.close();
  }
}
