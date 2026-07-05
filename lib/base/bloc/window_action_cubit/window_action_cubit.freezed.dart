// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'window_action_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WindowActionState implements DiagnosticableTreeMixin {

 AppView get view; bool get loading;
/// Create a copy of WindowActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowActionStateCopyWith<WindowActionState> get copyWith => _$WindowActionStateCopyWithImpl<WindowActionState>(this as WindowActionState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WindowActionState'))
    ..add(DiagnosticsProperty('view', view))..add(DiagnosticsProperty('loading', loading));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowActionState&&(identical(other.view, view) || other.view == view)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,view,loading);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WindowActionState(view: $view, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $WindowActionStateCopyWith<$Res>  {
  factory $WindowActionStateCopyWith(WindowActionState value, $Res Function(WindowActionState) _then) = _$WindowActionStateCopyWithImpl;
@useResult
$Res call({
 AppView view, bool loading
});




}
/// @nodoc
class _$WindowActionStateCopyWithImpl<$Res>
    implements $WindowActionStateCopyWith<$Res> {
  _$WindowActionStateCopyWithImpl(this._self, this._then);

  final WindowActionState _self;
  final $Res Function(WindowActionState) _then;

/// Create a copy of WindowActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? view = null,Object? loading = null,}) {
  return _then(_self.copyWith(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as AppView,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WindowActionState].
extension WindowActionStatePatterns on WindowActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WindowActionLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WindowActionLoaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WindowActionLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case WindowActionLoaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WindowActionLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case WindowActionLoaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AppView view,  bool loading)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WindowActionLoaded() when loaded != null:
return loaded(_that.view,_that.loading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AppView view,  bool loading)  loaded,}) {final _that = this;
switch (_that) {
case WindowActionLoaded():
return loaded(_that.view,_that.loading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AppView view,  bool loading)?  loaded,}) {final _that = this;
switch (_that) {
case WindowActionLoaded() when loaded != null:
return loaded(_that.view,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class WindowActionLoaded with DiagnosticableTreeMixin implements WindowActionState {
  const WindowActionLoaded({this.view = AppView.windowed, this.loading = true});
  

@override@JsonKey() final  AppView view;
@override@JsonKey() final  bool loading;

/// Create a copy of WindowActionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowActionLoadedCopyWith<WindowActionLoaded> get copyWith => _$WindowActionLoadedCopyWithImpl<WindowActionLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WindowActionState.loaded'))
    ..add(DiagnosticsProperty('view', view))..add(DiagnosticsProperty('loading', loading));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowActionLoaded&&(identical(other.view, view) || other.view == view)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,view,loading);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WindowActionState.loaded(view: $view, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $WindowActionLoadedCopyWith<$Res> implements $WindowActionStateCopyWith<$Res> {
  factory $WindowActionLoadedCopyWith(WindowActionLoaded value, $Res Function(WindowActionLoaded) _then) = _$WindowActionLoadedCopyWithImpl;
@override @useResult
$Res call({
 AppView view, bool loading
});




}
/// @nodoc
class _$WindowActionLoadedCopyWithImpl<$Res>
    implements $WindowActionLoadedCopyWith<$Res> {
  _$WindowActionLoadedCopyWithImpl(this._self, this._then);

  final WindowActionLoaded _self;
  final $Res Function(WindowActionLoaded) _then;

/// Create a copy of WindowActionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? view = null,Object? loading = null,}) {
  return _then(WindowActionLoaded(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as AppView,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
