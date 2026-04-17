import 'package:clipboard/base/data/isar/adapters/isar_sync_status.dart';
import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';
import 'package:clipboard/base/domain/sources/restoration_status.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

const restorationStatusId = 1;

@LazySingleton(as: RestorationStatusSource)
class RestorationStatusSourceImpl implements RestorationStatusSource {
  final Isar db;

  RestorationStatusSourceImpl({required this.db});

  IsarCollection<IsarSyncStatus> get _collection =>
      db.collection<IsarSyncStatus>();

  @override
  Future<SyncStatus?> getStatus() async {
    final result = await db.txn(() async {
      return _collection.get(restorationStatusId);
    });
    return result?.toDomain();
  }

  @override
  Future<SyncStatus> setStatus(SyncStatus status) async {
    final isarStatus = IsarSyncStatus.fromDomain(
      status.copyWith(id: restorationStatusId),
    );
    await db.writeTxn(() async {
      return _collection.put(isarStatus);
    });
    return status.copyWith(id: restorationStatusId);
  }
}
