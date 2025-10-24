import 'package:clipboard/base/db/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part 'syncstatus.freezed.dart';
part 'syncstatus.g.dart';

/// This is use for restoring the clips, if restoration failed.
@freezed
@Collection(ignore: {"copyWith"})
class SyncStatus with _$SyncStatus, IsarIdMixin {
  SyncStatus._();
  factory SyncStatus({
    DateTime?
        lastSyncPoint, // . . . ->* . . |<- it stores the last sync end point in time.
    DateTime?
        lastSyncStartPoint, // . . . ->| . . *<- it stores the last sync start point in time.
    int? lastKnownSyncCount,
    int? lastKnownTotalCount,
    @Default(true) bool restorationPending,
  }) = _SyncStatus;
}
