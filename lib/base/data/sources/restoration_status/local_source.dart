import 'package:clipboard/base/db/sync_status/syncstatus.dart';
import 'package:clipboard/base/domain/sources/restoration_status.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

const restorationStatusId = 1;

@LazySingleton(as: RestorationStatusSource)
class RestorationStatusSourceImpl implements RestorationStatusSource {
  final Isar db;

  RestorationStatusSourceImpl({required this.db});

  @override
  Future<SyncStatus?> getStatus() async {
    final result = await db.txn(() async {
      return db.syncStatus.get(restorationStatusId);
    });
    return result;
  }

  @override
  Future<SyncStatus> setStatus(SyncStatus status) async {
    await db.writeTxn(() async {
      status.id = restorationStatusId;
      return db.syncStatus.put(status);
    });
    return status;
  }
}
