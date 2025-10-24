import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/db/sync_status/syncstatus.dart';

abstract class RestorationStatusRepository {
  FailureOr<SyncStatus?> getStatus();
  FailureOr<SyncStatus> setStatus(SyncStatus status);
}
