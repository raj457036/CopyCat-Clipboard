// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clipboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClipboardState {

 int get revision; String get query; dynamic get hasMore; int get limit; int get offset; bool get loading; bool get syncing; SearchFilterState get filterState; Failure? get failure;
/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipboardStateCopyWith<ClipboardState> get copyWith => _$ClipboardStateCopyWithImpl<ClipboardState>(this as ClipboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipboardState&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.hasMore, hasMore)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.syncing, syncing) || other.syncing == syncing)&&(identical(other.filterState, filterState) || other.filterState == filterState)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,revision,query,const DeepCollectionEquality().hash(hasMore),limit,offset,loading,syncing,filterState,failure);

@override
String toString() {
  return 'ClipboardState(revision: $revision, query: $query, hasMore: $hasMore, limit: $limit, offset: $offset, loading: $loading, syncing: $syncing, filterState: $filterState, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ClipboardStateCopyWith<$Res>  {
  factory $ClipboardStateCopyWith(ClipboardState value, $Res Function(ClipboardState) _then) = _$ClipboardStateCopyWithImpl;
@useResult
$Res call({
 int revision, String query, dynamic hasMore, int limit, int offset, bool loading, bool syncing, SearchFilterState filterState, Failure? failure
});




}
/// @nodoc
class _$ClipboardStateCopyWithImpl<$Res>
    implements $ClipboardStateCopyWith<$Res> {
  _$ClipboardStateCopyWithImpl(this._self, this._then);

  final ClipboardState _self;
  final $Res Function(ClipboardState) _then;

/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revision = null,Object? query = null,Object? hasMore = freezed,Object? limit = null,Object? offset = null,Object? loading = null,Object? syncing = null,Object? filterState = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,hasMore: freezed == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as dynamic,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,syncing: null == syncing ? _self.syncing : syncing // ignore: cast_nullable_to_non_nullable
as bool,filterState: null == filterState ? _self.filterState : filterState // ignore: cast_nullable_to_non_nullable
as SearchFilterState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClipboardState].
extension ClipboardStatePatterns on ClipboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ClipboardLoadedState value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ClipboardLoadedState() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ClipboardLoadedState value)  loaded,}){
final _that = this;
switch (_that) {
case ClipboardLoadedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ClipboardLoadedState value)?  loaded,}){
final _that = this;
switch (_that) {
case ClipboardLoadedState() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int revision,  String query,  dynamic hasMore,  int limit,  int offset,  bool loading,  bool syncing,  SearchFilterState filterState,  Failure? failure)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ClipboardLoadedState() when loaded != null:
return loaded(_that.revision,_that.query,_that.hasMore,_that.limit,_that.offset,_that.loading,_that.syncing,_that.filterState,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int revision,  String query,  dynamic hasMore,  int limit,  int offset,  bool loading,  bool syncing,  SearchFilterState filterState,  Failure? failure)  loaded,}) {final _that = this;
switch (_that) {
case ClipboardLoadedState():
return loaded(_that.revision,_that.query,_that.hasMore,_that.limit,_that.offset,_that.loading,_that.syncing,_that.filterState,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int revision,  String query,  dynamic hasMore,  int limit,  int offset,  bool loading,  bool syncing,  SearchFilterState filterState,  Failure? failure)?  loaded,}) {final _that = this;
switch (_that) {
case ClipboardLoadedState() when loaded != null:
return loaded(_that.revision,_that.query,_that.hasMore,_that.limit,_that.offset,_that.loading,_that.syncing,_that.filterState,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ClipboardLoadedState implements ClipboardState {
  const ClipboardLoadedState({this.revision = 0, this.query = '', this.hasMore = true, this.limit = 50, this.offset = 0, this.loading = true, this.syncing = false, this.filterState = const SearchFilterState(), this.failure});
  

@override@JsonKey() final  int revision;
@override@JsonKey() final  String query;
@override@JsonKey() final  dynamic hasMore;
@override@JsonKey() final  int limit;
@override@JsonKey() final  int offset;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool syncing;
@override@JsonKey() final  SearchFilterState filterState;
@override final  Failure? failure;

/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipboardLoadedStateCopyWith<ClipboardLoadedState> get copyWith => _$ClipboardLoadedStateCopyWithImpl<ClipboardLoadedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipboardLoadedState&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.hasMore, hasMore)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.syncing, syncing) || other.syncing == syncing)&&(identical(other.filterState, filterState) || other.filterState == filterState)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,revision,query,const DeepCollectionEquality().hash(hasMore),limit,offset,loading,syncing,filterState,failure);

@override
String toString() {
  return 'ClipboardState.loaded(revision: $revision, query: $query, hasMore: $hasMore, limit: $limit, offset: $offset, loading: $loading, syncing: $syncing, filterState: $filterState, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ClipboardLoadedStateCopyWith<$Res> implements $ClipboardStateCopyWith<$Res> {
  factory $ClipboardLoadedStateCopyWith(ClipboardLoadedState value, $Res Function(ClipboardLoadedState) _then) = _$ClipboardLoadedStateCopyWithImpl;
@override @useResult
$Res call({
 int revision, String query, dynamic hasMore, int limit, int offset, bool loading, bool syncing, SearchFilterState filterState, Failure? failure
});




}
/// @nodoc
class _$ClipboardLoadedStateCopyWithImpl<$Res>
    implements $ClipboardLoadedStateCopyWith<$Res> {
  _$ClipboardLoadedStateCopyWithImpl(this._self, this._then);

  final ClipboardLoadedState _self;
  final $Res Function(ClipboardLoadedState) _then;

/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revision = null,Object? query = null,Object? hasMore = freezed,Object? limit = null,Object? offset = null,Object? loading = null,Object? syncing = null,Object? filterState = null,Object? failure = freezed,}) {
  return _then(ClipboardLoadedState(
revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,hasMore: freezed == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as dynamic,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,syncing: null == syncing ? _self.syncing : syncing // ignore: cast_nullable_to_non_nullable
as bool,filterState: null == filterState ? _self.filterState : filterState // ignore: cast_nullable_to_non_nullable
as SearchFilterState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
