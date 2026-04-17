import 'package:bloc/bloc.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sync_status_cubit.freezed.dart';
part 'sync_status_state.dart';

@injectable
class SyncStatusCubit extends Cubit<SyncStatusState> {
  final SyncOrchestrator orchestrator;

  SyncStatusCubit(this.orchestrator) : super(const SyncStatusState.unknown());

  Future<void> syncAll({bool force = false}) async {
    emit(const SyncStatusState.syncing());
    try {
      await orchestrator.syncAll(force: force);
      emit(const SyncStatusState.complete());
    } catch (e) {
      emit(
        SyncStatusState.failed(
          Failure(message: e.toString(), code: 'sync_error'),
        ),
      );
    }
  }

  void start() => orchestrator.start();
  void stop() => orchestrator.stop();
}
