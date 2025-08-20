// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_reading.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStoryReadingCollection on Isar {
  IsarCollection<StoryReading> get storyReadings => this.collection();
}

const StoryReadingSchema = CollectionSchema(
  name: r'StoryReading',
  id: -8532769167361121155,
  properties: {
    r'feedId': PropertySchema(
      id: 0,
      name: r'feedId',
      type: IsarType.long,
    ),
    r'feedItemId': PropertySchema(
      id: 1,
      name: r'feedItemId',
      type: IsarType.long,
    ),
    r'firstRead': PropertySchema(
      id: 2,
      name: r'firstRead',
      type: IsarType.dateTime,
    ),
    r'readLog': PropertySchema(
      id: 3,
      name: r'readLog',
      type: IsarType.dateTimeList,
    ),
    r'readingDuration': PropertySchema(
      id: 4,
      name: r'readingDuration',
      type: IsarType.long,
    )
  },
  estimateSize: _storyReadingEstimateSize,
  serialize: _storyReadingSerialize,
  deserialize: _storyReadingDeserialize,
  deserializeProp: _storyReadingDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _storyReadingGetId,
  getLinks: _storyReadingGetLinks,
  attach: _storyReadingAttach,
  version: '3.1.0+1',
);

int _storyReadingEstimateSize(
  StoryReading object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.readLog.length * 8;
  return bytesCount;
}

void _storyReadingSerialize(
  StoryReading object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.feedId);
  writer.writeLong(offsets[1], object.feedItemId);
  writer.writeDateTime(offsets[2], object.firstRead);
  writer.writeDateTimeList(offsets[3], object.readLog);
  writer.writeLong(offsets[4], object.readingDuration);
}

StoryReading _storyReadingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StoryReading(
    reader.readLong(offsets[1]),
    reader.readLong(offsets[0]),
    reader.readLong(offsets[4]),
    reader.readDateTimeList(offsets[3]) ?? [],
    reader.readDateTime(offsets[2]),
  );
  object.id = id;
  return object;
}

P _storyReadingDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _storyReadingGetId(StoryReading object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _storyReadingGetLinks(StoryReading object) {
  return [];
}

void _storyReadingAttach(
    IsarCollection<dynamic> col, Id id, StoryReading object) {
  object.id = id;
}

extension StoryReadingQueryWhereSort
    on QueryBuilder<StoryReading, StoryReading, QWhere> {
  QueryBuilder<StoryReading, StoryReading, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StoryReadingQueryWhere
    on QueryBuilder<StoryReading, StoryReading, QWhereClause> {
  QueryBuilder<StoryReading, StoryReading, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<StoryReading, StoryReading, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterWhereClause> idBetween(
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

extension StoryReadingQueryFilter
    on QueryBuilder<StoryReading, StoryReading, QFilterCondition> {
  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition> feedIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedId',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      feedIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feedId',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      feedIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feedId',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition> feedIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feedId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      feedItemIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      feedItemIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feedItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      feedItemIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feedItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      feedItemIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feedItemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      firstReadEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstRead',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      firstReadGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstRead',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      firstReadLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstRead',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      firstReadBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstRead',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readLog',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readLog',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readLog',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readLog',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readLog',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readLog',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readLog',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readLog',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readLog',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readLogLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readLog',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readingDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readingDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readingDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readingDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readingDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterFilterCondition>
      readingDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readingDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StoryReadingQueryObject
    on QueryBuilder<StoryReading, StoryReading, QFilterCondition> {}

extension StoryReadingQueryLinks
    on QueryBuilder<StoryReading, StoryReading, QFilterCondition> {}

extension StoryReadingQuerySortBy
    on QueryBuilder<StoryReading, StoryReading, QSortBy> {
  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> sortByFeedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedId', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> sortByFeedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedId', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> sortByFeedItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedItemId', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy>
      sortByFeedItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedItemId', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> sortByFirstRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstRead', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> sortByFirstReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstRead', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy>
      sortByReadingDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDuration', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy>
      sortByReadingDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDuration', Sort.desc);
    });
  }
}

extension StoryReadingQuerySortThenBy
    on QueryBuilder<StoryReading, StoryReading, QSortThenBy> {
  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenByFeedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedId', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenByFeedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedId', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenByFeedItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedItemId', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy>
      thenByFeedItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedItemId', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenByFirstRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstRead', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenByFirstReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstRead', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy>
      thenByReadingDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDuration', Sort.asc);
    });
  }

  QueryBuilder<StoryReading, StoryReading, QAfterSortBy>
      thenByReadingDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDuration', Sort.desc);
    });
  }
}

extension StoryReadingQueryWhereDistinct
    on QueryBuilder<StoryReading, StoryReading, QDistinct> {
  QueryBuilder<StoryReading, StoryReading, QDistinct> distinctByFeedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedId');
    });
  }

  QueryBuilder<StoryReading, StoryReading, QDistinct> distinctByFeedItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedItemId');
    });
  }

  QueryBuilder<StoryReading, StoryReading, QDistinct> distinctByFirstRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstRead');
    });
  }

  QueryBuilder<StoryReading, StoryReading, QDistinct> distinctByReadLog() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readLog');
    });
  }

  QueryBuilder<StoryReading, StoryReading, QDistinct>
      distinctByReadingDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingDuration');
    });
  }
}

extension StoryReadingQueryProperty
    on QueryBuilder<StoryReading, StoryReading, QQueryProperty> {
  QueryBuilder<StoryReading, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StoryReading, int, QQueryOperations> feedIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedId');
    });
  }

  QueryBuilder<StoryReading, int, QQueryOperations> feedItemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedItemId');
    });
  }

  QueryBuilder<StoryReading, DateTime, QQueryOperations> firstReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstRead');
    });
  }

  QueryBuilder<StoryReading, List<DateTime>, QQueryOperations>
      readLogProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readLog');
    });
  }

  QueryBuilder<StoryReading, int, QQueryOperations> readingDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingDuration');
    });
  }
}
