// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_outbox_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncOutboxEntry {

/// Local database ID of the outbox entry (not the entity).
@JsonKey(includeToJson: false, includeFromJson: false) int? get id;/// The type of entity being synced (e.g., 'clip', 'collection').
 String get entityType;/// The local ID of the target entity.
 int get localId;/// The action to perform on the server.
 SyncOutboxAction get action;/// When this entry was enqueued.
 DateTime get createdAt;/// The last failure message, if any.
 String? get lastError;
/// Create a copy of SyncOutboxEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncOutboxEntryCopyWith<SyncOutboxEntry> get copyWith => _$SyncOutboxEntryCopyWithImpl<SyncOutboxEntry>(this as SyncOutboxEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncOutboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.action, action) || other.action == action)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,id,entityType,localId,action,createdAt,lastError);

@override
String toString() {
  return 'SyncOutboxEntry(id: $id, entityType: $entityType, localId: $localId, action: $action, createdAt: $createdAt, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $SyncOutboxEntryCopyWith<$Res>  {
  factory $SyncOutboxEntryCopyWith(SyncOutboxEntry value, $Res Function(SyncOutboxEntry) _then) = _$SyncOutboxEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false, includeFromJson: false) int? id, String entityType, int localId, SyncOutboxAction action, DateTime createdAt, String? lastError
});




}
/// @nodoc
class _$SyncOutboxEntryCopyWithImpl<$Res>
    implements $SyncOutboxEntryCopyWith<$Res> {
  _$SyncOutboxEntryCopyWithImpl(this._self, this._then);

  final SyncOutboxEntry _self;
  final $Res Function(SyncOutboxEntry) _then;

/// Create a copy of SyncOutboxEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? entityType = null,Object? localId = null,Object? action = null,Object? createdAt = null,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as int,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SyncOutboxAction,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncOutboxEntry].
extension SyncOutboxEntryPatterns on SyncOutboxEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncOutboxEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncOutboxEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncOutboxEntry value)  $default,){
final _that = this;
switch (_that) {
case _SyncOutboxEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncOutboxEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SyncOutboxEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, includeFromJson: false)  int? id,  String entityType,  int localId,  SyncOutboxAction action,  DateTime createdAt,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncOutboxEntry() when $default != null:
return $default(_that.id,_that.entityType,_that.localId,_that.action,_that.createdAt,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, includeFromJson: false)  int? id,  String entityType,  int localId,  SyncOutboxAction action,  DateTime createdAt,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _SyncOutboxEntry():
return $default(_that.id,_that.entityType,_that.localId,_that.action,_that.createdAt,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false, includeFromJson: false)  int? id,  String entityType,  int localId,  SyncOutboxAction action,  DateTime createdAt,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _SyncOutboxEntry() when $default != null:
return $default(_that.id,_that.entityType,_that.localId,_that.action,_that.createdAt,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc


class _SyncOutboxEntry implements SyncOutboxEntry {
  const _SyncOutboxEntry({@JsonKey(includeToJson: false, includeFromJson: false) this.id, required this.entityType, required this.localId, required this.action, required this.createdAt, this.lastError});
  

/// Local database ID of the outbox entry (not the entity).
@override@JsonKey(includeToJson: false, includeFromJson: false) final  int? id;
/// The type of entity being synced (e.g., 'clip', 'collection').
@override final  String entityType;
/// The local ID of the target entity.
@override final  int localId;
/// The action to perform on the server.
@override final  SyncOutboxAction action;
/// When this entry was enqueued.
@override final  DateTime createdAt;
/// The last failure message, if any.
@override final  String? lastError;

/// Create a copy of SyncOutboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncOutboxEntryCopyWith<_SyncOutboxEntry> get copyWith => __$SyncOutboxEntryCopyWithImpl<_SyncOutboxEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncOutboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.action, action) || other.action == action)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,id,entityType,localId,action,createdAt,lastError);

@override
String toString() {
  return 'SyncOutboxEntry(id: $id, entityType: $entityType, localId: $localId, action: $action, createdAt: $createdAt, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$SyncOutboxEntryCopyWith<$Res> implements $SyncOutboxEntryCopyWith<$Res> {
  factory _$SyncOutboxEntryCopyWith(_SyncOutboxEntry value, $Res Function(_SyncOutboxEntry) _then) = __$SyncOutboxEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false, includeFromJson: false) int? id, String entityType, int localId, SyncOutboxAction action, DateTime createdAt, String? lastError
});




}
/// @nodoc
class __$SyncOutboxEntryCopyWithImpl<$Res>
    implements _$SyncOutboxEntryCopyWith<$Res> {
  __$SyncOutboxEntryCopyWithImpl(this._self, this._then);

  final _SyncOutboxEntry _self;
  final $Res Function(_SyncOutboxEntry) _then;

/// Create a copy of SyncOutboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? entityType = null,Object? localId = null,Object? action = null,Object? createdAt = null,Object? lastError = freezed,}) {
  return _then(_SyncOutboxEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as int,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SyncOutboxAction,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
