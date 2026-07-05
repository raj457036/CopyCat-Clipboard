// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncConfig {

/// Normal polling interval.
 int get pollingIntervalSeconds;/// Minimum delay allowed between manual sync pulls.
 int get minManualDelaySeconds;/// Delay used for manual pull rate limiting.
 int get manualDelaySeconds;/// Size of batch for fetching normal items.
 int get pullBatchSize;/// Size of batch for fetching collections.
 int get collectionBatchSize;/// Size of batch for fetching deleted items.
 int get deleteBatchSize;/// Delay between processing successive sync pages.
 int get interBatchDelayMs;/// Delay before attempting to reconnect to realtime stream after a drop.
 int get reconnectDelaySeconds;/// Whether fresh pull offset is enabled.
 bool get freshPullOffsetEnabled;
/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncConfigCopyWith<SyncConfig> get copyWith => _$SyncConfigCopyWithImpl<SyncConfig>(this as SyncConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncConfig&&(identical(other.pollingIntervalSeconds, pollingIntervalSeconds) || other.pollingIntervalSeconds == pollingIntervalSeconds)&&(identical(other.minManualDelaySeconds, minManualDelaySeconds) || other.minManualDelaySeconds == minManualDelaySeconds)&&(identical(other.manualDelaySeconds, manualDelaySeconds) || other.manualDelaySeconds == manualDelaySeconds)&&(identical(other.pullBatchSize, pullBatchSize) || other.pullBatchSize == pullBatchSize)&&(identical(other.collectionBatchSize, collectionBatchSize) || other.collectionBatchSize == collectionBatchSize)&&(identical(other.deleteBatchSize, deleteBatchSize) || other.deleteBatchSize == deleteBatchSize)&&(identical(other.interBatchDelayMs, interBatchDelayMs) || other.interBatchDelayMs == interBatchDelayMs)&&(identical(other.reconnectDelaySeconds, reconnectDelaySeconds) || other.reconnectDelaySeconds == reconnectDelaySeconds)&&(identical(other.freshPullOffsetEnabled, freshPullOffsetEnabled) || other.freshPullOffsetEnabled == freshPullOffsetEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,pollingIntervalSeconds,minManualDelaySeconds,manualDelaySeconds,pullBatchSize,collectionBatchSize,deleteBatchSize,interBatchDelayMs,reconnectDelaySeconds,freshPullOffsetEnabled);

@override
String toString() {
  return 'SyncConfig(pollingIntervalSeconds: $pollingIntervalSeconds, minManualDelaySeconds: $minManualDelaySeconds, manualDelaySeconds: $manualDelaySeconds, pullBatchSize: $pullBatchSize, collectionBatchSize: $collectionBatchSize, deleteBatchSize: $deleteBatchSize, interBatchDelayMs: $interBatchDelayMs, reconnectDelaySeconds: $reconnectDelaySeconds, freshPullOffsetEnabled: $freshPullOffsetEnabled)';
}


}

