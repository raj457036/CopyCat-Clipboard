import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';
import 'package:clipboard/common/failure.dart';

abstract class RestorationStatusRepository {
  FailureOr<SyncStatus?> getStatus();
  FailureOr<SyncStatus> setStatus(SyncStatus status);
}
