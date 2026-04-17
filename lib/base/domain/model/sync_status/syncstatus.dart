import 'package:clipboard/base/domain/model/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'syncstatus.freezed.dart';

/// This is use for restoring the clips, if restoration failed.
@freezed
class SyncStatus with _$SyncStatus, Identifiable {
  SyncStatus._();
  factory SyncStatus({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    DateTime?
    lastSyncPoint, // . . . -\>* . . |<- it stores the last sync end point in time.
    DateTime?
    lastSyncStartPoint, // . . . ->| . . *<- it stores the last sync start point in time.
    int? lastKnownSyncCount,
    int? lastKnownTotalCount,
    @Default(true) bool restorationPending,
  }) = _SyncStatus;
}
