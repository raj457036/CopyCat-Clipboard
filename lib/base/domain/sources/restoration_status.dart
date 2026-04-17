import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';

abstract class RestorationStatusSource {
  Future<SyncStatus?> getStatus();
  Future<SyncStatus> setStatus(SyncStatus status);
}
