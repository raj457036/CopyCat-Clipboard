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
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
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
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
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
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
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
  @useResult
  $Res call({Map<String, SyncProgress> progress});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? progress = null}) {
    return _then(
      _$SyncingStatusImpl(
        progress: null == progress
            ? _value._progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as Map<String, SyncProgress>,
      ),
    );
  }
}

/// @nodoc

class _$SyncingStatusImpl implements SyncingStatus {
  const _$SyncingStatusImpl({
    final Map<String, SyncProgress> progress = const <String, SyncProgress>{},
  }) : _progress = progress;

  final Map<String, SyncProgress> _progress;
  @override
  @JsonKey()
  Map<String, SyncProgress> get progress {
    if (_progress is EqualUnmodifiableMapView) return _progress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_progress);
  }

  @override
  String toString() {
    return 'SyncStatusState.syncing(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncingStatusImpl &&
            const DeepCollectionEquality().equals(other._progress, _progress));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_progress));

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncingStatusImplCopyWith<_$SyncingStatusImpl> get copyWith =>
      __$$SyncingStatusImplCopyWithImpl<_$SyncingStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) {
    return syncing(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) {
    return syncing?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class SyncingStatus implements SyncStatusState {
  const factory SyncingStatus({final Map<String, SyncProgress> progress}) =
      _$SyncingStatusImpl;

  Map<String, SyncProgress> get progress;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncingStatusImplCopyWith<_$SyncingStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncStatusDecryptingImplCopyWith<$Res> {
  factory _$$SyncStatusDecryptingImplCopyWith(
    _$SyncStatusDecryptingImpl value,
    $Res Function(_$SyncStatusDecryptingImpl) then,
  ) = __$$SyncStatusDecryptingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int decrypted, int total});
}

/// @nodoc
class __$$SyncStatusDecryptingImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncStatusDecryptingImpl>
    implements _$$SyncStatusDecryptingImplCopyWith<$Res> {
  __$$SyncStatusDecryptingImplCopyWithImpl(
    _$SyncStatusDecryptingImpl _value,
    $Res Function(_$SyncStatusDecryptingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? decrypted = null, Object? total = null}) {
    return _then(
      _$SyncStatusDecryptingImpl(
        decrypted: null == decrypted
            ? _value.decrypted
            : decrypted // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SyncStatusDecryptingImpl implements SyncStatusDecrypting {
  const _$SyncStatusDecryptingImpl({this.decrypted = 0, this.total = 0});

  @override
  @JsonKey()
  final int decrypted;
  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'SyncStatusState.decrypting(decrypted: $decrypted, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusDecryptingImpl &&
            (identical(other.decrypted, decrypted) ||
                other.decrypted == decrypted) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, decrypted, total);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusDecryptingImplCopyWith<_$SyncStatusDecryptingImpl>
  get copyWith =>
      __$$SyncStatusDecryptingImplCopyWithImpl<_$SyncStatusDecryptingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) {
    return decrypting(decrypted, total);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) {
    return decrypting?.call(decrypted, total);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (decrypting != null) {
      return decrypting(decrypted, total);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) {
    return decrypting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) {
    return decrypting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
    required TResult orElse(),
  }) {
    if (decrypting != null) {
      return decrypting(this);
    }
    return orElse();
  }
}

abstract class SyncStatusDecrypting implements SyncStatusState {
  const factory SyncStatusDecrypting({final int decrypted, final int total}) =
      _$SyncStatusDecryptingImpl;

  int get decrypted;
  int get total;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusDecryptingImplCopyWith<_$SyncStatusDecryptingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncStatusCompleteImplCopyWith<$Res> {
  factory _$$SyncStatusCompleteImplCopyWith(
    _$SyncStatusCompleteImpl value,
    $Res Function(_$SyncStatusCompleteImpl) then,
  ) = __$$SyncStatusCompleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hasUpdates});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hasUpdates = null}) {
    return _then(
      _$SyncStatusCompleteImpl(
        hasUpdates: null == hasUpdates
            ? _value.hasUpdates
            : hasUpdates // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SyncStatusCompleteImpl implements SyncStatusComplete {
  const _$SyncStatusCompleteImpl({this.hasUpdates = false});

  @override
  @JsonKey()
  final bool hasUpdates;

  @override
  String toString() {
    return 'SyncStatusState.complete(hasUpdates: $hasUpdates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusCompleteImpl &&
            (identical(other.hasUpdates, hasUpdates) ||
                other.hasUpdates == hasUpdates));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasUpdates);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusCompleteImplCopyWith<_$SyncStatusCompleteImpl> get copyWith =>
      __$$SyncStatusCompleteImplCopyWithImpl<_$SyncStatusCompleteImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) {
    return complete(hasUpdates);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) {
    return complete?.call(hasUpdates);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(hasUpdates);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) {
    return complete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) {
    return complete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(this);
    }
    return orElse();
  }
}

