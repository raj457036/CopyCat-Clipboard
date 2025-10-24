// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appconfig.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppConfigCollection on Isar {
  IsarCollection<AppConfig> get appConfigs => this.collection();
}

const AppConfigSchema = CollectionSchema(
  name: r'AppConfig',
  id: -7085420701237142207,
  properties: {
    r'androidBgListener': PropertySchema(
      id: 0,
      name: r'androidBgListener',
      type: IsarType.bool,
    ),
    r'autoEncrypt': PropertySchema(
      id: 1,
      name: r'autoEncrypt',
      type: IsarType.bool,
    ),
    r'dontCopyOver': PropertySchema(
      id: 2,
      name: r'dontCopyOver',
      type: IsarType.long,
    ),
    r'dontUploadOver': PropertySchema(
      id: 3,
      name: r'dontUploadOver',
      type: IsarType.long,
    ),
    r'duplicatePrevention': PropertySchema(
      id: 4,
      name: r'duplicatePrevention',
      type: IsarType.bool,
    ),
    r'enableDragNDrop': PropertySchema(
      id: 5,
      name: r'enableDragNDrop',
      type: IsarType.bool,
    ),
    r'enableFileSync': PropertySchema(
      id: 6,
      name: r'enableFileSync',
      type: IsarType.bool,
    ),
    r'enablePasteStack': PropertySchema(
      id: 7,
      name: r'enablePasteStack',
      type: IsarType.bool,
    ),
    r'enableSync': PropertySchema(
      id: 8,
      name: r'enableSync',
      type: IsarType.bool,
    ),
    r'enc2': PropertySchema(
      id: 9,
      name: r'enc2',
      type: IsarType.string,
    ),
    r'exclusionRules': PropertySchema(
      id: 10,
      name: r'exclusionRules',
      type: IsarType.object,
      target: r'ExclusionRules',
    ),
    r'launchAtStartup': PropertySchema(
      id: 11,
      name: r'launchAtStartup',
      type: IsarType.bool,
    ),
    r'layout': PropertySchema(
      id: 12,
      name: r'layout',
      type: IsarType.string,
      enumMap: _AppConfiglayoutEnumValueMap,
    ),
    r'locale': PropertySchema(
      id: 13,
      name: r'locale',
      type: IsarType.string,
    ),
    r'onBoardComplete': PropertySchema(
      id: 14,
      name: r'onBoardComplete',
      type: IsarType.bool,
    ),
    r'pausedTill': PropertySchema(
      id: 15,
      name: r'pausedTill',
      type: IsarType.dateTime,
    ),
    r'pinned': PropertySchema(
      id: 16,
      name: r'pinned',
      type: IsarType.bool,
    ),
    r'smartPaste': PropertySchema(
      id: 17,
      name: r'smartPaste',
      type: IsarType.bool,
    ),
    r'syncSpeed': PropertySchema(
      id: 18,
      name: r'syncSpeed',
      type: IsarType.string,
      enumMap: _AppConfigsyncSpeedEnumValueMap,
    ),
    r'themeColor': PropertySchema(
      id: 19,
      name: r'themeColor',
      type: IsarType.long,
    ),
    r'themeMode': PropertySchema(
      id: 20,
      name: r'themeMode',
      type: IsarType.string,
      enumMap: _AppConfigthemeModeEnumValueMap,
    ),
    r'themeVariant': PropertySchema(
      id: 21,
      name: r'themeVariant',
      type: IsarType.string,
      enumMap: _AppConfigthemeVariantEnumValueMap,
    ),
    r'toggleHotkey': PropertySchema(
      id: 22,
      name: r'toggleHotkey',
      type: IsarType.string,
    ),
    r'view': PropertySchema(
      id: 23,
      name: r'view',
      type: IsarType.string,
      enumMap: _AppConfigviewEnumValueMap,
    ),
    r'windowHeight': PropertySchema(
      id: 24,
      name: r'windowHeight',
      type: IsarType.double,
    ),
    r'windowWidth': PropertySchema(
      id: 25,
      name: r'windowWidth',
      type: IsarType.double,
    )
  },
  estimateSize: _appConfigEstimateSize,
  serialize: _appConfigSerialize,
  deserialize: _appConfigDeserialize,
  deserializeProp: _appConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'ExclusionRules': ExclusionRulesSchema,
    r'AppInfo': AppInfoSchema
  },
  getId: _appConfigGetId,
  getLinks: _appConfigGetLinks,
  attach: _appConfigAttach,
  version: '3.3.0-dev.1',
);

