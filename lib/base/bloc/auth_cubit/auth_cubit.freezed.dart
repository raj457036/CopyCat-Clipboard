// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UnknownAuthState value)?  unknown,TResult Function( AuthenticatedAuthState value)?  authenticated,TResult Function( LocalAuthenticatedAuthState value)?  localAuthenticated,TResult Function( AuthenticatingAuthState value)?  authenticating,TResult Function( UnauthenticatedAuthState value)?  unauthenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UnknownAuthState() when unknown != null:
return unknown(_that);case AuthenticatedAuthState() when authenticated != null:
return authenticated(_that);case LocalAuthenticatedAuthState() when localAuthenticated != null:
return localAuthenticated(_that);case AuthenticatingAuthState() when authenticating != null:
return authenticating(_that);case UnauthenticatedAuthState() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UnknownAuthState value)  unknown,required TResult Function( AuthenticatedAuthState value)  authenticated,required TResult Function( LocalAuthenticatedAuthState value)  localAuthenticated,required TResult Function( AuthenticatingAuthState value)  authenticating,required TResult Function( UnauthenticatedAuthState value)  unauthenticated,}){
final _that = this;
switch (_that) {
case UnknownAuthState():
return unknown(_that);case AuthenticatedAuthState():
return authenticated(_that);case LocalAuthenticatedAuthState():
return localAuthenticated(_that);case AuthenticatingAuthState():
return authenticating(_that);case UnauthenticatedAuthState():
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UnknownAuthState value)?  unknown,TResult? Function( AuthenticatedAuthState value)?  authenticated,TResult? Function( LocalAuthenticatedAuthState value)?  localAuthenticated,TResult? Function( AuthenticatingAuthState value)?  authenticating,TResult? Function( UnauthenticatedAuthState value)?  unauthenticated,}){
final _that = this;
switch (_that) {
case UnknownAuthState() when unknown != null:
return unknown(_that);case AuthenticatedAuthState() when authenticated != null:
return authenticated(_that);case LocalAuthenticatedAuthState() when localAuthenticated != null:
return localAuthenticated(_that);case AuthenticatingAuthState() when authenticating != null:
return authenticating(_that);case UnauthenticatedAuthState() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( AuthUser user,  String accessToken,  bool isOnboardingCompleted,  bool isEncryptionKeySetup)?  authenticated,TResult Function()?  localAuthenticated,TResult Function()?  authenticating,TResult Function( Failure? failure)?  unauthenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UnknownAuthState() when unknown != null:
return unknown();case AuthenticatedAuthState() when authenticated != null:
return authenticated(_that.user,_that.accessToken,_that.isOnboardingCompleted,_that.isEncryptionKeySetup);case LocalAuthenticatedAuthState() when localAuthenticated != null:
return localAuthenticated();case AuthenticatingAuthState() when authenticating != null:
return authenticating();case UnauthenticatedAuthState() when unauthenticated != null:
return unauthenticated(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( AuthUser user,  String accessToken,  bool isOnboardingCompleted,  bool isEncryptionKeySetup)  authenticated,required TResult Function()  localAuthenticated,required TResult Function()  authenticating,required TResult Function( Failure? failure)  unauthenticated,}) {final _that = this;
switch (_that) {
case UnknownAuthState():
return unknown();case AuthenticatedAuthState():
return authenticated(_that.user,_that.accessToken,_that.isOnboardingCompleted,_that.isEncryptionKeySetup);case LocalAuthenticatedAuthState():
return localAuthenticated();case AuthenticatingAuthState():
return authenticating();case UnauthenticatedAuthState():
return unauthenticated(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( AuthUser user,  String accessToken,  bool isOnboardingCompleted,  bool isEncryptionKeySetup)?  authenticated,TResult? Function()?  localAuthenticated,TResult? Function()?  authenticating,TResult? Function( Failure? failure)?  unauthenticated,}) {final _that = this;
switch (_that) {
case UnknownAuthState() when unknown != null:
return unknown();case AuthenticatedAuthState() when authenticated != null:
return authenticated(_that.user,_that.accessToken,_that.isOnboardingCompleted,_that.isEncryptionKeySetup);case LocalAuthenticatedAuthState() when localAuthenticated != null:
return localAuthenticated();case AuthenticatingAuthState() when authenticating != null:
return authenticating();case UnauthenticatedAuthState() when unauthenticated != null:
return unauthenticated(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class UnknownAuthState implements AuthState {
  const UnknownAuthState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownAuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unknown()';
}


}




/// @nodoc


class AuthenticatedAuthState implements AuthState {
  const AuthenticatedAuthState({required this.user, required this.accessToken, required this.isOnboardingCompleted, required this.isEncryptionKeySetup});
  

 final  AuthUser user;
 final  String accessToken;
 final  bool isOnboardingCompleted;
 final  bool isEncryptionKeySetup;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedAuthStateCopyWith<AuthenticatedAuthState> get copyWith => _$AuthenticatedAuthStateCopyWithImpl<AuthenticatedAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticatedAuthState&&(identical(other.user, user) || other.user == user)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.isOnboardingCompleted, isOnboardingCompleted) || other.isOnboardingCompleted == isOnboardingCompleted)&&(identical(other.isEncryptionKeySetup, isEncryptionKeySetup) || other.isEncryptionKeySetup == isEncryptionKeySetup));
}


@override
int get hashCode => Object.hash(runtimeType,user,accessToken,isOnboardingCompleted,isEncryptionKeySetup);

@override
String toString() {
  return 'AuthState.authenticated(user: $user, accessToken: $accessToken, isOnboardingCompleted: $isOnboardingCompleted, isEncryptionKeySetup: $isEncryptionKeySetup)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedAuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedAuthStateCopyWith(AuthenticatedAuthState value, $Res Function(AuthenticatedAuthState) _then) = _$AuthenticatedAuthStateCopyWithImpl;
@useResult
$Res call({
 AuthUser user, String accessToken, bool isOnboardingCompleted, bool isEncryptionKeySetup
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthenticatedAuthStateCopyWithImpl<$Res>
    implements $AuthenticatedAuthStateCopyWith<$Res> {
  _$AuthenticatedAuthStateCopyWithImpl(this._self, this._then);

  final AuthenticatedAuthState _self;
  final $Res Function(AuthenticatedAuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? accessToken = null,Object? isOnboardingCompleted = null,Object? isEncryptionKeySetup = null,}) {
  return _then(AuthenticatedAuthState(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,isOnboardingCompleted: null == isOnboardingCompleted ? _self.isOnboardingCompleted : isOnboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,isEncryptionKeySetup: null == isEncryptionKeySetup ? _self.isEncryptionKeySetup : isEncryptionKeySetup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class LocalAuthenticatedAuthState implements AuthState {
  const LocalAuthenticatedAuthState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalAuthenticatedAuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.localAuthenticated()';
}


}




/// @nodoc


class AuthenticatingAuthState implements AuthState {
  const AuthenticatingAuthState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticatingAuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.authenticating()';
}


}




/// @nodoc


class UnauthenticatedAuthState implements AuthState {
  const UnauthenticatedAuthState([this.failure]);
  

 final  Failure? failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthenticatedAuthStateCopyWith<UnauthenticatedAuthState> get copyWith => _$UnauthenticatedAuthStateCopyWithImpl<UnauthenticatedAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthenticatedAuthState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AuthState.unauthenticated(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UnauthenticatedAuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $UnauthenticatedAuthStateCopyWith(UnauthenticatedAuthState value, $Res Function(UnauthenticatedAuthState) _then) = _$UnauthenticatedAuthStateCopyWithImpl;
@useResult
$Res call({
 Failure? failure
});




}
/// @nodoc
class _$UnauthenticatedAuthStateCopyWithImpl<$Res>
    implements $UnauthenticatedAuthStateCopyWith<$Res> {
  _$UnauthenticatedAuthStateCopyWithImpl(this._self, this._then);

  final UnauthenticatedAuthState _self;
  final $Res Function(UnauthenticatedAuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = freezed,}) {
  return _then(UnauthenticatedAuthState(
freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
