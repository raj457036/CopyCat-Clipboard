// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_clips_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedClipsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedClipsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectedClipsState()';
}


}

/// @nodoc
class $SelectedClipsStateCopyWith<$Res>  {
$SelectedClipsStateCopyWith(SelectedClipsState _, $Res Function(SelectedClipsState) __);
}


/// Adds pattern-matching-related methods to [SelectedClipsState].
extension SelectedClipsStatePatterns on SelectedClipsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoClipSelected value)?  noClipSelected,TResult Function( ClipSelected value)?  clipSelected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoClipSelected() when noClipSelected != null:
return noClipSelected(_that);case ClipSelected() when clipSelected != null:
return clipSelected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoClipSelected value)  noClipSelected,required TResult Function( ClipSelected value)  clipSelected,}){
final _that = this;
switch (_that) {
case NoClipSelected():
return noClipSelected(_that);case ClipSelected():
return clipSelected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoClipSelected value)?  noClipSelected,TResult? Function( ClipSelected value)?  clipSelected,}){
final _that = this;
switch (_that) {
case NoClipSelected() when noClipSelected != null:
return noClipSelected(_that);case ClipSelected() when clipSelected != null:
return clipSelected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noClipSelected,TResult Function( List<ClipboardItem> selectedClipIds)?  clipSelected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoClipSelected() when noClipSelected != null:
return noClipSelected();case ClipSelected() when clipSelected != null:
return clipSelected(_that.selectedClipIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noClipSelected,required TResult Function( List<ClipboardItem> selectedClipIds)  clipSelected,}) {final _that = this;
switch (_that) {
case NoClipSelected():
return noClipSelected();case ClipSelected():
return clipSelected(_that.selectedClipIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noClipSelected,TResult? Function( List<ClipboardItem> selectedClipIds)?  clipSelected,}) {final _that = this;
switch (_that) {
case NoClipSelected() when noClipSelected != null:
return noClipSelected();case ClipSelected() when clipSelected != null:
return clipSelected(_that.selectedClipIds);case _:
  return null;

}
}

}

/// @nodoc


class NoClipSelected implements SelectedClipsState {
  const NoClipSelected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoClipSelected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectedClipsState.noClipSelected()';
}


}




/// @nodoc


class ClipSelected implements SelectedClipsState {
  const ClipSelected({required final  List<ClipboardItem> selectedClipIds}): _selectedClipIds = selectedClipIds;
  

 final  List<ClipboardItem> _selectedClipIds;
 List<ClipboardItem> get selectedClipIds {
  if (_selectedClipIds is EqualUnmodifiableListView) return _selectedClipIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedClipIds);
}


/// Create a copy of SelectedClipsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipSelectedCopyWith<ClipSelected> get copyWith => _$ClipSelectedCopyWithImpl<ClipSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipSelected&&const DeepCollectionEquality().equals(other._selectedClipIds, _selectedClipIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedClipIds));

@override
String toString() {
  return 'SelectedClipsState.clipSelected(selectedClipIds: $selectedClipIds)';
}


}

/// @nodoc
abstract mixin class $ClipSelectedCopyWith<$Res> implements $SelectedClipsStateCopyWith<$Res> {
  factory $ClipSelectedCopyWith(ClipSelected value, $Res Function(ClipSelected) _then) = _$ClipSelectedCopyWithImpl;
@useResult
$Res call({
 List<ClipboardItem> selectedClipIds
});




}
/// @nodoc
class _$ClipSelectedCopyWithImpl<$Res>
    implements $ClipSelectedCopyWith<$Res> {
  _$ClipSelectedCopyWithImpl(this._self, this._then);

  final ClipSelected _self;
  final $Res Function(ClipSelected) _then;

/// Create a copy of SelectedClipsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedClipIds = null,}) {
  return _then(ClipSelected(
selectedClipIds: null == selectedClipIds ? _self._selectedClipIds : selectedClipIds // ignore: cast_nullable_to_non_nullable
as List<ClipboardItem>,
  ));
}


}

// dart format on
