// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drive_access_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriveAccessToken {

@JsonKey(name: "access_token") String get accessToken;@JsonKey(name: "expires_in") int get expiresIn;@JsonKey(name: "issued_at") DateTime get issuedAt;@JsonKey(name: "scopes") List<String> get scopes;@JsonKey(name: "display_text") String? get displayText;@JsonKey(name: "provider") String? get provider;@JsonKey(name: "account_id") String? get accountId;
/// Create a copy of DriveAccessToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriveAccessTokenCopyWith<DriveAccessToken> get copyWith => _$DriveAccessTokenCopyWithImpl<DriveAccessToken>(this as DriveAccessToken, _$identity);

  /// Serializes this DriveAccessToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveAccessToken&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&const DeepCollectionEquality().equals(other.scopes, scopes)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,expiresIn,issuedAt,const DeepCollectionEquality().hash(scopes),displayText,provider,accountId);

@override
String toString() {
  return 'DriveAccessToken(accessToken: $accessToken, expiresIn: $expiresIn, issuedAt: $issuedAt, scopes: $scopes, displayText: $displayText, provider: $provider, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $DriveAccessTokenCopyWith<$Res>  {
  factory $DriveAccessTokenCopyWith(DriveAccessToken value, $Res Function(DriveAccessToken) _then) = _$DriveAccessTokenCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "access_token") String accessToken,@JsonKey(name: "expires_in") int expiresIn,@JsonKey(name: "issued_at") DateTime issuedAt,@JsonKey(name: "scopes") List<String> scopes,@JsonKey(name: "display_text") String? displayText,@JsonKey(name: "provider") String? provider,@JsonKey(name: "account_id") String? accountId
});




}
/// @nodoc
class _$DriveAccessTokenCopyWithImpl<$Res>
    implements $DriveAccessTokenCopyWith<$Res> {
  _$DriveAccessTokenCopyWithImpl(this._self, this._then);

  final DriveAccessToken _self;
  final $Res Function(DriveAccessToken) _then;

/// Create a copy of DriveAccessToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? expiresIn = null,Object? issuedAt = null,Object? scopes = null,Object? displayText = freezed,Object? provider = freezed,Object? accountId = freezed,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,scopes: null == scopes ? _self.scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,displayText: freezed == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DriveAccessToken].
extension DriveAccessTokenPatterns on DriveAccessToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriveAccessToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriveAccessToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriveAccessToken value)  $default,){
final _that = this;
switch (_that) {
case _DriveAccessToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriveAccessToken value)?  $default,){
final _that = this;
switch (_that) {
case _DriveAccessToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "expires_in")  int expiresIn, @JsonKey(name: "issued_at")  DateTime issuedAt, @JsonKey(name: "scopes")  List<String> scopes, @JsonKey(name: "display_text")  String? displayText, @JsonKey(name: "provider")  String? provider, @JsonKey(name: "account_id")  String? accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriveAccessToken() when $default != null:
return $default(_that.accessToken,_that.expiresIn,_that.issuedAt,_that.scopes,_that.displayText,_that.provider,_that.accountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "expires_in")  int expiresIn, @JsonKey(name: "issued_at")  DateTime issuedAt, @JsonKey(name: "scopes")  List<String> scopes, @JsonKey(name: "display_text")  String? displayText, @JsonKey(name: "provider")  String? provider, @JsonKey(name: "account_id")  String? accountId)  $default,) {final _that = this;
switch (_that) {
case _DriveAccessToken():
return $default(_that.accessToken,_that.expiresIn,_that.issuedAt,_that.scopes,_that.displayText,_that.provider,_that.accountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "expires_in")  int expiresIn, @JsonKey(name: "issued_at")  DateTime issuedAt, @JsonKey(name: "scopes")  List<String> scopes, @JsonKey(name: "display_text")  String? displayText, @JsonKey(name: "provider")  String? provider, @JsonKey(name: "account_id")  String? accountId)?  $default,) {final _that = this;
switch (_that) {
case _DriveAccessToken() when $default != null:
return $default(_that.accessToken,_that.expiresIn,_that.issuedAt,_that.scopes,_that.displayText,_that.provider,_that.accountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriveAccessToken extends DriveAccessToken {
   _DriveAccessToken({@JsonKey(name: "access_token") required this.accessToken, @JsonKey(name: "expires_in") required this.expiresIn, @JsonKey(name: "issued_at") required this.issuedAt, @JsonKey(name: "scopes") required final  List<String> scopes, @JsonKey(name: "display_text") this.displayText, @JsonKey(name: "provider") this.provider, @JsonKey(name: "account_id") this.accountId}): _scopes = scopes,super._();
  factory _DriveAccessToken.fromJson(Map<String, dynamic> json) => _$DriveAccessTokenFromJson(json);

@override@JsonKey(name: "access_token") final  String accessToken;
@override@JsonKey(name: "expires_in") final  int expiresIn;
@override@JsonKey(name: "issued_at") final  DateTime issuedAt;
 final  List<String> _scopes;
@override@JsonKey(name: "scopes") List<String> get scopes {
  if (_scopes is EqualUnmodifiableListView) return _scopes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scopes);
}

@override@JsonKey(name: "display_text") final  String? displayText;
@override@JsonKey(name: "provider") final  String? provider;
@override@JsonKey(name: "account_id") final  String? accountId;

/// Create a copy of DriveAccessToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriveAccessTokenCopyWith<_DriveAccessToken> get copyWith => __$DriveAccessTokenCopyWithImpl<_DriveAccessToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriveAccessTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriveAccessToken&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&const DeepCollectionEquality().equals(other._scopes, _scopes)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,expiresIn,issuedAt,const DeepCollectionEquality().hash(_scopes),displayText,provider,accountId);

@override
String toString() {
  return 'DriveAccessToken(accessToken: $accessToken, expiresIn: $expiresIn, issuedAt: $issuedAt, scopes: $scopes, displayText: $displayText, provider: $provider, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$DriveAccessTokenCopyWith<$Res> implements $DriveAccessTokenCopyWith<$Res> {
  factory _$DriveAccessTokenCopyWith(_DriveAccessToken value, $Res Function(_DriveAccessToken) _then) = __$DriveAccessTokenCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "access_token") String accessToken,@JsonKey(name: "expires_in") int expiresIn,@JsonKey(name: "issued_at") DateTime issuedAt,@JsonKey(name: "scopes") List<String> scopes,@JsonKey(name: "display_text") String? displayText,@JsonKey(name: "provider") String? provider,@JsonKey(name: "account_id") String? accountId
});




}
/// @nodoc
class __$DriveAccessTokenCopyWithImpl<$Res>
    implements _$DriveAccessTokenCopyWith<$Res> {
  __$DriveAccessTokenCopyWithImpl(this._self, this._then);

  final _DriveAccessToken _self;
  final $Res Function(_DriveAccessToken) _then;

/// Create a copy of DriveAccessToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? expiresIn = null,Object? issuedAt = null,Object? scopes = null,Object? displayText = freezed,Object? provider = freezed,Object? accountId = freezed,}) {
  return _then(_DriveAccessToken(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,scopes: null == scopes ? _self._scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,displayText: freezed == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
