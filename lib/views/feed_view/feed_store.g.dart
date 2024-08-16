// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FeedStore on _FeedStore, Store {
  late final _$feedsAtom = Atom(name: '_FeedStore.feeds', context: context);

  @override
  List<Feed> get feeds {
    _$feedsAtom.reportRead();
    return super.feeds;
  }

  @override
  set feeds(List<Feed> value) {
    _$feedsAtom.reportWrite(value, super.feeds, () {
      super.feeds = value;
    });
  }

  late final _$feedItemsAtom =
      Atom(name: '_FeedStore.feedItems', context: context);

  @override
  ObservableList<FeedItem> get feedItems {
    _$feedItemsAtom.reportRead();
    return super.feedItems;
  }

  @override
  set feedItems(ObservableList<FeedItem> value) {
    _$feedItemsAtom.reportWrite(value, super.feedItems, () {
      super.feedItems = value;
    });
  }

  late final _$initializedAtom =
      Atom(name: '_FeedStore.initialized', context: context);

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

  late final _$loadingAtom = Atom(name: '_FeedStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$isarAtom = Atom(name: '_FeedStore.isar', context: context);

  @override
  Isar get isar {
    _$isarAtom.reportRead();
    return super.isar;
  }

  @override
  set isar(Isar value) {
    _$isarAtom.reportWrite(value, super.isar, () {
      super.isar = value;
    });
  }

  late final _$dbUtilsAtom = Atom(name: '_FeedStore.dbUtils', context: context);

  @override
  DbUtils get dbUtils {
    _$dbUtilsAtom.reportRead();
    return super.dbUtils;
  }

  bool _dbUtilsIsInitialized = false;

  @override
  set dbUtils(DbUtils value) {
    _$dbUtilsAtom
        .reportWrite(value, _dbUtilsIsInitialized ? super.dbUtils : null, () {
      super.dbUtils = value;
      _dbUtilsIsInitialized = true;
    });
  }

  late final _$authAtom = Atom(name: '_FeedStore.auth', context: context);

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

  late final _$userAtom = Atom(name: '_FeedStore.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  bool _userIsInitialized = false;

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, _userIsInitialized ? super.user : null, () {
      super.user = value;
      _userIsInitialized = true;
    });
  }

  late final _$settingsStoreAtom =
      Atom(name: '_FeedStore.settingsStore', context: context);

  @override
  SettingsStore get settingsStore {
    _$settingsStoreAtom.reportRead();
    return super.settingsStore;
  }

  bool _settingsStoreIsInitialized = false;

  @override
  set settingsStore(SettingsStore value) {
    _$settingsStoreAtom.reportWrite(
        value, _settingsStoreIsInitialized ? super.settingsStore : null, () {
      super.settingsStore = value;
      _settingsStoreIsInitialized = true;
    });
  }

  late final _$authStoreAtom =
      Atom(name: '_FeedStore.authStore', context: context);

  @override
  AuthStore get authStore {
    _$authStoreAtom.reportRead();
    return super.authStore;
  }

  bool _authStoreIsInitialized = false;

  @override
  set authStore(AuthStore value) {
    _$authStoreAtom.reportWrite(
        value, _authStoreIsInitialized ? super.authStore : null, () {
      super.authStore = value;
      _authStoreIsInitialized = true;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_FeedStore.init', context: context);

  @override
  Future<bool> init(
      {required SettingsStore setStore, required AuthStore authStore}) {
    return _$initAsyncAction
        .run(() => super.init(setStore: setStore, authStore: authStore));
  }

  late final _$getItemsAsyncAction =
      AsyncAction('_FeedStore.getItems', context: context);

  @override
  Future<void> getItems() {
    return _$getItemsAsyncAction.run(() => super.getItems());
  }

  late final _$fetchItemsAsyncAction =
      AsyncAction('_FeedStore.fetchItems', context: context);

  @override
  Future<void> fetchItems() {
    return _$fetchItemsAsyncAction.run(() => super.fetchItems());
  }

  late final _$toggleItemReadAsyncAction =
      AsyncAction('_FeedStore.toggleItemRead', context: context);

  @override
  Future<void> toggleItemRead(int itemId, {bool toggle = false}) {
    return _$toggleItemReadAsyncAction
        .run(() => super.toggleItemRead(itemId, toggle: toggle));
  }

  late final _$toggleItemBookmarkedAsyncAction =
      AsyncAction('_FeedStore.toggleItemBookmarked', context: context);

  @override
  Future<void> toggleItemBookmarked(int itemId, {bool toggle = false}) {
    return _$toggleItemBookmarkedAsyncAction
        .run(() => super.toggleItemBookmarked(itemId, toggle: toggle));
  }

  late final _$changeSortAsyncAction =
      AsyncAction('_FeedStore.changeSort', context: context);

  @override
  Future<void> changeSort(FeedListSort sort) {
    return _$changeSortAsyncAction.run(() => super.changeSort(sort));
  }

  @override
  String toString() {
    return '''
feeds: ${feeds},
feedItems: ${feedItems},
initialized: ${initialized},
loading: ${loading},
isar: ${isar},
dbUtils: ${dbUtils},
auth: ${auth},
user: ${user},
settingsStore: ${settingsStore},
authStore: ${authStore}
    ''';
  }
}