import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sync_status_cubit.freezed.dart';
part 'sync_status_state.dart';

class SyncAllParams {
  final bool force;
  final bool freshPull;

  const SyncAllParams({this.force = false, this.freshPull = false});
}

class SyncProgressInitParams {
  final Map<String, int> totalCounts;
  const SyncProgressInitParams(this.totalCounts);
}

@injectable
class SyncStatusCubit extends Cubit<SyncStatusState> {
  static const _notificationDedupeWindow = Duration(seconds: 3);

  final MonetizationCubit monetizationCubit;
  final SyncOrchestrator orchestrator;
  final SyncEventBus eventBus;
  StreamSubscription? _eventSub;
  final Set<String> _busyEngines = {};
  final Map<String, DateTime> _lastNotifiedAt = {};
  bool _isManualSyncing = false;

  SyncStatusCubit(this.orchestrator, this.eventBus, this.monetizationCubit)
    : super(const SyncStatusState.unknown()) {
    _subscribeToEvents();
  }

  Subscription? get _activeSubscription =>
      monetizationCubit.state.when(unknown: () => null, active: (sub) => sub);

  /// Determines the pull offset for fresh pulls based on subscription status.
  int get pullOffset => _activeSubscription?.syncHours != null
      ? _activeSubscription!.syncHours * 60 * 60
      : 24 * 60 * 60; // Default to 24 hours for non-subscribers

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
        _checkCompletion();
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
      } else if (event is SyncOutboxFailureEvent) {
        _notifyOutboxFailure(event);
      }
    });
  }

  void _notifyOutboxFailure(SyncOutboxFailureEvent event) {
    final failure = _toUserFailure(event.failure);
    final key = '${event.entityType}:${failure.code}';
    final now = DateTime.now();
    final previous = _lastNotifiedAt[key];

    if (previous != null &&
        now.difference(previous) < _notificationDedupeWindow) {
      return;
    }

    _lastNotifiedAt[key] = now;
    showFailureSnackbar(failure);
  }

  Failure _toUserFailure(Failure failure) {
    if (failure.code == 'file-sync-not-enabled') {
      return const Failure(
        message:
            'File and media sync is disabled. Enable it in settings to sync attachments.',
        code: 'file-sync-not-enabled',
      );
    }
    return failure;
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
      final success = await orchestrator.syncAll(
        force: params.force,
        freshPull: params.freshPull,
        pullOffset: pullOffset,
      );
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
