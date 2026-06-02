// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_schemas.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScreenConfigSchemaCollection on Isar {
  IsarCollection<ScreenConfigSchema> get screenConfigSchemas =>
      this.collection();
}

const ScreenConfigSchemaSchema = CollectionSchema(
  name: r'ScreenConfigSchema',
  id: 7476910180476222410,
  properties: {
    r'heartbeatIntervalSeconds': PropertySchema(
      id: 0,
      name: r'heartbeatIntervalSeconds',
      type: IsarType.long,
    ),
    r'metricsUploadBatchSize': PropertySchema(
      id: 1,
      name: r'metricsUploadBatchSize',
      type: IsarType.long,
    ),
    r'screenId': PropertySchema(
      id: 2,
      name: r'screenId',
      type: IsarType.string,
    ),
    r'screenToken': PropertySchema(
      id: 3,
      name: r'screenToken',
      type: IsarType.string,
    ),
    r'syncIntervalMinutes': PropertySchema(
      id: 4,
      name: r'syncIntervalMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _screenConfigSchemaEstimateSize,
  serialize: _screenConfigSchemaSerialize,
  deserialize: _screenConfigSchemaDeserialize,
  deserializeProp: _screenConfigSchemaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _screenConfigSchemaGetId,
  getLinks: _screenConfigSchemaGetLinks,
  attach: _screenConfigSchemaAttach,
  version: '3.1.0+1',
);

int _screenConfigSchemaEstimateSize(
  ScreenConfigSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.screenId.length * 3;
  bytesCount += 3 + object.screenToken.length * 3;
  return bytesCount;
}

void _screenConfigSchemaSerialize(
  ScreenConfigSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.heartbeatIntervalSeconds);
  writer.writeLong(offsets[1], object.metricsUploadBatchSize);
  writer.writeString(offsets[2], object.screenId);
  writer.writeString(offsets[3], object.screenToken);
  writer.writeLong(offsets[4], object.syncIntervalMinutes);
}

ScreenConfigSchema _screenConfigSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScreenConfigSchema();
  object.heartbeatIntervalSeconds = reader.readLong(offsets[0]);
  object.id = id;
  object.metricsUploadBatchSize = reader.readLong(offsets[1]);
  object.screenId = reader.readString(offsets[2]);
  object.screenToken = reader.readString(offsets[3]);
  object.syncIntervalMinutes = reader.readLong(offsets[4]);
  return object;
}

P _screenConfigSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _screenConfigSchemaGetId(ScreenConfigSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _screenConfigSchemaGetLinks(
    ScreenConfigSchema object) {
  return [];
}

void _screenConfigSchemaAttach(
    IsarCollection<dynamic> col, Id id, ScreenConfigSchema object) {
  object.id = id;
}

extension ScreenConfigSchemaQueryWhereSort
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QWhere> {
  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScreenConfigSchemaQueryWhere
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QWhereClause> {
  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterWhereClause>
      idBetween(
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

extension ScreenConfigSchemaQueryFilter
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QFilterCondition> {
  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      heartbeatIntervalSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heartbeatIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      heartbeatIntervalSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heartbeatIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      heartbeatIntervalSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heartbeatIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      heartbeatIntervalSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heartbeatIntervalSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      metricsUploadBatchSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metricsUploadBatchSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      metricsUploadBatchSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metricsUploadBatchSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      metricsUploadBatchSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metricsUploadBatchSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      metricsUploadBatchSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metricsUploadBatchSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'screenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'screenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'screenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'screenId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'screenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'screenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'screenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'screenId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'screenId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'screenId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'screenToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'screenToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'screenToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'screenToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'screenToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'screenToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'screenToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'screenToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'screenToken',
        value: '',
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      screenTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'screenToken',
        value: '',
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      syncIntervalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      syncIntervalMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      syncIntervalMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterFilterCondition>
      syncIntervalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncIntervalMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScreenConfigSchemaQueryObject
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QFilterCondition> {}

extension ScreenConfigSchemaQueryLinks
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QFilterCondition> {}

extension ScreenConfigSchemaQuerySortBy
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QSortBy> {
  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByHeartbeatIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartbeatIntervalSeconds', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByHeartbeatIntervalSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartbeatIntervalSeconds', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByMetricsUploadBatchSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricsUploadBatchSize', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByMetricsUploadBatchSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricsUploadBatchSize', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByScreenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenId', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByScreenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenId', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByScreenToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenToken', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortByScreenTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenToken', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortBySyncIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncIntervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      sortBySyncIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncIntervalMinutes', Sort.desc);
    });
  }
}

extension ScreenConfigSchemaQuerySortThenBy
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QSortThenBy> {
  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByHeartbeatIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartbeatIntervalSeconds', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByHeartbeatIntervalSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartbeatIntervalSeconds', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByMetricsUploadBatchSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricsUploadBatchSize', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByMetricsUploadBatchSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricsUploadBatchSize', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByScreenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenId', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByScreenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenId', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByScreenToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenToken', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenByScreenTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenToken', Sort.desc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenBySyncIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncIntervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QAfterSortBy>
      thenBySyncIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncIntervalMinutes', Sort.desc);
    });
  }
}