/// @nodoc
abstract mixin class $SyncConfigCopyWith<$Res>  {
  factory $SyncConfigCopyWith(SyncConfig value, $Res Function(SyncConfig) _then) = _$SyncConfigCopyWithImpl;
@useResult
$Res call({
 int pollingIntervalSeconds, int minManualDelaySeconds, int manualDelaySeconds, int pullBatchSize, int collectionBatchSize, int deleteBatchSize, int interBatchDelayMs, int reconnectDelaySeconds, bool freshPullOffsetEnabled
});




}
/// @nodoc
class _$SyncConfigCopyWithImpl<$Res>
    implements $SyncConfigCopyWith<$Res> {
  _$SyncConfigCopyWithImpl(this._self, this._then);

  final SyncConfig _self;
  final $Res Function(SyncConfig) _then;

/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pollingIntervalSeconds = null,Object? minManualDelaySeconds = null,Object? manualDelaySeconds = null,Object? pullBatchSize = null,Object? collectionBatchSize = null,Object? deleteBatchSize = null,Object? interBatchDelayMs = null,Object? reconnectDelaySeconds = null,Object? freshPullOffsetEnabled = null,}) {
  return _then(_self.copyWith(
pollingIntervalSeconds: null == pollingIntervalSeconds ? _self.pollingIntervalSeconds : pollingIntervalSeconds // ignore: cast_nullable_to_non_nullable
as int,minManualDelaySeconds: null == minManualDelaySeconds ? _self.minManualDelaySeconds : minManualDelaySeconds // ignore: cast_nullable_to_non_nullable
as int,manualDelaySeconds: null == manualDelaySeconds ? _self.manualDelaySeconds : manualDelaySeconds // ignore: cast_nullable_to_non_nullable
as int,pullBatchSize: null == pullBatchSize ? _self.pullBatchSize : pullBatchSize // ignore: cast_nullable_to_non_nullable
as int,collectionBatchSize: null == collectionBatchSize ? _self.collectionBatchSize : collectionBatchSize // ignore: cast_nullable_to_non_nullable
as int,deleteBatchSize: null == deleteBatchSize ? _self.deleteBatchSize : deleteBatchSize // ignore: cast_nullable_to_non_nullable
as int,interBatchDelayMs: null == interBatchDelayMs ? _self.interBatchDelayMs : interBatchDelayMs // ignore: cast_nullable_to_non_nullable
as int,reconnectDelaySeconds: null == reconnectDelaySeconds ? _self.reconnectDelaySeconds : reconnectDelaySeconds // ignore: cast_nullable_to_non_nullable
as int,freshPullOffsetEnabled: null == freshPullOffsetEnabled ? _self.freshPullOffsetEnabled : freshPullOffsetEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncConfig].
extension SyncConfigPatterns on SyncConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncConfig value)  $default,){
final _that = this;
switch (_that) {
case _SyncConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pollingIntervalSeconds,  int minManualDelaySeconds,  int manualDelaySeconds,  int pullBatchSize,  int collectionBatchSize,  int deleteBatchSize,  int interBatchDelayMs,  int reconnectDelaySeconds,  bool freshPullOffsetEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
return $default(_that.pollingIntervalSeconds,_that.minManualDelaySeconds,_that.manualDelaySeconds,_that.pullBatchSize,_that.collectionBatchSize,_that.deleteBatchSize,_that.interBatchDelayMs,_that.reconnectDelaySeconds,_that.freshPullOffsetEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pollingIntervalSeconds,  int minManualDelaySeconds,  int manualDelaySeconds,  int pullBatchSize,  int collectionBatchSize,  int deleteBatchSize,  int interBatchDelayMs,  int reconnectDelaySeconds,  bool freshPullOffsetEnabled)  $default,) {final _that = this;
switch (_that) {
case _SyncConfig():
return $default(_that.pollingIntervalSeconds,_that.minManualDelaySeconds,_that.manualDelaySeconds,_that.pullBatchSize,_that.collectionBatchSize,_that.deleteBatchSize,_that.interBatchDelayMs,_that.reconnectDelaySeconds,_that.freshPullOffsetEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pollingIntervalSeconds,  int minManualDelaySeconds,  int manualDelaySeconds,  int pullBatchSize,  int collectionBatchSize,  int deleteBatchSize,  int interBatchDelayMs,  int reconnectDelaySeconds,  bool freshPullOffsetEnabled)?  $default,) {final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
return $default(_that.pollingIntervalSeconds,_that.minManualDelaySeconds,_that.manualDelaySeconds,_that.pullBatchSize,_that.collectionBatchSize,_that.deleteBatchSize,_that.interBatchDelayMs,_that.reconnectDelaySeconds,_that.freshPullOffsetEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _SyncConfig implements SyncConfig {
  const _SyncConfig({this.pollingIntervalSeconds = 45, this.minManualDelaySeconds = 5, this.manualDelaySeconds = 15, this.pullBatchSize = 50, this.collectionBatchSize = 50, this.deleteBatchSize = 50, this.interBatchDelayMs = 350, this.reconnectDelaySeconds = 5, this.freshPullOffsetEnabled = false});
  

/// Normal polling interval.
@override@JsonKey() final  int pollingIntervalSeconds;
/// Minimum delay allowed between manual sync pulls.
@override@JsonKey() final  int minManualDelaySeconds;
/// Delay used for manual pull rate limiting.
@override@JsonKey() final  int manualDelaySeconds;
/// Size of batch for fetching normal items.
@override@JsonKey() final  int pullBatchSize;
/// Size of batch for fetching collections.
@override@JsonKey() final  int collectionBatchSize;
/// Size of batch for fetching deleted items.
@override@JsonKey() final  int deleteBatchSize;
/// Delay between processing successive sync pages.
@override@JsonKey() final  int interBatchDelayMs;
/// Delay before attempting to reconnect to realtime stream after a drop.
@override@JsonKey() final  int reconnectDelaySeconds;
/// Whether fresh pull offset is enabled.
@override@JsonKey() final  bool freshPullOffsetEnabled;

/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncConfigCopyWith<_SyncConfig> get copyWith => __$SyncConfigCopyWithImpl<_SyncConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncConfig&&(identical(other.pollingIntervalSeconds, pollingIntervalSeconds) || other.pollingIntervalSeconds == pollingIntervalSeconds)&&(identical(other.minManualDelaySeconds, minManualDelaySeconds) || other.minManualDelaySeconds == minManualDelaySeconds)&&(identical(other.manualDelaySeconds, manualDelaySeconds) || other.manualDelaySeconds == manualDelaySeconds)&&(identical(other.pullBatchSize, pullBatchSize) || other.pullBatchSize == pullBatchSize)&&(identical(other.collectionBatchSize, collectionBatchSize) || other.collectionBatchSize == collectionBatchSize)&&(identical(other.deleteBatchSize, deleteBatchSize) || other.deleteBatchSize == deleteBatchSize)&&(identical(other.interBatchDelayMs, interBatchDelayMs) || other.interBatchDelayMs == interBatchDelayMs)&&(identical(other.reconnectDelaySeconds, reconnectDelaySeconds) || other.reconnectDelaySeconds == reconnectDelaySeconds)&&(identical(other.freshPullOffsetEnabled, freshPullOffsetEnabled) || other.freshPullOffsetEnabled == freshPullOffsetEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,pollingIntervalSeconds,minManualDelaySeconds,manualDelaySeconds,pullBatchSize,collectionBatchSize,deleteBatchSize,interBatchDelayMs,reconnectDelaySeconds,freshPullOffsetEnabled);

@override
String toString() {
  return 'SyncConfig(pollingIntervalSeconds: $pollingIntervalSeconds, minManualDelaySeconds: $minManualDelaySeconds, manualDelaySeconds: $manualDelaySeconds, pullBatchSize: $pullBatchSize, collectionBatchSize: $collectionBatchSize, deleteBatchSize: $deleteBatchSize, interBatchDelayMs: $interBatchDelayMs, reconnectDelaySeconds: $reconnectDelaySeconds, freshPullOffsetEnabled: $freshPullOffsetEnabled)';
}


}

/// @nodoc
abstract mixin class _$SyncConfigCopyWith<$Res> implements $SyncConfigCopyWith<$Res> {
  factory _$SyncConfigCopyWith(_SyncConfig value, $Res Function(_SyncConfig) _then) = __$SyncConfigCopyWithImpl;
@override @useResult
$Res call({
 int pollingIntervalSeconds, int minManualDelaySeconds, int manualDelaySeconds, int pullBatchSize, int collectionBatchSize, int deleteBatchSize, int interBatchDelayMs, int reconnectDelaySeconds, bool freshPullOffsetEnabled
});




}
/// @nodoc
class __$SyncConfigCopyWithImpl<$Res>
    implements _$SyncConfigCopyWith<$Res> {
  __$SyncConfigCopyWithImpl(this._self, this._then);

  final _SyncConfig _self;
  final $Res Function(_SyncConfig) _then;

/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pollingIntervalSeconds = null,Object? minManualDelaySeconds = null,Object? manualDelaySeconds = null,Object? pullBatchSize = null,Object? collectionBatchSize = null,Object? deleteBatchSize = null,Object? interBatchDelayMs = null,Object? reconnectDelaySeconds = null,Object? freshPullOffsetEnabled = null,}) {
  return _then(_SyncConfig(
pollingIntervalSeconds: null == pollingIntervalSeconds ? _self.pollingIntervalSeconds : pollingIntervalSeconds // ignore: cast_nullable_to_non_nullable
as int,minManualDelaySeconds: null == minManualDelaySeconds ? _self.minManualDelaySeconds : minManualDelaySeconds // ignore: cast_nullable_to_non_nullable
as int,manualDelaySeconds: null == manualDelaySeconds ? _self.manualDelaySeconds : manualDelaySeconds // ignore: cast_nullable_to_non_nullable
as int,pullBatchSize: null == pullBatchSize ? _self.pullBatchSize : pullBatchSize // ignore: cast_nullable_to_non_nullable
as int,collectionBatchSize: null == collectionBatchSize ? _self.collectionBatchSize : collectionBatchSize // ignore: cast_nullable_to_non_nullable
as int,deleteBatchSize: null == deleteBatchSize ? _self.deleteBatchSize : deleteBatchSize // ignore: cast_nullable_to_non_nullable
as int,interBatchDelayMs: null == interBatchDelayMs ? _self.interBatchDelayMs : interBatchDelayMs // ignore: cast_nullable_to_non_nullable
as int,reconnectDelaySeconds: null == reconnectDelaySeconds ? _self.reconnectDelaySeconds : reconnectDelaySeconds // ignore: cast_nullable_to_non_nullable
as int,freshPullOffsetEnabled: null == freshPullOffsetEnabled ? _self.freshPullOffsetEnabled : freshPullOffsetEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
