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

  late final _$functionsAtom =
      Atom(name: '_AuthStore.functions', context: context);

  @override
  FirebaseFunctions get functions {
    _$functionsAtom.reportRead();
    return super.functions;
  }

  @override
  set functions(FirebaseFunctions value) {
    _$functionsAtom.reportWrite(value, super.functions, () {
      super.functions = value;
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

  late final _$hasUserRefundedAtom =
      Atom(name: '_AuthStore.hasUserRefunded', context: context);

  @override
  bool get hasUserRefunded {
    _$hasUserRefundedAtom.reportRead();
    return super.hasUserRefunded;
  }

  @override
  set hasUserRefunded(bool value) {
    _$hasUserRefundedAtom.reportWrite(value, super.hasUserRefunded, () {
      super.hasUserRefunded = value;
    });
  }

  late final _$userInterestsAtom =
      Atom(name: '_AuthStore.userInterests', context: context);

  @override
  List<String> get userInterests {
    _$userInterestsAtom.reportRead();
    return super.userInterests;
  }

  @override
  set userInterests(List<String> value) {
    _$userInterestsAtom.reportWrite(value, super.userInterests, () {
      super.userInterests = value;
    });
  }

  late final _$builtUserProfileDateAtom =
      Atom(name: '_AuthStore.builtUserProfileDate', context: context);

  @override
  DateTime? get builtUserProfileDate {
    _$builtUserProfileDateAtom.reportRead();
    return super.builtUserProfileDate;
  }

  @override
  set builtUserProfileDate(DateTime? value) {
    _$builtUserProfileDateAtom.reportWrite(value, super.builtUserProfileDate,
        () {
      super.builtUserProfileDate = value;
    });
  }

  late final _$suggestionsLeftTodayAtom =
      Atom(name: '_AuthStore.suggestionsLeftToday', context: context);

  @override
  int get suggestionsLeftToday {
    _$suggestionsLeftTodayAtom.reportRead();
    return super.suggestionsLeftToday;
  }

  @override
  set suggestionsLeftToday(int value) {
    _$suggestionsLeftTodayAtom.reportWrite(value, super.suggestionsLeftToday,
        () {
      super.suggestionsLeftToday = value;
    });
  }

  late final _$lastSuggestionDateAtom =
      Atom(name: '_AuthStore.lastSuggestionDate', context: context);

  @override
  DateTime? get lastSuggestionDate {
    _$lastSuggestionDateAtom.reportRead();
    return super.lastSuggestionDate;
  }

  @override
  set lastSuggestionDate(DateTime? value) {
    _$lastSuggestionDateAtom.reportWrite(value, super.lastSuggestionDate, () {
      super.lastSuggestionDate = value;
    });
  }

  late final _$summariesLeftTodayAtom =
      Atom(name: '_AuthStore.summariesLeftToday', context: context);

  @override
  int get summariesLeftToday {
    _$summariesLeftTodayAtom.reportRead();
    return super.summariesLeftToday;
  }

  @override
  set summariesLeftToday(int value) {
    _$summariesLeftTodayAtom.reportWrite(value, super.summariesLeftToday, () {
      super.summariesLeftToday = value;
    });
  }

  late final _$lastSummaryDateAtom =
      Atom(name: '_AuthStore.lastSummaryDate', context: context);

  @override
  DateTime? get lastSummaryDate {
    _$lastSummaryDateAtom.reportRead();
    return super.lastSummaryDate;
  }

  @override
  set lastSummaryDate(DateTime? value) {
    _$lastSummaryDateAtom.reportWrite(value, super.lastSummaryDate, () {
      super.lastSummaryDate = value;
    });
  }

  late final _$deviceIdAtom =
      Atom(name: '_AuthStore.deviceId', context: context);

  @override
  String? get deviceId {
    _$deviceIdAtom.reportRead();
    return super.deviceId;
  }

  @override
  set deviceId(String? value) {
    _$deviceIdAtom.reportWrite(value, super.deviceId, () {
      super.deviceId = value;
    });
  }

  late final _$_getIdAsyncAction =
      AsyncAction('_AuthStore._getId', context: context);

  @override
  Future<String?> _getId() {
    return _$_getIdAsyncAction.run(() => super._getId());
  }

  late final _$_AuthStoreActionController =
      ActionController(name: '_AuthStore', context: context);

  @override
  bool _shouldUpdateLocalFeed(Feed localFeed, Feed firestoreFeed) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore._shouldUpdateLocalFeed');
    try {
      return super._shouldUpdateLocalFeed(localFeed, firestoreFeed);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool _shouldUpdateLocalFeedGroup(
      FeedGroup localFeedGroup, FeedGroup firestoreFeedGroup) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore._shouldUpdateLocalFeedGroup');
    try {
      return super
          ._shouldUpdateLocalFeedGroup(localFeedGroup, firestoreFeedGroup);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool _listsEqual(List<String> list1, List<String> list2) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore._listsEqual');
    try {
      return super._listsEqual(list1, list2);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
auth: ${auth},
functions: ${functions},
initialized: ${initialized},
user: ${user},
userTier: ${userTier},
hasUserRefunded: ${hasUserRefunded},
userInterests: ${userInterests},
builtUserProfileDate: ${builtUserProfileDate},
suggestionsLeftToday: ${suggestionsLeftToday},
lastSuggestionDate: ${lastSuggestionDate},
summariesLeftToday: ${summariesLeftToday},
lastSummaryDate: ${lastSummaryDate},
deviceId: ${deviceId}
    ''';
  }
}
