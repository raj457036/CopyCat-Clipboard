// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monetization_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonetizationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonetizationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MonetizationState()';
}


}

/// @nodoc
class $MonetizationStateCopyWith<$Res>  {
$MonetizationStateCopyWith(MonetizationState _, $Res Function(MonetizationState) __);
}


/// Adds pattern-matching-related methods to [MonetizationState].
extension MonetizationStatePatterns on MonetizationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MonetizationUnknown value)?  unknown,TResult Function( MonetizationActive value)?  active,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MonetizationUnknown() when unknown != null:
return unknown(_that);case MonetizationActive() when active != null:
return active(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MonetizationUnknown value)  unknown,required TResult Function( MonetizationActive value)  active,}){
final _that = this;
switch (_that) {
case MonetizationUnknown():
return unknown(_that);case MonetizationActive():
return active(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MonetizationUnknown value)?  unknown,TResult? Function( MonetizationActive value)?  active,}){
final _that = this;
switch (_that) {
case MonetizationUnknown() when unknown != null:
return unknown(_that);case MonetizationActive() when active != null:
return active(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( Subscription subscription)?  active,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MonetizationUnknown() when unknown != null:
return unknown();case MonetizationActive() when active != null:
return active(_that.subscription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( Subscription subscription)  active,}) {final _that = this;
switch (_that) {
case MonetizationUnknown():
return unknown();case MonetizationActive():
return active(_that.subscription);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( Subscription subscription)?  active,}) {final _that = this;
switch (_that) {
case MonetizationUnknown() when unknown != null:
return unknown();case MonetizationActive() when active != null:
return active(_that.subscription);case _:
  return null;

}
}

}

/// @nodoc


class MonetizationUnknown implements MonetizationState {
  const MonetizationUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonetizationUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MonetizationState.unknown()';
}


}




/// @nodoc


class MonetizationActive implements MonetizationState {
  const MonetizationActive({required this.subscription});
  

 final  Subscription subscription;

/// Create a copy of MonetizationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonetizationActiveCopyWith<MonetizationActive> get copyWith => _$MonetizationActiveCopyWithImpl<MonetizationActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonetizationActive&&(identical(other.subscription, subscription) || other.subscription == subscription));
}


@override
int get hashCode => Object.hash(runtimeType,subscription);

@override
String toString() {
  return 'MonetizationState.active(subscription: $subscription)';
}


}

/// @nodoc
abstract mixin class $MonetizationActiveCopyWith<$Res> implements $MonetizationStateCopyWith<$Res> {
  factory $MonetizationActiveCopyWith(MonetizationActive value, $Res Function(MonetizationActive) _then) = _$MonetizationActiveCopyWithImpl;
@useResult
$Res call({
 Subscription subscription
});


$SubscriptionCopyWith<$Res> get subscription;

}
/// @nodoc
class _$MonetizationActiveCopyWithImpl<$Res>
    implements $MonetizationActiveCopyWith<$Res> {
  _$MonetizationActiveCopyWithImpl(this._self, this._then);

  final MonetizationActive _self;
  final $Res Function(MonetizationActive) _then;

/// Create a copy of MonetizationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? subscription = null,}) {
  return _then(MonetizationActive(
subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as Subscription,
  ));
}

/// Create a copy of MonetizationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<$Res> get subscription {
  
  return $SubscriptionCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}

// dart format on
