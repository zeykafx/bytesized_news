// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAiProviderCollection on Isar {
  IsarCollection<AiProvider> get aiProviders => this.collection();
}

const AiProviderSchema = CollectionSchema(
  name: r'AiProvider',
  id: 8746231323786382361,
  properties: {
    r'apiKey': PropertySchema(id: 0, name: r'apiKey', type: IsarType.string),
    r'apiLink': PropertySchema(id: 1, name: r'apiLink', type: IsarType.string),
    r'devName': PropertySchema(id: 2, name: r'devName', type: IsarType.string),
    r'hashCode': PropertySchema(id: 3, name: r'hashCode', type: IsarType.long),
    r'iconFileName': PropertySchema(
      id: 4,
      name: r'iconFileName',
      type: IsarType.string,
    ),
    r'inUse': PropertySchema(id: 5, name: r'inUse', type: IsarType.bool),
    r'modelToUseIndex': PropertySchema(
      id: 6,
      name: r'modelToUseIndex',
      type: IsarType.long,
    ),
    r'models': PropertySchema(
      id: 7,
      name: r'models',
      type: IsarType.stringList,
    ),
    r'name': PropertySchema(id: 8, name: r'name', type: IsarType.string),
    r'openAiCompatible': PropertySchema(
      id: 9,
      name: r'openAiCompatible',
      type: IsarType.bool,
    ),
    r'providerInfo': PropertySchema(
      id: 10,
      name: r'providerInfo',
      type: IsarType.string,
    ),
    r'temperature': PropertySchema(
      id: 11,
      name: r'temperature',
      type: IsarType.double,
    ),
  },

  estimateSize: _aiProviderEstimateSize,
  serialize: _aiProviderSerialize,
  deserialize: _aiProviderDeserialize,
  deserializeProp: _aiProviderDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _aiProviderGetId,
  getLinks: _aiProviderGetLinks,
  attach: _aiProviderAttach,
  version: '3.2.0-dev.2',
);

