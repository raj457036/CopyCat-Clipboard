// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drive_setup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DriveSetupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DriveSetupState()';
}


}

/// @nodoc
class $DriveSetupStateCopyWith<$Res>  {
$DriveSetupStateCopyWith(DriveSetupState _, $Res Function(DriveSetupState) __);
}


/// Adds pattern-matching-related methods to [DriveSetupState].
extension DriveSetupStatePatterns on DriveSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DriveSetupUnknown value)?  unknown,TResult Function( DriveSetupFetching value)?  fetching,TResult Function( DriveSetupVerifyingCode value)?  verifyingCode,TResult Function( DriveSetupRefreshingToken value)?  refreshingToken,TResult Function( DriveSetupDone value)?  setupDone,TResult Function( DriveSetupError value)?  setupError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DriveSetupUnknown() when unknown != null:
return unknown(_that);case DriveSetupFetching() when fetching != null:
return fetching(_that);case DriveSetupVerifyingCode() when verifyingCode != null:
return verifyingCode(_that);case DriveSetupRefreshingToken() when refreshingToken != null:
return refreshingToken(_that);case DriveSetupDone() when setupDone != null:
return setupDone(_that);case DriveSetupError() when setupError != null:
return setupError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DriveSetupUnknown value)  unknown,required TResult Function( DriveSetupFetching value)  fetching,required TResult Function( DriveSetupVerifyingCode value)  verifyingCode,required TResult Function( DriveSetupRefreshingToken value)  refreshingToken,required TResult Function( DriveSetupDone value)  setupDone,required TResult Function( DriveSetupError value)  setupError,}){
final _that = this;
switch (_that) {
case DriveSetupUnknown():
return unknown(_that);case DriveSetupFetching():
return fetching(_that);case DriveSetupVerifyingCode():
return verifyingCode(_that);case DriveSetupRefreshingToken():
return refreshingToken(_that);case DriveSetupDone():
return setupDone(_that);case DriveSetupError():
return setupError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DriveSetupUnknown value)?  unknown,TResult? Function( DriveSetupFetching value)?  fetching,TResult? Function( DriveSetupVerifyingCode value)?  verifyingCode,TResult? Function( DriveSetupRefreshingToken value)?  refreshingToken,TResult? Function( DriveSetupDone value)?  setupDone,TResult? Function( DriveSetupError value)?  setupError,}){
final _that = this;
switch (_that) {
case DriveSetupUnknown() when unknown != null:
return unknown(_that);case DriveSetupFetching() when fetching != null:
return fetching(_that);case DriveSetupVerifyingCode() when verifyingCode != null:
return verifyingCode(_that);case DriveSetupRefreshingToken() when refreshingToken != null:
return refreshingToken(_that);case DriveSetupDone() when setupDone != null:
return setupDone(_that);case DriveSetupError() when setupError != null:
return setupError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool waiting)?  unknown,TResult Function()?  fetching,TResult Function( String code,  List<String> scopes)?  verifyingCode,TResult Function()?  refreshingToken,TResult Function( DriveAccessToken token)?  setupDone,TResult Function( Failure failure)?  setupError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DriveSetupUnknown() when unknown != null:
return unknown(_that.waiting);case DriveSetupFetching() when fetching != null:
return fetching();case DriveSetupVerifyingCode() when verifyingCode != null:
return verifyingCode(_that.code,_that.scopes);case DriveSetupRefreshingToken() when refreshingToken != null:
return refreshingToken();case DriveSetupDone() when setupDone != null:
return setupDone(_that.token);case DriveSetupError() when setupError != null:
return setupError(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool waiting)  unknown,required TResult Function()  fetching,required TResult Function( String code,  List<String> scopes)  verifyingCode,required TResult Function()  refreshingToken,required TResult Function( DriveAccessToken token)  setupDone,required TResult Function( Failure failure)  setupError,}) {final _that = this;
switch (_that) {
case DriveSetupUnknown():
return unknown(_that.waiting);case DriveSetupFetching():
return fetching();case DriveSetupVerifyingCode():
return verifyingCode(_that.code,_that.scopes);case DriveSetupRefreshingToken():
return refreshingToken();case DriveSetupDone():
return setupDone(_that.token);case DriveSetupError():
return setupError(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool waiting)?  unknown,TResult? Function()?  fetching,TResult? Function( String code,  List<String> scopes)?  verifyingCode,TResult? Function()?  refreshingToken,TResult? Function( DriveAccessToken token)?  setupDone,TResult? Function( Failure failure)?  setupError,}) {final _that = this;
switch (_that) {
case DriveSetupUnknown() when unknown != null:
return unknown(_that.waiting);case DriveSetupFetching() when fetching != null:
return fetching();case DriveSetupVerifyingCode() when verifyingCode != null:
return verifyingCode(_that.code,_that.scopes);case DriveSetupRefreshingToken() when refreshingToken != null:
return refreshingToken();case DriveSetupDone() when setupDone != null:
return setupDone(_that.token);case DriveSetupError() when setupError != null:
return setupError(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DriveSetupUnknown implements DriveSetupState {
  const DriveSetupUnknown({this.waiting = false});
  

@JsonKey() final  bool waiting;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriveSetupUnknownCopyWith<DriveSetupUnknown> get copyWith => _$DriveSetupUnknownCopyWithImpl<DriveSetupUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupUnknown&&(identical(other.waiting, waiting) || other.waiting == waiting));
}


@override
int get hashCode => Object.hash(runtimeType,waiting);

@override
String toString() {
  return 'DriveSetupState.unknown(waiting: $waiting)';
}


}

/// @nodoc
abstract mixin class $DriveSetupUnknownCopyWith<$Res> implements $DriveSetupStateCopyWith<$Res> {
  factory $DriveSetupUnknownCopyWith(DriveSetupUnknown value, $Res Function(DriveSetupUnknown) _then) = _$DriveSetupUnknownCopyWithImpl;
@useResult
$Res call({
 bool waiting
});




}
/// @nodoc
class _$DriveSetupUnknownCopyWithImpl<$Res>
    implements $DriveSetupUnknownCopyWith<$Res> {
  _$DriveSetupUnknownCopyWithImpl(this._self, this._then);

  final DriveSetupUnknown _self;
  final $Res Function(DriveSetupUnknown) _then;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? waiting = null,}) {
  return _then(DriveSetupUnknown(
waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class DriveSetupFetching implements DriveSetupState {
  const DriveSetupFetching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupFetching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DriveSetupState.fetching()';
}


}




/// @nodoc


class DriveSetupVerifyingCode implements DriveSetupState {
  const DriveSetupVerifyingCode({required this.code, required final  List<String> scopes}): _scopes = scopes;
  

 final  String code;
 final  List<String> _scopes;
 List<String> get scopes {
  if (_scopes is EqualUnmodifiableListView) return _scopes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scopes);
}


/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriveSetupVerifyingCodeCopyWith<DriveSetupVerifyingCode> get copyWith => _$DriveSetupVerifyingCodeCopyWithImpl<DriveSetupVerifyingCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupVerifyingCode&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._scopes, _scopes));
}


