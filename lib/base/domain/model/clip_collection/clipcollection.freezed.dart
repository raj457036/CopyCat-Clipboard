// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clipcollection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClipCollection {

@JsonKey(includeToJson: false, includeFromJson: false) int? get id;@JsonKey(name: "id", includeToJson: false) int? get serverId;@JsonKey(includeFromJson: false, includeToJson: false) DateTime? get lastSynced;@JsonKey(name: "created")@DateTimeConverter() DateTime get created;@JsonKey(name: "modified")@DateTimeConverter() DateTime get modified; String get userId;@DateTimeConverter() DateTime? get deletedAt; String? get deviceId; String get title; String? get description; String get emoji;
/// Create a copy of ClipCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipCollectionCopyWith<ClipCollection> get copyWith => _$ClipCollectionCopyWithImpl<ClipCollection>(this as ClipCollection, _$identity);

  /// Serializes this ClipCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.lastSynced, lastSynced) || other.lastSynced == lastSynced)&&(identical(other.created, created) || other.created == created)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,lastSynced,created,modified,userId,deletedAt,deviceId,title,description,emoji);

@override
String toString() {
  return 'ClipCollection(id: $id, serverId: $serverId, lastSynced: $lastSynced, created: $created, modified: $modified, userId: $userId, deletedAt: $deletedAt, deviceId: $deviceId, title: $title, description: $description, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $ClipCollectionCopyWith<$Res>  {
  factory $ClipCollectionCopyWith(ClipCollection value, $Res Function(ClipCollection) _then) = _$ClipCollectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false, includeFromJson: false) int? id,@JsonKey(name: "id", includeToJson: false) int? serverId,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? lastSynced,@JsonKey(name: "created")@DateTimeConverter() DateTime created,@JsonKey(name: "modified")@DateTimeConverter() DateTime modified, String userId,@DateTimeConverter() DateTime? deletedAt, String? deviceId, String title, String? description, String emoji
});




}
/// @nodoc
class _$ClipCollectionCopyWithImpl<$Res>
    implements $ClipCollectionCopyWith<$Res> {
  _$ClipCollectionCopyWithImpl(this._self, this._then);

  final ClipCollection _self;
  final $Res Function(ClipCollection) _then;

/// Create a copy of ClipCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? serverId = freezed,Object? lastSynced = freezed,Object? created = null,Object? modified = null,Object? userId = null,Object? deletedAt = freezed,Object? deviceId = freezed,Object? title = null,Object? description = freezed,Object? emoji = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as int?,lastSynced: freezed == lastSynced ? _self.lastSynced : lastSynced // ignore: cast_nullable_to_non_nullable
as DateTime?,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,modified: null == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClipCollection].
extension ClipCollectionPatterns on ClipCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClipCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClipCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClipCollection value)  $default,){
final _that = this;
switch (_that) {
case _ClipCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClipCollection value)?  $default,){
final _that = this;
switch (_that) {
case _ClipCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, includeFromJson: false)  int? id, @JsonKey(name: "id", includeToJson: false)  int? serverId, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? lastSynced, @JsonKey(name: "created")@DateTimeConverter()  DateTime created, @JsonKey(name: "modified")@DateTimeConverter()  DateTime modified,  String userId, @DateTimeConverter()  DateTime? deletedAt,  String? deviceId,  String title,  String? description,  String emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClipCollection() when $default != null:
return $default(_that.id,_that.serverId,_that.lastSynced,_that.created,_that.modified,_that.userId,_that.deletedAt,_that.deviceId,_that.title,_that.description,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, includeFromJson: false)  int? id, @JsonKey(name: "id", includeToJson: false)  int? serverId, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? lastSynced, @JsonKey(name: "created")@DateTimeConverter()  DateTime created, @JsonKey(name: "modified")@DateTimeConverter()  DateTime modified,  String userId, @DateTimeConverter()  DateTime? deletedAt,  String? deviceId,  String title,  String? description,  String emoji)  $default,) {final _that = this;
switch (_that) {
case _ClipCollection():
return $default(_that.id,_that.serverId,_that.lastSynced,_that.created,_that.modified,_that.userId,_that.deletedAt,_that.deviceId,_that.title,_that.description,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false, includeFromJson: false)  int? id, @JsonKey(name: "id", includeToJson: false)  int? serverId, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? lastSynced, @JsonKey(name: "created")@DateTimeConverter()  DateTime created, @JsonKey(name: "modified")@DateTimeConverter()  DateTime modified,  String userId, @DateTimeConverter()  DateTime? deletedAt,  String? deviceId,  String title,  String? description,  String emoji)?  $default,) {final _that = this;
switch (_that) {
case _ClipCollection() when $default != null:
return $default(_that.id,_that.serverId,_that.lastSynced,_that.created,_that.modified,_that.userId,_that.deletedAt,_that.deviceId,_that.title,_that.description,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClipCollection extends ClipCollection {
   _ClipCollection({@JsonKey(includeToJson: false, includeFromJson: false) this.id, @JsonKey(name: "id", includeToJson: false) this.serverId, @JsonKey(includeFromJson: false, includeToJson: false) this.lastSynced, @JsonKey(name: "created")@DateTimeConverter() required this.created, @JsonKey(name: "modified")@DateTimeConverter() required this.modified, this.userId = kLocalUserId, @DateTimeConverter() this.deletedAt, this.deviceId, required this.title, this.description, required this.emoji}): super._();
  factory _ClipCollection.fromJson(Map<String, dynamic> json) => _$ClipCollectionFromJson(json);

@override@JsonKey(includeToJson: false, includeFromJson: false) final  int? id;
@override@JsonKey(name: "id", includeToJson: false) final  int? serverId;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  DateTime? lastSynced;
@override@JsonKey(name: "created")@DateTimeConverter() final  DateTime created;
@override@JsonKey(name: "modified")@DateTimeConverter() final  DateTime modified;
@override@JsonKey() final  String userId;
@override@DateTimeConverter() final  DateTime? deletedAt;
@override final  String? deviceId;
@override final  String title;
@override final  String? description;
@override final  String emoji;

/// Create a copy of ClipCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClipCollectionCopyWith<_ClipCollection> get copyWith => __$ClipCollectionCopyWithImpl<_ClipCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClipCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClipCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.lastSynced, lastSynced) || other.lastSynced == lastSynced)&&(identical(other.created, created) || other.created == created)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,lastSynced,created,modified,userId,deletedAt,deviceId,title,description,emoji);

@override
String toString() {
  return 'ClipCollection(id: $id, serverId: $serverId, lastSynced: $lastSynced, created: $created, modified: $modified, userId: $userId, deletedAt: $deletedAt, deviceId: $deviceId, title: $title, description: $description, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$ClipCollectionCopyWith<$Res> implements $ClipCollectionCopyWith<$Res> {
  factory _$ClipCollectionCopyWith(_ClipCollection value, $Res Function(_ClipCollection) _then) = __$ClipCollectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false, includeFromJson: false) int? id,@JsonKey(name: "id", includeToJson: false) int? serverId,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? lastSynced,@JsonKey(name: "created")@DateTimeConverter() DateTime created,@JsonKey(name: "modified")@DateTimeConverter() DateTime modified, String userId,@DateTimeConverter() DateTime? deletedAt, String? deviceId, String title, String? description, String emoji
});




}
/// @nodoc
class __$ClipCollectionCopyWithImpl<$Res>
    implements _$ClipCollectionCopyWith<$Res> {
  __$ClipCollectionCopyWithImpl(this._self, this._then);

  final _ClipCollection _self;
  final $Res Function(_ClipCollection) _then;

/// Create a copy of ClipCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? serverId = freezed,Object? lastSynced = freezed,Object? created = null,Object? modified = null,Object? userId = null,Object? deletedAt = freezed,Object? deviceId = freezed,Object? title = null,Object? description = freezed,Object? emoji = null,}) {
  return _then(_ClipCollection(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as int?,lastSynced: freezed == lastSynced ? _self.lastSynced : lastSynced // ignore: cast_nullable_to_non_nullable
as DateTime?,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,modified: null == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
