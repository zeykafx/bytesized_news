// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  late final _$authAtom = Atom(name: '_AuthStore.auth', context: context);

  @override
  FirebaseAuth get auth {
    _$authAtom.reportRead();
    return super.auth;
  }

  @override
  set auth(FirebaseAuth value) {
    _$authAtom.reportWrite(value, super.auth, () {
      super.auth = value;
    });
  }

  late final _$initializedAtom =
      Atom(name: '_AuthStore.initialized', context: context);

  @override
  bool get initialized {
    _$initializedAtom.reportRead();
    return super.initialized;
  }

  @override
  set initialized(bool value) {
    _$initializedAtom.reportWrite(value, super.initialized, () {
      super.initialized = value;
    });
  }

  late final _$userAtom = Atom(name: '_AuthStore.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$userTierAtom =
      Atom(name: '_AuthStore.userTier', context: context);

  @override
  Tier get userTier {
    _$userTierAtom.reportRead();
    return super.userTier;
  }

  @override
  set userTier(Tier value) {
    _$userTierAtom.reportWrite(value, super.userTier, () {
      super.userTier = value;
    });
  }

  @override
  String toString() {
    return '''
auth: ${auth},
initialized: ${initialized},
user: ${user},
userTier: ${userTier}
    ''';
  }
}
