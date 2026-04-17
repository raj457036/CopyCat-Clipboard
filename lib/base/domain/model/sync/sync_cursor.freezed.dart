// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_cursor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncCursor {
  /// Unique identifier for the entity type (e.g., 'clip', 'collection').
  String get entityType => throw _privateConstructorUsedError;

  /// The timestamp of the last successful pull sync.
  DateTime get lastSyncedAt => throw _privateConstructorUsedError;

  /// Offset for pagination, useful if the sync stopped mid-batch.
  int get lastOffset => throw _privateConstructorUsedError;

  /// Create a copy of SyncCursor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncCursorCopyWith<SyncCursor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncCursorCopyWith<$Res> {
  factory $SyncCursorCopyWith(
    SyncCursor value,
    $Res Function(SyncCursor) then,
  ) = _$SyncCursorCopyWithImpl<$Res, SyncCursor>;
  @useResult
  $Res call({String entityType, DateTime lastSyncedAt, int lastOffset});
}

/// @nodoc
class _$SyncCursorCopyWithImpl<$Res, $Val extends SyncCursor>
    implements $SyncCursorCopyWith<$Res> {
  _$SyncCursorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncCursor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityType = null,
    Object? lastSyncedAt = null,
    Object? lastOffset = null,
  }) {
    return _then(
      _value.copyWith(
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            lastSyncedAt: null == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastOffset: null == lastOffset
                ? _value.lastOffset
                : lastOffset // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncCursorImplCopyWith<$Res>
    implements $SyncCursorCopyWith<$Res> {
  factory _$$SyncCursorImplCopyWith(
    _$SyncCursorImpl value,
    $Res Function(_$SyncCursorImpl) then,
  ) = __$$SyncCursorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String entityType, DateTime lastSyncedAt, int lastOffset});
}

/// @nodoc
class __$$SyncCursorImplCopyWithImpl<$Res>
    extends _$SyncCursorCopyWithImpl<$Res, _$SyncCursorImpl>
    implements _$$SyncCursorImplCopyWith<$Res> {
  __$$SyncCursorImplCopyWithImpl(
    _$SyncCursorImpl _value,
    $Res Function(_$SyncCursorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncCursor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityType = null,
    Object? lastSyncedAt = null,
    Object? lastOffset = null,
  }) {
    return _then(
      _$SyncCursorImpl(
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        lastSyncedAt: null == lastSyncedAt
            ? _value.lastSyncedAt
            : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastOffset: null == lastOffset
            ? _value.lastOffset
            : lastOffset // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SyncCursorImpl implements _SyncCursor {
  const _$SyncCursorImpl({
    required this.entityType,
    required this.lastSyncedAt,
    this.lastOffset = 0,
  });

  /// Unique identifier for the entity type (e.g., 'clip', 'collection').
  @override
  final String entityType;

  /// The timestamp of the last successful pull sync.
  @override
  final DateTime lastSyncedAt;

  /// Offset for pagination, useful if the sync stopped mid-batch.
  @override
  @JsonKey()
  final int lastOffset;

  @override
  String toString() {
    return 'SyncCursor(entityType: $entityType, lastSyncedAt: $lastSyncedAt, lastOffset: $lastOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncCursorImpl &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.lastOffset, lastOffset) ||
                other.lastOffset == lastOffset));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, entityType, lastSyncedAt, lastOffset);

  /// Create a copy of SyncCursor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncCursorImplCopyWith<_$SyncCursorImpl> get copyWith =>
      __$$SyncCursorImplCopyWithImpl<_$SyncCursorImpl>(this, _$identity);
}

abstract class _SyncCursor implements SyncCursor {
  const factory _SyncCursor({
    required final String entityType,
    required final DateTime lastSyncedAt,
    final int lastOffset,
  }) = _$SyncCursorImpl;

  /// Unique identifier for the entity type (e.g., 'clip', 'collection').
  @override
  String get entityType;

  /// The timestamp of the last successful pull sync.
  @override
  DateTime get lastSyncedAt;

  /// Offset for pagination, useful if the sync stopped mid-batch.
  @override
  int get lastOffset;

  /// Create a copy of SyncCursor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncCursorImplCopyWith<_$SyncCursorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
