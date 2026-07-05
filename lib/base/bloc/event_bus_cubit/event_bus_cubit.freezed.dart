// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_bus_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventBusState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventBusState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventBusState()';
}


}

/// @nodoc
class $EventBusStateCopyWith<$Res>  {
$EventBusStateCopyWith(EventBusState _, $Res Function(EventBusState) __);
}


/// Adds pattern-matching-related methods to [EventBusState].
extension EventBusStatePatterns on EventBusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Empty value)?  empty,TResult Function( EventBusKeyboardEvent value)?  keyboard,TResult Function( EventBusIndexPasteEvent value)?  indexPaste,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty(_that);case EventBusKeyboardEvent() when keyboard != null:
return keyboard(_that);case EventBusIndexPasteEvent() when indexPaste != null:
return indexPaste(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Empty value)  empty,required TResult Function( EventBusKeyboardEvent value)  keyboard,required TResult Function( EventBusIndexPasteEvent value)  indexPaste,}){
final _that = this;
switch (_that) {
case _Empty():
return empty(_that);case EventBusKeyboardEvent():
return keyboard(_that);case EventBusIndexPasteEvent():
return indexPaste(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Empty value)?  empty,TResult? Function( EventBusKeyboardEvent value)?  keyboard,TResult? Function( EventBusIndexPasteEvent value)?  indexPaste,}){
final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty(_that);case EventBusKeyboardEvent() when keyboard != null:
return keyboard(_that);case EventBusIndexPasteEvent() when indexPaste != null:
return indexPaste(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( KeyboardShortcutEvent event)?  keyboard,TResult Function( int index)?  indexPaste,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty();case EventBusKeyboardEvent() when keyboard != null:
return keyboard(_that.event);case EventBusIndexPasteEvent() when indexPaste != null:
return indexPaste(_that.index);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( KeyboardShortcutEvent event)  keyboard,required TResult Function( int index)  indexPaste,}) {final _that = this;
switch (_that) {
case _Empty():
return empty();case EventBusKeyboardEvent():
return keyboard(_that.event);case EventBusIndexPasteEvent():
return indexPaste(_that.index);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( KeyboardShortcutEvent event)?  keyboard,TResult? Function( int index)?  indexPaste,}) {final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty();case EventBusKeyboardEvent() when keyboard != null:
return keyboard(_that.event);case EventBusIndexPasteEvent() when indexPaste != null:
return indexPaste(_that.index);case _:
  return null;

}
}

}

/// @nodoc


class _Empty implements EventBusState {
  const _Empty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventBusState.empty()';
}


}




/// @nodoc


class EventBusKeyboardEvent implements EventBusState {
  const EventBusKeyboardEvent(this.event);
  

 final  KeyboardShortcutEvent event;

/// Create a copy of EventBusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventBusKeyboardEventCopyWith<EventBusKeyboardEvent> get copyWith => _$EventBusKeyboardEventCopyWithImpl<EventBusKeyboardEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventBusKeyboardEvent&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,event);

@override
String toString() {
  return 'EventBusState.keyboard(event: $event)';
}


}

/// @nodoc
abstract mixin class $EventBusKeyboardEventCopyWith<$Res> implements $EventBusStateCopyWith<$Res> {
  factory $EventBusKeyboardEventCopyWith(EventBusKeyboardEvent value, $Res Function(EventBusKeyboardEvent) _then) = _$EventBusKeyboardEventCopyWithImpl;
@useResult
$Res call({
 KeyboardShortcutEvent event
});




}
/// @nodoc
class _$EventBusKeyboardEventCopyWithImpl<$Res>
    implements $EventBusKeyboardEventCopyWith<$Res> {
  _$EventBusKeyboardEventCopyWithImpl(this._self, this._then);

  final EventBusKeyboardEvent _self;
  final $Res Function(EventBusKeyboardEvent) _then;

/// Create a copy of EventBusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? event = null,}) {
  return _then(EventBusKeyboardEvent(
null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as KeyboardShortcutEvent,
  ));
}


}

/// @nodoc


class EventBusIndexPasteEvent implements EventBusState {
  const EventBusIndexPasteEvent(this.index);
  

 final  int index;

/// Create a copy of EventBusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventBusIndexPasteEventCopyWith<EventBusIndexPasteEvent> get copyWith => _$EventBusIndexPasteEventCopyWithImpl<EventBusIndexPasteEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventBusIndexPasteEvent&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'EventBusState.indexPaste(index: $index)';
}


}

/// @nodoc
abstract mixin class $EventBusIndexPasteEventCopyWith<$Res> implements $EventBusStateCopyWith<$Res> {
  factory $EventBusIndexPasteEventCopyWith(EventBusIndexPasteEvent value, $Res Function(EventBusIndexPasteEvent) _then) = _$EventBusIndexPasteEventCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$EventBusIndexPasteEventCopyWithImpl<$Res>
    implements $EventBusIndexPasteEventCopyWith<$Res> {
  _$EventBusIndexPasteEventCopyWithImpl(this._self, this._then);

  final EventBusIndexPasteEvent _self;
  final $Res Function(EventBusIndexPasteEvent) _then;

/// Create a copy of EventBusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(EventBusIndexPasteEvent(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
