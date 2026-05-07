// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncConfig {
  /// Normal polling interval.
  int get pollingIntervalSeconds => throw _privateConstructorUsedError;

  /// Minimum delay allowed between manual sync pulls.
  int get minManualDelaySeconds => throw _privateConstructorUsedError;

  /// Delay used for manual pull rate limiting.
  int get manualDelaySeconds => throw _privateConstructorUsedError;

  /// Size of batch for fetching normal items.
  int get pullBatchSize => throw _privateConstructorUsedError;

  /// Size of batch for fetching collections.
  int get collectionBatchSize => throw _privateConstructorUsedError;

  /// Size of batch for fetching deleted items.
  int get deleteBatchSize => throw _privateConstructorUsedError;

  /// Delay between processing successive sync pages.
  int get interBatchDelayMs => throw _privateConstructorUsedError;

  /// Delay before attempting to reconnect to realtime stream after a drop.
  int get reconnectDelaySeconds => throw _privateConstructorUsedError;

  /// Whether fresh pull offset is enabled.
  bool get freshPullOffsetEnabled => throw _privateConstructorUsedError;

  /// Create a copy of SyncConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncConfigCopyWith<SyncConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncConfigCopyWith<$Res> {
  factory $SyncConfigCopyWith(
    SyncConfig value,
    $Res Function(SyncConfig) then,
  ) = _$SyncConfigCopyWithImpl<$Res, SyncConfig>;
  @useResult
  $Res call({
    int pollingIntervalSeconds,
    int minManualDelaySeconds,
    int manualDelaySeconds,
    int pullBatchSize,
    int collectionBatchSize,
    int deleteBatchSize,
    int interBatchDelayMs,
    int reconnectDelaySeconds,
    bool freshPullOffsetEnabled,
  });
}

/// @nodoc
class _$SyncConfigCopyWithImpl<$Res, $Val extends SyncConfig>
    implements $SyncConfigCopyWith<$Res> {
  _$SyncConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pollingIntervalSeconds = null,
    Object? minManualDelaySeconds = null,
    Object? manualDelaySeconds = null,
    Object? pullBatchSize = null,
    Object? collectionBatchSize = null,
    Object? deleteBatchSize = null,
    Object? interBatchDelayMs = null,
    Object? reconnectDelaySeconds = null,
    Object? freshPullOffsetEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            pollingIntervalSeconds: null == pollingIntervalSeconds
                ? _value.pollingIntervalSeconds
                : pollingIntervalSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            minManualDelaySeconds: null == minManualDelaySeconds
                ? _value.minManualDelaySeconds
                : minManualDelaySeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            manualDelaySeconds: null == manualDelaySeconds
                ? _value.manualDelaySeconds
                : manualDelaySeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            pullBatchSize: null == pullBatchSize
                ? _value.pullBatchSize
                : pullBatchSize // ignore: cast_nullable_to_non_nullable
                      as int,
            collectionBatchSize: null == collectionBatchSize
                ? _value.collectionBatchSize
                : collectionBatchSize // ignore: cast_nullable_to_non_nullable
                      as int,
            deleteBatchSize: null == deleteBatchSize
                ? _value.deleteBatchSize
                : deleteBatchSize // ignore: cast_nullable_to_non_nullable
                      as int,
            interBatchDelayMs: null == interBatchDelayMs
                ? _value.interBatchDelayMs
                : interBatchDelayMs // ignore: cast_nullable_to_non_nullable
                      as int,
            reconnectDelaySeconds: null == reconnectDelaySeconds
                ? _value.reconnectDelaySeconds
                : reconnectDelaySeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            freshPullOffsetEnabled: null == freshPullOffsetEnabled
                ? _value.freshPullOffsetEnabled
                : freshPullOffsetEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncConfigImplCopyWith<$Res>
    implements $SyncConfigCopyWith<$Res> {
  factory _$$SyncConfigImplCopyWith(
    _$SyncConfigImpl value,
    $Res Function(_$SyncConfigImpl) then,
  ) = __$$SyncConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int pollingIntervalSeconds,
    int minManualDelaySeconds,
    int manualDelaySeconds,
    int pullBatchSize,
    int collectionBatchSize,
    int deleteBatchSize,
    int interBatchDelayMs,
    int reconnectDelaySeconds,
    bool freshPullOffsetEnabled,
  });
}

