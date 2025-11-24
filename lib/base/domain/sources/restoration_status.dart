import 'package:clipboard/base/db/sync_status/syncstatus.dart';

abstract class RestorationStatusSource {
  Future<SyncStatus?> getStatus();
  Future<SyncStatus> setStatus(SyncStatus status);
}