int _appConfigEstimateSize(
  AppConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.enc2;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.exclusionRules;
    if (value != null) {
      bytesCount += 3 +
          ExclusionRulesSchema.estimateSize(
              value, allOffsets[ExclusionRules]!, allOffsets);
    }
  }
  bytesCount += 3 + object.layout.name.length * 3;
  bytesCount += 3 + object.locale.length * 3;
  bytesCount += 3 + object.syncSpeed.name.length * 3;
  bytesCount += 3 + object.themeMode.name.length * 3;
  bytesCount += 3 + object.themeVariant.name.length * 3;
  {
    final value = object.toggleHotkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.view.name.length * 3;
  return bytesCount;
}

void _appConfigSerialize(
  AppConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.androidBgListener);
  writer.writeBool(offsets[1], object.autoEncrypt);
  writer.writeLong(offsets[2], object.dontCopyOver);
  writer.writeLong(offsets[3], object.dontUploadOver);
  writer.writeBool(offsets[4], object.duplicatePrevention);
  writer.writeBool(offsets[5], object.enableDragNDrop);
  writer.writeBool(offsets[6], object.enableFileSync);
  writer.writeBool(offsets[7], object.enablePasteStack);
  writer.writeBool(offsets[8], object.enableSync);
  writer.writeString(offsets[9], object.enc2);
  writer.writeObject<ExclusionRules>(
    offsets[10],
    allOffsets,
    ExclusionRulesSchema.serialize,
    object.exclusionRules,
  );
  writer.writeBool(offsets[11], object.launchAtStartup);
  writer.writeString(offsets[12], object.layout.name);
  writer.writeString(offsets[13], object.locale);
  writer.writeBool(offsets[14], object.onBoardComplete);
  writer.writeDateTime(offsets[15], object.pausedTill);
  writer.writeBool(offsets[16], object.pinned);
  writer.writeBool(offsets[17], object.smartPaste);
  writer.writeString(offsets[18], object.syncSpeed.name);
  writer.writeLong(offsets[19], object.themeColor);
  writer.writeString(offsets[20], object.themeMode.name);
  writer.writeString(offsets[21], object.themeVariant.name);
  writer.writeString(offsets[22], object.toggleHotkey);
  writer.writeString(offsets[23], object.view.name);
  writer.writeDouble(offsets[24], object.windowHeight);
  writer.writeDouble(offsets[25], object.windowWidth);
}

AppConfig _appConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppConfig(
    androidBgListener: reader.readBool(offsets[0]),
    autoEncrypt: reader.readBool(offsets[1]),
    dontCopyOver: reader.readLong(offsets[2]),
    dontUploadOver: reader.readLong(offsets[3]),
    duplicatePrevention: reader.readBool(offsets[4]),
    enableDragNDrop: reader.readBool(offsets[5]),
    enableFileSync: reader.readBool(offsets[6]),
    enablePasteStack: reader.readBool(offsets[7]),
    enableSync: reader.readBool(offsets[8]),
    enc2: reader.readStringOrNull(offsets[9]),
    exclusionRules: reader.readObjectOrNull<ExclusionRules>(
      offsets[10],
      ExclusionRulesSchema.deserialize,
      allOffsets,
    ),
    launchAtStartup: reader.readBool(offsets[11]),
    layout:
        _AppConfiglayoutValueEnumMap[reader.readStringOrNull(offsets[12])] ??
            AppLayout.grid,
    locale: reader.readString(offsets[13]),
    onBoardComplete: reader.readBool(offsets[14]),
    pausedTill: reader.readDateTimeOrNull(offsets[15]),
    pinned: reader.readBool(offsets[16]),
    smartPaste: reader.readBool(offsets[17]),
    syncSpeed:
        _AppConfigsyncSpeedValueEnumMap[reader.readStringOrNull(offsets[18])] ??
            SyncSpeed.realtime,
    themeColor: reader.readLong(offsets[19]),
    themeMode:
        _AppConfigthemeModeValueEnumMap[reader.readStringOrNull(offsets[20])] ??
            ThemeMode.system,
    themeVariant: _AppConfigthemeVariantValueEnumMap[
            reader.readStringOrNull(offsets[21])] ??
        DynamicSchemeVariant.tonalSpot,
    toggleHotkey: reader.readStringOrNull(offsets[22]),
    view: _AppConfigviewValueEnumMap[reader.readStringOrNull(offsets[23])] ??
        AppView.topDocked,
    windowHeight: reader.readDouble(offsets[24]),
    windowWidth: reader.readDouble(offsets[25]),
  );
  object.id = id;
  return object;
}

