// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncStatusState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() syncing,
    required TResult Function() complete,
    required TResult Function(Failure failure) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? syncing,
    TResult? Function()? complete,
    TResult? Function(Failure failure)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? syncing,
    TResult Function()? complete,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusStateCopyWith<$Res> {
  factory $SyncStatusStateCopyWith(
    SyncStatusState value,
    $Res Function(SyncStatusState) then,
  ) = _$SyncStatusStateCopyWithImpl<$Res, SyncStatusState>;
}

/// @nodoc
class _$SyncStatusStateCopyWithImpl<$Res, $Val extends SyncStatusState>
    implements $SyncStatusStateCopyWith<$Res> {
  _$SyncStatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncStatusUnknownImplCopyWith<$Res> {
  factory _$$SyncStatusUnknownImplCopyWith(
    _$SyncStatusUnknownImpl value,
    $Res Function(_$SyncStatusUnknownImpl) then,
  ) = __$$SyncStatusUnknownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusUnknownImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncStatusUnknownImpl>
    implements _$$SyncStatusUnknownImplCopyWith<$Res> {
  __$$SyncStatusUnknownImplCopyWithImpl(
    _$SyncStatusUnknownImpl _value,
    $Res Function(_$SyncStatusUnknownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncStatusUnknownImpl implements SyncStatusUnknown {
  const _$SyncStatusUnknownImpl();

  @override
  String toString() {
    return 'SyncStatusState.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStatusUnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() syncing,
    required TResult Function() complete,
    required TResult Function(Failure failure) failed,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? syncing,
    TResult? Function()? complete,
    TResult? Function(Failure failure)? failed,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? syncing,
    TResult Function()? complete,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class SyncStatusUnknown implements SyncStatusState {
  const factory SyncStatusUnknown() = _$SyncStatusUnknownImpl;
}

/// @nodoc
abstract class _$$SyncingStatusImplCopyWith<$Res> {
  factory _$$SyncingStatusImplCopyWith(
    _$SyncingStatusImpl value,
    $Res Function(_$SyncingStatusImpl) then,
  ) = __$$SyncingStatusImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncingStatusImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncingStatusImpl>
    implements _$$SyncingStatusImplCopyWith<$Res> {
  __$$SyncingStatusImplCopyWithImpl(
    _$SyncingStatusImpl _value,
    $Res Function(_$SyncingStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncingStatusImpl implements SyncingStatus {
  const _$SyncingStatusImpl();

  @override
  String toString() {
    return 'SyncStatusState.syncing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncingStatusImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() syncing,
    required TResult Function() complete,
    required TResult Function(Failure failure) failed,
  }) {
    return syncing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? syncing,
    TResult? Function()? complete,
    TResult? Function(Failure failure)? failed,
  }) {
    return syncing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? syncing,
    TResult Function()? complete,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class SyncingStatus implements SyncStatusState {
  const factory SyncingStatus() = _$SyncingStatusImpl;
}

/// @nodoc
abstract class _$$SyncStatusCompleteImplCopyWith<$Res> {
  factory _$$SyncStatusCompleteImplCopyWith(
    _$SyncStatusCompleteImpl value,
    $Res Function(_$SyncStatusCompleteImpl) then,
  ) = __$$SyncStatusCompleteImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusCompleteImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncStatusCompleteImpl>
    implements _$$SyncStatusCompleteImplCopyWith<$Res> {
  __$$SyncStatusCompleteImplCopyWithImpl(
    _$SyncStatusCompleteImpl _value,
    $Res Function(_$SyncStatusCompleteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncStatusCompleteImpl implements SyncStatusComplete {
  const _$SyncStatusCompleteImpl();

  @override
  String toString() {
    return 'SyncStatusState.complete()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStatusCompleteImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() syncing,
    required TResult Function() complete,
    required TResult Function(Failure failure) failed,
  }) {
    return complete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? syncing,
    TResult? Function()? complete,
    TResult? Function(Failure failure)? failed,
  }) {
    return complete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? syncing,
    TResult Function()? complete,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
  }) {
    return complete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
  }) {
    return complete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(this);
    }
    return orElse();
  }
}

abstract class SyncStatusComplete implements SyncStatusState {
  const factory SyncStatusComplete() = _$SyncStatusCompleteImpl;
}

/// @nodoc
abstract class _$$SyncStatusFailedImplCopyWith<$Res> {
  factory _$$SyncStatusFailedImplCopyWith(
    _$SyncStatusFailedImpl value,
    $Res Function(_$SyncStatusFailedImpl) then,
  ) = __$$SyncStatusFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});
}

/// @nodoc
class __$$SyncStatusFailedImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncStatusFailedImpl>
    implements _$$SyncStatusFailedImplCopyWith<$Res> {
  __$$SyncStatusFailedImplCopyWithImpl(
    _$SyncStatusFailedImpl _value,
    $Res Function(_$SyncStatusFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$SyncStatusFailedImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }
}

/// @nodoc

class _$SyncStatusFailedImpl implements SyncStatusFailed {
  const _$SyncStatusFailedImpl(this.failure);

  @override
  final Failure failure;

  @override
  String toString() {
    return 'SyncStatusState.failed(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusFailedImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusFailedImplCopyWith<_$SyncStatusFailedImpl> get copyWith =>
      __$$SyncStatusFailedImplCopyWithImpl<_$SyncStatusFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() syncing,
    required TResult Function() complete,
    required TResult Function(Failure failure) failed,
  }) {
    return failed(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? syncing,
    TResult? Function()? complete,
    TResult? Function(Failure failure)? failed,
  }) {
    return failed?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? syncing,
    TResult Function()? complete,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class SyncStatusFailed implements SyncStatusState {
  const factory SyncStatusFailed(final Failure failure) =
      _$SyncStatusFailedImpl;

  Failure get failure;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusFailedImplCopyWith<_$SyncStatusFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
