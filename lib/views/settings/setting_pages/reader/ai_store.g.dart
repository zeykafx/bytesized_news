// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AiStore on _AiStore, Store {
  late final _$storageAtom = Atom(name: '_AiStore.storage', context: context);

  @override
  FlutterSecureStorage get storage {
    _$storageAtom.reportRead();
    return super.storage;
  }

  @override
  set storage(FlutterSecureStorage value) {
    _$storageAtom.reportWrite(value, super.storage, () {
      super.storage = value;
    });
  }

  late final _$apiKeyAtom = Atom(name: '_AiStore.apiKey', context: context);

  @override
  String get apiKey {
    _$apiKeyAtom.reportRead();
    return super.apiKey;
  }

  @override
  set apiKey(String value) {
    _$apiKeyAtom.reportWrite(value, super.apiKey, () {
      super.apiKey = value;
    });
  }

  late final _$hasApiKeyAtom = Atom(
    name: '_AiStore.hasApiKey',
    context: context,
  );

  @override
  bool get hasApiKey {
    _$hasApiKeyAtom.reportRead();
    return super.hasApiKey;
  }

  @override
  set hasApiKey(bool value) {
    _$hasApiKeyAtom.reportWrite(value, super.hasApiKey, () {
      super.hasApiKey = value;
    });
  }

  @override
  String toString() {
    return '''
storage: ${storage},
apiKey: ${apiKey},
hasApiKey: ${hasApiKey}
    ''';
  }
}