@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(_scopes));

@override
String toString() {
  return 'DriveSetupState.verifyingCode(code: $code, scopes: $scopes)';
}


}

/// @nodoc
abstract mixin class $DriveSetupVerifyingCodeCopyWith<$Res> implements $DriveSetupStateCopyWith<$Res> {
  factory $DriveSetupVerifyingCodeCopyWith(DriveSetupVerifyingCode value, $Res Function(DriveSetupVerifyingCode) _then) = _$DriveSetupVerifyingCodeCopyWithImpl;
@useResult
$Res call({
 String code, List<String> scopes
});




}
/// @nodoc
class _$DriveSetupVerifyingCodeCopyWithImpl<$Res>
    implements $DriveSetupVerifyingCodeCopyWith<$Res> {
  _$DriveSetupVerifyingCodeCopyWithImpl(this._self, this._then);

  final DriveSetupVerifyingCode _self;
  final $Res Function(DriveSetupVerifyingCode) _then;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? scopes = null,}) {
  return _then(DriveSetupVerifyingCode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self._scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class DriveSetupRefreshingToken implements DriveSetupState {
  const DriveSetupRefreshingToken();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupRefreshingToken);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DriveSetupState.refreshingToken()';
}


}




/// @nodoc


class DriveSetupDone implements DriveSetupState {
  const DriveSetupDone({required this.token});
  

 final  DriveAccessToken token;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriveSetupDoneCopyWith<DriveSetupDone> get copyWith => _$DriveSetupDoneCopyWithImpl<DriveSetupDone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupDone&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'DriveSetupState.setupDone(token: $token)';
}


}

/// @nodoc
abstract mixin class $DriveSetupDoneCopyWith<$Res> implements $DriveSetupStateCopyWith<$Res> {
  factory $DriveSetupDoneCopyWith(DriveSetupDone value, $Res Function(DriveSetupDone) _then) = _$DriveSetupDoneCopyWithImpl;
@useResult
$Res call({
 DriveAccessToken token
});


$DriveAccessTokenCopyWith<$Res> get token;

}
/// @nodoc
class _$DriveSetupDoneCopyWithImpl<$Res>
    implements $DriveSetupDoneCopyWith<$Res> {
  _$DriveSetupDoneCopyWithImpl(this._self, this._then);

  final DriveSetupDone _self;
  final $Res Function(DriveSetupDone) _then;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(DriveSetupDone(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as DriveAccessToken,
  ));
}

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriveAccessTokenCopyWith<$Res> get token {
  
  return $DriveAccessTokenCopyWith<$Res>(_self.token, (value) {
    return _then(_self.copyWith(token: value));
  });
}
}

/// @nodoc


class DriveSetupError implements DriveSetupState {
  const DriveSetupError({required this.failure});
  

 final  Failure failure;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriveSetupErrorCopyWith<DriveSetupError> get copyWith => _$DriveSetupErrorCopyWithImpl<DriveSetupError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveSetupError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DriveSetupState.setupError(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DriveSetupErrorCopyWith<$Res> implements $DriveSetupStateCopyWith<$Res> {
  factory $DriveSetupErrorCopyWith(DriveSetupError value, $Res Function(DriveSetupError) _then) = _$DriveSetupErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$DriveSetupErrorCopyWithImpl<$Res>
    implements $DriveSetupErrorCopyWith<$Res> {
  _$DriveSetupErrorCopyWithImpl(this._self, this._then);

  final DriveSetupError _self;
  final $Res Function(DriveSetupError) _then;

/// Create a copy of DriveSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DriveSetupError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
