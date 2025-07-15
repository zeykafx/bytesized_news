// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedItem.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFeedItemCollection on Isar {
  IsarCollection<FeedItem> get feedItems => this.collection();
}

const FeedItemSchema = CollectionSchema(
  name: r'FeedItem',
  id: -4620245456200782061,
  properties: {
    r'aiSummary': PropertySchema(
      id: 0,
      name: r'aiSummary',
      type: IsarType.string,
    ),
    r'authors': PropertySchema(
      id: 1,
      name: r'authors',
      type: IsarType.stringList,
    ),
    r'bookmarked': PropertySchema(
      id: 2,
      name: r'bookmarked',
      type: IsarType.bool,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'downloaded': PropertySchema(
      id: 4,
      name: r'downloaded',
      type: IsarType.bool,
    ),
    r'estReadingTimeMinutes': PropertySchema(
      id: 5,
      name: r'estReadingTimeMinutes',
      type: IsarType.long,
    ),
    r'feedName': PropertySchema(
      id: 6,
      name: r'feedName',
      type: IsarType.string,
    ),
    r'fetchedInBg': PropertySchema(
      id: 7,
      name: r'fetchedInBg',
      type: IsarType.bool,
    ),
    r'hashCode': PropertySchema(
      id: 8,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'htmlContent': PropertySchema(
      id: 9,
      name: r'htmlContent',
      type: IsarType.string,
    ),
    r'imageUrl': PropertySchema(
      id: 10,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'publishedDate': PropertySchema(
      id: 11,
      name: r'publishedDate',
      type: IsarType.dateTime,
    ),
    r'read': PropertySchema(
      id: 12,
      name: r'read',
      type: IsarType.bool,
    ),
    r'suggested': PropertySchema(
      id: 13,
      name: r'suggested',
      type: IsarType.bool,
    ),
    r'summarized': PropertySchema(
      id: 14,
      name: r'summarized',
      type: IsarType.bool,
    ),
    r'timeFetched': PropertySchema(
      id: 15,
      name: r'timeFetched',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 16,
      name: r'title',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 17,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _feedItemEstimateSize,
  serialize: _feedItemSerialize,
  deserialize: _feedItemDeserialize,
  deserializeProp: _feedItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'url': IndexSchema(
      id: -5756857009679432345,
      name: r'url',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'url',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _feedItemGetId,
  getLinks: _feedItemGetLinks,
  attach: _feedItemAttach,
  version: '3.1.0+1',
);

int _feedItemEstimateSize(
  FeedItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.aiSummary.length * 3;
  bytesCount += 3 + object.authors.length * 3;
  {
    for (var i = 0; i < object.authors.length; i++) {
      final value = object.authors[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.feedName.length * 3;
  {
    final value = object.htmlContent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.imageUrl.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _feedItemSerialize(
  FeedItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiSummary);
  writer.writeStringList(offsets[1], object.authors);
  writer.writeBool(offsets[2], object.bookmarked);
  writer.writeString(offsets[3], object.description);
  writer.writeBool(offsets[4], object.downloaded);
  writer.writeLong(offsets[5], object.estReadingTimeMinutes);
  writer.writeString(offsets[6], object.feedName);
  writer.writeBool(offsets[7], object.fetchedInBg);
  writer.writeLong(offsets[8], object.hashCode);
  writer.writeString(offsets[9], object.htmlContent);
  writer.writeString(offsets[10], object.imageUrl);
  writer.writeDateTime(offsets[11], object.publishedDate);
  writer.writeBool(offsets[12], object.read);
  writer.writeBool(offsets[13], object.suggested);
  writer.writeBool(offsets[14], object.summarized);
  writer.writeDateTime(offsets[15], object.timeFetched);
  writer.writeString(offsets[16], object.title);
  writer.writeString(offsets[17], object.url);
}

FeedItem _feedItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FeedItem();
  object.aiSummary = reader.readString(offsets[0]);
  object.authors = reader.readStringList(offsets[1]) ?? [];
  object.bookmarked = reader.readBool(offsets[2]);
  object.description = reader.readString(offsets[3]);
  object.downloaded = reader.readBool(offsets[4]);
  object.estReadingTimeMinutes = reader.readLong(offsets[5]);
  object.feedName = reader.readString(offsets[6]);
  object.fetchedInBg = reader.readBoolOrNull(offsets[7]);
  object.htmlContent = reader.readStringOrNull(offsets[9]);
  object.id = id;
  object.imageUrl = reader.readString(offsets[10]);
  object.publishedDate = reader.readDateTime(offsets[11]);
  object.read = reader.readBool(offsets[12]);
  object.suggested = reader.readBool(offsets[13]);
  object.summarized = reader.readBool(offsets[14]);
  object.timeFetched = reader.readDateTime(offsets[15]);
  object.title = reader.readString(offsets[16]);
  object.url = reader.readString(offsets[17]);
  return object;
}

P _feedItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _feedItemGetId(FeedItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _feedItemGetLinks(FeedItem object) {
  return [];
}

void _feedItemAttach(IsarCollection<dynamic> col, Id id, FeedItem object) {
  object.id = id;
}

extension FeedItemQueryWhereSort on QueryBuilder<FeedItem, FeedItem, QWhere> {
  QueryBuilder<FeedItem, FeedItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FeedItemQueryWhere on QueryBuilder<FeedItem, FeedItem, QWhereClause> {
  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> urlEqualTo(String url) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'url',
        value: [url],
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterWhereClause> urlNotEqualTo(
      String url) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [],
              upper: [url],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [url],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [url],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [],
              upper: [url],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FeedItemQueryFilter
    on QueryBuilder<FeedItem, FeedItem, QFilterCondition> {
  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiSummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> aiSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      aiSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'authors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'authors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'authors',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'authors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'authors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'authors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'authors',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authors',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'authors',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'authors',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'authors',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'authors',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'authors',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      authorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'authors',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> authorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'authors',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> bookmarkedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookmarked',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> downloadedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      estReadingTimeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estReadingTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      estReadingTimeMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estReadingTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      estReadingTimeMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estReadingTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      estReadingTimeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estReadingTimeMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feedName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'feedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'feedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'feedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'feedName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedName',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> feedNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'feedName',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> fetchedInBgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fetchedInBg',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      fetchedInBgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fetchedInBg',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> fetchedInBgEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedInBg',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'htmlContent',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      htmlContentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'htmlContent',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'htmlContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      htmlContentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'htmlContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'htmlContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'htmlContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'htmlContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'htmlContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'htmlContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'htmlContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> htmlContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'htmlContent',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      htmlContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'htmlContent',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> publishedDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publishedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      publishedDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publishedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> publishedDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publishedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> publishedDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publishedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> readEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'read',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> suggestedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suggested',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> summarizedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summarized',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> timeFetchedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition>
      timeFetchedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> timeFetchedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> timeFetchedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeFetched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlEqualTo(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlGreaterThan(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlLessThan(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlBetween(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlStartsWith(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlEndsWith(
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

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension FeedItemQueryObject
    on QueryBuilder<FeedItem, FeedItem, QFilterCondition> {}

extension FeedItemQueryLinks
    on QueryBuilder<FeedItem, FeedItem, QFilterCondition> {}

extension FeedItemQuerySortBy on QueryBuilder<FeedItem, FeedItem, QSortBy> {
  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByAiSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByAiSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByBookmarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByEstReadingTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estReadingTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy>
      sortByEstReadingTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estReadingTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByFeedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedName', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByFeedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedName', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByFetchedInBg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedInBg', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByFetchedInBgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedInBg', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByHtmlContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'htmlContent', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByHtmlContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'htmlContent', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByPublishedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedDate', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByPublishedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedDate', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortBySuggested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggested', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortBySuggestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggested', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortBySummarized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summarized', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortBySummarizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summarized', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByTimeFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeFetched', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByTimeFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeFetched', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension FeedItemQuerySortThenBy
    on QueryBuilder<FeedItem, FeedItem, QSortThenBy> {
  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByAiSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByAiSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByBookmarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByEstReadingTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estReadingTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy>
      thenByEstReadingTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estReadingTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByFeedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedName', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByFeedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedName', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByFetchedInBg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedInBg', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByFetchedInBgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedInBg', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByHtmlContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'htmlContent', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByHtmlContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'htmlContent', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByPublishedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedDate', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByPublishedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedDate', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenBySuggested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggested', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenBySuggestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggested', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenBySummarized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summarized', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenBySummarizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summarized', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByTimeFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeFetched', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByTimeFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeFetched', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension FeedItemQueryWhereDistinct
    on QueryBuilder<FeedItem, FeedItem, QDistinct> {
  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByAiSummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiSummary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByAuthors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authors');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookmarked');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloaded');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct>
      distinctByEstReadingTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estReadingTimeMinutes');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByFeedName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByFetchedInBg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedInBg');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByHtmlContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'htmlContent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByPublishedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publishedDate');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'read');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctBySuggested() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suggested');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctBySummarized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summarized');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByTimeFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeFetched');
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedItem, FeedItem, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension FeedItemQueryProperty
    on QueryBuilder<FeedItem, FeedItem, QQueryProperty> {
  QueryBuilder<FeedItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FeedItem, String, QQueryOperations> aiSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiSummary');
    });
  }

  QueryBuilder<FeedItem, List<String>, QQueryOperations> authorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authors');
    });
  }

  QueryBuilder<FeedItem, bool, QQueryOperations> bookmarkedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookmarked');
    });
  }

  QueryBuilder<FeedItem, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<FeedItem, bool, QQueryOperations> downloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloaded');
    });
  }

  QueryBuilder<FeedItem, int, QQueryOperations>
      estReadingTimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estReadingTimeMinutes');
    });
  }

  QueryBuilder<FeedItem, String, QQueryOperations> feedNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedName');
    });
  }

  QueryBuilder<FeedItem, bool?, QQueryOperations> fetchedInBgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedInBg');
    });
  }

  QueryBuilder<FeedItem, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<FeedItem, String?, QQueryOperations> htmlContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'htmlContent');
    });
  }

  QueryBuilder<FeedItem, String, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<FeedItem, DateTime, QQueryOperations> publishedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publishedDate');
    });
  }

  QueryBuilder<FeedItem, bool, QQueryOperations> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'read');
    });
  }

  QueryBuilder<FeedItem, bool, QQueryOperations> suggestedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suggested');
    });
  }

  QueryBuilder<FeedItem, bool, QQueryOperations> summarizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summarized');
    });
  }

  QueryBuilder<FeedItem, DateTime, QQueryOperations> timeFetchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeFetched');
    });
  }

  QueryBuilder<FeedItem, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<FeedItem, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}
