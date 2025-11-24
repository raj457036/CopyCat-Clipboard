// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syncstatus.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncStatusCollection on Isar {
  IsarCollection<SyncStatus> get syncStatus => this.collection();
}

const SyncStatusSchema = CollectionSchema(
  name: r'SyncStatus',
  id: -6770449623075495653,
  properties: {
    r'lastKnownSyncCount': PropertySchema(
      id: 0,
      name: r'lastKnownSyncCount',
      type: IsarType.long,
    ),
    r'lastKnownTotalCount': PropertySchema(
      id: 1,
      name: r'lastKnownTotalCount',
      type: IsarType.long,
    ),
    r'lastSyncPoint': PropertySchema(
      id: 2,
      name: r'lastSyncPoint',
      type: IsarType.dateTime,
    ),
    r'lastSyncStartPoint': PropertySchema(
      id: 3,
      name: r'lastSyncStartPoint',
      type: IsarType.dateTime,
    ),
    r'restorationPending': PropertySchema(
      id: 4,
      name: r'restorationPending',
      type: IsarType.bool,
    )
  },
  estimateSize: _syncStatusEstimateSize,
  serialize: _syncStatusSerialize,
  deserialize: _syncStatusDeserialize,
  deserializeProp: _syncStatusDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _syncStatusGetId,
  getLinks: _syncStatusGetLinks,
  attach: _syncStatusAttach,
  version: '3.3.0-dev.1',
);

int _syncStatusEstimateSize(
  SyncStatus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _syncStatusSerialize(
  SyncStatus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.lastKnownSyncCount);
  writer.writeLong(offsets[1], object.lastKnownTotalCount);
  writer.writeDateTime(offsets[2], object.lastSyncPoint);
  writer.writeDateTime(offsets[3], object.lastSyncStartPoint);
  writer.writeBool(offsets[4], object.restorationPending);
}

SyncStatus _syncStatusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncStatus(
    lastKnownSyncCount: reader.readLongOrNull(offsets[0]),
    lastKnownTotalCount: reader.readLongOrNull(offsets[1]),
    lastSyncPoint: reader.readDateTimeOrNull(offsets[2]),
    lastSyncStartPoint: reader.readDateTimeOrNull(offsets[3]),
    restorationPending: reader.readBool(offsets[4]),
  );
  object.id = id;
  return object;
}

P _syncStatusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncStatusGetId(SyncStatus object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncStatusGetLinks(SyncStatus object) {
  return [];
}

void _syncStatusAttach(IsarCollection<dynamic> col, Id id, SyncStatus object) {
  object.id = id;
}

extension SyncStatusQueryWhereSort
    on QueryBuilder<SyncStatus, SyncStatus, QWhere> {
  QueryBuilder<SyncStatus, SyncStatus, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncStatusQueryWhere
    on QueryBuilder<SyncStatus, SyncStatus, QWhereClause> {
  QueryBuilder<SyncStatus, SyncStatus, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SyncStatus, SyncStatus, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterWhereClause> idBetween(
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

extension SyncStatusQueryFilter
    on QueryBuilder<SyncStatus, SyncStatus, QFilterCondition> {
  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownSyncCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastKnownSyncCount',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownSyncCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastKnownSyncCount',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownSyncCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastKnownSyncCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownSyncCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastKnownSyncCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownSyncCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastKnownSyncCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownSyncCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastKnownSyncCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownTotalCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastKnownTotalCount',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownTotalCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastKnownTotalCount',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownTotalCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastKnownTotalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownTotalCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastKnownTotalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownTotalCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastKnownTotalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastKnownTotalCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastKnownTotalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncPointIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncPoint',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncPointIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncPoint',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncPointEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncPoint',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncPointGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncPoint',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncPointLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncPoint',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncPointBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncPoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncStartPointIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncStartPoint',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncStartPointIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncStartPoint',
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncStartPointEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncStartPoint',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncStartPointGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncStartPoint',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncStartPointLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncStartPoint',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      lastSyncStartPointBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncStartPoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterFilterCondition>
      restorationPendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'restorationPending',
        value: value,
      ));
    });
  }
}

extension SyncStatusQueryObject
    on QueryBuilder<SyncStatus, SyncStatus, QFilterCondition> {}

extension SyncStatusQueryLinks
    on QueryBuilder<SyncStatus, SyncStatus, QFilterCondition> {}

extension SyncStatusQuerySortBy
    on QueryBuilder<SyncStatus, SyncStatus, QSortBy> {
  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByLastKnownSyncCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownSyncCount', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByLastKnownSyncCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownSyncCount', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByLastKnownTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownTotalCount', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByLastKnownTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownTotalCount', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy> sortByLastSyncPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncPoint', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy> sortByLastSyncPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncPoint', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByLastSyncStartPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncStartPoint', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByLastSyncStartPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncStartPoint', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByRestorationPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restorationPending', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      sortByRestorationPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restorationPending', Sort.desc);
    });
  }
}

extension SyncStatusQuerySortThenBy
    on QueryBuilder<SyncStatus, SyncStatus, QSortThenBy> {
  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByLastKnownSyncCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownSyncCount', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByLastKnownSyncCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownSyncCount', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByLastKnownTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownTotalCount', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByLastKnownTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastKnownTotalCount', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy> thenByLastSyncPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncPoint', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy> thenByLastSyncPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncPoint', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByLastSyncStartPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncStartPoint', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByLastSyncStartPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncStartPoint', Sort.desc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByRestorationPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restorationPending', Sort.asc);
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QAfterSortBy>
      thenByRestorationPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restorationPending', Sort.desc);
    });
  }
}

extension SyncStatusQueryWhereDistinct
    on QueryBuilder<SyncStatus, SyncStatus, QDistinct> {
  QueryBuilder<SyncStatus, SyncStatus, QDistinct>
      distinctByLastKnownSyncCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastKnownSyncCount');
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QDistinct>
      distinctByLastKnownTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastKnownTotalCount');
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QDistinct> distinctByLastSyncPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncPoint');
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QDistinct>
      distinctByLastSyncStartPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncStartPoint');
    });
  }

  QueryBuilder<SyncStatus, SyncStatus, QDistinct>
      distinctByRestorationPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'restorationPending');
    });
  }
}

extension SyncStatusQueryProperty
    on QueryBuilder<SyncStatus, SyncStatus, QQueryProperty> {
  QueryBuilder<SyncStatus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncStatus, int?, QQueryOperations>
      lastKnownSyncCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastKnownSyncCount');
    });
  }

  QueryBuilder<SyncStatus, int?, QQueryOperations>
      lastKnownTotalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastKnownTotalCount');
    });
  }

  QueryBuilder<SyncStatus, DateTime?, QQueryOperations>
      lastSyncPointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncPoint');
    });
  }

  QueryBuilder<SyncStatus, DateTime?, QQueryOperations>
      lastSyncStartPointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncStartPoint');
    });
  }

  QueryBuilder<SyncStatus, bool, QQueryOperations>
      restorationPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'restorationPending');
    });
  }
}