/// @nodoc
class __$$SyncConfigImplCopyWithImpl<$Res>
    extends _$SyncConfigCopyWithImpl<$Res, _$SyncConfigImpl>
    implements _$$SyncConfigImplCopyWith<$Res> {
  __$$SyncConfigImplCopyWithImpl(
    _$SyncConfigImpl _value,
    $Res Function(_$SyncConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pollingIntervalSeconds = null,
    Object? minManualDelaySeconds = null,
    Object? manualDelaySeconds = null,
    Object? pullBatchSize = null,
    Object? collectionBatchSize = null,
    Object? deleteBatchSize = null,
    Object? interBatchDelayMs = null,
    Object? reconnectDelaySeconds = null,
    Object? freshPullOffsetEnabled = null,
  }) {
    return _then(
      _$SyncConfigImpl(
        pollingIntervalSeconds: null == pollingIntervalSeconds
            ? _value.pollingIntervalSeconds
            : pollingIntervalSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        minManualDelaySeconds: null == minManualDelaySeconds
            ? _value.minManualDelaySeconds
            : minManualDelaySeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        manualDelaySeconds: null == manualDelaySeconds
            ? _value.manualDelaySeconds
            : manualDelaySeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        pullBatchSize: null == pullBatchSize
            ? _value.pullBatchSize
            : pullBatchSize // ignore: cast_nullable_to_non_nullable
                  as int,
        collectionBatchSize: null == collectionBatchSize
            ? _value.collectionBatchSize
            : collectionBatchSize // ignore: cast_nullable_to_non_nullable
                  as int,
        deleteBatchSize: null == deleteBatchSize
            ? _value.deleteBatchSize
            : deleteBatchSize // ignore: cast_nullable_to_non_nullable
                  as int,
        interBatchDelayMs: null == interBatchDelayMs
            ? _value.interBatchDelayMs
            : interBatchDelayMs // ignore: cast_nullable_to_non_nullable
                  as int,
        reconnectDelaySeconds: null == reconnectDelaySeconds
            ? _value.reconnectDelaySeconds
            : reconnectDelaySeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        freshPullOffsetEnabled: null == freshPullOffsetEnabled
            ? _value.freshPullOffsetEnabled
            : freshPullOffsetEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SyncConfigImpl implements _SyncConfig {
  const _$SyncConfigImpl({
    this.pollingIntervalSeconds = 45,
    this.minManualDelaySeconds = 5,
    this.manualDelaySeconds = 15,
    this.pullBatchSize = 250,
    this.collectionBatchSize = 250,
    this.deleteBatchSize = 250,
    this.interBatchDelayMs = 350,
    this.reconnectDelaySeconds = 10,
    this.freshPullOffsetEnabled = false,
  });

  /// Normal polling interval.
  @override
  @JsonKey()
  final int pollingIntervalSeconds;

  /// Minimum delay allowed between manual sync pulls.
  @override
  @JsonKey()
  final int minManualDelaySeconds;

  /// Delay used for manual pull rate limiting.
  @override
  @JsonKey()
  final int manualDelaySeconds;

  /// Size of batch for fetching normal items.
  @override
  @JsonKey()
  final int pullBatchSize;

  /// Size of batch for fetching collections.
  @override
  @JsonKey()
  final int collectionBatchSize;

  /// Size of batch for fetching deleted items.
  @override
  @JsonKey()
  final int deleteBatchSize;

  /// Delay between processing successive sync pages.
  @override
  @JsonKey()
  final int interBatchDelayMs;

  /// Delay before attempting to reconnect to realtime stream after a drop.
  @override
  @JsonKey()
  final int reconnectDelaySeconds;

  /// Whether fresh pull offset is enabled.
  @override
  @JsonKey()
  final bool freshPullOffsetEnabled;

  @override
  String toString() {
    return 'SyncConfig(pollingIntervalSeconds: $pollingIntervalSeconds, minManualDelaySeconds: $minManualDelaySeconds, manualDelaySeconds: $manualDelaySeconds, pullBatchSize: $pullBatchSize, collectionBatchSize: $collectionBatchSize, deleteBatchSize: $deleteBatchSize, interBatchDelayMs: $interBatchDelayMs, reconnectDelaySeconds: $reconnectDelaySeconds, freshPullOffsetEnabled: $freshPullOffsetEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncConfigImpl &&
            (identical(other.pollingIntervalSeconds, pollingIntervalSeconds) ||
                other.pollingIntervalSeconds == pollingIntervalSeconds) &&
            (identical(other.minManualDelaySeconds, minManualDelaySeconds) ||
                other.minManualDelaySeconds == minManualDelaySeconds) &&
            (identical(other.manualDelaySeconds, manualDelaySeconds) ||
                other.manualDelaySeconds == manualDelaySeconds) &&
            (identical(other.pullBatchSize, pullBatchSize) ||
                other.pullBatchSize == pullBatchSize) &&
            (identical(other.collectionBatchSize, collectionBatchSize) ||
                other.collectionBatchSize == collectionBatchSize) &&
            (identical(other.deleteBatchSize, deleteBatchSize) ||
                other.deleteBatchSize == deleteBatchSize) &&
            (identical(other.interBatchDelayMs, interBatchDelayMs) ||
                other.interBatchDelayMs == interBatchDelayMs) &&
            (identical(other.reconnectDelaySeconds, reconnectDelaySeconds) ||
                other.reconnectDelaySeconds == reconnectDelaySeconds) &&
            (identical(other.freshPullOffsetEnabled, freshPullOffsetEnabled) ||
                other.freshPullOffsetEnabled == freshPullOffsetEnabled));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    pollingIntervalSeconds,
    minManualDelaySeconds,
    manualDelaySeconds,
    pullBatchSize,
    collectionBatchSize,
    deleteBatchSize,
    interBatchDelayMs,
    reconnectDelaySeconds,
    freshPullOffsetEnabled,
  );

  /// Create a copy of SyncConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncConfigImplCopyWith<_$SyncConfigImpl> get copyWith =>
      __$$SyncConfigImplCopyWithImpl<_$SyncConfigImpl>(this, _$identity);
}

abstract class _SyncConfig implements SyncConfig {
  const factory _SyncConfig({
    final int pollingIntervalSeconds,
    final int minManualDelaySeconds,
    final int manualDelaySeconds,
    final int pullBatchSize,
    final int collectionBatchSize,
    final int deleteBatchSize,
    final int interBatchDelayMs,
    final int reconnectDelaySeconds,
    final bool freshPullOffsetEnabled,
  }) = _$SyncConfigImpl;

  /// Normal polling interval.
  @override
  int get pollingIntervalSeconds;

  /// Minimum delay allowed between manual sync pulls.
  @override
  int get minManualDelaySeconds;

  /// Delay used for manual pull rate limiting.
  @override
  int get manualDelaySeconds;

  /// Size of batch for fetching normal items.
  @override
  int get pullBatchSize;

  /// Size of batch for fetching collections.
  @override
  int get collectionBatchSize;

  /// Size of batch for fetching deleted items.
  @override
  int get deleteBatchSize;

  /// Delay between processing successive sync pages.
  @override
  int get interBatchDelayMs;

  /// Delay before attempting to reconnect to realtime stream after a drop.
  @override
  int get reconnectDelaySeconds;

  /// Whether fresh pull offset is enabled.
  @override
  bool get freshPullOffsetEnabled;

  /// Create a copy of SyncConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncConfigImplCopyWith<_$SyncConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