abstract class SyncStatusComplete implements SyncStatusState {
  const factory SyncStatusComplete({final bool hasUpdates}) =
      _$SyncStatusCompleteImpl;

  bool get hasUpdates;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusCompleteImplCopyWith<_$SyncStatusCompleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) {
    return failed(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) {
    return failed?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
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
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
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

/// @nodoc
abstract class _$$SyncStatusDisabledImplCopyWith<$Res> {
  factory _$$SyncStatusDisabledImplCopyWith(
    _$SyncStatusDisabledImpl value,
    $Res Function(_$SyncStatusDisabledImpl) then,
  ) = __$$SyncStatusDisabledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusDisabledImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncStatusDisabledImpl>
    implements _$$SyncStatusDisabledImplCopyWith<$Res> {
  __$$SyncStatusDisabledImplCopyWithImpl(
    _$SyncStatusDisabledImpl _value,
    $Res Function(_$SyncStatusDisabledImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncStatusDisabledImpl implements SyncStatusDisabled {
  const _$SyncStatusDisabledImpl();

  @override
  String toString() {
    return 'SyncStatusState.disabled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStatusDisabledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function(Map<String, SyncProgress> progress) syncing,
    required TResult Function(int decrypted, int total) decrypting,
    required TResult Function(bool hasUpdates) complete,
    required TResult Function(Failure failure) failed,
    required TResult Function() disabled,
  }) {
    return disabled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function(Map<String, SyncProgress> progress)? syncing,
    TResult? Function(int decrypted, int total)? decrypting,
    TResult? Function(bool hasUpdates)? complete,
    TResult? Function(Failure failure)? failed,
    TResult? Function()? disabled,
  }) {
    return disabled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function(Map<String, SyncProgress> progress)? syncing,
    TResult Function(int decrypted, int total)? decrypting,
    TResult Function(bool hasUpdates)? complete,
    TResult Function(Failure failure)? failed,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (disabled != null) {
      return disabled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStatusUnknown value) unknown,
    required TResult Function(SyncingStatus value) syncing,
    required TResult Function(SyncStatusDecrypting value) decrypting,
    required TResult Function(SyncStatusComplete value) complete,
    required TResult Function(SyncStatusFailed value) failed,
    required TResult Function(SyncStatusDisabled value) disabled,
  }) {
    return disabled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStatusUnknown value)? unknown,
    TResult? Function(SyncingStatus value)? syncing,
    TResult? Function(SyncStatusDecrypting value)? decrypting,
    TResult? Function(SyncStatusComplete value)? complete,
    TResult? Function(SyncStatusFailed value)? failed,
    TResult? Function(SyncStatusDisabled value)? disabled,
  }) {
    return disabled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStatusUnknown value)? unknown,
    TResult Function(SyncingStatus value)? syncing,
    TResult Function(SyncStatusDecrypting value)? decrypting,
    TResult Function(SyncStatusComplete value)? complete,
    TResult Function(SyncStatusFailed value)? failed,
    TResult Function(SyncStatusDisabled value)? disabled,
    required TResult orElse(),
  }) {
    if (disabled != null) {
      return disabled(this);
    }
    return orElse();
  }
}

abstract class SyncStatusDisabled implements SyncStatusState {
  const factory SyncStatusDisabled() = _$SyncStatusDisabledImpl;
}
