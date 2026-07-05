// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_persistance_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfflinePersistanceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflinePersistanceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflinePersistanceState()';
}


}

/// @nodoc
class $OfflinePersistanceStateCopyWith<$Res>  {
$OfflinePersistanceStateCopyWith(OfflinePersistanceState _, $Res Function(OfflinePersistanceState) __);
}


/// Adds pattern-matching-related methods to [OfflinePersistanceState].
extension OfflinePersistanceStatePatterns on OfflinePersistanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OfflinePersistanceInitial value)?  initial,TResult Function( OfflinePersistanceSaved value)?  saved,TResult Function( OfflinePersistanceError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OfflinePersistanceInitial() when initial != null:
return initial(_that);case OfflinePersistanceSaved() when saved != null:
return saved(_that);case OfflinePersistanceError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OfflinePersistanceInitial value)  initial,required TResult Function( OfflinePersistanceSaved value)  saved,required TResult Function( OfflinePersistanceError value)  error,}){
final _that = this;
switch (_that) {
case OfflinePersistanceInitial():
return initial(_that);case OfflinePersistanceSaved():
return saved(_that);case OfflinePersistanceError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OfflinePersistanceInitial value)?  initial,TResult? Function( OfflinePersistanceSaved value)?  saved,TResult? Function( OfflinePersistanceError value)?  error,}){
final _that = this;
switch (_that) {
case OfflinePersistanceInitial() when initial != null:
return initial(_that);case OfflinePersistanceSaved() when saved != null:
return saved(_that);case OfflinePersistanceError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int count,  bool created,  bool synced,  List<String>? updatedFields)?  saved,TResult Function( Failure failure,  ClipboardItem? item)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OfflinePersistanceInitial() when initial != null:
return initial();case OfflinePersistanceSaved() when saved != null:
return saved(_that.count,_that.created,_that.synced,_that.updatedFields);case OfflinePersistanceError() when error != null:
return error(_that.failure,_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int count,  bool created,  bool synced,  List<String>? updatedFields)  saved,required TResult Function( Failure failure,  ClipboardItem? item)  error,}) {final _that = this;
switch (_that) {
case OfflinePersistanceInitial():
return initial();case OfflinePersistanceSaved():
return saved(_that.count,_that.created,_that.synced,_that.updatedFields);case OfflinePersistanceError():
return error(_that.failure,_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int count,  bool created,  bool synced,  List<String>? updatedFields)?  saved,TResult? Function( Failure failure,  ClipboardItem? item)?  error,}) {final _that = this;
switch (_that) {
case OfflinePersistanceInitial() when initial != null:
return initial();case OfflinePersistanceSaved() when saved != null:
return saved(_that.count,_that.created,_that.synced,_that.updatedFields);case OfflinePersistanceError() when error != null:
return error(_that.failure,_that.item);case _:
  return null;

}
}

}

/// @nodoc


class OfflinePersistanceInitial implements OfflinePersistanceState {
  const OfflinePersistanceInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflinePersistanceInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflinePersistanceState.initial()';
}


}




/// @nodoc


class OfflinePersistanceSaved implements OfflinePersistanceState {
  const OfflinePersistanceSaved({this.count = 0, this.created = false, this.synced = false, final  List<String>? updatedFields}): _updatedFields = updatedFields;
  

@JsonKey() final  int count;
@JsonKey() final  bool created;
@JsonKey() final  bool synced;
 final  List<String>? _updatedFields;
 List<String>? get updatedFields {
  final value = _updatedFields;
  if (value == null) return null;
  if (_updatedFields is EqualUnmodifiableListView) return _updatedFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of OfflinePersistanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfflinePersistanceSavedCopyWith<OfflinePersistanceSaved> get copyWith => _$OfflinePersistanceSavedCopyWithImpl<OfflinePersistanceSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflinePersistanceSaved&&(identical(other.count, count) || other.count == count)&&(identical(other.created, created) || other.created == created)&&(identical(other.synced, synced) || other.synced == synced)&&const DeepCollectionEquality().equals(other._updatedFields, _updatedFields));
}


@override
int get hashCode => Object.hash(runtimeType,count,created,synced,const DeepCollectionEquality().hash(_updatedFields));

@override
String toString() {
  return 'OfflinePersistanceState.saved(count: $count, created: $created, synced: $synced, updatedFields: $updatedFields)';
}


}

/// @nodoc
abstract mixin class $OfflinePersistanceSavedCopyWith<$Res> implements $OfflinePersistanceStateCopyWith<$Res> {
  factory $OfflinePersistanceSavedCopyWith(OfflinePersistanceSaved value, $Res Function(OfflinePersistanceSaved) _then) = _$OfflinePersistanceSavedCopyWithImpl;
@useResult
$Res call({
 int count, bool created, bool synced, List<String>? updatedFields
});




}
/// @nodoc
class _$OfflinePersistanceSavedCopyWithImpl<$Res>
    implements $OfflinePersistanceSavedCopyWith<$Res> {
  _$OfflinePersistanceSavedCopyWithImpl(this._self, this._then);

  final OfflinePersistanceSaved _self;
  final $Res Function(OfflinePersistanceSaved) _then;

/// Create a copy of OfflinePersistanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? created = null,Object? synced = null,Object? updatedFields = freezed,}) {
  return _then(OfflinePersistanceSaved(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as bool,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,updatedFields: freezed == updatedFields ? _self._updatedFields : updatedFields // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc


class OfflinePersistanceError implements OfflinePersistanceState {
  const OfflinePersistanceError(this.failure, [this.item]);
  

 final  Failure failure;
 final  ClipboardItem? item;

/// Create a copy of OfflinePersistanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfflinePersistanceErrorCopyWith<OfflinePersistanceError> get copyWith => _$OfflinePersistanceErrorCopyWithImpl<OfflinePersistanceError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflinePersistanceError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,failure,item);

@override
String toString() {
  return 'OfflinePersistanceState.error(failure: $failure, item: $item)';
}


}

/// @nodoc
abstract mixin class $OfflinePersistanceErrorCopyWith<$Res> implements $OfflinePersistanceStateCopyWith<$Res> {
  factory $OfflinePersistanceErrorCopyWith(OfflinePersistanceError value, $Res Function(OfflinePersistanceError) _then) = _$OfflinePersistanceErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure, ClipboardItem? item
});


$ClipboardItemCopyWith<$Res>? get item;

}
/// @nodoc
class _$OfflinePersistanceErrorCopyWithImpl<$Res>
    implements $OfflinePersistanceErrorCopyWith<$Res> {
  _$OfflinePersistanceErrorCopyWithImpl(this._self, this._then);

  final OfflinePersistanceError _self;
  final $Res Function(OfflinePersistanceError) _then;

/// Create a copy of OfflinePersistanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? item = freezed,}) {
  return _then(OfflinePersistanceError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ClipboardItem?,
  ));
}

/// Create a copy of OfflinePersistanceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClipboardItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $ClipboardItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
