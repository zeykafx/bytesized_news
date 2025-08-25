// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curated_feeds_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CuratedFeedsStore on _CuratedFeedsStore, Store {
  late final _$curatedCategoriesAtom = Atom(
    name: '_CuratedFeedsStore.curatedCategories',
    context: context,
  );

  @override
  List<CuratedFeedCategory> get curatedCategories {
    _$curatedCategoriesAtom.reportRead();
    return super.curatedCategories;
  }

  @override
  set curatedCategories(List<CuratedFeedCategory> value) {
    _$curatedCategoriesAtom.reportWrite(value, super.curatedCategories, () {
      super.curatedCategories = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: '_CuratedFeedsStore.loading',
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

  late final _$selectedFeedsAtom = Atom(
    name: '_CuratedFeedsStore.selectedFeeds',
    context: context,
  );

  @override
  ObservableSet<CuratedFeed> get selectedFeeds {
    _$selectedFeedsAtom.reportRead();
    return super.selectedFeeds;
  }

  @override
  set selectedFeeds(ObservableSet<CuratedFeed> value) {
    _$selectedFeedsAtom.reportWrite(value, super.selectedFeeds, () {
      super.selectedFeeds = value;
    });
  }

  late final _$selectedCategoriesAtom = Atom(
    name: '_CuratedFeedsStore.selectedCategories',
    context: context,
  );

  @override
  ObservableSet<CuratedFeedCategory> get selectedCategories {
    _$selectedCategoriesAtom.reportRead();
    return super.selectedCategories;
  }

  @override
  set selectedCategories(ObservableSet<CuratedFeedCategory> value) {
    _$selectedCategoriesAtom.reportWrite(value, super.selectedCategories, () {
      super.selectedCategories = value;
    });
  }

  late final _$isarAtom = Atom(
    name: '_CuratedFeedsStore.isar',
    context: context,
  );

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

  late final _$dbUtilsAtom = Atom(
    name: '_CuratedFeedsStore.dbUtils',
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

  late final _$feedSyncAtom = Atom(
    name: '_CuratedFeedsStore.feedSync',
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

  late final _$followedFeedsAtom = Atom(
    name: '_CuratedFeedsStore.followedFeeds',
    context: context,
  );

  @override
  ObservableList<Feed> get followedFeeds {
    _$followedFeedsAtom.reportRead();
    return super.followedFeeds;
  }

  @override
  set followedFeeds(ObservableList<Feed> value) {
    _$followedFeedsAtom.reportWrite(value, super.followedFeeds, () {
      super.followedFeeds = value;
    });
  }

  late final _$followedFeedGroupAtom = Atom(
    name: '_CuratedFeedsStore.followedFeedGroup',
    context: context,
  );

  @override
  ObservableList<FeedGroup> get followedFeedGroup {
    _$followedFeedGroupAtom.reportRead();
    return super.followedFeedGroup;
  }

  @override
  set followedFeedGroup(ObservableList<FeedGroup> value) {
    _$followedFeedGroupAtom.reportWrite(value, super.followedFeedGroup, () {
      super.followedFeedGroup = value;
    });
  }

  late final _$readCuratedFeedsAsyncAction = AsyncAction(
    '_CuratedFeedsStore.readCuratedFeeds',
    context: context,
  );

  @override
  Future<void> readCuratedFeeds(BuildContext context, AuthStore authStore) {
    return _$readCuratedFeedsAsyncAction.run(
      () => super.readCuratedFeeds(context, authStore),
    );
  }

  late final _$_CuratedFeedsStoreActionController = ActionController(
    name: '_CuratedFeedsStore',
    context: context,
  );

  @override
  bool isFeedAlreadyFollowed(CuratedFeed feed) {
    final _$actionInfo = _$_CuratedFeedsStoreActionController.startAction(
      name: '_CuratedFeedsStore.isFeedAlreadyFollowed',
    );
    try {
      return super.isFeedAlreadyFollowed(feed);
    } finally {
      _$_CuratedFeedsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isCategoryAlreadyFollowed(CuratedFeedCategory cat) {
    final _$actionInfo = _$_CuratedFeedsStoreActionController.startAction(
      name: '_CuratedFeedsStore.isCategoryAlreadyFollowed',
    );
    try {
      return super.isCategoryAlreadyFollowed(cat);
    } finally {
      _$_CuratedFeedsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleFeedSelection(CuratedFeed feed, CuratedFeedCategory category) {
    final _$actionInfo = _$_CuratedFeedsStoreActionController.startAction(
      name: '_CuratedFeedsStore.toggleFeedSelection',
    );
    try {
      return super.toggleFeedSelection(feed, category);
    } finally {
      _$_CuratedFeedsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleCategorySelection(CuratedFeedCategory category) {
    final _$actionInfo = _$_CuratedFeedsStoreActionController.startAction(
      name: '_CuratedFeedsStore.toggleCategorySelection',
    );
    try {
      return super.toggleCategorySelection(category);
    } finally {
      _$_CuratedFeedsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelections() {
    final _$actionInfo = _$_CuratedFeedsStoreActionController.startAction(
      name: '_CuratedFeedsStore.clearSelections',
    );
    try {
      return super.clearSelections();
    } finally {
      _$_CuratedFeedsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
curatedCategories: ${curatedCategories},
loading: ${loading},
selectedFeeds: ${selectedFeeds},
selectedCategories: ${selectedCategories},
isar: ${isar},
dbUtils: ${dbUtils},
feedSync: ${feedSync},
followedFeeds: ${followedFeeds},
followedFeedGroup: ${followedFeedGroup}
    ''';
  }
}
