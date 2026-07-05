// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_clips_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionClipsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionClipsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionClipsState()';
}


}

/// @nodoc
class $CollectionClipsStateCopyWith<$Res>  {
$CollectionClipsStateCopyWith(CollectionClipsState _, $Res Function(CollectionClipsState) __);
}


/// Adds pattern-matching-related methods to [CollectionClipsState].
extension CollectionClipsStatePatterns on CollectionClipsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitialCollectionClipsState value)?  initial,TResult Function( SearchingCollectionClipsState value)?  searching,TResult Function( CollectionClipsResultsState value)?  results,TResult Function( CollectionClipsErrorState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitialCollectionClipsState() when initial != null:
return initial(_that);case SearchingCollectionClipsState() when searching != null:
return searching(_that);case CollectionClipsResultsState() when results != null:
return results(_that);case CollectionClipsErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitialCollectionClipsState value)  initial,required TResult Function( SearchingCollectionClipsState value)  searching,required TResult Function( CollectionClipsResultsState value)  results,required TResult Function( CollectionClipsErrorState value)  error,}){
final _that = this;
switch (_that) {
case InitialCollectionClipsState():
return initial(_that);case SearchingCollectionClipsState():
return searching(_that);case CollectionClipsResultsState():
return results(_that);case CollectionClipsErrorState():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitialCollectionClipsState value)?  initial,TResult? Function( SearchingCollectionClipsState value)?  searching,TResult? Function( CollectionClipsResultsState value)?  results,TResult? Function( CollectionClipsErrorState value)?  error,}){
final _that = this;
switch (_that) {
case InitialCollectionClipsState() when initial != null:
return initial(_that);case SearchingCollectionClipsState() when searching != null:
return searching(_that);case CollectionClipsResultsState() when results != null:
return results(_that);case CollectionClipsErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String? query)?  searching,TResult Function( String? query,  List<ClipboardItem> results,  bool hasMore,  bool isLoading,  int offset)?  results,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitialCollectionClipsState() when initial != null:
return initial();case SearchingCollectionClipsState() when searching != null:
return searching(_that.query);case CollectionClipsResultsState() when results != null:
return results(_that.query,_that.results,_that.hasMore,_that.isLoading,_that.offset);case CollectionClipsErrorState() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String? query)  searching,required TResult Function( String? query,  List<ClipboardItem> results,  bool hasMore,  bool isLoading,  int offset)  results,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case InitialCollectionClipsState():
return initial();case SearchingCollectionClipsState():
return searching(_that.query);case CollectionClipsResultsState():
return results(_that.query,_that.results,_that.hasMore,_that.isLoading,_that.offset);case CollectionClipsErrorState():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String? query)?  searching,TResult? Function( String? query,  List<ClipboardItem> results,  bool hasMore,  bool isLoading,  int offset)?  results,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case InitialCollectionClipsState() when initial != null:
return initial();case SearchingCollectionClipsState() when searching != null:
return searching(_that.query);case CollectionClipsResultsState() when results != null:
return results(_that.query,_that.results,_that.hasMore,_that.isLoading,_that.offset);case CollectionClipsErrorState() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class InitialCollectionClipsState implements CollectionClipsState {
  const InitialCollectionClipsState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialCollectionClipsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionClipsState.initial()';
}


}




/// @nodoc


class SearchingCollectionClipsState implements CollectionClipsState {
  const SearchingCollectionClipsState({this.query});
  

 final  String? query;

/// Create a copy of CollectionClipsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchingCollectionClipsStateCopyWith<SearchingCollectionClipsState> get copyWith => _$SearchingCollectionClipsStateCopyWithImpl<SearchingCollectionClipsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchingCollectionClipsState&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'CollectionClipsState.searching(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchingCollectionClipsStateCopyWith<$Res> implements $CollectionClipsStateCopyWith<$Res> {
  factory $SearchingCollectionClipsStateCopyWith(SearchingCollectionClipsState value, $Res Function(SearchingCollectionClipsState) _then) = _$SearchingCollectionClipsStateCopyWithImpl;
@useResult
$Res call({
 String? query
});




}
/// @nodoc
class _$SearchingCollectionClipsStateCopyWithImpl<$Res>
    implements $SearchingCollectionClipsStateCopyWith<$Res> {
  _$SearchingCollectionClipsStateCopyWithImpl(this._self, this._then);

  final SearchingCollectionClipsState _self;
  final $Res Function(SearchingCollectionClipsState) _then;

/// Create a copy of CollectionClipsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = freezed,}) {
  return _then(SearchingCollectionClipsState(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class CollectionClipsResultsState implements CollectionClipsState {
  const CollectionClipsResultsState({this.query, required final  List<ClipboardItem> results, this.hasMore = false, this.isLoading = false, this.offset = 0}): _results = results;
  

 final  String? query;
 final  List<ClipboardItem> _results;
 List<ClipboardItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  bool isLoading;
@JsonKey() final  int offset;

/// Create a copy of CollectionClipsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionClipsResultsStateCopyWith<CollectionClipsResultsState> get copyWith => _$CollectionClipsResultsStateCopyWithImpl<CollectionClipsResultsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionClipsResultsState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_results),hasMore,isLoading,offset);

@override
String toString() {
  return 'CollectionClipsState.results(query: $query, results: $results, hasMore: $hasMore, isLoading: $isLoading, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $CollectionClipsResultsStateCopyWith<$Res> implements $CollectionClipsStateCopyWith<$Res> {
  factory $CollectionClipsResultsStateCopyWith(CollectionClipsResultsState value, $Res Function(CollectionClipsResultsState) _then) = _$CollectionClipsResultsStateCopyWithImpl;
@useResult
$Res call({
 String? query, List<ClipboardItem> results, bool hasMore, bool isLoading, int offset
});




}
/// @nodoc
class _$CollectionClipsResultsStateCopyWithImpl<$Res>
    implements $CollectionClipsResultsStateCopyWith<$Res> {
  _$CollectionClipsResultsStateCopyWithImpl(this._self, this._then);

  final CollectionClipsResultsState _self;
  final $Res Function(CollectionClipsResultsState) _then;

/// Create a copy of CollectionClipsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = freezed,Object? results = null,Object? hasMore = null,Object? isLoading = null,Object? offset = null,}) {
  return _then(CollectionClipsResultsState(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ClipboardItem>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CollectionClipsErrorState implements CollectionClipsState {
  const CollectionClipsErrorState({required this.failure});
  

 final  Failure failure;

/// Create a copy of CollectionClipsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionClipsErrorStateCopyWith<CollectionClipsErrorState> get copyWith => _$CollectionClipsErrorStateCopyWithImpl<CollectionClipsErrorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionClipsErrorState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CollectionClipsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CollectionClipsErrorStateCopyWith<$Res> implements $CollectionClipsStateCopyWith<$Res> {
  factory $CollectionClipsErrorStateCopyWith(CollectionClipsErrorState value, $Res Function(CollectionClipsErrorState) _then) = _$CollectionClipsErrorStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$CollectionClipsErrorStateCopyWithImpl<$Res>
    implements $CollectionClipsErrorStateCopyWith<$Res> {
  _$CollectionClipsErrorStateCopyWithImpl(this._self, this._then);

  final CollectionClipsErrorState _self;
  final $Res Function(CollectionClipsErrorState) _then;

/// Create a copy of CollectionClipsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CollectionClipsErrorState(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
