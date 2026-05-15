// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_cloud_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FileCloudState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(ClipboardItem item) downloading,
    required TResult Function(ClipboardItem item) downloaded,
    required TResult Function(Failure failure, ClipboardItem item) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(ClipboardItem item)? downloading,
    TResult? Function(ClipboardItem item)? downloaded,
    TResult? Function(Failure failure, ClipboardItem item)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(ClipboardItem item)? downloading,
    TResult Function(ClipboardItem item)? downloaded,
    TResult Function(Failure failure, ClipboardItem item)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileCloudInitial value) initial,
    required TResult Function(FileCloudDownloading value) downloading,
    required TResult Function(FileCloudDownloaded value) downloaded,
    required TResult Function(FileCloudError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileCloudInitial value)? initial,
    TResult? Function(FileCloudDownloading value)? downloading,
    TResult? Function(FileCloudDownloaded value)? downloaded,
    TResult? Function(FileCloudError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileCloudInitial value)? initial,
    TResult Function(FileCloudDownloading value)? downloading,
    TResult Function(FileCloudDownloaded value)? downloaded,
    TResult Function(FileCloudError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileCloudStateCopyWith<$Res> {
  factory $FileCloudStateCopyWith(
    FileCloudState value,
    $Res Function(FileCloudState) then,
  ) = _$FileCloudStateCopyWithImpl<$Res, FileCloudState>;
}

/// @nodoc
class _$FileCloudStateCopyWithImpl<$Res, $Val extends FileCloudState>
    implements $FileCloudStateCopyWith<$Res> {
  _$FileCloudStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FileCloudInitialImplCopyWith<$Res> {
  factory _$$FileCloudInitialImplCopyWith(
    _$FileCloudInitialImpl value,
    $Res Function(_$FileCloudInitialImpl) then,
  ) = __$$FileCloudInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FileCloudInitialImplCopyWithImpl<$Res>
    extends _$FileCloudStateCopyWithImpl<$Res, _$FileCloudInitialImpl>
    implements _$$FileCloudInitialImplCopyWith<$Res> {
  __$$FileCloudInitialImplCopyWithImpl(
    _$FileCloudInitialImpl _value,
    $Res Function(_$FileCloudInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FileCloudInitialImpl implements FileCloudInitial {
  const _$FileCloudInitialImpl();

  @override
  String toString() {
    return 'FileCloudState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FileCloudInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(ClipboardItem item) downloading,
    required TResult Function(ClipboardItem item) downloaded,
    required TResult Function(Failure failure, ClipboardItem item) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(ClipboardItem item)? downloading,
    TResult? Function(ClipboardItem item)? downloaded,
    TResult? Function(Failure failure, ClipboardItem item)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(ClipboardItem item)? downloading,
    TResult Function(ClipboardItem item)? downloaded,
    TResult Function(Failure failure, ClipboardItem item)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileCloudInitial value) initial,
    required TResult Function(FileCloudDownloading value) downloading,
    required TResult Function(FileCloudDownloaded value) downloaded,
    required TResult Function(FileCloudError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileCloudInitial value)? initial,
    TResult? Function(FileCloudDownloading value)? downloading,
    TResult? Function(FileCloudDownloaded value)? downloaded,
    TResult? Function(FileCloudError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileCloudInitial value)? initial,
    TResult Function(FileCloudDownloading value)? downloading,
    TResult Function(FileCloudDownloaded value)? downloaded,
    TResult Function(FileCloudError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FileCloudInitial implements FileCloudState {
  const factory FileCloudInitial() = _$FileCloudInitialImpl;
}

/// @nodoc
abstract class _$$FileCloudDownloadingImplCopyWith<$Res> {
  factory _$$FileCloudDownloadingImplCopyWith(
    _$FileCloudDownloadingImpl value,
    $Res Function(_$FileCloudDownloadingImpl) then,
  ) = __$$FileCloudDownloadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ClipboardItem item});

  $ClipboardItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$FileCloudDownloadingImplCopyWithImpl<$Res>
    extends _$FileCloudStateCopyWithImpl<$Res, _$FileCloudDownloadingImpl>
    implements _$$FileCloudDownloadingImplCopyWith<$Res> {
  __$$FileCloudDownloadingImplCopyWithImpl(
    _$FileCloudDownloadingImpl _value,
    $Res Function(_$FileCloudDownloadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? item = null}) {
    return _then(
      _$FileCloudDownloadingImpl(
        null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ClipboardItem,
      ),
    );
  }

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClipboardItemCopyWith<$Res> get item {
    return $ClipboardItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value));
    });
  }
}

/// @nodoc

class _$FileCloudDownloadingImpl implements FileCloudDownloading {
  const _$FileCloudDownloadingImpl(this.item);

  @override
  final ClipboardItem item;

  @override
  String toString() {
    return 'FileCloudState.downloading(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileCloudDownloadingImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileCloudDownloadingImplCopyWith<_$FileCloudDownloadingImpl>
  get copyWith =>
      __$$FileCloudDownloadingImplCopyWithImpl<_$FileCloudDownloadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(ClipboardItem item) downloading,
    required TResult Function(ClipboardItem item) downloaded,
    required TResult Function(Failure failure, ClipboardItem item) error,
  }) {
    return downloading(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(ClipboardItem item)? downloading,
    TResult? Function(ClipboardItem item)? downloaded,
    TResult? Function(Failure failure, ClipboardItem item)? error,
  }) {
    return downloading?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(ClipboardItem item)? downloading,
    TResult Function(ClipboardItem item)? downloaded,
    TResult Function(Failure failure, ClipboardItem item)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileCloudInitial value) initial,
    required TResult Function(FileCloudDownloading value) downloading,
    required TResult Function(FileCloudDownloaded value) downloaded,
    required TResult Function(FileCloudError value) error,
  }) {
    return downloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileCloudInitial value)? initial,
    TResult? Function(FileCloudDownloading value)? downloading,
    TResult? Function(FileCloudDownloaded value)? downloaded,
    TResult? Function(FileCloudError value)? error,
  }) {
    return downloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileCloudInitial value)? initial,
    TResult Function(FileCloudDownloading value)? downloading,
    TResult Function(FileCloudDownloaded value)? downloaded,
    TResult Function(FileCloudError value)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(this);
    }
    return orElse();
  }
}