extension ScreenConfigSchemaQueryWhereDistinct
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QDistinct> {
  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QDistinct>
      distinctByHeartbeatIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heartbeatIntervalSeconds');
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QDistinct>
      distinctByMetricsUploadBatchSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metricsUploadBatchSize');
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QDistinct>
      distinctByScreenId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'screenId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QDistinct>
      distinctByScreenToken({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'screenToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QDistinct>
      distinctBySyncIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncIntervalMinutes');
    });
  }
}

extension ScreenConfigSchemaQueryProperty
    on QueryBuilder<ScreenConfigSchema, ScreenConfigSchema, QQueryProperty> {
  QueryBuilder<ScreenConfigSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScreenConfigSchema, int, QQueryOperations>
      heartbeatIntervalSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heartbeatIntervalSeconds');
    });
  }

  QueryBuilder<ScreenConfigSchema, int, QQueryOperations>
      metricsUploadBatchSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metricsUploadBatchSize');
    });
  }

  QueryBuilder<ScreenConfigSchema, String, QQueryOperations>
      screenIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'screenId');
    });
  }

  QueryBuilder<ScreenConfigSchema, String, QQueryOperations>
      screenTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'screenToken');
    });
  }

  QueryBuilder<ScreenConfigSchema, int, QQueryOperations>
      syncIntervalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncIntervalMinutes');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaylistContentSchemaCollection on Isar {
  IsarCollection<PlaylistContentSchema> get playlistContentSchemas =>
      this.collection();
}

