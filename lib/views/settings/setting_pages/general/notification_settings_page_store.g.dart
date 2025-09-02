// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationsPageStore on _NotificationsPageStore, Store {
  late final _$loadingAtom = Atom(
    name: '_NotificationsPageStore.loading',
    context: context,
  );

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

  late final _$feedsAtom = Atom(
    name: '_NotificationsPageStore.feeds',
    context: context,
  );

  @override
  ObservableList<Feed> get feeds {
    _$feedsAtom.reportRead();
    return super.feeds;
  }

  @override
  set feeds(ObservableList<Feed> value) {
    _$feedsAtom.reportWrite(value, super.feeds, () {
      super.feeds = value;
    });
  }

  late final _$dbUtilsAtom = Atom(
    name: '_NotificationsPageStore.dbUtils',
    context: context,
  );

  @override
  DbUtils get dbUtils {
    _$dbUtilsAtom.reportRead();
    return super.dbUtils;
  }

  bool _dbUtilsIsInitialized = false;

  @override
  set dbUtils(DbUtils value) {
    _$dbUtilsAtom.reportWrite(
      value,
      _dbUtilsIsInitialized ? super.dbUtils : null,
      () {
        super.dbUtils = value;
        _dbUtilsIsInitialized = true;
      },
    );
  }

  late final _$authStoreAtom = Atom(
    name: '_NotificationsPageStore.authStore',
    context: context,
  );

  @override
  AuthStore get authStore {
    _$authStoreAtom.reportRead();
    return super.authStore;
  }

  bool _authStoreIsInitialized = false;

  @override
  set authStore(AuthStore value) {
    _$authStoreAtom.reportWrite(
      value,
      _authStoreIsInitialized ? super.authStore : null,
      () {
        super.authStore = value;
        _authStoreIsInitialized = true;
      },
    );
  }

  late final _$feedSyncAtom = Atom(
    name: '_NotificationsPageStore.feedSync',
    context: context,
  );

  @override
  FeedSync get feedSync {
    _$feedSyncAtom.reportRead();
    return super.feedSync;
  }

  bool _feedSyncIsInitialized = false;

  @override
  set feedSync(FeedSync value) {
    _$feedSyncAtom.reportWrite(
      value,
      _feedSyncIsInitialized ? super.feedSync : null,
      () {
        super.feedSync = value;
        _feedSyncIsInitialized = true;
      },
    );
  }

  late final _$loadFeedsAsyncAction = AsyncAction(
    '_NotificationsPageStore.loadFeeds',
    context: context,
  );

  @override
  Future<void> loadFeeds() {
    return _$loadFeedsAsyncAction.run(() => super.loadFeeds());
  }

  late final _$_NotificationsPageStoreActionController = ActionController(
    name: '_NotificationsPageStore',
    context: context,
  );

  @override
  void init(AuthStore aStore) {
    final _$actionInfo = _$_NotificationsPageStoreActionController.startAction(
      name: '_NotificationsPageStore.init',
    );
    try {
      return super.init(aStore);
    } finally {
      _$_NotificationsPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
feeds: ${feeds},
dbUtils: ${dbUtils},
authStore: ${authStore},
feedSync: ${feedSync}
    ''';
  }
}
