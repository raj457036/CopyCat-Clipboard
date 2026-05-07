// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_persistance_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OfflinePersistanceState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfflinePersistanceStateCopyWith<$Res> {
  factory $OfflinePersistanceStateCopyWith(
    OfflinePersistanceState value,
    $Res Function(OfflinePersistanceState) then,
  ) = _$OfflinePersistanceStateCopyWithImpl<$Res, OfflinePersistanceState>;
}

/// @nodoc
class _$OfflinePersistanceStateCopyWithImpl<
  $Res,
  $Val extends OfflinePersistanceState
>
    implements $OfflinePersistanceStateCopyWith<$Res> {
  _$OfflinePersistanceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OfflinePersistanceInitialImplCopyWith<$Res> {
  factory _$$OfflinePersistanceInitialImplCopyWith(
    _$OfflinePersistanceInitialImpl value,
    $Res Function(_$OfflinePersistanceInitialImpl) then,
  ) = __$$OfflinePersistanceInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OfflinePersistanceInitialImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceInitialImpl
        >
    implements _$$OfflinePersistanceInitialImplCopyWith<$Res> {
  __$$OfflinePersistanceInitialImplCopyWithImpl(
    _$OfflinePersistanceInitialImpl _value,
    $Res Function(_$OfflinePersistanceInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OfflinePersistanceInitialImpl implements OfflinePersistanceInitial {
  const _$OfflinePersistanceInitialImpl();

  @override
  String toString() {
    return 'OfflinePersistanceState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
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
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceInitial implements OfflinePersistanceState {
  const factory OfflinePersistanceInitial() = _$OfflinePersistanceInitialImpl;
}

/// @nodoc
abstract class _$$OfflinePersistanceCreatingImplCopyWith<$Res> {
  factory _$$OfflinePersistanceCreatingImplCopyWith(
    _$OfflinePersistanceCreatingImpl value,
    $Res Function(_$OfflinePersistanceCreatingImpl) then,
  ) = __$$OfflinePersistanceCreatingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$OfflinePersistanceCreatingImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceCreatingImpl
        >
    implements _$$OfflinePersistanceCreatingImplCopyWith<$Res> {
  __$$OfflinePersistanceCreatingImplCopyWithImpl(
    _$OfflinePersistanceCreatingImpl _value,
    $Res Function(_$OfflinePersistanceCreatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null}) {
    return _then(
      _$OfflinePersistanceCreatingImpl(
        null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OfflinePersistanceCreatingImpl implements OfflinePersistanceCreating {
  const _$OfflinePersistanceCreatingImpl(this.count);

  @override
  final int count;

  @override
  String toString() {
    return 'OfflinePersistanceState.creatingItems(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceCreatingImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflinePersistanceCreatingImplCopyWith<_$OfflinePersistanceCreatingImpl>
  get copyWith =>
      __$$OfflinePersistanceCreatingImplCopyWithImpl<
        _$OfflinePersistanceCreatingImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return creatingItems(count);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return creatingItems?.call(count);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
    required TResult orElse(),
  }) {
    if (creatingItems != null) {
      return creatingItems(count);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return creatingItems(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return creatingItems?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (creatingItems != null) {
      return creatingItems(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceCreating implements OfflinePersistanceState {
  const factory OfflinePersistanceCreating(final int count) =
      _$OfflinePersistanceCreatingImpl;

  int get count;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflinePersistanceCreatingImplCopyWith<_$OfflinePersistanceCreatingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OfflinePersistanceUpdatingImplCopyWith<$Res> {
  factory _$$OfflinePersistanceUpdatingImplCopyWith(
    _$OfflinePersistanceUpdatingImpl value,
    $Res Function(_$OfflinePersistanceUpdatingImpl) then,
  ) = __$$OfflinePersistanceUpdatingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$OfflinePersistanceUpdatingImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceUpdatingImpl
        >
    implements _$$OfflinePersistanceUpdatingImplCopyWith<$Res> {
  __$$OfflinePersistanceUpdatingImplCopyWithImpl(
    _$OfflinePersistanceUpdatingImpl _value,
    $Res Function(_$OfflinePersistanceUpdatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null}) {
    return _then(
      _$OfflinePersistanceUpdatingImpl(
        null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OfflinePersistanceUpdatingImpl implements OfflinePersistanceUpdating {
  const _$OfflinePersistanceUpdatingImpl(this.count);

  @override
  final int count;

  @override
  String toString() {
    return 'OfflinePersistanceState.updatingItems(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceUpdatingImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflinePersistanceUpdatingImplCopyWith<_$OfflinePersistanceUpdatingImpl>
  get copyWith =>
      __$$OfflinePersistanceUpdatingImplCopyWithImpl<
        _$OfflinePersistanceUpdatingImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return updatingItems(count);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return updatingItems?.call(count);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
    required TResult orElse(),
  }) {
    if (updatingItems != null) {
      return updatingItems(count);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return updatingItems(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return updatingItems?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (updatingItems != null) {
      return updatingItems(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceUpdating implements OfflinePersistanceState {
  const factory OfflinePersistanceUpdating(final int count) =
      _$OfflinePersistanceUpdatingImpl;

  int get count;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflinePersistanceUpdatingImplCopyWith<_$OfflinePersistanceUpdatingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OfflinePersistanceDeletingImplCopyWith<$Res> {
  factory _$$OfflinePersistanceDeletingImplCopyWith(
    _$OfflinePersistanceDeletingImpl value,
    $Res Function(_$OfflinePersistanceDeletingImpl) then,
  ) = __$$OfflinePersistanceDeletingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$OfflinePersistanceDeletingImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceDeletingImpl
        >
    implements _$$OfflinePersistanceDeletingImplCopyWith<$Res> {
  __$$OfflinePersistanceDeletingImplCopyWithImpl(
    _$OfflinePersistanceDeletingImpl _value,
    $Res Function(_$OfflinePersistanceDeletingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null}) {
    return _then(
      _$OfflinePersistanceDeletingImpl(
        null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OfflinePersistanceDeletingImpl implements OfflinePersistanceDeleting {
  const _$OfflinePersistanceDeletingImpl(this.count);

  @override
  final int count;

  @override
  String toString() {
    return 'OfflinePersistanceState.deletingItems(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceDeletingImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflinePersistanceDeletingImplCopyWith<_$OfflinePersistanceDeletingImpl>
  get copyWith =>
      __$$OfflinePersistanceDeletingImplCopyWithImpl<
        _$OfflinePersistanceDeletingImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return deletingItems(count);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return deletingItems?.call(count);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
    required TResult orElse(),
  }) {
    if (deletingItems != null) {
      return deletingItems(count);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return deletingItems(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return deletingItems?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (deletingItems != null) {
      return deletingItems(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceDeleting implements OfflinePersistanceState {
  const factory OfflinePersistanceDeleting(final int count) =
      _$OfflinePersistanceDeletingImpl;

  int get count;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflinePersistanceDeletingImplCopyWith<_$OfflinePersistanceDeletingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OfflinePersistanceDeletedImplCopyWith<$Res> {
  factory _$$OfflinePersistanceDeletedImplCopyWith(
    _$OfflinePersistanceDeletedImpl value,
    $Res Function(_$OfflinePersistanceDeletedImpl) then,
  ) = __$$OfflinePersistanceDeletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$OfflinePersistanceDeletedImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceDeletedImpl
        >
    implements _$$OfflinePersistanceDeletedImplCopyWith<$Res> {
  __$$OfflinePersistanceDeletedImplCopyWithImpl(
    _$OfflinePersistanceDeletedImpl _value,
    $Res Function(_$OfflinePersistanceDeletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null}) {
    return _then(
      _$OfflinePersistanceDeletedImpl(
        null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OfflinePersistanceDeletedImpl implements OfflinePersistanceDeleted {
  const _$OfflinePersistanceDeletedImpl(this.count);

  @override
  final int count;

  @override
  String toString() {
    return 'OfflinePersistanceState.deletedItems(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceDeletedImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflinePersistanceDeletedImplCopyWith<_$OfflinePersistanceDeletedImpl>
  get copyWith =>
      __$$OfflinePersistanceDeletedImplCopyWithImpl<
        _$OfflinePersistanceDeletedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return deletedItems(count);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return deletedItems?.call(count);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
    required TResult orElse(),
  }) {
    if (deletedItems != null) {
      return deletedItems(count);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return deletedItems(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return deletedItems?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (deletedItems != null) {
      return deletedItems(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceDeleted implements OfflinePersistanceState {
  const factory OfflinePersistanceDeleted(final int count) =
      _$OfflinePersistanceDeletedImpl;

  int get count;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflinePersistanceDeletedImplCopyWith<_$OfflinePersistanceDeletedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OfflinePersistanceSavedImplCopyWith<$Res> {
  factory _$$OfflinePersistanceSavedImplCopyWith(
    _$OfflinePersistanceSavedImpl value,
    $Res Function(_$OfflinePersistanceSavedImpl) then,
  ) = __$$OfflinePersistanceSavedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    int count,
    bool created,
    bool synced,
    List<String>? updatedFields,
  });
}

/// @nodoc
class __$$OfflinePersistanceSavedImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceSavedImpl
        >
    implements _$$OfflinePersistanceSavedImplCopyWith<$Res> {
  __$$OfflinePersistanceSavedImplCopyWithImpl(
    _$OfflinePersistanceSavedImpl _value,
    $Res Function(_$OfflinePersistanceSavedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? created = null,
    Object? synced = null,
    Object? updatedFields = freezed,
  }) {
    return _then(
      _$OfflinePersistanceSavedImpl(
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        created: null == created
            ? _value.created
            : created // ignore: cast_nullable_to_non_nullable
                  as bool,
        synced: null == synced
            ? _value.synced
            : synced // ignore: cast_nullable_to_non_nullable
                  as bool,
        updatedFields: freezed == updatedFields
            ? _value._updatedFields
            : updatedFields // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$OfflinePersistanceSavedImpl implements OfflinePersistanceSaved {
  const _$OfflinePersistanceSavedImpl({
    this.count = 0,
    this.created = false,
    this.synced = false,
    final List<String>? updatedFields,
  }) : _updatedFields = updatedFields;

  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final bool created;
  @override
  @JsonKey()
  final bool synced;
  final List<String>? _updatedFields;
  @override
  List<String>? get updatedFields {
    final value = _updatedFields;
    if (value == null) return null;
    if (_updatedFields is EqualUnmodifiableListView) return _updatedFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OfflinePersistanceState.saved(count: $count, created: $created, synced: $synced, updatedFields: $updatedFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceSavedImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            const DeepCollectionEquality().equals(
              other._updatedFields,
              _updatedFields,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    count,
    created,
    synced,
    const DeepCollectionEquality().hash(_updatedFields),
  );

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflinePersistanceSavedImplCopyWith<_$OfflinePersistanceSavedImpl>
  get copyWith =>
      __$$OfflinePersistanceSavedImplCopyWithImpl<
        _$OfflinePersistanceSavedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return saved(count, created, synced, updatedFields);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return saved?.call(count, created, synced, updatedFields);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(count, created, synced, updatedFields);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return saved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return saved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceSaved implements OfflinePersistanceState {
  const factory OfflinePersistanceSaved({
    final int count,
    final bool created,
    final bool synced,
    final List<String>? updatedFields,
  }) = _$OfflinePersistanceSavedImpl;

  int get count;
  bool get created;
  bool get synced;
  List<String>? get updatedFields;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflinePersistanceSavedImplCopyWith<_$OfflinePersistanceSavedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OfflinePersistanceErrorImplCopyWith<$Res> {
  factory _$$OfflinePersistanceErrorImplCopyWith(
    _$OfflinePersistanceErrorImpl value,
    $Res Function(_$OfflinePersistanceErrorImpl) then,
  ) = __$$OfflinePersistanceErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure, ClipboardItem? item});

  $ClipboardItemCopyWith<$Res>? get item;
}

/// @nodoc
class __$$OfflinePersistanceErrorImplCopyWithImpl<$Res>
    extends
        _$OfflinePersistanceStateCopyWithImpl<
          $Res,
          _$OfflinePersistanceErrorImpl
        >
    implements _$$OfflinePersistanceErrorImplCopyWith<$Res> {
  __$$OfflinePersistanceErrorImplCopyWithImpl(
    _$OfflinePersistanceErrorImpl _value,
    $Res Function(_$OfflinePersistanceErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null, Object? item = freezed}) {
    return _then(
      _$OfflinePersistanceErrorImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
        freezed == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ClipboardItem?,
      ),
    );
  }

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClipboardItemCopyWith<$Res>? get item {
    if (_value.item == null) {
      return null;
    }

    return $ClipboardItemCopyWith<$Res>(_value.item!, (value) {
      return _then(_value.copyWith(item: value));
    });
  }
}

/// @nodoc

class _$OfflinePersistanceErrorImpl implements OfflinePersistanceError {
  const _$OfflinePersistanceErrorImpl(this.failure, [this.item]);

  @override
  final Failure failure;
  @override
  final ClipboardItem? item;

  @override
  String toString() {
    return 'OfflinePersistanceState.error(failure: $failure, item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflinePersistanceErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure, item);

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflinePersistanceErrorImplCopyWith<_$OfflinePersistanceErrorImpl>
  get copyWith =>
      __$$OfflinePersistanceErrorImplCopyWithImpl<
        _$OfflinePersistanceErrorImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int count) creatingItems,
    required TResult Function(int count) updatingItems,
    required TResult Function(int count) deletingItems,
    required TResult Function(int count) deletedItems,
    required TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )
    saved,
    required TResult Function(Failure failure, ClipboardItem? item) error,
  }) {
    return error(failure, item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int count)? creatingItems,
    TResult? Function(int count)? updatingItems,
    TResult? Function(int count)? deletingItems,
    TResult? Function(int count)? deletedItems,
    TResult? Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult? Function(Failure failure, ClipboardItem? item)? error,
  }) {
    return error?.call(failure, item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int count)? creatingItems,
    TResult Function(int count)? updatingItems,
    TResult Function(int count)? deletingItems,
    TResult Function(int count)? deletedItems,
    TResult Function(
      int count,
      bool created,
      bool synced,
      List<String>? updatedFields,
    )?
    saved,
    TResult Function(Failure failure, ClipboardItem? item)? error,
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
    required TResult Function(OfflinePersistanceInitial value) initial,
    required TResult Function(OfflinePersistanceCreating value) creatingItems,
    required TResult Function(OfflinePersistanceUpdating value) updatingItems,
    required TResult Function(OfflinePersistanceDeleting value) deletingItems,
    required TResult Function(OfflinePersistanceDeleted value) deletedItems,
    required TResult Function(OfflinePersistanceSaved value) saved,
    required TResult Function(OfflinePersistanceError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OfflinePersistanceInitial value)? initial,
    TResult? Function(OfflinePersistanceCreating value)? creatingItems,
    TResult? Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult? Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult? Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult? Function(OfflinePersistanceSaved value)? saved,
    TResult? Function(OfflinePersistanceError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OfflinePersistanceInitial value)? initial,
    TResult Function(OfflinePersistanceCreating value)? creatingItems,
    TResult Function(OfflinePersistanceUpdating value)? updatingItems,
    TResult Function(OfflinePersistanceDeleting value)? deletingItems,
    TResult Function(OfflinePersistanceDeleted value)? deletedItems,
    TResult Function(OfflinePersistanceSaved value)? saved,
    TResult Function(OfflinePersistanceError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class OfflinePersistanceError implements OfflinePersistanceState {
  const factory OfflinePersistanceError(
    final Failure failure, [
    final ClipboardItem? item,
  ]) = _$OfflinePersistanceErrorImpl;

  Failure get failure;
  ClipboardItem? get item;

  /// Create a copy of OfflinePersistanceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflinePersistanceErrorImplCopyWith<_$OfflinePersistanceErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
