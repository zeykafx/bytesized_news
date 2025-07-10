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

  late final _$pinnedFeedsOrFeedGroupsAtom =
      Atom(name: '_FeedStore.pinnedFeedsOrFeedGroups', context: context);

  @override
  ObservableList<dynamic> get pinnedFeedsOrFeedGroups {
    _$pinnedFeedsOrFeedGroupsAtom.reportRead();
    return super.pinnedFeedsOrFeedGroups;
  }

  @override
  set pinnedFeedsOrFeedGroups(ObservableList<dynamic> value) {
    _$pinnedFeedsOrFeedGroupsAtom
        .reportWrite(value, super.pinnedFeedsOrFeedGroups, () {
      super.pinnedFeedsOrFeedGroups = value;
    });
  }

  late final _$feedGroupsAtom =
      Atom(name: '_FeedStore.feedGroups', context: context);

  @override
  ObservableList<FeedGroup> get feedGroups {
    _$feedGroupsAtom.reportRead();
    return super.feedGroups;
  }

  @override
  set feedGroups(ObservableList<FeedGroup> value) {
    _$feedGroupsAtom.reportWrite(value, super.feedGroups, () {
      super.feedGroups = value;
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

  late final _$searchResultsAtom =
      Atom(name: '_FeedStore.searchResults', context: context);

  @override
  ObservableList<FeedItem> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableList<FeedItem> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$suggestedFeedItemsAtom =
      Atom(name: '_FeedStore.suggestedFeedItems', context: context);

  @override
  ObservableList<FeedItem> get suggestedFeedItems {
    _$suggestedFeedItemsAtom.reportRead();
    return super.suggestedFeedItems;
  }

  @override
  set suggestedFeedItems(ObservableList<FeedItem> value) {
    _$suggestedFeedItemsAtom.reportWrite(value, super.suggestedFeedItems, () {
      super.suggestedFeedItems = value;
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

  late final _$suggestionsLoadingAtom =
      Atom(name: '_FeedStore.suggestionsLoading', context: context);

  @override
  bool get suggestionsLoading {
    _$suggestionsLoadingAtom.reportRead();
    return super.suggestionsLoading;
  }

  @override
  set suggestionsLoading(bool value) {
    _$suggestionsLoadingAtom.reportWrite(value, super.suggestionsLoading, () {
      super.suggestionsLoading = value;
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

  late final _$aiUtilsAtom = Atom(name: '_FeedStore.aiUtils', context: context);

  @override
  AiUtils get aiUtils {
    _$aiUtilsAtom.reportRead();
    return super.aiUtils;
  }

  @override
  set aiUtils(AiUtils value) {
    _$aiUtilsAtom.reportWrite(value, super.aiUtils, () {
      super.aiUtils = value;
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

  late final _$isLockedAtom =
      Atom(name: '_FeedStore.isLocked', context: context);

  @override
  bool get isLocked {
    _$isLockedAtom.reportRead();
    return super.isLocked;
  }

  @override
  set isLocked(bool value) {
    _$isLockedAtom.reportWrite(value, super.isLocked, () {
      super.isLocked = value;
    });
  }

  late final _$isCollapsedAtom =
      Atom(name: '_FeedStore.isCollapsed', context: context);

  @override
  bool get isCollapsed {
    _$isCollapsedAtom.reportRead();
    return super.isCollapsed;
  }

  @override
  set isCollapsed(bool value) {
    _$isCollapsedAtom.reportWrite(value, super.isCollapsed, () {
      super.isCollapsed = value;
    });
  }

  late final _$isExpandedAtom =
      Atom(name: '_FeedStore.isExpanded', context: context);

  @override
  bool get isExpanded {
    _$isExpandedAtom.reportRead();
    return super.isExpanded;
  }

  @override
  set isExpanded(bool value) {
    _$isExpandedAtom.reportWrite(value, super.isExpanded, () {
      super.isExpanded = value;
    });
  }

  late final _$bsbControllerAtom =
      Atom(name: '_FeedStore.bsbController', context: context);

  @override
  BottomSheetBarController get bsbController {
    _$bsbControllerAtom.reportRead();
    return super.bsbController;
  }

  @override
  set bsbController(BottomSheetBarController value) {
    _$bsbControllerAtom.reportWrite(value, super.bsbController, () {
      super.bsbController = value;
    });
  }

  late final _$bsbHeightAtom =
      Atom(name: '_FeedStore.bsbHeight', context: context);

  @override
  double get bsbHeight {
    _$bsbHeightAtom.reportRead();
    return super.bsbHeight;
  }

  @override
  set bsbHeight(double value) {
    _$bsbHeightAtom.reportWrite(value, super.bsbHeight, () {
      super.bsbHeight = value;
    });
  }

  late final _$scrollControllerAtom =
      Atom(name: '_FeedStore.scrollController', context: context);

  @override
  ScrollController get scrollController {
    _$scrollControllerAtom.reportRead();
    return super.scrollController;
  }

  @override
  set scrollController(ScrollController value) {
    _$scrollControllerAtom.reportWrite(value, super.scrollController, () {
      super.scrollController = value;
    });
  }

  late final _$suggestionsScrollControllerAtom =
      Atom(name: '_FeedStore.suggestionsScrollController', context: context);

  @override
  ScrollController get suggestionsScrollController {
    _$suggestionsScrollControllerAtom.reportRead();
    return super.suggestionsScrollController;
  }

  @override
  set suggestionsScrollController(ScrollController value) {
    _$suggestionsScrollControllerAtom
        .reportWrite(value, super.suggestionsScrollController, () {
      super.suggestionsScrollController = value;
    });
  }

  late final _$showScrollToTopAtom =
      Atom(name: '_FeedStore.showScrollToTop', context: context);

  @override
  bool get showScrollToTop {
    _$showScrollToTopAtom.reportRead();
    return super.showScrollToTop;
  }

  @override
  set showScrollToTop(bool value) {
    _$showScrollToTopAtom.reportWrite(value, super.showScrollToTop, () {
      super.showScrollToTop = value;
    });
  }

  late final _$hasCreatedNewSuggestionAtom =
      Atom(name: '_FeedStore.hasCreatedNewSuggestion', context: context);

  @override
  bool get hasCreatedNewSuggestion {
    _$hasCreatedNewSuggestionAtom.reportRead();
    return super.hasCreatedNewSuggestion;
  }

  @override
  set hasCreatedNewSuggestion(bool value) {
    _$hasCreatedNewSuggestionAtom
        .reportWrite(value, super.hasCreatedNewSuggestion, () {
      super.hasCreatedNewSuggestion = value;
    });
  }

  late final _$hasCleanedArticlesTodayAtom =
      Atom(name: '_FeedStore.hasCleanedArticlesToday', context: context);

  @override
  bool get hasCleanedArticlesToday {
    _$hasCleanedArticlesTodayAtom.reportRead();
    return super.hasCleanedArticlesToday;
  }

  @override
  set hasCleanedArticlesToday(bool value) {
    _$hasCleanedArticlesTodayAtom
        .reportWrite(value, super.hasCleanedArticlesToday, () {
      super.hasCleanedArticlesToday = value;
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

  late final _$getFeedsAsyncAction =
      AsyncAction('_FeedStore.getFeeds', context: context);

  @override
  Future<void> getFeeds() {
    return _$getFeedsAsyncAction.run(() => super.getFeeds());
  }

  late final _$getFeedGroupsAsyncAction =
      AsyncAction('_FeedStore.getFeedGroups', context: context);

  @override
  Future<void> getFeedGroups() {
    return _$getFeedGroupsAsyncAction.run(() => super.getFeedGroups());
  }

  late final _$getPinnedFeedsOrFeedGroupsAsyncAction =
      AsyncAction('_FeedStore.getPinnedFeedsOrFeedGroups', context: context);

  @override
  Future<void> getPinnedFeedsOrFeedGroups() {
    return _$getPinnedFeedsOrFeedGroupsAsyncAction
        .run(() => super.getPinnedFeedsOrFeedGroups());
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
  Future<void> toggleItemRead(FeedItem item, {bool toggle = false}) {
    return _$toggleItemReadAsyncAction
        .run(() => super.toggleItemRead(item, toggle: toggle));
  }

  late final _$toggleItemBookmarkedAsyncAction =
      AsyncAction('_FeedStore.toggleItemBookmarked', context: context);

  @override
  Future<void> toggleItemBookmarked(FeedItem item, {bool toggle = false}) {
    return _$toggleItemBookmarkedAsyncAction
        .run(() => super.toggleItemBookmarked(item, toggle: toggle));
  }

  late final _$changeSortAsyncAction =
      AsyncAction('_FeedStore.changeSort', context: context);

  @override
  Future<void> changeSort(FeedListSort sort) {
    return _$changeSortAsyncAction.run(() => super.changeSort(sort));
  }

  late final _$createFeedGroupAsyncAction =
      AsyncAction('_FeedStore.createFeedGroup', context: context);

  @override
  Future<void> createFeedGroup(String feedGroupName, BuildContext context) {
    return _$createFeedGroupAsyncAction
        .run(() => super.createFeedGroup(feedGroupName, context));
  }

  late final _$searchFeedItemsAsyncAction =
      AsyncAction('_FeedStore.searchFeedItems', context: context);

  @override
  Future<void> searchFeedItems(String searchTerm) {
    return _$searchFeedItemsAsyncAction
        .run(() => super.searchFeedItems(searchTerm));
  }

  late final _$buildUserTasteProfileAsyncAction =
      AsyncAction('_FeedStore.buildUserTasteProfile', context: context);

  @override
  Future<void> buildUserTasteProfile() {
    return _$buildUserTasteProfileAsyncAction
        .run(() => super.buildUserTasteProfile());
  }

  late final _$createNewsSuggestionAsyncAction =
      AsyncAction('_FeedStore.createNewsSuggestion', context: context);

  @override
  Future<void> createNewsSuggestion() {
    return _$createNewsSuggestionAsyncAction
        .run(() => super.createNewsSuggestion());
  }

  late final _$_FeedStoreActionController =
      ActionController(name: '_FeedStore', context: context);

  @override
  void onBsbChanged() {
    final _$actionInfo = _$_FeedStoreActionController.startAction(
        name: '_FeedStore.onBsbChanged');
    try {
      return super.onBsbChanged();
    } finally {
      _$_FeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void scrollToTop() {
    final _$actionInfo = _$_FeedStoreActionController.startAction(
        name: '_FeedStore.scrollToTop');
    try {
      return super.scrollToTop();
    } finally {
      _$_FeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feeds: ${feeds},
pinnedFeedsOrFeedGroups: ${pinnedFeedsOrFeedGroups},
feedGroups: ${feedGroups},
feedItems: ${feedItems},
searchResults: ${searchResults},
suggestedFeedItems: ${suggestedFeedItems},
initialized: ${initialized},
loading: ${loading},
suggestionsLoading: ${suggestionsLoading},
isar: ${isar},
dbUtils: ${dbUtils},
aiUtils: ${aiUtils},
auth: ${auth},
user: ${user},
settingsStore: ${settingsStore},
authStore: ${authStore},
isLocked: ${isLocked},
isCollapsed: ${isCollapsed},
isExpanded: ${isExpanded},
bsbController: ${bsbController},
bsbHeight: ${bsbHeight},
scrollController: ${scrollController},
suggestionsScrollController: ${suggestionsScrollController},
showScrollToTop: ${showScrollToTop},
hasCreatedNewSuggestion: ${hasCreatedNewSuggestion},
hasCleanedArticlesToday: ${hasCleanedArticlesToday}
    ''';
  }
}
