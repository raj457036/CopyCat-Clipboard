// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exclusion_rules.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AppInfoSchema = Schema(
  name: r'AppInfo',
  id: 4749786948375295623,
  properties: {
    r'identifier': PropertySchema(
      id: 0,
      name: r'identifier',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 2,
      name: r'path',
      type: IsarType.string,
    )
  },
  estimateSize: _appInfoEstimateSize,
  serialize: _appInfoSerialize,
  deserialize: _appInfoDeserialize,
  deserializeProp: _appInfoDeserializeProp,
);

int _appInfoEstimateSize(
  AppInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.identifier;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appInfoSerialize(
  AppInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.identifier);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.path);
}

AppInfo _appInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppInfo(
    identifier: reader.readStringOrNull(offsets[0]),
    name: reader.readString(offsets[1]),
    path: reader.readStringOrNull(offsets[2]),
  );
  return object;
}

P _appInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AppInfoQueryFilter
    on QueryBuilder<AppInfo, AppInfo, QFilterCondition> {
  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'identifier',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'identifier',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'identifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'identifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifier',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> identifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'identifier',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfo, AppInfo, QAfterFilterCondition> pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }
}

extension AppInfoQueryObject
    on QueryBuilder<AppInfo, AppInfo, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ExclusionRulesSchema = Schema(
  name: r'ExclusionRules',
  id: -6535766385402914530,
  properties: {
    r'apps': PropertySchema(
      id: 0,
      name: r'apps',
      type: IsarType.objectList,
      target: r'AppInfo',
    ),
    r'creditCard': PropertySchema(
      id: 1,
      name: r'creditCard',
      type: IsarType.bool,
    ),
    r'email': PropertySchema(
      id: 2,
      name: r'email',
      type: IsarType.bool,
    ),
    r'enable': PropertySchema(
      id: 3,
      name: r'enable',
      type: IsarType.bool,
    ),
    r'passwordManager': PropertySchema(
      id: 4,
      name: r'passwordManager',
      type: IsarType.bool,
    ),
    r'patterns': PropertySchema(
      id: 5,
      name: r'patterns',
      type: IsarType.stringList,
    ),
    r'phone': PropertySchema(
      id: 6,
      name: r'phone',
      type: IsarType.bool,
    ),
    r'sensitiveUrls': PropertySchema(
      id: 7,
      name: r'sensitiveUrls',
      type: IsarType.bool,
    ),
    r'titles': PropertySchema(
      id: 8,
      name: r'titles',
      type: IsarType.stringList,
    ),
    r'urls': PropertySchema(
      id: 9,
      name: r'urls',
      type: IsarType.stringList,
    )
  },
  estimateSize: _exclusionRulesEstimateSize,
  serialize: _exclusionRulesSerialize,
  deserialize: _exclusionRulesDeserialize,
  deserializeProp: _exclusionRulesDeserializeProp,
);

int _exclusionRulesEstimateSize(
  ExclusionRules object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.apps.length * 3;
  {
    final offsets = allOffsets[AppInfo]!;
    for (var i = 0; i < object.apps.length; i++) {
      final value = object.apps[i];
      bytesCount += AppInfoSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.patterns.length * 3;
  {
    for (var i = 0; i < object.patterns.length; i++) {
      final value = object.patterns[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.titles.length * 3;
  {
    for (var i = 0; i < object.titles.length; i++) {
      final value = object.titles[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.urls.length * 3;
  {
    for (var i = 0; i < object.urls.length; i++) {
      final value = object.urls[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _exclusionRulesSerialize(
  ExclusionRules object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<AppInfo>(
    offsets[0],
    allOffsets,
    AppInfoSchema.serialize,
    object.apps,
  );
  writer.writeBool(offsets[1], object.creditCard);
  writer.writeBool(offsets[2], object.email);
  writer.writeBool(offsets[3], object.enable);
  writer.writeBool(offsets[4], object.passwordManager);
  writer.writeStringList(offsets[5], object.patterns);
  writer.writeBool(offsets[6], object.phone);
  writer.writeBool(offsets[7], object.sensitiveUrls);
  writer.writeStringList(offsets[8], object.titles);
  writer.writeStringList(offsets[9], object.urls);
}

ExclusionRules _exclusionRulesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExclusionRules(
    apps: reader.readObjectList<AppInfo>(
          offsets[0],
          AppInfoSchema.deserialize,
          allOffsets,
          AppInfo(),
        ) ??
        [],
    creditCard: reader.readBool(offsets[1]),
    email: reader.readBool(offsets[2]),
    enable: reader.readBool(offsets[3]),
    passwordManager: reader.readBool(offsets[4]),
    patterns: reader.readStringList(offsets[5]) ?? [],
    phone: reader.readBool(offsets[6]),
    sensitiveUrls: reader.readBool(offsets[7]),
    titles: reader.readStringList(offsets[8]) ?? [],
    urls: reader.readStringList(offsets[9]) ?? [],
  );
  return object;
}

P _exclusionRulesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<AppInfo>(
            offset,
            AppInfoSchema.deserialize,
            allOffsets,
            AppInfo(),
          ) ??
          []) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ExclusionRulesQueryFilter
    on QueryBuilder<ExclusionRules, ExclusionRules, QFilterCondition> {
  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'apps',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'apps',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'apps',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'apps',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'apps',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'apps',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      creditCardEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creditCard',
        value: value,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      emailEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      enableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enable',
        value: value,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      passwordManagerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordManager',
        value: value,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'patterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'patterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'patterns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'patterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'patterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'patterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'patterns',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patterns',
        value: '',
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'patterns',
        value: '',
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'patterns',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'patterns',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'patterns',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'patterns',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'patterns',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      patternsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'patterns',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      phoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      sensitiveUrlsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sensitiveUrls',
        value: value,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titles',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titles',
        value: '',
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titles',
        value: '',
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'titles',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'titles',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'titles',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'titles',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'titles',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      titlesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'titles',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'urls',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'urls',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urls',
        value: '',
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'urls',
        value: '',
      ));
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      urlsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ExclusionRulesQueryObject
    on QueryBuilder<ExclusionRules, ExclusionRules, QFilterCondition> {
  QueryBuilder<ExclusionRules, ExclusionRules, QAfterFilterCondition>
      appsElement(FilterQuery<AppInfo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'apps');
    });
  }
}
