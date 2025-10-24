// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  @JsonKey(name: "id", includeToJson: false)
  int? get serverId => throw _privateConstructorUsedError;
  @JsonKey(name: "created")
  @DateTimeConverter()
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: "modified")
  @DateTimeConverter()
  DateTime get modified => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get planName => throw _privateConstructorUsedError;
  String get subId => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get trialStart => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get trialEnd => throw _privateConstructorUsedError;
  int get collections => throw _privateConstructorUsedError;
  int get itemsPerCollection => throw _privateConstructorUsedError;
  bool get dragNdrop => throw _privateConstructorUsedError;
  bool get theming => throw _privateConstructorUsedError;
  @JsonKey(name: "syncHr")
  int get syncHours => throw _privateConstructorUsedError;
  bool get ads => throw _privateConstructorUsedError;
  @JsonKey(name: "syncInt")
  int get syncInterval => throw _privateConstructorUsedError;
  bool get edit => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get activeTill => throw _privateConstructorUsedError;
  @JsonKey(name: "devices")
  int get maxSyncDevices => throw _privateConstructorUsedError;
  @JsonKey(name: "cers")
  bool get customExclusionRules => throw _privateConstructorUsedError;
  int get grants => throw _privateConstructorUsedError;
  String? get tkn => throw _privateConstructorUsedError; // local state
  @ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get managementUrl => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {@JsonKey(name: "id", includeToJson: false) int? serverId,
      @JsonKey(name: "created") @DateTimeConverter() DateTime created,
      @JsonKey(name: "modified") @DateTimeConverter() DateTime modified,
      String userId,
      String planName,
      String subId,
      String source,
      @DateTimeConverter() DateTime? trialStart,
      @DateTimeConverter() DateTime? trialEnd,
      int collections,
      int itemsPerCollection,
      bool dragNdrop,
      bool theming,
      @JsonKey(name: "syncHr") int syncHours,
      bool ads,
      @JsonKey(name: "syncInt") int syncInterval,
      bool edit,
      @DateTimeConverter() DateTime? activeTill,
      @JsonKey(name: "devices") int maxSyncDevices,
      @JsonKey(name: "cers") bool customExclusionRules,
      int grants,
      String? tkn,
      @ignore
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? managementUrl});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverId = freezed,
    Object? created = null,
    Object? modified = null,
    Object? userId = null,
    Object? planName = null,
    Object? subId = null,
    Object? source = null,
    Object? trialStart = freezed,
    Object? trialEnd = freezed,
    Object? collections = null,
    Object? itemsPerCollection = null,
    Object? dragNdrop = null,
    Object? theming = null,
    Object? syncHours = null,
    Object? ads = null,
    Object? syncInterval = null,
    Object? edit = null,
    Object? activeTill = freezed,
    Object? maxSyncDevices = null,
    Object? customExclusionRules = null,
    Object? grants = null,
    Object? tkn = freezed,
    Object? managementUrl = freezed,
  }) {
    return _then(_value.copyWith(
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as int?,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modified: null == modified
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      subId: null == subId
          ? _value.subId
          : subId // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      trialStart: freezed == trialStart
          ? _value.trialStart
          : trialStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trialEnd: freezed == trialEnd
          ? _value.trialEnd
          : trialEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      collections: null == collections
          ? _value.collections
          : collections // ignore: cast_nullable_to_non_nullable
              as int,
      itemsPerCollection: null == itemsPerCollection
          ? _value.itemsPerCollection
          : itemsPerCollection // ignore: cast_nullable_to_non_nullable
              as int,
      dragNdrop: null == dragNdrop
          ? _value.dragNdrop
          : dragNdrop // ignore: cast_nullable_to_non_nullable
              as bool,
      theming: null == theming
          ? _value.theming
          : theming // ignore: cast_nullable_to_non_nullable
              as bool,
      syncHours: null == syncHours
          ? _value.syncHours
          : syncHours // ignore: cast_nullable_to_non_nullable
              as int,
      ads: null == ads
          ? _value.ads
          : ads // ignore: cast_nullable_to_non_nullable
              as bool,
      syncInterval: null == syncInterval
          ? _value.syncInterval
          : syncInterval // ignore: cast_nullable_to_non_nullable
              as int,
      edit: null == edit
          ? _value.edit
          : edit // ignore: cast_nullable_to_non_nullable
              as bool,
      activeTill: freezed == activeTill
          ? _value.activeTill
          : activeTill // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxSyncDevices: null == maxSyncDevices
          ? _value.maxSyncDevices
          : maxSyncDevices // ignore: cast_nullable_to_non_nullable
              as int,
      customExclusionRules: null == customExclusionRules
          ? _value.customExclusionRules
          : customExclusionRules // ignore: cast_nullable_to_non_nullable
              as bool,
      grants: null == grants
          ? _value.grants
          : grants // ignore: cast_nullable_to_non_nullable
              as int,
      tkn: freezed == tkn
          ? _value.tkn
          : tkn // ignore: cast_nullable_to_non_nullable
              as String?,
      managementUrl: freezed == managementUrl
          ? _value.managementUrl
          : managementUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id", includeToJson: false) int? serverId,
      @JsonKey(name: "created") @DateTimeConverter() DateTime created,
      @JsonKey(name: "modified") @DateTimeConverter() DateTime modified,
      String userId,
      String planName,
      String subId,
      String source,
      @DateTimeConverter() DateTime? trialStart,
      @DateTimeConverter() DateTime? trialEnd,
      int collections,
      int itemsPerCollection,
      bool dragNdrop,
      bool theming,
      @JsonKey(name: "syncHr") int syncHours,
      bool ads,
      @JsonKey(name: "syncInt") int syncInterval,
      bool edit,
      @DateTimeConverter() DateTime? activeTill,
      @JsonKey(name: "devices") int maxSyncDevices,
      @JsonKey(name: "cers") bool customExclusionRules,
      int grants,
      String? tkn,
      @ignore
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? managementUrl});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverId = freezed,
    Object? created = null,
    Object? modified = null,
    Object? userId = null,
    Object? planName = null,
    Object? subId = null,
    Object? source = null,
    Object? trialStart = freezed,
    Object? trialEnd = freezed,
    Object? collections = null,
    Object? itemsPerCollection = null,
    Object? dragNdrop = null,
    Object? theming = null,
    Object? syncHours = null,
    Object? ads = null,
    Object? syncInterval = null,
    Object? edit = null,
    Object? activeTill = freezed,
    Object? maxSyncDevices = null,
    Object? customExclusionRules = null,
    Object? grants = null,
    Object? tkn = freezed,
    Object? managementUrl = freezed,
  }) {
    return _then(_$SubscriptionImpl(
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as int?,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modified: null == modified
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      subId: null == subId
          ? _value.subId
          : subId // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      trialStart: freezed == trialStart
          ? _value.trialStart
          : trialStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trialEnd: freezed == trialEnd
          ? _value.trialEnd
          : trialEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      collections: null == collections
          ? _value.collections
          : collections // ignore: cast_nullable_to_non_nullable
              as int,
      itemsPerCollection: null == itemsPerCollection
          ? _value.itemsPerCollection
          : itemsPerCollection // ignore: cast_nullable_to_non_nullable
              as int,
      dragNdrop: null == dragNdrop
          ? _value.dragNdrop
          : dragNdrop // ignore: cast_nullable_to_non_nullable
              as bool,
      theming: null == theming
          ? _value.theming
          : theming // ignore: cast_nullable_to_non_nullable
              as bool,
      syncHours: null == syncHours
          ? _value.syncHours
          : syncHours // ignore: cast_nullable_to_non_nullable
              as int,
      ads: null == ads
          ? _value.ads
          : ads // ignore: cast_nullable_to_non_nullable
              as bool,
      syncInterval: null == syncInterval
          ? _value.syncInterval
          : syncInterval // ignore: cast_nullable_to_non_nullable
              as int,
      edit: null == edit
          ? _value.edit
          : edit // ignore: cast_nullable_to_non_nullable
              as bool,
      activeTill: freezed == activeTill
          ? _value.activeTill
          : activeTill // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxSyncDevices: null == maxSyncDevices
          ? _value.maxSyncDevices
          : maxSyncDevices // ignore: cast_nullable_to_non_nullable
              as int,
      customExclusionRules: null == customExclusionRules
          ? _value.customExclusionRules
          : customExclusionRules // ignore: cast_nullable_to_non_nullable
              as bool,
      grants: null == grants
          ? _value.grants
          : grants // ignore: cast_nullable_to_non_nullable
              as int,
      tkn: freezed == tkn
          ? _value.tkn
          : tkn // ignore: cast_nullable_to_non_nullable
              as String?,
      managementUrl: freezed == managementUrl
          ? _value.managementUrl
          : managementUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl extends _Subscription {
  _$SubscriptionImpl(
      {@JsonKey(name: "id", includeToJson: false) this.serverId,
      @JsonKey(name: "created") @DateTimeConverter() required this.created,
      @JsonKey(name: "modified") @DateTimeConverter() required this.modified,
      required this.userId,
      required this.planName,
      required this.subId,
      required this.source,
      @DateTimeConverter() this.trialStart,
      @DateTimeConverter() this.trialEnd,
      this.collections = 3,
      this.itemsPerCollection = 50,
      this.dragNdrop = false,
      this.theming = false,
      @JsonKey(name: "syncHr") this.syncHours = 24,
      this.ads = true,
      @JsonKey(name: "syncInt") this.syncInterval = $45S,
      this.edit = false,
      @DateTimeConverter() this.activeTill,
      @JsonKey(name: "devices") this.maxSyncDevices = 3,
      @JsonKey(name: "cers") this.customExclusionRules = false,
      this.grants = 0,
      this.tkn,
      @ignore
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.managementUrl})
      : super._();

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  @JsonKey(name: "id", includeToJson: false)
  final int? serverId;
  @override
  @JsonKey(name: "created")
  @DateTimeConverter()
  final DateTime created;
  @override
  @JsonKey(name: "modified")
  @DateTimeConverter()
  final DateTime modified;
  @override
  final String userId;
  @override
  final String planName;
  @override
  final String subId;
  @override
  final String source;
  @override
  @DateTimeConverter()
  final DateTime? trialStart;
  @override
  @DateTimeConverter()
  final DateTime? trialEnd;
  @override
  @JsonKey()
  final int collections;
  @override
  @JsonKey()
  final int itemsPerCollection;
  @override
  @JsonKey()
  final bool dragNdrop;
  @override
  @JsonKey()
  final bool theming;
  @override
  @JsonKey(name: "syncHr")
  final int syncHours;
  @override
  @JsonKey()
  final bool ads;
  @override
  @JsonKey(name: "syncInt")
  final int syncInterval;
  @override
  @JsonKey()
  final bool edit;
  @override
  @DateTimeConverter()
  final DateTime? activeTill;
  @override
  @JsonKey(name: "devices")
  final int maxSyncDevices;
  @override
  @JsonKey(name: "cers")
  final bool customExclusionRules;
  @override
  @JsonKey()
  final int grants;
  @override
  final String? tkn;
// local state
  @override
  @ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? managementUrl;

  @override
  String toString() {
    return 'Subscription(serverId: $serverId, created: $created, modified: $modified, userId: $userId, planName: $planName, subId: $subId, source: $source, trialStart: $trialStart, trialEnd: $trialEnd, collections: $collections, itemsPerCollection: $itemsPerCollection, dragNdrop: $dragNdrop, theming: $theming, syncHours: $syncHours, ads: $ads, syncInterval: $syncInterval, edit: $edit, activeTill: $activeTill, maxSyncDevices: $maxSyncDevices, customExclusionRules: $customExclusionRules, grants: $grants, tkn: $tkn, managementUrl: $managementUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.subId, subId) || other.subId == subId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.trialStart, trialStart) ||
                other.trialStart == trialStart) &&
            (identical(other.trialEnd, trialEnd) ||
                other.trialEnd == trialEnd) &&
            (identical(other.collections, collections) ||
                other.collections == collections) &&
            (identical(other.itemsPerCollection, itemsPerCollection) ||
                other.itemsPerCollection == itemsPerCollection) &&
            (identical(other.dragNdrop, dragNdrop) ||
                other.dragNdrop == dragNdrop) &&
            (identical(other.theming, theming) || other.theming == theming) &&
            (identical(other.syncHours, syncHours) ||
                other.syncHours == syncHours) &&
            (identical(other.ads, ads) || other.ads == ads) &&
            (identical(other.syncInterval, syncInterval) ||
                other.syncInterval == syncInterval) &&
            (identical(other.edit, edit) || other.edit == edit) &&
            (identical(other.activeTill, activeTill) ||
                other.activeTill == activeTill) &&
            (identical(other.maxSyncDevices, maxSyncDevices) ||
                other.maxSyncDevices == maxSyncDevices) &&
            (identical(other.customExclusionRules, customExclusionRules) ||
                other.customExclusionRules == customExclusionRules) &&
            (identical(other.grants, grants) || other.grants == grants) &&
            (identical(other.tkn, tkn) || other.tkn == tkn) &&
            (identical(other.managementUrl, managementUrl) ||
                other.managementUrl == managementUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        serverId,
        created,
        modified,
        userId,
        planName,
        subId,
        source,
        trialStart,
        trialEnd,
        collections,
        itemsPerCollection,
        dragNdrop,
        theming,
        syncHours,
        ads,
        syncInterval,
        edit,
        activeTill,
        maxSyncDevices,
        customExclusionRules,
        grants,
        tkn,
        managementUrl
      ]);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription extends Subscription {
  factory _Subscription(
      {@JsonKey(name: "id", includeToJson: false) final int? serverId,
      @JsonKey(name: "created")
      @DateTimeConverter()
      required final DateTime created,
      @JsonKey(name: "modified")
      @DateTimeConverter()
      required final DateTime modified,
      required final String userId,
      required final String planName,
      required final String subId,
      required final String source,
      @DateTimeConverter() final DateTime? trialStart,
      @DateTimeConverter() final DateTime? trialEnd,
      final int collections,
      final int itemsPerCollection,
      final bool dragNdrop,
      final bool theming,
      @JsonKey(name: "syncHr") final int syncHours,
      final bool ads,
      @JsonKey(name: "syncInt") final int syncInterval,
      final bool edit,
      @DateTimeConverter() final DateTime? activeTill,
      @JsonKey(name: "devices") final int maxSyncDevices,
      @JsonKey(name: "cers") final bool customExclusionRules,
      final int grants,
      final String? tkn,
      @ignore
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? managementUrl}) = _$SubscriptionImpl;
  _Subscription._() : super._();

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  @JsonKey(name: "id", includeToJson: false)
  int? get serverId;
  @override
  @JsonKey(name: "created")
  @DateTimeConverter()
  DateTime get created;
  @override
  @JsonKey(name: "modified")
  @DateTimeConverter()
  DateTime get modified;
  @override
  String get userId;
  @override
  String get planName;
  @override
  String get subId;
  @override
  String get source;
  @override
  @DateTimeConverter()
  DateTime? get trialStart;
  @override
  @DateTimeConverter()
  DateTime? get trialEnd;
  @override
  int get collections;
  @override
  int get itemsPerCollection;
  @override
  bool get dragNdrop;
  @override
  bool get theming;
  @override
  @JsonKey(name: "syncHr")
  int get syncHours;
  @override
  bool get ads;
  @override
  @JsonKey(name: "syncInt")
  int get syncInterval;
  @override
  bool get edit;
  @override
  @DateTimeConverter()
  DateTime? get activeTill;
  @override
  @JsonKey(name: "devices")
  int get maxSyncDevices;
  @override
  @JsonKey(name: "cers")
  bool get customExclusionRules;
  @override
  int get grants;
  @override
  String? get tkn; // local state
  @override
  @ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get managementUrl;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