int _aiProviderEstimateSize(
  AiProvider object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.apiKey.length * 3;
  bytesCount += 3 + object.apiLink.length * 3;
  bytesCount += 3 + object.devName.length * 3;
  bytesCount += 3 + object.iconFileName.length * 3;
  bytesCount += 3 + object.models.length * 3;
  {
    for (var i = 0; i < object.models.length; i++) {
      final value = object.models[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.providerInfo.length * 3;
  return bytesCount;
}

void _aiProviderSerialize(
  AiProvider object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.apiKey);
  writer.writeString(offsets[1], object.apiLink);
  writer.writeString(offsets[2], object.devName);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeString(offsets[4], object.iconFileName);
  writer.writeBool(offsets[5], object.inUse);
  writer.writeLong(offsets[6], object.modelToUseIndex);
  writer.writeStringList(offsets[7], object.models);
  writer.writeString(offsets[8], object.name);
  writer.writeBool(offsets[9], object.openAiCompatible);
  writer.writeString(offsets[10], object.providerInfo);
  writer.writeDouble(offsets[11], object.temperature);
}

AiProvider _aiProviderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AiProvider(
    apiKey: reader.readString(offsets[0]),
    apiLink: reader.readString(offsets[1]),
    devName: reader.readString(offsets[2]),
    iconFileName: reader.readString(offsets[4]),
    inUse: reader.readBool(offsets[5]),
    models: reader.readStringList(offsets[7]) ?? [],
    name: reader.readString(offsets[8]),
    openAiCompatible: reader.readBool(offsets[9]),
    providerInfo: reader.readString(offsets[10]),
    temperature: reader.readDouble(offsets[11]),
  );
  object.id = id;
  object.modelToUseIndex = reader.readLong(offsets[6]);
  return object;
}

P _aiProviderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aiProviderGetId(AiProvider object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aiProviderGetLinks(AiProvider object) {
  return [];
}

void _aiProviderAttach(IsarCollection<dynamic> col, Id id, AiProvider object) {
  object.id = id;
}

extension AiProviderQueryWhereSort
    on QueryBuilder<AiProvider, AiProvider, QWhere> {
  QueryBuilder<AiProvider, AiProvider, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AiProviderQueryWhere
    on QueryBuilder<AiProvider, AiProvider, QWhereClause> {
  QueryBuilder<AiProvider, AiProvider, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AiProvider, AiProvider, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterWhereClause> idBetween(
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

extension AiProviderQueryFilter
    on QueryBuilder<AiProvider, AiProvider, QFilterCondition> {
  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'apiKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'apiKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'apiKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'apiKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'apiKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'apiKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'apiKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'apiKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'apiKey', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  apiKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'apiKey', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'apiLink',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  apiLinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'apiLink',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'apiLink',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'apiLink',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'apiLink',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'apiLink',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'apiLink',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'apiLink',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> apiLinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'apiLink', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  apiLinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'apiLink', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'devName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  devNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'devName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'devName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'devName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'devName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'devName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'devName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'devName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> devNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'devName', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  devNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'devName', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> hashCodeEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hashCode', value: value),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  hashCodeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hashCode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hashCode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hashCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'iconFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconFileName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'iconFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'iconFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'iconFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'iconFileName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconFileName', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  iconFileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'iconFileName', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> inUseEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inUse', value: value),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelToUseIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'modelToUseIndex', value: value),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelToUseIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'modelToUseIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelToUseIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'modelToUseIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelToUseIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'modelToUseIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'models',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'models',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'models',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'models',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'models',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'models',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'models',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'models',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'models', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'models', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'models', length, true, length, true);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> modelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'models', 0, true, 0, true);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'models', 0, false, 999999, true);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'models', 0, true, length, include);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'models', length, include, 999999, true);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  modelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameContains(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  openAiCompatibleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'openAiCompatible', value: value),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'providerInfo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'providerInfo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'providerInfo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'providerInfo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'providerInfo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'providerInfo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'providerInfo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'providerInfo',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'providerInfo', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  providerInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'providerInfo', value: ''),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  temperatureEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'temperature',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  temperatureGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'temperature',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  temperatureLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'temperature',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterFilterCondition>
  temperatureBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'temperature',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension AiProviderQueryObject
    on QueryBuilder<AiProvider, AiProvider, QFilterCondition> {}

extension AiProviderQueryLinks
    on QueryBuilder<AiProvider, AiProvider, QFilterCondition> {}

extension AiProviderQuerySortBy
    on QueryBuilder<AiProvider, AiProvider, QSortBy> {
  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByApiLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiLink', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByApiLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiLink', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByDevName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devName', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByDevNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devName', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByIconFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFileName', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByIconFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFileName', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByInUse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inUse', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByInUseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inUse', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByModelToUseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelToUseIndex', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy>
  sortByModelToUseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelToUseIndex', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByOpenAiCompatible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAiCompatible', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy>
  sortByOpenAiCompatibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAiCompatible', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByProviderInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerInfo', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByProviderInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerInfo', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }
}

extension AiProviderQuerySortThenBy
    on QueryBuilder<AiProvider, AiProvider, QSortThenBy> {
  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByApiLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiLink', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByApiLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiLink', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByDevName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devName', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByDevNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devName', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByIconFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFileName', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByIconFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFileName', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByInUse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inUse', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByInUseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inUse', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByModelToUseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelToUseIndex', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy>
  thenByModelToUseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelToUseIndex', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByOpenAiCompatible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAiCompatible', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy>
  thenByOpenAiCompatibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAiCompatible', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByProviderInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerInfo', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByProviderInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerInfo', Sort.desc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QAfterSortBy> thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }
}

extension AiProviderQueryWhereDistinct
    on QueryBuilder<AiProvider, AiProvider, QDistinct> {
  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByApiKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByApiLink({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiLink', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByDevName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'devName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByIconFileName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconFileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByInUse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inUse');
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByModelToUseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelToUseIndex');
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByModels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'models');
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByOpenAiCompatible() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openAiCompatible');
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByProviderInfo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiProvider, AiProvider, QDistinct> distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }
}

extension AiProviderQueryProperty
    on QueryBuilder<AiProvider, AiProvider, QQueryProperty> {
  QueryBuilder<AiProvider, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AiProvider, String, QQueryOperations> apiKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiKey');
    });
  }

  QueryBuilder<AiProvider, String, QQueryOperations> apiLinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiLink');
    });
  }

  QueryBuilder<AiProvider, String, QQueryOperations> devNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'devName');
    });
  }

  QueryBuilder<AiProvider, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<AiProvider, String, QQueryOperations> iconFileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconFileName');
    });
  }

  QueryBuilder<AiProvider, bool, QQueryOperations> inUseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inUse');
    });
  }

  QueryBuilder<AiProvider, int, QQueryOperations> modelToUseIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelToUseIndex');
    });
  }

  QueryBuilder<AiProvider, List<String>, QQueryOperations> modelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'models');
    });
  }

  QueryBuilder<AiProvider, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AiProvider, bool, QQueryOperations> openAiCompatibleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openAiCompatible');
    });
  }

  QueryBuilder<AiProvider, String, QQueryOperations> providerInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerInfo');
    });
  }

  QueryBuilder<AiProvider, double, QQueryOperations> temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }
}