abstract class FileCloudDownloading implements FileCloudState {
  const factory FileCloudDownloading(final ClipboardItem item) =
      _$FileCloudDownloadingImpl;

  ClipboardItem get item;

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileCloudDownloadingImplCopyWith<_$FileCloudDownloadingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileCloudDownloadedImplCopyWith<$Res> {
  factory _$$FileCloudDownloadedImplCopyWith(
    _$FileCloudDownloadedImpl value,
    $Res Function(_$FileCloudDownloadedImpl) then,
  ) = __$$FileCloudDownloadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ClipboardItem item});

  $ClipboardItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$FileCloudDownloadedImplCopyWithImpl<$Res>
    extends _$FileCloudStateCopyWithImpl<$Res, _$FileCloudDownloadedImpl>
    implements _$$FileCloudDownloadedImplCopyWith<$Res> {
  __$$FileCloudDownloadedImplCopyWithImpl(
    _$FileCloudDownloadedImpl _value,
    $Res Function(_$FileCloudDownloadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? item = null}) {
    return _then(
      _$FileCloudDownloadedImpl(
        null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ClipboardItem,
      ),
    );
  }

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClipboardItemCopyWith<$Res> get item {
    return $ClipboardItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value));
    });
  }
}

/// @nodoc

class _$FileCloudDownloadedImpl implements FileCloudDownloaded {
  const _$FileCloudDownloadedImpl(this.item);

  @override
  final ClipboardItem item;

