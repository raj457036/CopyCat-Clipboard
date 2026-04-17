// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_bus_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EventBusState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(KeyboardShortcutEvent event) keyboard,
    required TResult Function(int index) indexPaste,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(KeyboardShortcutEvent event)? keyboard,
    TResult? Function(int index)? indexPaste,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(KeyboardShortcutEvent event)? keyboard,
    TResult Function(int index)? indexPaste,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(EventBusKeyboardEvent value) keyboard,
    required TResult Function(EventBusIndexPasteEvent value) indexPaste,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(EventBusKeyboardEvent value)? keyboard,
    TResult? Function(EventBusIndexPasteEvent value)? indexPaste,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(EventBusKeyboardEvent value)? keyboard,
    TResult Function(EventBusIndexPasteEvent value)? indexPaste,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventBusStateCopyWith<$Res> {
  factory $EventBusStateCopyWith(
    EventBusState value,
    $Res Function(EventBusState) then,
  ) = _$EventBusStateCopyWithImpl<$Res, EventBusState>;
}

/// @nodoc
class _$EventBusStateCopyWithImpl<$Res, $Val extends EventBusState>
    implements $EventBusStateCopyWith<$Res> {
  _$EventBusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<$Res> {
  factory _$$EmptyImplCopyWith(
    _$EmptyImpl value,
    $Res Function(_$EmptyImpl) then,
  ) = __$$EmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<$Res>
    extends _$EventBusStateCopyWithImpl<$Res, _$EmptyImpl>
    implements _$$EmptyImplCopyWith<$Res> {
  __$$EmptyImplCopyWithImpl(
    _$EmptyImpl _value,
    $Res Function(_$EmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmptyImpl implements _Empty {
  const _$EmptyImpl();

  @override
  String toString() {
    return 'EventBusState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(KeyboardShortcutEvent event) keyboard,
    required TResult Function(int index) indexPaste,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(KeyboardShortcutEvent event)? keyboard,
    TResult? Function(int index)? indexPaste,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(KeyboardShortcutEvent event)? keyboard,
    TResult Function(int index)? indexPaste,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(EventBusKeyboardEvent value) keyboard,
    required TResult Function(EventBusIndexPasteEvent value) indexPaste,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(EventBusKeyboardEvent value)? keyboard,
    TResult? Function(EventBusIndexPasteEvent value)? indexPaste,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(EventBusKeyboardEvent value)? keyboard,
    TResult Function(EventBusIndexPasteEvent value)? indexPaste,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _Empty implements EventBusState {
  const factory _Empty() = _$EmptyImpl;
}

/// @nodoc
abstract class _$$EventBusKeyboardEventImplCopyWith<$Res> {
  factory _$$EventBusKeyboardEventImplCopyWith(
    _$EventBusKeyboardEventImpl value,
    $Res Function(_$EventBusKeyboardEventImpl) then,
  ) = __$$EventBusKeyboardEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({KeyboardShortcutEvent event});
}

/// @nodoc
class __$$EventBusKeyboardEventImplCopyWithImpl<$Res>
    extends _$EventBusStateCopyWithImpl<$Res, _$EventBusKeyboardEventImpl>
    implements _$$EventBusKeyboardEventImplCopyWith<$Res> {
  __$$EventBusKeyboardEventImplCopyWithImpl(
    _$EventBusKeyboardEventImpl _value,
    $Res Function(_$EventBusKeyboardEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? event = null}) {
    return _then(
      _$EventBusKeyboardEventImpl(
        null == event
            ? _value.event
            : event // ignore: cast_nullable_to_non_nullable
                  as KeyboardShortcutEvent,
      ),
    );
  }
}

/// @nodoc

class _$EventBusKeyboardEventImpl implements EventBusKeyboardEvent {
  const _$EventBusKeyboardEventImpl(this.event);

  @override
  final KeyboardShortcutEvent event;

  @override
  String toString() {
    return 'EventBusState.keyboard(event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventBusKeyboardEventImpl &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventBusKeyboardEventImplCopyWith<_$EventBusKeyboardEventImpl>
  get copyWith =>
      __$$EventBusKeyboardEventImplCopyWithImpl<_$EventBusKeyboardEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(KeyboardShortcutEvent event) keyboard,
    required TResult Function(int index) indexPaste,
  }) {
    return keyboard(event);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(KeyboardShortcutEvent event)? keyboard,
    TResult? Function(int index)? indexPaste,
  }) {
    return keyboard?.call(event);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(KeyboardShortcutEvent event)? keyboard,
    TResult Function(int index)? indexPaste,
    required TResult orElse(),
  }) {
    if (keyboard != null) {
      return keyboard(event);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(EventBusKeyboardEvent value) keyboard,
    required TResult Function(EventBusIndexPasteEvent value) indexPaste,
  }) {
    return keyboard(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(EventBusKeyboardEvent value)? keyboard,
    TResult? Function(EventBusIndexPasteEvent value)? indexPaste,
  }) {
    return keyboard?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(EventBusKeyboardEvent value)? keyboard,
    TResult Function(EventBusIndexPasteEvent value)? indexPaste,
    required TResult orElse(),
  }) {
    if (keyboard != null) {
      return keyboard(this);
    }
    return orElse();
  }
}

abstract class EventBusKeyboardEvent implements EventBusState {
  const factory EventBusKeyboardEvent(final KeyboardShortcutEvent event) =
      _$EventBusKeyboardEventImpl;

  KeyboardShortcutEvent get event;

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventBusKeyboardEventImplCopyWith<_$EventBusKeyboardEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventBusIndexPasteEventImplCopyWith<$Res> {
  factory _$$EventBusIndexPasteEventImplCopyWith(
    _$EventBusIndexPasteEventImpl value,
    $Res Function(_$EventBusIndexPasteEventImpl) then,
  ) = __$$EventBusIndexPasteEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int index});
}

/// @nodoc
class __$$EventBusIndexPasteEventImplCopyWithImpl<$Res>
    extends _$EventBusStateCopyWithImpl<$Res, _$EventBusIndexPasteEventImpl>
    implements _$$EventBusIndexPasteEventImplCopyWith<$Res> {
  __$$EventBusIndexPasteEventImplCopyWithImpl(
    _$EventBusIndexPasteEventImpl _value,
    $Res Function(_$EventBusIndexPasteEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? index = null}) {
    return _then(
      _$EventBusIndexPasteEventImpl(
        null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$EventBusIndexPasteEventImpl implements EventBusIndexPasteEvent {
  const _$EventBusIndexPasteEventImpl(this.index);

  @override
  final int index;

  @override
  String toString() {
    return 'EventBusState.indexPaste(index: $index)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventBusIndexPasteEventImpl &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index);

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventBusIndexPasteEventImplCopyWith<_$EventBusIndexPasteEventImpl>
  get copyWith =>
      __$$EventBusIndexPasteEventImplCopyWithImpl<
        _$EventBusIndexPasteEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(KeyboardShortcutEvent event) keyboard,
    required TResult Function(int index) indexPaste,
  }) {
    return indexPaste(index);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(KeyboardShortcutEvent event)? keyboard,
    TResult? Function(int index)? indexPaste,
  }) {
    return indexPaste?.call(index);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(KeyboardShortcutEvent event)? keyboard,
    TResult Function(int index)? indexPaste,
    required TResult orElse(),
  }) {
    if (indexPaste != null) {
      return indexPaste(index);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(EventBusKeyboardEvent value) keyboard,
    required TResult Function(EventBusIndexPasteEvent value) indexPaste,
  }) {
    return indexPaste(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(EventBusKeyboardEvent value)? keyboard,
    TResult? Function(EventBusIndexPasteEvent value)? indexPaste,
  }) {
    return indexPaste?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(EventBusKeyboardEvent value)? keyboard,
    TResult Function(EventBusIndexPasteEvent value)? indexPaste,
    required TResult orElse(),
  }) {
    if (indexPaste != null) {
      return indexPaste(this);
    }
    return orElse();
  }
}

abstract class EventBusIndexPasteEvent implements EventBusState {
  const factory EventBusIndexPasteEvent(final int index) =
      _$EventBusIndexPasteEventImpl;

  int get index;

  /// Create a copy of EventBusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventBusIndexPasteEventImplCopyWith<_$EventBusIndexPasteEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
