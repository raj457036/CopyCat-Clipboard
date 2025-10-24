import 'package:clipboard/base/db/sync_status/syncstatus.dart';
import 'package:clipboard/base/domain/repositories/restoration_status.dart';
import 'package:clipboard/base/domain/sources/restoration_status.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RestorationStatusRepository)
class RestorationStatusRepositoryImpl implements RestorationStatusRepository {
  final RestorationStatusSource source;

  RestorationStatusRepositoryImpl(this.source);

  @override
  FailureOr<SyncStatus?> getStatus() async {
    try {
      final status = await source.getStatus();
      return Right(status);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<SyncStatus> setStatus(SyncStatus status) async {
    try {
      final updated = await source.setStatus(status);
      return Right(updated);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
