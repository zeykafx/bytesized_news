// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedGroup.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFeedGroupCollection on Isar {
  IsarCollection<FeedGroup> get feedGroups => this.collection();
}

const FeedGroupSchema = CollectionSchema(
  name: r'FeedGroup',
  id: 4402445768558669849,
  properties: {
    r'feedUrls': PropertySchema(
      id: 0,
      name: r'feedUrls',
      type: IsarType.stringList,
    ),
    r'isPinned': PropertySchema(id: 1, name: r'isPinned', type: IsarType.bool),
    r'name': PropertySchema(id: 2, name: r'name', type: IsarType.string),
    r'pinnedPosition': PropertySchema(
      id: 3,
      name: r'pinnedPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _feedGroupEstimateSize,
  serialize: _feedGroupSerialize,
  deserialize: _feedGroupDeserialize,
  deserializeProp: _feedGroupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _feedGroupGetId,
  getLinks: _feedGroupGetLinks,
  attach: _feedGroupAttach,
  version: '3.2.0-dev.2',
);

int _feedGroupEstimateSize(
  FeedGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.feedUrls.length * 3;
  {
    for (var i = 0; i < object.feedUrls.length; i++) {
      final value = object.feedUrls[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _feedGroupSerialize(
  FeedGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.feedUrls);
  writer.writeBool(offsets[1], object.isPinned);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.pinnedPosition);
}

FeedGroup _feedGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FeedGroup(reader.readString(offsets[2]));
  object.feedUrls = reader.readStringList(offsets[0]) ?? [];
  object.id = id;
  object.isPinned = reader.readBool(offsets[1]);
  object.pinnedPosition = reader.readLong(offsets[3]);
  return object;
}

P _feedGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _feedGroupGetId(FeedGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _feedGroupGetLinks(FeedGroup object) {
  return [];
}

void _feedGroupAttach(IsarCollection<dynamic> col, Id id, FeedGroup object) {
  object.id = id;
}

extension FeedGroupQueryWhereSort
    on QueryBuilder<FeedGroup, FeedGroup, QWhere> {
  QueryBuilder<FeedGroup, FeedGroup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FeedGroupQueryWhere
    on QueryBuilder<FeedGroup, FeedGroup, QWhereClause> {
  QueryBuilder<FeedGroup, FeedGroup, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<FeedGroup, FeedGroup, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FeedGroupQueryFilter
    on QueryBuilder<FeedGroup, FeedGroup, QFilterCondition> {
  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'feedUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'feedUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'feedUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'feedUrls',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'feedUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'feedUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'feedUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'feedUrls',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'feedUrls', value: ''),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'feedUrls', value: ''),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'feedUrls', length, true, length, true);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> feedUrlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'feedUrls', 0, true, 0, true);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'feedUrls', 0, false, 999999, true);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'feedUrls', 0, true, length, include);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'feedUrls', length, include, 999999, true);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  feedUrlsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'feedUrls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> isPinnedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPinned', value: value),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  pinnedPositionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinnedPosition', value: value),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  pinnedPositionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pinnedPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  pinnedPositionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pinnedPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterFilterCondition>
  pinnedPositionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pinnedPosition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FeedGroupQueryObject
    on QueryBuilder<FeedGroup, FeedGroup, QFilterCondition> {}

extension FeedGroupQueryLinks
    on QueryBuilder<FeedGroup, FeedGroup, QFilterCondition> {}

extension FeedGroupQuerySortBy on QueryBuilder<FeedGroup, FeedGroup, QSortBy> {
  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> sortByPinnedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> sortByPinnedPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.desc);
    });
  }
}

extension FeedGroupQuerySortThenBy
    on QueryBuilder<FeedGroup, FeedGroup, QSortThenBy> {
  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByPinnedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.asc);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QAfterSortBy> thenByPinnedPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.desc);
    });
  }
}

extension FeedGroupQueryWhereDistinct
    on QueryBuilder<FeedGroup, FeedGroup, QDistinct> {
  QueryBuilder<FeedGroup, FeedGroup, QDistinct> distinctByFeedUrls() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedUrls');
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedGroup, FeedGroup, QDistinct> distinctByPinnedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedPosition');
    });
  }
}

extension FeedGroupQueryProperty
    on QueryBuilder<FeedGroup, FeedGroup, QQueryProperty> {
  QueryBuilder<FeedGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FeedGroup, List<String>, QQueryOperations> feedUrlsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedUrls');
    });
  }

  QueryBuilder<FeedGroup, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<FeedGroup, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FeedGroup, int, QQueryOperations> pinnedPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedPosition');
    });
  }
}
