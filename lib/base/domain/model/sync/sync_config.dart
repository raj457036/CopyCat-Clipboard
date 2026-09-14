import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:clipboard/base/constants/numbers/values.dart';

part 'sync_config.freezed.dart';

/// Centralized configuration parameters for the generic sync engine.
@freezed
abstract class SyncConfig with _$SyncConfig {
  const factory SyncConfig({
    /// Normal polling interval.
    @Default(defaultBestEffortSyncInterval) int pollingIntervalSeconds,

    /// Minimum delay allowed between manual sync pulls.
    @Default(5) int minManualDelaySeconds,

    /// Delay used for manual pull rate limiting.
    @Default(15) int manualDelaySeconds,

    /// Size of batch for fetching normal items.
    @Default(50) int pullBatchSize,

    /// Size of batch for fetching collections.
    @Default(50) int collectionBatchSize,

    /// Size of batch for fetching deleted items.
    @Default(50) int deleteBatchSize,

    /// Delay between processing successive sync pages.
    @Default(350) int interBatchDelayMs,

    /// Whether fresh pull offset is enabled.
    @Default(false) bool freshPullOffsetEnabled,
  }) = _SyncConfig;
}
