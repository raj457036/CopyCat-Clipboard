// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncStatusState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncStatusState()';
}


}

/// @nodoc
class $SyncStatusStateCopyWith<$Res>  {
$SyncStatusStateCopyWith(SyncStatusState _, $Res Function(SyncStatusState) __);
}


/// Adds pattern-matching-related methods to [SyncStatusState].
extension SyncStatusStatePatterns on SyncStatusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SyncStatusUnknown value)?  unknown,TResult Function( SyncingStatus value)?  syncing,TResult Function( SyncStatusDecrypting value)?  decrypting,TResult Function( SyncStatusComplete value)?  complete,TResult Function( SyncStatusFailed value)?  failed,TResult Function( SyncStatusDisabled value)?  disabled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SyncStatusUnknown() when unknown != null:
return unknown(_that);case SyncingStatus() when syncing != null:
return syncing(_that);case SyncStatusDecrypting() when decrypting != null:
return decrypting(_that);case SyncStatusComplete() when complete != null:
return complete(_that);case SyncStatusFailed() when failed != null:
return failed(_that);case SyncStatusDisabled() when disabled != null:
return disabled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SyncStatusUnknown value)  unknown,required TResult Function( SyncingStatus value)  syncing,required TResult Function( SyncStatusDecrypting value)  decrypting,required TResult Function( SyncStatusComplete value)  complete,required TResult Function( SyncStatusFailed value)  failed,required TResult Function( SyncStatusDisabled value)  disabled,}){
final _that = this;
switch (_that) {
case SyncStatusUnknown():
return unknown(_that);case SyncingStatus():
return syncing(_that);case SyncStatusDecrypting():
return decrypting(_that);case SyncStatusComplete():
return complete(_that);case SyncStatusFailed():
return failed(_that);case SyncStatusDisabled():
return disabled(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SyncStatusUnknown value)?  unknown,TResult? Function( SyncingStatus value)?  syncing,TResult? Function( SyncStatusDecrypting value)?  decrypting,TResult? Function( SyncStatusComplete value)?  complete,TResult? Function( SyncStatusFailed value)?  failed,TResult? Function( SyncStatusDisabled value)?  disabled,}){
final _that = this;
switch (_that) {
case SyncStatusUnknown() when unknown != null:
return unknown(_that);case SyncingStatus() when syncing != null:
return syncing(_that);case SyncStatusDecrypting() when decrypting != null:
return decrypting(_that);case SyncStatusComplete() when complete != null:
return complete(_that);case SyncStatusFailed() when failed != null:
return failed(_that);case SyncStatusDisabled() when disabled != null:
return disabled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( Map<String, SyncProgress> progress)?  syncing,TResult Function( int decrypted,  int total)?  decrypting,TResult Function( bool hasUpdates)?  complete,TResult Function( Failure failure)?  failed,TResult Function()?  disabled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SyncStatusUnknown() when unknown != null:
return unknown();case SyncingStatus() when syncing != null:
return syncing(_that.progress);case SyncStatusDecrypting() when decrypting != null:
return decrypting(_that.decrypted,_that.total);case SyncStatusComplete() when complete != null:
return complete(_that.hasUpdates);case SyncStatusFailed() when failed != null:
return failed(_that.failure);case SyncStatusDisabled() when disabled != null:
return disabled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( Map<String, SyncProgress> progress)  syncing,required TResult Function( int decrypted,  int total)  decrypting,required TResult Function( bool hasUpdates)  complete,required TResult Function( Failure failure)  failed,required TResult Function()  disabled,}) {final _that = this;
switch (_that) {
case SyncStatusUnknown():
return unknown();case SyncingStatus():
return syncing(_that.progress);case SyncStatusDecrypting():
return decrypting(_that.decrypted,_that.total);case SyncStatusComplete():
return complete(_that.hasUpdates);case SyncStatusFailed():
return failed(_that.failure);case SyncStatusDisabled():
return disabled();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( Map<String, SyncProgress> progress)?  syncing,TResult? Function( int decrypted,  int total)?  decrypting,TResult? Function( bool hasUpdates)?  complete,TResult? Function( Failure failure)?  failed,TResult? Function()?  disabled,}) {final _that = this;
switch (_that) {
case SyncStatusUnknown() when unknown != null:
return unknown();case SyncingStatus() when syncing != null:
return syncing(_that.progress);case SyncStatusDecrypting() when decrypting != null:
return decrypting(_that.decrypted,_that.total);case SyncStatusComplete() when complete != null:
return complete(_that.hasUpdates);case SyncStatusFailed() when failed != null:
return failed(_that.failure);case SyncStatusDisabled() when disabled != null:
return disabled();case _:
  return null;

}
}

}

/// @nodoc


class SyncStatusUnknown implements SyncStatusState {
  const SyncStatusUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncStatusState.unknown()';
}


}




/// @nodoc


class SyncingStatus implements SyncStatusState {
  const SyncingStatus({final  Map<String, SyncProgress> progress = const <String, SyncProgress>{}}): _progress = progress;
  

 final  Map<String, SyncProgress> _progress;
@JsonKey() Map<String, SyncProgress> get progress {
  if (_progress is EqualUnmodifiableMapView) return _progress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_progress);
}


