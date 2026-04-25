// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_outbox_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncOutboxEntry {
  /// Local database ID of the outbox entry (not the entity).
  @JsonKey(includeToJson: false, includeFromJson: false)
  int? get id => throw _privateConstructorUsedError;

  /// The type of entity being synced (e.g., 'clip', 'collection').
  String get entityType => throw _privateConstructorUsedError;

  /// The local ID of the target entity.
  int get localId => throw _privateConstructorUsedError;

  /// The action to perform on the server.
  SyncOutboxAction get action => throw _privateConstructorUsedError;

  /// When this entry was enqueued.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// The last failure message, if any.
  String? get lastError => throw _privateConstructorUsedError;

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncOutboxEntryCopyWith<SyncOutboxEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncOutboxEntryCopyWith<$Res> {
  factory $SyncOutboxEntryCopyWith(
    SyncOutboxEntry value,
    $Res Function(SyncOutboxEntry) then,
  ) = _$SyncOutboxEntryCopyWithImpl<$Res, SyncOutboxEntry>;
  @useResult
  $Res call({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    String entityType,
    int localId,
    SyncOutboxAction action,
    DateTime createdAt,
    String? lastError,
  });
}

/// @nodoc
class _$SyncOutboxEntryCopyWithImpl<$Res, $Val extends SyncOutboxEntry>
    implements $SyncOutboxEntryCopyWith<$Res> {
  _$SyncOutboxEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? entityType = null,
    Object? localId = null,
    Object? action = null,
    Object? createdAt = null,
    Object? lastError = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            localId: null == localId
                ? _value.localId
                : localId // ignore: cast_nullable_to_non_nullable
                      as int,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as SyncOutboxAction,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastError: freezed == lastError
                ? _value.lastError
                : lastError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncOutboxEntryImplCopyWith<$Res>
    implements $SyncOutboxEntryCopyWith<$Res> {
  factory _$$SyncOutboxEntryImplCopyWith(
    _$SyncOutboxEntryImpl value,
    $Res Function(_$SyncOutboxEntryImpl) then,
  ) = __$$SyncOutboxEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    String entityType,
    int localId,
    SyncOutboxAction action,
    DateTime createdAt,
    String? lastError,
  });
}

/// @nodoc
class __$$SyncOutboxEntryImplCopyWithImpl<$Res>
    extends _$SyncOutboxEntryCopyWithImpl<$Res, _$SyncOutboxEntryImpl>
    implements _$$SyncOutboxEntryImplCopyWith<$Res> {
  __$$SyncOutboxEntryImplCopyWithImpl(
    _$SyncOutboxEntryImpl _value,
    $Res Function(_$SyncOutboxEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? entityType = null,
    Object? localId = null,
    Object? action = null,
    Object? createdAt = null,
    Object? lastError = freezed,
  }) {
    return _then(
      _$SyncOutboxEntryImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        localId: null == localId
            ? _value.localId
            : localId // ignore: cast_nullable_to_non_nullable
                  as int,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as SyncOutboxAction,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastError: freezed == lastError
            ? _value.lastError
            : lastError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SyncOutboxEntryImpl implements _SyncOutboxEntry {
  const _$SyncOutboxEntryImpl({
    @JsonKey(includeToJson: false, includeFromJson: false) this.id,
    required this.entityType,
    required this.localId,
    required this.action,
    required this.createdAt,
    this.lastError,
  });

  /// Local database ID of the outbox entry (not the entity).
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final int? id;

  /// The type of entity being synced (e.g., 'clip', 'collection').
  @override
  final String entityType;

  /// The local ID of the target entity.
  @override
  final int localId;

  /// The action to perform on the server.
  @override
  final SyncOutboxAction action;

  /// When this entry was enqueued.
  @override
  final DateTime createdAt;

  /// The last failure message, if any.
  @override
  final String? lastError;

  @override
  String toString() {
    return 'SyncOutboxEntry(id: $id, entityType: $entityType, localId: $localId, action: $action, createdAt: $createdAt, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncOutboxEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    localId,
    action,
    createdAt,
    lastError,
  );

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncOutboxEntryImplCopyWith<_$SyncOutboxEntryImpl> get copyWith =>
      __$$SyncOutboxEntryImplCopyWithImpl<_$SyncOutboxEntryImpl>(
        this,
        _$identity,
      );
}

abstract class _SyncOutboxEntry implements SyncOutboxEntry {
  const factory _SyncOutboxEntry({
    @JsonKey(includeToJson: false, includeFromJson: false) final int? id,
    required final String entityType,
    required final int localId,
    required final SyncOutboxAction action,
    required final DateTime createdAt,
    final String? lastError,
  }) = _$SyncOutboxEntryImpl;

  /// Local database ID of the outbox entry (not the entity).
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  int? get id;

  /// The type of entity being synced (e.g., 'clip', 'collection').
  @override
  String get entityType;

  /// The local ID of the target entity.
  @override
  int get localId;

  /// The action to perform on the server.
  @override
  SyncOutboxAction get action;

  /// When this entry was enqueued.
  @override
  DateTime get createdAt;

  /// The last failure message, if any.
  @override
  String? get lastError;

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncOutboxEntryImplCopyWith<_$SyncOutboxEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