const PlaylistContentSchemaSchema = CollectionSchema(
  name: r'PlaylistContentSchema',
  id: 1045612180147011473,
  properties: {
    r'contentId': PropertySchema(
      id: 0,
      name: r'contentId',
      type: IsarType.string,
    ),
    r'durationSeconds': PropertySchema(
      id: 1,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'isDownloaded': PropertySchema(
      id: 2,
      name: r'isDownloaded',
      type: IsarType.bool,
    ),
    r'localPath': PropertySchema(
      id: 3,
      name: r'localPath',
      type: IsarType.string,
    ),
    r'order': PropertySchema(
      id: 4,
      name: r'order',
      type: IsarType.long,
    ),
    r'regionId': PropertySchema(
      id: 5,
      name: r'regionId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 7,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _playlistContentSchemaEstimateSize,
  serialize: _playlistContentSchemaSerialize,
  deserialize: _playlistContentSchemaDeserialize,
  deserializeProp: _playlistContentSchemaDeserializeProp,
  idName: r'id',
  indexes: {
    r'regionId': IndexSchema(
      id: -3633044038139156791,
      name: r'regionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'regionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _playlistContentSchemaGetId,
  getLinks: _playlistContentSchemaGetLinks,
  attach: _playlistContentSchemaAttach,
  version: '3.1.0+1',
);

int _playlistContentSchemaEstimateSize(
  PlaylistContentSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contentId.length * 3;
  {
    final value = object.localPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.regionId.length * 3;
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _playlistContentSchemaSerialize(
  PlaylistContentSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contentId);
  writer.writeLong(offsets[1], object.durationSeconds);
  writer.writeBool(offsets[2], object.isDownloaded);
  writer.writeString(offsets[3], object.localPath);
  writer.writeLong(offsets[4], object.order);
  writer.writeString(offsets[5], object.regionId);
  writer.writeString(offsets[6], object.type);
  writer.writeString(offsets[7], object.url);
}

PlaylistContentSchema _playlistContentSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaylistContentSchema();
  object.contentId = reader.readString(offsets[0]);
  object.durationSeconds = reader.readLong(offsets[1]);
  object.id = id;
  object.isDownloaded = reader.readBool(offsets[2]);
  object.localPath = reader.readStringOrNull(offsets[3]);
  object.order = reader.readLong(offsets[4]);
  object.regionId = reader.readString(offsets[5]);
  object.type = reader.readString(offsets[6]);
  object.url = reader.readString(offsets[7]);
  return object;
}

P _playlistContentSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playlistContentSchemaGetId(PlaylistContentSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playlistContentSchemaGetLinks(
    PlaylistContentSchema object) {
  return [];
}

void _playlistContentSchemaAttach(
    IsarCollection<dynamic> col, Id id, PlaylistContentSchema object) {
  object.id = id;
}

extension PlaylistContentSchemaQueryWhereSort
    on QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QWhere> {
  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlaylistContentSchemaQueryWhere on QueryBuilder<PlaylistContentSchema,
    PlaylistContentSchema, QWhereClause> {
  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      regionIdEqualTo(String regionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'regionId',
        value: [regionId],
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterWhereClause>
      regionIdNotEqualTo(String regionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'regionId',
              lower: [],
              upper: [regionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'regionId',
              lower: [regionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'regionId',
              lower: [regionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'regionId',
              lower: [],
              upper: [regionId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PlaylistContentSchemaQueryFilter on QueryBuilder<
    PlaylistContentSchema, PlaylistContentSchema, QFilterCondition> {
  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      contentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      contentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> contentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> isDownloadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      localPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      localPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> localPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> orderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> orderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> orderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> orderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'order',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      regionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      regionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regionId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> regionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regionId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
          QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema,
      QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension PlaylistContentSchemaQueryObject on QueryBuilder<
    PlaylistContentSchema, PlaylistContentSchema, QFilterCondition> {}

extension PlaylistContentSchemaQueryLinks on QueryBuilder<PlaylistContentSchema,
    PlaylistContentSchema, QFilterCondition> {}

extension PlaylistContentSchemaQuerySortBy
    on QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QSortBy> {
  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension PlaylistContentSchemaQuerySortThenBy
    on QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QSortThenBy> {
  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QAfterSortBy>
      thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension PlaylistContentSchemaQueryWhereDistinct
    on QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct> {
  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByContentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownloaded');
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'order');
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByRegionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistContentSchema, PlaylistContentSchema, QDistinct>
      distinctByUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension PlaylistContentSchemaQueryProperty on QueryBuilder<
    PlaylistContentSchema, PlaylistContentSchema, QQueryProperty> {
  QueryBuilder<PlaylistContentSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaylistContentSchema, String, QQueryOperations>
      contentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentId');
    });
  }

  QueryBuilder<PlaylistContentSchema, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<PlaylistContentSchema, bool, QQueryOperations>
      isDownloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownloaded');
    });
  }

  QueryBuilder<PlaylistContentSchema, String?, QQueryOperations>
      localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localPath');
    });
  }

  QueryBuilder<PlaylistContentSchema, int, QQueryOperations> orderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'order');
    });
  }

  QueryBuilder<PlaylistContentSchema, String, QQueryOperations>
      regionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regionId');
    });
  }

  QueryBuilder<PlaylistContentSchema, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<PlaylistContentSchema, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetContentPlayLogSchemaCollection on Isar {
  IsarCollection<ContentPlayLogSchema> get contentPlayLogSchemas =>
      this.collection();
}

const ContentPlayLogSchemaSchema = CollectionSchema(
  name: r'ContentPlayLogSchema',
  id: -2448096835567780200,
  properties: {
    r'campaignId': PropertySchema(
      id: 0,
      name: r'campaignId',
      type: IsarType.string,
    ),
    r'completed': PropertySchema(
      id: 1,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'contentId': PropertySchema(
      id: 2,
      name: r'contentId',
      type: IsarType.string,
    ),
    r'durationSeconds': PropertySchema(
      id: 3,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'errorMessage': PropertySchema(
      id: 4,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'layoutRegionId': PropertySchema(
      id: 5,
      name: r'layoutRegionId',
      type: IsarType.string,
    ),
    r'playedAt': PropertySchema(
      id: 6,
      name: r'playedAt',
      type: IsarType.dateTime,
    ),
    r'scheduleId': PropertySchema(
      id: 7,
      name: r'scheduleId',
      type: IsarType.string,
    )
  },
  estimateSize: _contentPlayLogSchemaEstimateSize,
  serialize: _contentPlayLogSchemaSerialize,
  deserialize: _contentPlayLogSchemaDeserialize,
  deserializeProp: _contentPlayLogSchemaDeserializeProp,
  idName: r'id',
  indexes: {
    r'playedAt': IndexSchema(
      id: -3711549563919110219,
      name: r'playedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'playedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _contentPlayLogSchemaGetId,
  getLinks: _contentPlayLogSchemaGetLinks,
  attach: _contentPlayLogSchemaAttach,
  version: '3.1.0+1',
);

int _contentPlayLogSchemaEstimateSize(
  ContentPlayLogSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.campaignId.length * 3;
  bytesCount += 3 + object.contentId.length * 3;
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.layoutRegionId.length * 3;
  bytesCount += 3 + object.scheduleId.length * 3;
  return bytesCount;
}

void _contentPlayLogSchemaSerialize(
  ContentPlayLogSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.campaignId);
  writer.writeBool(offsets[1], object.completed);
  writer.writeString(offsets[2], object.contentId);
  writer.writeLong(offsets[3], object.durationSeconds);
  writer.writeString(offsets[4], object.errorMessage);
  writer.writeString(offsets[5], object.layoutRegionId);
  writer.writeDateTime(offsets[6], object.playedAt);
  writer.writeString(offsets[7], object.scheduleId);
}

ContentPlayLogSchema _contentPlayLogSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContentPlayLogSchema();
  object.campaignId = reader.readString(offsets[0]);
  object.completed = reader.readBool(offsets[1]);
  object.contentId = reader.readString(offsets[2]);
  object.durationSeconds = reader.readLong(offsets[3]);
  object.errorMessage = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.layoutRegionId = reader.readString(offsets[5]);
  object.playedAt = reader.readDateTime(offsets[6]);
  object.scheduleId = reader.readString(offsets[7]);
  return object;
}

P _contentPlayLogSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _contentPlayLogSchemaGetId(ContentPlayLogSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _contentPlayLogSchemaGetLinks(
    ContentPlayLogSchema object) {
  return [];
}

void _contentPlayLogSchemaAttach(
    IsarCollection<dynamic> col, Id id, ContentPlayLogSchema object) {
  object.id = id;
}

extension ContentPlayLogSchemaQueryWhereSort
    on QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QWhere> {
  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhere>
      anyPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'playedAt'),
      );
    });
  }
}

extension ContentPlayLogSchemaQueryWhere
    on QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QWhereClause> {
  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      playedAtEqualTo(DateTime playedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'playedAt',
        value: [playedAt],
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      playedAtNotEqualTo(DateTime playedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playedAt',
              lower: [],
              upper: [playedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playedAt',
              lower: [playedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playedAt',
              lower: [playedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playedAt',
              lower: [],
              upper: [playedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      playedAtGreaterThan(
    DateTime playedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'playedAt',
        lower: [playedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      playedAtLessThan(
    DateTime playedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'playedAt',
        lower: [],
        upper: [playedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterWhereClause>
      playedAtBetween(
    DateTime lowerPlayedAt,
    DateTime upperPlayedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'playedAt',
        lower: [lowerPlayedAt],
        includeLower: includeLower,
        upper: [upperPlayedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ContentPlayLogSchemaQueryFilter on QueryBuilder<ContentPlayLogSchema,
    ContentPlayLogSchema, QFilterCondition> {
  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'campaignId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      campaignIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      campaignIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'campaignId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> campaignIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'campaignId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      contentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      contentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> contentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layoutRegionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'layoutRegionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'layoutRegionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'layoutRegionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'layoutRegionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'layoutRegionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      layoutRegionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'layoutRegionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      layoutRegionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'layoutRegionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layoutRegionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> layoutRegionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'layoutRegionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> playedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> playedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> playedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> playedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      scheduleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
          QAfterFilterCondition>
      scheduleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema,
      QAfterFilterCondition> scheduleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduleId',
        value: '',
      ));
    });
  }
}

extension ContentPlayLogSchemaQueryObject on QueryBuilder<ContentPlayLogSchema,
    ContentPlayLogSchema, QFilterCondition> {}

extension ContentPlayLogSchemaQueryLinks on QueryBuilder<ContentPlayLogSchema,
    ContentPlayLogSchema, QFilterCondition> {}

extension ContentPlayLogSchemaQuerySortBy
    on QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QSortBy> {
  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByCampaignIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByLayoutRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutRegionId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByLayoutRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutRegionId', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      sortByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }
}

extension ContentPlayLogSchemaQuerySortThenBy
    on QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QSortThenBy> {
  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByCampaignIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByLayoutRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutRegionId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByLayoutRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutRegionId', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QAfterSortBy>
      thenByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }
}

extension ContentPlayLogSchemaQueryWhereDistinct
    on QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct> {
  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByCampaignId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'campaignId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByContentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByLayoutRegionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'layoutRegionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playedAt');
    });
  }

  QueryBuilder<ContentPlayLogSchema, ContentPlayLogSchema, QDistinct>
      distinctByScheduleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleId', caseSensitive: caseSensitive);
    });
  }
}

extension ContentPlayLogSchemaQueryProperty on QueryBuilder<
    ContentPlayLogSchema, ContentPlayLogSchema, QQueryProperty> {
  QueryBuilder<ContentPlayLogSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ContentPlayLogSchema, String, QQueryOperations>
      campaignIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'campaignId');
    });
  }

  QueryBuilder<ContentPlayLogSchema, bool, QQueryOperations>
      completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<ContentPlayLogSchema, String, QQueryOperations>
      contentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentId');
    });
  }

  QueryBuilder<ContentPlayLogSchema, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<ContentPlayLogSchema, String?, QQueryOperations>
      errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<ContentPlayLogSchema, String, QQueryOperations>
      layoutRegionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'layoutRegionId');
    });
  }

  QueryBuilder<ContentPlayLogSchema, DateTime, QQueryOperations>
      playedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playedAt');
    });
  }

  QueryBuilder<ContentPlayLogSchema, String, QQueryOperations>
      scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleId');
    });
  }
}
