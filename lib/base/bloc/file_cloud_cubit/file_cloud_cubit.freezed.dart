// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_cloud_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileCloudState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileCloudState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FileCloudState()';
}


}

/// @nodoc
class $FileCloudStateCopyWith<$Res>  {
$FileCloudStateCopyWith(FileCloudState _, $Res Function(FileCloudState) __);
}


/// Adds pattern-matching-related methods to [FileCloudState].
extension FileCloudStatePatterns on FileCloudState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FileCloudInitial value)?  initial,TResult Function( FileCloudDownloading value)?  downloading,TResult Function( FileCloudDownloaded value)?  downloaded,TResult Function( FileCloudError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FileCloudInitial() when initial != null:
return initial(_that);case FileCloudDownloading() when downloading != null:
return downloading(_that);case FileCloudDownloaded() when downloaded != null:
return downloaded(_that);case FileCloudError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FileCloudInitial value)  initial,required TResult Function( FileCloudDownloading value)  downloading,required TResult Function( FileCloudDownloaded value)  downloaded,required TResult Function( FileCloudError value)  error,}){
final _that = this;
switch (_that) {
case FileCloudInitial():
return initial(_that);case FileCloudDownloading():
return downloading(_that);case FileCloudDownloaded():
return downloaded(_that);case FileCloudError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FileCloudInitial value)?  initial,TResult? Function( FileCloudDownloading value)?  downloading,TResult? Function( FileCloudDownloaded value)?  downloaded,TResult? Function( FileCloudError value)?  error,}){
final _that = this;
switch (_that) {
case FileCloudInitial() when initial != null:
return initial(_that);case FileCloudDownloading() when downloading != null:
return downloading(_that);case FileCloudDownloaded() when downloaded != null:
return downloaded(_that);case FileCloudError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ClipboardItem item)?  downloading,TResult Function( ClipboardItem item)?  downloaded,TResult Function( Failure failure,  ClipboardItem item)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FileCloudInitial() when initial != null:
return initial();case FileCloudDownloading() when downloading != null:
return downloading(_that.item);case FileCloudDownloaded() when downloaded != null:
return downloaded(_that.item);case FileCloudError() when error != null:
return error(_that.failure,_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ClipboardItem item)  downloading,required TResult Function( ClipboardItem item)  downloaded,required TResult Function( Failure failure,  ClipboardItem item)  error,}) {final _that = this;
switch (_that) {
case FileCloudInitial():
return initial();case FileCloudDownloading():
return downloading(_that.item);case FileCloudDownloaded():
return downloaded(_that.item);case FileCloudError():
return error(_that.failure,_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ClipboardItem item)?  downloading,TResult? Function( ClipboardItem item)?  downloaded,TResult? Function( Failure failure,  ClipboardItem item)?  error,}) {final _that = this;
switch (_that) {
case FileCloudInitial() when initial != null:
return initial();case FileCloudDownloading() when downloading != null:
return downloading(_that.item);case FileCloudDownloaded() when downloaded != null:
return downloaded(_that.item);case FileCloudError() when error != null:
return error(_that.failure,_that.item);case _:
  return null;

}
}

}

/// @nodoc


class FileCloudInitial implements FileCloudState {
  const FileCloudInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileCloudInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FileCloudState.initial()';
}


}




/// @nodoc


class FileCloudDownloading implements FileCloudState {
  const FileCloudDownloading(this.item);
  

 final  ClipboardItem item;

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileCloudDownloadingCopyWith<FileCloudDownloading> get copyWith => _$FileCloudDownloadingCopyWithImpl<FileCloudDownloading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileCloudDownloading&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'FileCloudState.downloading(item: $item)';
}


}

/// @nodoc
abstract mixin class $FileCloudDownloadingCopyWith<$Res> implements $FileCloudStateCopyWith<$Res> {
  factory $FileCloudDownloadingCopyWith(FileCloudDownloading value, $Res Function(FileCloudDownloading) _then) = _$FileCloudDownloadingCopyWithImpl;
@useResult
$Res call({
 ClipboardItem item
});


$ClipboardItemCopyWith<$Res> get item;

}
/// @nodoc
class _$FileCloudDownloadingCopyWithImpl<$Res>
    implements $FileCloudDownloadingCopyWith<$Res> {
  _$FileCloudDownloadingCopyWithImpl(this._self, this._then);

  final FileCloudDownloading _self;
  final $Res Function(FileCloudDownloading) _then;

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(FileCloudDownloading(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ClipboardItem,
  ));
}

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClipboardItemCopyWith<$Res> get item {
  
  return $ClipboardItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class FileCloudDownloaded implements FileCloudState {
  const FileCloudDownloaded(this.item);
  

 final  ClipboardItem item;

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileCloudDownloadedCopyWith<FileCloudDownloaded> get copyWith => _$FileCloudDownloadedCopyWithImpl<FileCloudDownloaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileCloudDownloaded&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'FileCloudState.downloaded(item: $item)';
}


}

/// @nodoc
abstract mixin class $FileCloudDownloadedCopyWith<$Res> implements $FileCloudStateCopyWith<$Res> {
  factory $FileCloudDownloadedCopyWith(FileCloudDownloaded value, $Res Function(FileCloudDownloaded) _then) = _$FileCloudDownloadedCopyWithImpl;
@useResult
$Res call({
 ClipboardItem item
});


$ClipboardItemCopyWith<$Res> get item;

}
/// @nodoc
class _$FileCloudDownloadedCopyWithImpl<$Res>
    implements $FileCloudDownloadedCopyWith<$Res> {
  _$FileCloudDownloadedCopyWithImpl(this._self, this._then);

  final FileCloudDownloaded _self;
  final $Res Function(FileCloudDownloaded) _then;

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(FileCloudDownloaded(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ClipboardItem,
  ));
}

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClipboardItemCopyWith<$Res> get item {
  
  return $ClipboardItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class FileCloudError implements FileCloudState {
  const FileCloudError(this.failure, this.item);
  

 final  Failure failure;
 final  ClipboardItem item;

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileCloudErrorCopyWith<FileCloudError> get copyWith => _$FileCloudErrorCopyWithImpl<FileCloudError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileCloudError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,failure,item);

@override
String toString() {
  return 'FileCloudState.error(failure: $failure, item: $item)';
}


}

/// @nodoc
abstract mixin class $FileCloudErrorCopyWith<$Res> implements $FileCloudStateCopyWith<$Res> {
  factory $FileCloudErrorCopyWith(FileCloudError value, $Res Function(FileCloudError) _then) = _$FileCloudErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure, ClipboardItem item
});


$ClipboardItemCopyWith<$Res> get item;

}
/// @nodoc
class _$FileCloudErrorCopyWithImpl<$Res>
    implements $FileCloudErrorCopyWith<$Res> {
  _$FileCloudErrorCopyWithImpl(this._self, this._then);

  final FileCloudError _self;
  final $Res Function(FileCloudError) _then;

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? item = null,}) {
  return _then(FileCloudError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ClipboardItem,
  ));
}

/// Create a copy of FileCloudState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClipboardItemCopyWith<$Res> get item {
  
  return $ClipboardItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
