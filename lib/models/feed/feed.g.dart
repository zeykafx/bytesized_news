// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFeedCollection on Isar {
  IsarCollection<Feed> get feeds => this.collection();
}

const FeedSchema = CollectionSchema(
  name: r'Feed',
  id: 8879644747771893978,
  properties: {
    r'alwaysOpenInWebview': PropertySchema(
      id: 0,
      name: r'alwaysOpenInWebview',
      type: IsarType.bool,
    ),
    r'articlesRead': PropertySchema(
      id: 1,
      name: r'articlesRead',
      type: IsarType.long,
    ),
    r'categories': PropertySchema(
      id: 2,
      name: r'categories',
      type: IsarType.stringList,
    ),
    r'iconUrl': PropertySchema(id: 3, name: r'iconUrl', type: IsarType.string),
    r'isPinned': PropertySchema(id: 4, name: r'isPinned', type: IsarType.bool),
    r'link': PropertySchema(id: 5, name: r'link', type: IsarType.string),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'notifyAfterBgSync': PropertySchema(
      id: 7,
      name: r'notifyAfterBgSync',
      type: IsarType.bool,
    ),
    r'pinnedPosition': PropertySchema(
      id: 8,
      name: r'pinnedPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _feedEstimateSize,
  serialize: _feedSerialize,
  deserialize: _feedDeserialize,
  deserializeProp: _feedDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _feedGetId,
  getLinks: _feedGetLinks,
  attach: _feedAttach,
  version: '3.2.0-dev.2',
);

int _feedEstimateSize(
  Feed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categories.length * 3;
  {
    for (var i = 0; i < object.categories.length; i++) {
      final value = object.categories[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.iconUrl.length * 3;
  bytesCount += 3 + object.link.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _feedSerialize(
  Feed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.alwaysOpenInWebview);
  writer.writeLong(offsets[1], object.articlesRead);
  writer.writeStringList(offsets[2], object.categories);
  writer.writeString(offsets[3], object.iconUrl);
  writer.writeBool(offsets[4], object.isPinned);
  writer.writeString(offsets[5], object.link);
  writer.writeString(offsets[6], object.name);
  writer.writeBool(offsets[7], object.notifyAfterBgSync);
  writer.writeLong(offsets[8], object.pinnedPosition);
}

Feed _feedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Feed(
    reader.readString(offsets[6]),
    reader.readString(offsets[5]),
    reader.readString(offsets[3]),
  );
  object.alwaysOpenInWebview = reader.readBool(offsets[0]);
  object.articlesRead = reader.readLong(offsets[1]);
  object.categories = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.isPinned = reader.readBool(offsets[4]);
  object.notifyAfterBgSync = reader.readBool(offsets[7]);
  object.pinnedPosition = reader.readLong(offsets[8]);
  return object;
}

P _feedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _feedGetId(Feed object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _feedGetLinks(Feed object) {
  return [];
}

void _feedAttach(IsarCollection<dynamic> col, Id id, Feed object) {
  object.id = id;
}

extension FeedQueryWhereSort on QueryBuilder<Feed, Feed, QWhere> {
  QueryBuilder<Feed, Feed, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FeedQueryWhere on QueryBuilder<Feed, Feed, QWhereClause> {
  QueryBuilder<Feed, Feed, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Feed, Feed, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Feed, Feed, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterWhereClause> idBetween(
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

extension FeedQueryFilter on QueryBuilder<Feed, Feed, QFilterCondition> {
  QueryBuilder<Feed, Feed, QAfterFilterCondition> alwaysOpenInWebviewEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alwaysOpenInWebview', value: value),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> articlesReadEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'articlesRead', value: value),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> articlesReadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'articlesRead',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> articlesReadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'articlesRead',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> articlesReadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'articlesRead',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categories',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categories',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categories', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition>
  categoriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categories', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'categories', length, true, length, true);
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'categories', 0, true, 0, true);
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'categories', 0, false, 999999, true);
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'categories', 0, true, length, include);
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'categories', length, include, 999999, true);
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> categoriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'iconUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconUrl', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> iconUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'iconUrl', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> isPinnedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPinned', value: value),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'link',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'link',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'link',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'link',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'link',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'link',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'link',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'link',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'link', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> linkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'link', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameContains(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> notifyAfterBgSyncEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notifyAfterBgSync', value: value),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> pinnedPositionEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinnedPosition', value: value),
      );
    });
  }

  QueryBuilder<Feed, Feed, QAfterFilterCondition> pinnedPositionGreaterThan(
    int value, {
    bool include = false,
  }) {
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> pinnedPositionLessThan(
    int value, {
    bool include = false,
  }) {
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

  QueryBuilder<Feed, Feed, QAfterFilterCondition> pinnedPositionBetween(
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

extension FeedQueryObject on QueryBuilder<Feed, Feed, QFilterCondition> {}

extension FeedQueryLinks on QueryBuilder<Feed, Feed, QFilterCondition> {}

extension FeedQuerySortBy on QueryBuilder<Feed, Feed, QSortBy> {
  QueryBuilder<Feed, Feed, QAfterSortBy> sortByAlwaysOpenInWebview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysOpenInWebview', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByAlwaysOpenInWebviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysOpenInWebview', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByArticlesRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articlesRead', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByArticlesReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articlesRead', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByNotifyAfterBgSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyAfterBgSync', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByNotifyAfterBgSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyAfterBgSync', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByPinnedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> sortByPinnedPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.desc);
    });
  }
}

extension FeedQuerySortThenBy on QueryBuilder<Feed, Feed, QSortThenBy> {
  QueryBuilder<Feed, Feed, QAfterSortBy> thenByAlwaysOpenInWebview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysOpenInWebview', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByAlwaysOpenInWebviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysOpenInWebview', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByArticlesRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articlesRead', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByArticlesReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articlesRead', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByNotifyAfterBgSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyAfterBgSync', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByNotifyAfterBgSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyAfterBgSync', Sort.desc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByPinnedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.asc);
    });
  }

  QueryBuilder<Feed, Feed, QAfterSortBy> thenByPinnedPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedPosition', Sort.desc);
    });
  }
}

extension FeedQueryWhereDistinct on QueryBuilder<Feed, Feed, QDistinct> {
  QueryBuilder<Feed, Feed, QDistinct> distinctByAlwaysOpenInWebview() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alwaysOpenInWebview');
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByArticlesRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'articlesRead');
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByCategories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categories');
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByIconUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByLink({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'link', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByNotifyAfterBgSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifyAfterBgSync');
    });
  }

  QueryBuilder<Feed, Feed, QDistinct> distinctByPinnedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedPosition');
    });
  }
}

extension FeedQueryProperty on QueryBuilder<Feed, Feed, QQueryProperty> {
  QueryBuilder<Feed, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Feed, bool, QQueryOperations> alwaysOpenInWebviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alwaysOpenInWebview');
    });
  }

  QueryBuilder<Feed, int, QQueryOperations> articlesReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'articlesRead');
    });
  }

  QueryBuilder<Feed, List<String>, QQueryOperations> categoriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categories');
    });
  }

  QueryBuilder<Feed, String, QQueryOperations> iconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconUrl');
    });
  }

  QueryBuilder<Feed, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<Feed, String, QQueryOperations> linkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'link');
    });
  }

  QueryBuilder<Feed, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Feed, bool, QQueryOperations> notifyAfterBgSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifyAfterBgSync');
    });
  }

  QueryBuilder<Feed, int, QQueryOperations> pinnedPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedPosition');
    });
  }
}