P _appConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readObjectOrNull<ExclusionRules>(
        offset,
        ExclusionRulesSchema.deserialize,
        allOffsets,
      )) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (_AppConfiglayoutValueEnumMap[reader.readStringOrNull(offset)] ??
          AppLayout.grid) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (_AppConfigsyncSpeedValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncSpeed.realtime) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (_AppConfigthemeModeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          ThemeMode.system) as P;
    case 21:
      return (_AppConfigthemeVariantValueEnumMap[
              reader.readStringOrNull(offset)] ??
          DynamicSchemeVariant.tonalSpot) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (_AppConfigviewValueEnumMap[reader.readStringOrNull(offset)] ??
          AppView.topDocked) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppConfiglayoutEnumValueMap = {
  r'grid': r'grid',
  r'list': r'list',
};
const _AppConfiglayoutValueEnumMap = {
  r'grid': AppLayout.grid,
  r'list': AppLayout.list,
};
const _AppConfigsyncSpeedEnumValueMap = {
  r'realtime': r'realtime',
  r'balanced': r'balanced',
};
const _AppConfigsyncSpeedValueEnumMap = {
  r'realtime': SyncSpeed.realtime,
  r'balanced': SyncSpeed.balanced,
};
const _AppConfigthemeModeEnumValueMap = {
  r'system': r'system',
  r'light': r'light',
  r'dark': r'dark',
};
const _AppConfigthemeModeValueEnumMap = {
  r'system': ThemeMode.system,
  r'light': ThemeMode.light,
  r'dark': ThemeMode.dark,
};
const _AppConfigthemeVariantEnumValueMap = {
  r'tonalSpot': r'tonalSpot',
  r'fidelity': r'fidelity',
  r'monochrome': r'monochrome',
  r'neutral': r'neutral',
  r'vibrant': r'vibrant',
  r'expressive': r'expressive',
  r'content': r'content',
  r'rainbow': r'rainbow',
  r'fruitSalad': r'fruitSalad',
};
const _AppConfigthemeVariantValueEnumMap = {
  r'tonalSpot': DynamicSchemeVariant.tonalSpot,
  r'fidelity': DynamicSchemeVariant.fidelity,
  r'monochrome': DynamicSchemeVariant.monochrome,
  r'neutral': DynamicSchemeVariant.neutral,
  r'vibrant': DynamicSchemeVariant.vibrant,
  r'expressive': DynamicSchemeVariant.expressive,
  r'content': DynamicSchemeVariant.content,
  r'rainbow': DynamicSchemeVariant.rainbow,
  r'fruitSalad': DynamicSchemeVariant.fruitSalad,
};
const _AppConfigviewEnumValueMap = {
  r'topDocked': r'topDocked',
  r'bottomDocked': r'bottomDocked',
  r'leftDocked': r'leftDocked',
  r'rightDocked': r'rightDocked',
  r'windowed': r'windowed',
};
const _AppConfigviewValueEnumMap = {
  r'topDocked': AppView.topDocked,
  r'bottomDocked': AppView.bottomDocked,
  r'leftDocked': AppView.leftDocked,
  r'rightDocked': AppView.rightDocked,
  r'windowed': AppView.windowed,
};