  @override
  String toString() {
    return 'FileCloudState.downloaded(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileCloudDownloadedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileCloudDownloadedImplCopyWith<_$FileCloudDownloadedImpl> get copyWith =>
      __$$FileCloudDownloadedImplCopyWithImpl<_$FileCloudDownloadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(ClipboardItem item) downloading,
    required TResult Function(ClipboardItem item) downloaded,
    required TResult Function(Failure failure, ClipboardItem item) error,
  }) {
    return downloaded(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(ClipboardItem item)? downloading,
    TResult? Function(ClipboardItem item)? downloaded,
    TResult? Function(Failure failure, ClipboardItem item)? error,
  }) {
    return downloaded?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(ClipboardItem item)? downloading,
    TResult Function(ClipboardItem item)? downloaded,
    TResult Function(Failure failure, ClipboardItem item)? error,
    required TResult orElse(),
  }) {
    if (downloaded != null) {
      return downloaded(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileCloudInitial value) initial,
    required TResult Function(FileCloudDownloading value) downloading,
    required TResult Function(FileCloudDownloaded value) downloaded,
    required TResult Function(FileCloudError value) error,
  }) {
    return downloaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileCloudInitial value)? initial,
    TResult? Function(FileCloudDownloading value)? downloading,
    TResult? Function(FileCloudDownloaded value)? downloaded,
    TResult? Function(FileCloudError value)? error,
  }) {
    return downloaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileCloudInitial value)? initial,
    TResult Function(FileCloudDownloading value)? downloading,
    TResult Function(FileCloudDownloaded value)? downloaded,
    TResult Function(FileCloudError value)? error,
    required TResult orElse(),
  }) {
    if (downloaded != null) {
      return downloaded(this);
    }
    return orElse();
  }
}

abstract class FileCloudDownloaded implements FileCloudState {
  const factory FileCloudDownloaded(final ClipboardItem item) =
      _$FileCloudDownloadedImpl;

  ClipboardItem get item;

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileCloudDownloadedImplCopyWith<_$FileCloudDownloadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileCloudErrorImplCopyWith<$Res> {
  factory _$$FileCloudErrorImplCopyWith(
    _$FileCloudErrorImpl value,
    $Res Function(_$FileCloudErrorImpl) then,
  ) = __$$FileCloudErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure, ClipboardItem item});

  $ClipboardItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$FileCloudErrorImplCopyWithImpl<$Res>
    extends _$FileCloudStateCopyWithImpl<$Res, _$FileCloudErrorImpl>
    implements _$$FileCloudErrorImplCopyWith<$Res> {
  __$$FileCloudErrorImplCopyWithImpl(
    _$FileCloudErrorImpl _value,
    $Res Function(_$FileCloudErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null, Object? item = null}) {
    return _then(
      _$FileCloudErrorImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
        null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ClipboardItem,
      ),
    );
  }

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClipboardItemCopyWith<$Res> get item {
    return $ClipboardItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value));
    });
  }
}

/// @nodoc

class _$FileCloudErrorImpl implements FileCloudError {
  const _$FileCloudErrorImpl(this.failure, this.item);

  @override
  final Failure failure;
  @override
  final ClipboardItem item;

  @override
  String toString() {
    return 'FileCloudState.error(failure: $failure, item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileCloudErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure, item);

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileCloudErrorImplCopyWith<_$FileCloudErrorImpl> get copyWith =>
      __$$FileCloudErrorImplCopyWithImpl<_$FileCloudErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(ClipboardItem item) downloading,
    required TResult Function(ClipboardItem item) downloaded,
    required TResult Function(Failure failure, ClipboardItem item) error,
  }) {
    return error(failure, item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(ClipboardItem item)? downloading,
    TResult? Function(ClipboardItem item)? downloaded,
    TResult? Function(Failure failure, ClipboardItem item)? error,
  }) {
    return error?.call(failure, item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(ClipboardItem item)? downloading,
    TResult Function(ClipboardItem item)? downloaded,
    TResult Function(Failure failure, ClipboardItem item)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure, item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileCloudInitial value) initial,
    required TResult Function(FileCloudDownloading value) downloading,
    required TResult Function(FileCloudDownloaded value) downloaded,
    required TResult Function(FileCloudError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileCloudInitial value)? initial,
    TResult? Function(FileCloudDownloading value)? downloading,
    TResult? Function(FileCloudDownloaded value)? downloaded,
    TResult? Function(FileCloudError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileCloudInitial value)? initial,
    TResult Function(FileCloudDownloading value)? downloading,
    TResult Function(FileCloudDownloaded value)? downloaded,
    TResult Function(FileCloudError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FileCloudError implements FileCloudState {
  const factory FileCloudError(
    final Failure failure,
    final ClipboardItem item,
  ) = _$FileCloudErrorImpl;

  Failure get failure;
  ClipboardItem get item;

  /// Create a copy of FileCloudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileCloudErrorImplCopyWith<_$FileCloudErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