/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncingStatusCopyWith<SyncingStatus> get copyWith => _$SyncingStatusCopyWithImpl<SyncingStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncingStatus&&const DeepCollectionEquality().equals(other._progress, _progress));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_progress));

@override
String toString() {
  return 'SyncStatusState.syncing(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $SyncingStatusCopyWith<$Res> implements $SyncStatusStateCopyWith<$Res> {
  factory $SyncingStatusCopyWith(SyncingStatus value, $Res Function(SyncingStatus) _then) = _$SyncingStatusCopyWithImpl;
@useResult
$Res call({
 Map<String, SyncProgress> progress
});




}
/// @nodoc
class _$SyncingStatusCopyWithImpl<$Res>
    implements $SyncingStatusCopyWith<$Res> {
  _$SyncingStatusCopyWithImpl(this._self, this._then);

  final SyncingStatus _self;
  final $Res Function(SyncingStatus) _then;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,}) {
  return _then(SyncingStatus(
progress: null == progress ? _self._progress : progress // ignore: cast_nullable_to_non_nullable
as Map<String, SyncProgress>,
  ));
}


}

/// @nodoc


class SyncStatusDecrypting implements SyncStatusState {
  const SyncStatusDecrypting({this.decrypted = 0, this.total = 0});
  

@JsonKey() final  int decrypted;
@JsonKey() final  int total;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStatusDecryptingCopyWith<SyncStatusDecrypting> get copyWith => _$SyncStatusDecryptingCopyWithImpl<SyncStatusDecrypting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusDecrypting&&(identical(other.decrypted, decrypted) || other.decrypted == decrypted)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,decrypted,total);

@override
String toString() {
  return 'SyncStatusState.decrypting(decrypted: $decrypted, total: $total)';
}


}

/// @nodoc
abstract mixin class $SyncStatusDecryptingCopyWith<$Res> implements $SyncStatusStateCopyWith<$Res> {
  factory $SyncStatusDecryptingCopyWith(SyncStatusDecrypting value, $Res Function(SyncStatusDecrypting) _then) = _$SyncStatusDecryptingCopyWithImpl;
@useResult
$Res call({
 int decrypted, int total
});




}
/// @nodoc
class _$SyncStatusDecryptingCopyWithImpl<$Res>
    implements $SyncStatusDecryptingCopyWith<$Res> {
  _$SyncStatusDecryptingCopyWithImpl(this._self, this._then);

  final SyncStatusDecrypting _self;
  final $Res Function(SyncStatusDecrypting) _then;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? decrypted = null,Object? total = null,}) {
  return _then(SyncStatusDecrypting(
decrypted: null == decrypted ? _self.decrypted : decrypted // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SyncStatusComplete implements SyncStatusState {
  const SyncStatusComplete({this.hasUpdates = false});
  

@JsonKey() final  bool hasUpdates;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStatusCompleteCopyWith<SyncStatusComplete> get copyWith => _$SyncStatusCompleteCopyWithImpl<SyncStatusComplete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusComplete&&(identical(other.hasUpdates, hasUpdates) || other.hasUpdates == hasUpdates));
}


@override
int get hashCode => Object.hash(runtimeType,hasUpdates);

@override
String toString() {
  return 'SyncStatusState.complete(hasUpdates: $hasUpdates)';
}


}

/// @nodoc
abstract mixin class $SyncStatusCompleteCopyWith<$Res> implements $SyncStatusStateCopyWith<$Res> {
  factory $SyncStatusCompleteCopyWith(SyncStatusComplete value, $Res Function(SyncStatusComplete) _then) = _$SyncStatusCompleteCopyWithImpl;
@useResult
$Res call({
 bool hasUpdates
});




}
/// @nodoc
class _$SyncStatusCompleteCopyWithImpl<$Res>
    implements $SyncStatusCompleteCopyWith<$Res> {
  _$SyncStatusCompleteCopyWithImpl(this._self, this._then);

  final SyncStatusComplete _self;
  final $Res Function(SyncStatusComplete) _then;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hasUpdates = null,}) {
  return _then(SyncStatusComplete(
hasUpdates: null == hasUpdates ? _self.hasUpdates : hasUpdates // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SyncStatusFailed implements SyncStatusState {
  const SyncStatusFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStatusFailedCopyWith<SyncStatusFailed> get copyWith => _$SyncStatusFailedCopyWithImpl<SyncStatusFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SyncStatusState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SyncStatusFailedCopyWith<$Res> implements $SyncStatusStateCopyWith<$Res> {
  factory $SyncStatusFailedCopyWith(SyncStatusFailed value, $Res Function(SyncStatusFailed) _then) = _$SyncStatusFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$SyncStatusFailedCopyWithImpl<$Res>
    implements $SyncStatusFailedCopyWith<$Res> {
  _$SyncStatusFailedCopyWithImpl(this._self, this._then);

  final SyncStatusFailed _self;
  final $Res Function(SyncStatusFailed) _then;

/// Create a copy of SyncStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SyncStatusFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

/// @nodoc


class SyncStatusDisabled implements SyncStatusState {
  const SyncStatusDisabled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusDisabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncStatusState.disabled()';
}


}




// dart format on