Id _appConfigGetId(AppConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appConfigGetLinks(AppConfig object) {
  return [];
}

void _appConfigAttach(IsarCollection<dynamic> col, Id id, AppConfig object) {
  object.id = id;
}

extension AppConfigQueryWhereSort
    on QueryBuilder<AppConfig, AppConfig, QWhere> {
  QueryBuilder<AppConfig, AppConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppConfigQueryWhere
    on QueryBuilder<AppConfig, AppConfig, QWhereClause> {
  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppConfigQueryFilter
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {
  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      androidBgListenerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'androidBgListener',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> autoEncryptEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoEncrypt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> dontCopyOverEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dontCopyOver',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dontCopyOverGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dontCopyOver',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dontCopyOverLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dontCopyOver',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> dontCopyOverBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dontCopyOver',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dontUploadOverEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dontUploadOver',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dontUploadOverGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dontUploadOver',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dontUploadOverLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dontUploadOver',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dontUploadOverBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dontUploadOver',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      duplicatePreventionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duplicatePrevention',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      enableDragNDropEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableDragNDrop',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      enableFileSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableFileSync',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      enablePasteStackEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enablePasteStack',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enableSyncEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableSync',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'enc2',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'enc2',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2EqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enc2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2GreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enc2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2LessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enc2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2Between(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enc2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'enc2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'enc2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'enc2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'enc2',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enc2',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> enc2IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'enc2',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      exclusionRulesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exclusionRules',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      exclusionRulesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exclusionRules',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      launchAtStartupEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'launchAtStartup',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutEqualTo(
    AppLayout value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layout',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutGreaterThan(
    AppLayout value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'layout',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutLessThan(
    AppLayout value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'layout',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutBetween(
    AppLayout lower,
    AppLayout upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'layout',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'layout',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'layout',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'layout',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'layout',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layout',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> layoutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'layout',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locale',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locale',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> localeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locale',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      onBoardCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onBoardComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> pausedTillIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pausedTill',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      pausedTillIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pausedTill',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> pausedTillEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pausedTill',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      pausedTillGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pausedTill',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> pausedTillLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pausedTill',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> pausedTillBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pausedTill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> pinnedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> smartPasteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'smartPaste',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedEqualTo(
    SyncSpeed value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncSpeed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      syncSpeedGreaterThan(
    SyncSpeed value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncSpeed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedLessThan(
    SyncSpeed value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncSpeed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedBetween(
    SyncSpeed lower,
    SyncSpeed upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncSpeed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncSpeed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncSpeed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncSpeed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> syncSpeedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncSpeed',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      syncSpeedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncSpeed',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeColorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeColor',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeColor',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeColor',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeEqualTo(
    ThemeMode value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeModeGreaterThan(
    ThemeMode value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeLessThan(
    ThemeMode value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeBetween(
    ThemeMode lower,
    ThemeMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themeMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeMode',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themeMode',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeVariantEqualTo(
    DynamicSchemeVariant value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeVariant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantGreaterThan(
    DynamicSchemeVariant value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeVariant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantLessThan(
    DynamicSchemeVariant value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeVariant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeVariantBetween(
    DynamicSchemeVariant lower,
    DynamicSchemeVariant upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeVariant',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themeVariant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themeVariant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themeVariant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> themeVariantMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themeVariant',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeVariant',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      themeVariantIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themeVariant',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'toggleHotkey',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'toggleHotkey',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> toggleHotkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toggleHotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toggleHotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toggleHotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> toggleHotkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toggleHotkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toggleHotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toggleHotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toggleHotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> toggleHotkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toggleHotkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toggleHotkey',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      toggleHotkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toggleHotkey',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewEqualTo(
    AppView value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'view',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewGreaterThan(
    AppView value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'view',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewLessThan(
    AppView value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'view',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewBetween(
    AppView lower,
    AppView upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'view',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'view',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'view',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'view',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'view',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'view',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> viewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'view',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> windowHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'windowHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      windowHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'windowHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      windowHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'windowHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> windowHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'windowHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> windowWidthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'windowWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      windowWidthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'windowWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> windowWidthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'windowWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> windowWidthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'windowWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AppConfigQueryObject
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {
  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> exclusionRules(
      FilterQuery<ExclusionRules> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'exclusionRules');
    });
  }
}

extension AppConfigQueryLinks
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {}

extension AppConfigQuerySortBy on QueryBuilder<AppConfig, AppConfig, QSortBy> {
  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByAndroidBgListener() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidBgListener', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByAndroidBgListenerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidBgListener', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByAutoEncrypt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoEncrypt', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByAutoEncryptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoEncrypt', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDontCopyOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontCopyOver', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDontCopyOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontCopyOver', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDontUploadOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontUploadOver', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDontUploadOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontUploadOver', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDuplicatePrevention() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicatePrevention', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByDuplicatePreventionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicatePrevention', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnableDragNDrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDragNDrop', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnableDragNDropDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDragNDrop', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnableFileSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableFileSync', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnableFileSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableFileSync', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnablePasteStack() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablePasteStack', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByEnablePasteStackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablePasteStack', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnableSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableSync', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnableSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableSync', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnc2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enc2', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByEnc2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enc2', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByLaunchAtStartup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launchAtStartup', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByLaunchAtStartupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launchAtStartup', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByLayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layout', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByLayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layout', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locale', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locale', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByOnBoardComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onBoardComplete', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByOnBoardCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onBoardComplete', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByPausedTill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedTill', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByPausedTillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedTill', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortBySmartPaste() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartPaste', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortBySmartPasteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartPaste', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortBySyncSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSpeed', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortBySyncSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSpeed', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByThemeColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeColor', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByThemeColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeColor', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByThemeVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByThemeVariantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByToggleHotkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toggleHotkey', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByToggleHotkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toggleHotkey', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByView() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'view', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByViewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'view', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByWindowHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowHeight', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByWindowHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowHeight', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByWindowWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowWidth', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByWindowWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowWidth', Sort.desc);
    });
  }
}

extension AppConfigQuerySortThenBy
    on QueryBuilder<AppConfig, AppConfig, QSortThenBy> {
  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByAndroidBgListener() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidBgListener', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByAndroidBgListenerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidBgListener', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByAutoEncrypt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoEncrypt', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByAutoEncryptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoEncrypt', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDontCopyOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontCopyOver', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDontCopyOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontCopyOver', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDontUploadOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontUploadOver', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDontUploadOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontUploadOver', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDuplicatePrevention() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicatePrevention', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByDuplicatePreventionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicatePrevention', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnableDragNDrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDragNDrop', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnableDragNDropDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDragNDrop', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnableFileSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableFileSync', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnableFileSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableFileSync', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnablePasteStack() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablePasteStack', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByEnablePasteStackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablePasteStack', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnableSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableSync', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnableSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableSync', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnc2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enc2', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByEnc2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enc2', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByLaunchAtStartup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launchAtStartup', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByLaunchAtStartupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launchAtStartup', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByLayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layout', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByLayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layout', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locale', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locale', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByOnBoardComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onBoardComplete', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByOnBoardCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onBoardComplete', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByPausedTill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedTill', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByPausedTillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedTill', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenBySmartPaste() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartPaste', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenBySmartPasteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartPaste', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenBySyncSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSpeed', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenBySyncSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSpeed', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByThemeColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeColor', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByThemeColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeColor', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByThemeVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByThemeVariantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByToggleHotkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toggleHotkey', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByToggleHotkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toggleHotkey', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByView() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'view', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByViewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'view', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByWindowHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowHeight', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByWindowHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowHeight', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByWindowWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowWidth', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByWindowWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windowWidth', Sort.desc);
    });
  }
}

extension AppConfigQueryWhereDistinct
    on QueryBuilder<AppConfig, AppConfig, QDistinct> {
  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByAndroidBgListener() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'androidBgListener');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByAutoEncrypt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoEncrypt');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByDontCopyOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dontCopyOver');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByDontUploadOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dontUploadOver');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct>
      distinctByDuplicatePrevention() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duplicatePrevention');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByEnableDragNDrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableDragNDrop');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByEnableFileSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableFileSync');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByEnablePasteStack() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enablePasteStack');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByEnableSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableSync');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByEnc2(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enc2', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByLaunchAtStartup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'launchAtStartup');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByLayout(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'layout', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByLocale(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locale', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByOnBoardComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onBoardComplete');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByPausedTill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pausedTill');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctBySmartPaste() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'smartPaste');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctBySyncSpeed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncSpeed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByThemeColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeColor');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByThemeMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByThemeVariant(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeVariant', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByToggleHotkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toggleHotkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByView(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'view', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByWindowHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'windowHeight');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByWindowWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'windowWidth');
    });
  }
}

extension AppConfigQueryProperty
    on QueryBuilder<AppConfig, AppConfig, QQueryProperty> {
  QueryBuilder<AppConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> androidBgListenerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'androidBgListener');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> autoEncryptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoEncrypt');
    });
  }

  QueryBuilder<AppConfig, int, QQueryOperations> dontCopyOverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dontCopyOver');
    });
  }

  QueryBuilder<AppConfig, int, QQueryOperations> dontUploadOverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dontUploadOver');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations>
      duplicatePreventionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duplicatePrevention');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> enableDragNDropProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableDragNDrop');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> enableFileSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableFileSync');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> enablePasteStackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enablePasteStack');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> enableSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableSync');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations> enc2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enc2');
    });
  }

  QueryBuilder<AppConfig, ExclusionRules?, QQueryOperations>
      exclusionRulesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exclusionRules');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> launchAtStartupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'launchAtStartup');
    });
  }

  QueryBuilder<AppConfig, AppLayout, QQueryOperations> layoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'layout');
    });
  }

  QueryBuilder<AppConfig, String, QQueryOperations> localeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locale');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> onBoardCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onBoardComplete');
    });
  }

  QueryBuilder<AppConfig, DateTime?, QQueryOperations> pausedTillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pausedTill');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> smartPasteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'smartPaste');
    });
  }

  QueryBuilder<AppConfig, SyncSpeed, QQueryOperations> syncSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncSpeed');
    });
  }

  QueryBuilder<AppConfig, int, QQueryOperations> themeColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeColor');
    });
  }

  QueryBuilder<AppConfig, ThemeMode, QQueryOperations> themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }

  QueryBuilder<AppConfig, DynamicSchemeVariant, QQueryOperations>
      themeVariantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeVariant');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations> toggleHotkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toggleHotkey');
    });
  }

  QueryBuilder<AppConfig, AppView, QQueryOperations> viewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'view');
    });
  }

  QueryBuilder<AppConfig, double, QQueryOperations> windowHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'windowHeight');
    });
  }

  QueryBuilder<AppConfig, double, QQueryOperations> windowWidthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'windowWidth');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigImpl _$$AppConfigImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigImpl(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      enableSync: json['enableSync'] as bool? ?? true,
      enableFileSync: json['enableFileSync'] as bool? ?? true,
      layout: $enumDecodeNullable(_$AppLayoutEnumMap, json['layout']) ??
          AppLayout.grid,
      view: $enumDecodeNullable(_$AppViewEnumMap, json['view']) ??
          AppView.windowed,
      pinned: json['pinned'] as bool? ?? false,
      windowWidth:
          (json['windowWidth'] as num?)?.toDouble() ?? initialWindowWidth,
      windowHeight:
          (json['windowHeight'] as num?)?.toDouble() ?? initialWindowHeight,
      dontUploadOver: (json['dontUploadOver'] as num?)?.toInt() ?? $10MB,
      dontCopyOver: (json['dontCopyOver'] as num?)?.toInt() ?? $10MB,
      pausedTill: json['pausedTill'] == null
          ? null
          : DateTime.parse(json['pausedTill'] as String),
      syncSpeed: $enumDecodeNullable(_$SyncSpeedEnumMap, json['syncSpeed']) ??
          SyncSpeed.balanced,
      toggleHotkey: json['toggleHotkey'] as String?,
      smartPaste: json['smartPaste'] as bool? ?? false,
      launchAtStartup: json['launchAtStartup'] as bool? ?? false,
      locale: json['locale'] as String? ?? "en",
      enc2: json['enc2'] as String?,
      autoEncrypt: json['autoEncrypt'] as bool? ?? false,
      themeColor: (json['themeColor'] as num?)?.toInt() ?? defaultThemeColor,
      themeVariant: $enumDecodeNullable(
              _$DynamicSchemeVariantEnumMap, json['themeVariant']) ??
          DynamicSchemeVariant.tonalSpot,
      enableDragNDrop: json['enableDragNDrop'] as bool? ?? false,
      enablePasteStack: json['enablePasteStack'] as bool? ?? false,
      androidBgListener: json['androidBgListener'] as bool? ?? false,
      duplicatePrevention: json['duplicatePrevention'] as bool? ?? false,
      onBoardComplete: json['onBoardComplete'] as bool? ?? true,
      clockUnSynced: json['clockUnSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppConfigImplToJson(_$AppConfigImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'enableSync': instance.enableSync,
      'enableFileSync': instance.enableFileSync,
      'layout': _$AppLayoutEnumMap[instance.layout]!,
      'view': _$AppViewEnumMap[instance.view]!,
      'pinned': instance.pinned,
      'windowWidth': instance.windowWidth,
      'windowHeight': instance.windowHeight,
      'dontUploadOver': instance.dontUploadOver,
      'dontCopyOver': instance.dontCopyOver,
      'pausedTill': instance.pausedTill?.toIso8601String(),
      'syncSpeed': _$SyncSpeedEnumMap[instance.syncSpeed]!,
      'toggleHotkey': instance.toggleHotkey,
      'smartPaste': instance.smartPaste,
      'launchAtStartup': instance.launchAtStartup,
      'locale': instance.locale,
      'enc2': instance.enc2,
      'autoEncrypt': instance.autoEncrypt,
      'themeColor': instance.themeColor,
      'themeVariant': _$DynamicSchemeVariantEnumMap[instance.themeVariant]!,
      'enableDragNDrop': instance.enableDragNDrop,
      'enablePasteStack': instance.enablePasteStack,
      'androidBgListener': instance.androidBgListener,
      'duplicatePrevention': instance.duplicatePrevention,
      'onBoardComplete': instance.onBoardComplete,
      'clockUnSynced': instance.clockUnSynced,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AppLayoutEnumMap = {
  AppLayout.grid: 'grid',
  AppLayout.list: 'list',
};

const _$AppViewEnumMap = {
  AppView.topDocked: 'topDocked',
  AppView.bottomDocked: 'bottomDocked',
  AppView.leftDocked: 'leftDocked',
  AppView.rightDocked: 'rightDocked',
  AppView.windowed: 'windowed',
};

const _$SyncSpeedEnumMap = {
  SyncSpeed.realtime: 'realtime',
  SyncSpeed.balanced: 'balanced',
};

const _$DynamicSchemeVariantEnumMap = {
  DynamicSchemeVariant.tonalSpot: 'tonalSpot',
  DynamicSchemeVariant.fidelity: 'fidelity',
  DynamicSchemeVariant.monochrome: 'monochrome',
  DynamicSchemeVariant.neutral: 'neutral',
  DynamicSchemeVariant.vibrant: 'vibrant',
  DynamicSchemeVariant.expressive: 'expressive',
  DynamicSchemeVariant.content: 'content',
  DynamicSchemeVariant.rainbow: 'rainbow',
  DynamicSchemeVariant.fruitSalad: 'fruitSalad',
};
