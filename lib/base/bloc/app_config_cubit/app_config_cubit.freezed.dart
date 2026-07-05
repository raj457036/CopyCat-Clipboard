// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppConfigState {

 AppConfig get config; bool get isLoading; Failure? get failure;
/// Create a copy of AppConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigStateCopyWith<AppConfigState> get copyWith => _$AppConfigStateCopyWithImpl<AppConfigState>(this as AppConfigState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfigState&&(identical(other.config, config) || other.config == config)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,config,isLoading,failure);

@override
String toString() {
  return 'AppConfigState(config: $config, isLoading: $isLoading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AppConfigStateCopyWith<$Res>  {
  factory $AppConfigStateCopyWith(AppConfigState value, $Res Function(AppConfigState) _then) = _$AppConfigStateCopyWithImpl;
@useResult
$Res call({
 AppConfig config, bool isLoading, Failure? failure
});


$AppConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$AppConfigStateCopyWithImpl<$Res>
    implements $AppConfigStateCopyWith<$Res> {
  _$AppConfigStateCopyWithImpl(this._self, this._then);

  final AppConfigState _self;
  final $Res Function(AppConfigState) _then;

/// Create a copy of AppConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? config = null,Object? isLoading = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as AppConfig,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of AppConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppConfigCopyWith<$Res> get config {
  
  return $AppConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppConfigState].
extension AppConfigStatePatterns on AppConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AppConfigLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AppConfigLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AppConfigLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case AppConfigLoaded():
return loaded(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AppConfigLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case AppConfigLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AppConfig config,  bool isLoading,  Failure? failure)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AppConfigLoaded() when loaded != null:
return loaded(_that.config,_that.isLoading,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AppConfig config,  bool isLoading,  Failure? failure)  loaded,}) {final _that = this;
switch (_that) {
case AppConfigLoaded():
return loaded(_that.config,_that.isLoading,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AppConfig config,  bool isLoading,  Failure? failure)?  loaded,}) {final _that = this;
switch (_that) {
case AppConfigLoaded() when loaded != null:
return loaded(_that.config,_that.isLoading,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AppConfigLoaded implements AppConfigState {
  const AppConfigLoaded({required this.config, this.isLoading = false, this.failure});
  

@override final  AppConfig config;
@override@JsonKey() final  bool isLoading;
@override final  Failure? failure;

/// Create a copy of AppConfigState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigLoadedCopyWith<AppConfigLoaded> get copyWith => _$AppConfigLoadedCopyWithImpl<AppConfigLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfigLoaded&&(identical(other.config, config) || other.config == config)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,config,isLoading,failure);

@override
String toString() {
  return 'AppConfigState.loaded(config: $config, isLoading: $isLoading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AppConfigLoadedCopyWith<$Res> implements $AppConfigStateCopyWith<$Res> {
  factory $AppConfigLoadedCopyWith(AppConfigLoaded value, $Res Function(AppConfigLoaded) _then) = _$AppConfigLoadedCopyWithImpl;
@override @useResult
$Res call({
 AppConfig config, bool isLoading, Failure? failure
});


@override $AppConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$AppConfigLoadedCopyWithImpl<$Res>
    implements $AppConfigLoadedCopyWith<$Res> {
  _$AppConfigLoadedCopyWithImpl(this._self, this._then);

  final AppConfigLoaded _self;
  final $Res Function(AppConfigLoaded) _then;

/// Create a copy of AppConfigState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? isLoading = null,Object? failure = freezed,}) {
  return _then(AppConfigLoaded(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as AppConfig,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of AppConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppConfigCopyWith<$Res> get config {
  
  return $AppConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
