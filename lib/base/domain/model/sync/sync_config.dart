import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_config.freezed.dart';

/// Centralized configuration parameters for the generic sync engine.
@freezed
class SyncConfig with _$SyncConfig {
  const factory SyncConfig({
    /// Normal polling interval.
    @Default(45) int pollingIntervalSeconds,

    /// Minimum delay allowed between manual sync pulls.
    @Default(5) int minManualDelaySeconds,

    /// Delay used for manual pull rate limiting.
    @Default(15) int manualDelaySeconds,

    /// Size of batch for fetching normal items.
    @Default(500) int pullBatchSize,

    /// Size of batch for fetching collections.
    @Default(250) int collectionBatchSize,

    /// Size of batch for fetching deleted items.
    @Default(1000) int deleteBatchSize,

    /// Delay between processing successive sync pages.
    @Default(350) int interBatchDelayMs,

    /// Delay before attempting to reconnect to realtime stream after a drop.
    @Default(10) int reconnectDelaySeconds,
  }) = _SyncConfig;
}
