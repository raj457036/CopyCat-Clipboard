// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'syncstatus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncStatus {
  DateTime? get lastSyncPoint =>
      throw _privateConstructorUsedError; // . . . ->* . . |<- it stores the last sync end point in time.
  DateTime? get lastSyncStartPoint =>
      throw _privateConstructorUsedError; // . . . ->| . . *<- it stores the last sync start point in time.
  int? get lastKnownSyncCount => throw _privateConstructorUsedError;
  int? get lastKnownTotalCount => throw _privateConstructorUsedError;
  bool get restorationPending => throw _privateConstructorUsedError;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStatusCopyWith<SyncStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusCopyWith<$Res> {
  factory $SyncStatusCopyWith(
          SyncStatus value, $Res Function(SyncStatus) then) =
      _$SyncStatusCopyWithImpl<$Res, SyncStatus>;
  @useResult
  $Res call(
      {DateTime? lastSyncPoint,
      DateTime? lastSyncStartPoint,
      int? lastKnownSyncCount,
      int? lastKnownTotalCount,
      bool restorationPending});
}

/// @nodoc
class _$SyncStatusCopyWithImpl<$Res, $Val extends SyncStatus>
    implements $SyncStatusCopyWith<$Res> {
  _$SyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastSyncPoint = freezed,
    Object? lastSyncStartPoint = freezed,
    Object? lastKnownSyncCount = freezed,
    Object? lastKnownTotalCount = freezed,
    Object? restorationPending = null,
  }) {
    return _then(_value.copyWith(
      lastSyncPoint: freezed == lastSyncPoint
          ? _value.lastSyncPoint
          : lastSyncPoint // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncStartPoint: freezed == lastSyncStartPoint
          ? _value.lastSyncStartPoint
          : lastSyncStartPoint // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastKnownSyncCount: freezed == lastKnownSyncCount
          ? _value.lastKnownSyncCount
          : lastKnownSyncCount // ignore: cast_nullable_to_non_nullable
              as int?,
      lastKnownTotalCount: freezed == lastKnownTotalCount
          ? _value.lastKnownTotalCount
          : lastKnownTotalCount // ignore: cast_nullable_to_non_nullable
              as int?,
      restorationPending: null == restorationPending
          ? _value.restorationPending
          : restorationPending // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStatusImplCopyWith<$Res>
    implements $SyncStatusCopyWith<$Res> {
  factory _$$SyncStatusImplCopyWith(
          _$SyncStatusImpl value, $Res Function(_$SyncStatusImpl) then) =
      __$$SyncStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? lastSyncPoint,
      DateTime? lastSyncStartPoint,
      int? lastKnownSyncCount,
      int? lastKnownTotalCount,
      bool restorationPending});
}

/// @nodoc
class __$$SyncStatusImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusImpl>
    implements _$$SyncStatusImplCopyWith<$Res> {
  __$$SyncStatusImplCopyWithImpl(
      _$SyncStatusImpl _value, $Res Function(_$SyncStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastSyncPoint = freezed,
    Object? lastSyncStartPoint = freezed,
    Object? lastKnownSyncCount = freezed,
    Object? lastKnownTotalCount = freezed,
    Object? restorationPending = null,
  }) {
    return _then(_$SyncStatusImpl(
      lastSyncPoint: freezed == lastSyncPoint
          ? _value.lastSyncPoint
          : lastSyncPoint // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncStartPoint: freezed == lastSyncStartPoint
          ? _value.lastSyncStartPoint
          : lastSyncStartPoint // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastKnownSyncCount: freezed == lastKnownSyncCount
          ? _value.lastKnownSyncCount
          : lastKnownSyncCount // ignore: cast_nullable_to_non_nullable
              as int?,
      lastKnownTotalCount: freezed == lastKnownTotalCount
          ? _value.lastKnownTotalCount
          : lastKnownTotalCount // ignore: cast_nullable_to_non_nullable
              as int?,
      restorationPending: null == restorationPending
          ? _value.restorationPending
          : restorationPending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SyncStatusImpl extends _SyncStatus {
  _$SyncStatusImpl(
      {this.lastSyncPoint,
      this.lastSyncStartPoint,
      this.lastKnownSyncCount,
      this.lastKnownTotalCount,
      this.restorationPending = true})
      : super._();

  @override
  final DateTime? lastSyncPoint;
// . . . ->* . . |<- it stores the last sync end point in time.
  @override
  final DateTime? lastSyncStartPoint;
// . . . ->| . . *<- it stores the last sync start point in time.
  @override
  final int? lastKnownSyncCount;
  @override
  final int? lastKnownTotalCount;
  @override
  @JsonKey()
  final bool restorationPending;

  @override
  String toString() {
    return 'SyncStatus(lastSyncPoint: $lastSyncPoint, lastSyncStartPoint: $lastSyncStartPoint, lastKnownSyncCount: $lastKnownSyncCount, lastKnownTotalCount: $lastKnownTotalCount, restorationPending: $restorationPending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusImpl &&
            (identical(other.lastSyncPoint, lastSyncPoint) ||
                other.lastSyncPoint == lastSyncPoint) &&
            (identical(other.lastSyncStartPoint, lastSyncStartPoint) ||
                other.lastSyncStartPoint == lastSyncStartPoint) &&
            (identical(other.lastKnownSyncCount, lastKnownSyncCount) ||
                other.lastKnownSyncCount == lastKnownSyncCount) &&
            (identical(other.lastKnownTotalCount, lastKnownTotalCount) ||
                other.lastKnownTotalCount == lastKnownTotalCount) &&
            (identical(other.restorationPending, restorationPending) ||
                other.restorationPending == restorationPending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastSyncPoint,
      lastSyncStartPoint,
      lastKnownSyncCount,
      lastKnownTotalCount,
      restorationPending);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusImplCopyWith<_$SyncStatusImpl> get copyWith =>
      __$$SyncStatusImplCopyWithImpl<_$SyncStatusImpl>(this, _$identity);
}

abstract class _SyncStatus extends SyncStatus {
  factory _SyncStatus(
      {final DateTime? lastSyncPoint,
      final DateTime? lastSyncStartPoint,
      final int? lastKnownSyncCount,
      final int? lastKnownTotalCount,
      final bool restorationPending}) = _$SyncStatusImpl;
  _SyncStatus._() : super._();

  @override
  DateTime?
      get lastSyncPoint; // . . . ->* . . |<- it stores the last sync end point in time.
  @override
  DateTime?
      get lastSyncStartPoint; // . . . ->| . . *<- it stores the last sync start point in time.
  @override
  int? get lastKnownSyncCount;
  @override
  int? get lastKnownTotalCount;
  @override
  bool get restorationPending;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusImplCopyWith<_$SyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
