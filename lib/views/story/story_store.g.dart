// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StoryStore on _StoryStore, Store {
  Computed<bool>? _$hasImageInArticleComputed;

  @override
  bool get hasImageInArticle => (_$hasImageInArticleComputed ??= Computed<bool>(
          () => super.hasImageInArticle,
          name: '_StoryStore.hasImageInArticle'))
      .value;

  late final _$dbUtilsAtom =
      Atom(name: '_StoryStore.dbUtils', context: context);

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

  late final _$feedItemAtom =
      Atom(name: '_StoryStore.feedItem', context: context);

  @override
  FeedItem get feedItem {
    _$feedItemAtom.reportRead();
    return super.feedItem;
  }

  bool _feedItemIsInitialized = false;

  @override
  set feedItem(FeedItem value) {
    _$feedItemAtom
        .reportWrite(value, _feedItemIsInitialized ? super.feedItem : null, () {
      super.feedItem = value;
      _feedItemIsInitialized = true;
    });
  }

  late final _$htmlContentAtom =
      Atom(name: '_StoryStore.htmlContent', context: context);

  @override
  String get htmlContent {
    _$htmlContentAtom.reportRead();
    return super.htmlContent;
  }

  @override
  set htmlContent(String value) {
    _$htmlContentAtom.reportWrite(value, super.htmlContent, () {
      super.htmlContent = value;
    });
  }

  late final _$showReaderModeAtom =
      Atom(name: '_StoryStore.showReaderMode', context: context);

  @override
  bool get showReaderMode {
    _$showReaderModeAtom.reportRead();
    return super.showReaderMode;
  }

  bool _showReaderModeIsInitialized = false;

  @override
  set showReaderMode(bool value) {
    _$showReaderModeAtom.reportWrite(
        value, _showReaderModeIsInitialized ? super.showReaderMode : null, () {
      super.showReaderMode = value;
      _showReaderModeIsInitialized = true;
    });
  }

  late final _$isBookmarkedAtom =
      Atom(name: '_StoryStore.isBookmarked', context: context);

  @override
  bool get isBookmarked {
    _$isBookmarkedAtom.reportRead();
    return super.isBookmarked;
  }

  @override
  set isBookmarked(bool value) {
    _$isBookmarkedAtom.reportWrite(value, super.isBookmarked, () {
      super.isBookmarked = value;
    });
  }

  late final _$canGoForwardAtom =
      Atom(name: '_StoryStore.canGoForward', context: context);

  @override
  bool get canGoForward {
    _$canGoForwardAtom.reportRead();
    return super.canGoForward;
  }

  @override
  set canGoForward(bool value) {
    _$canGoForwardAtom.reportWrite(value, super.canGoForward, () {
      super.canGoForward = value;
    });
  }

  late final _$canGoBackAtom =
      Atom(name: '_StoryStore.canGoBack', context: context);

  @override
  bool get canGoBack {
    _$canGoBackAtom.reportRead();
    return super.canGoBack;
  }

  @override
  set canGoBack(bool value) {
    _$canGoBackAtom.reportWrite(value, super.canGoBack, () {
      super.canGoBack = value;
    });
  }

  late final _$progressAtom =
      Atom(name: '_StoryStore.progress', context: context);

  @override
  int get progress {
    _$progressAtom.reportRead();
    return super.progress;
  }

  @override
  set progress(int value) {
    _$progressAtom.reportWrite(value, super.progress, () {
      super.progress = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_StoryStore.loading', context: context);

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

  late final _$isLockedAtom =
      Atom(name: '_StoryStore.isLocked', context: context);

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
      Atom(name: '_StoryStore.isCollapsed', context: context);

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
      Atom(name: '_StoryStore.isExpanded', context: context);

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

  late final _$controllerAtom =
      Atom(name: '_StoryStore.controller', context: context);

  @override
  InAppWebViewController? get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(InAppWebViewController? value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  late final _$initializedAtom =
      Atom(name: '_StoryStore.initialized', context: context);

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

  late final _$adUrlFiltersAtom =
      Atom(name: '_StoryStore.adUrlFilters', context: context);

  @override
  List<String> get adUrlFilters {
    _$adUrlFiltersAtom.reportRead();
    return super.adUrlFilters;
  }

  @override
  set adUrlFilters(List<String> value) {
    _$adUrlFiltersAtom.reportWrite(value, super.adUrlFilters, () {
      super.adUrlFilters = value;
    });
  }

  late final _$contentBlockersAtom =
      Atom(name: '_StoryStore.contentBlockers', context: context);

  @override
  List<ContentBlocker> get contentBlockers {
    _$contentBlockersAtom.reportRead();
    return super.contentBlockers;
  }

  @override
  set contentBlockers(List<ContentBlocker> value) {
    _$contentBlockersAtom.reportWrite(value, super.contentBlockers, () {
      super.contentBlockers = value;
    });
  }

  late final _$settingsAtom =
      Atom(name: '_StoryStore.settings', context: context);

  @override
  InAppWebViewSettings get settings {
    _$settingsAtom.reportRead();
    return super.settings;
  }

  bool _settingsIsInitialized = false;

  @override
  set settings(InAppWebViewSettings value) {
    _$settingsAtom
        .reportWrite(value, _settingsIsInitialized ? super.settings : null, () {
      super.settings = value;
      _settingsIsInitialized = true;
    });
  }

  late final _$aiUtilsAtom =
      Atom(name: '_StoryStore.aiUtils', context: context);

  @override
  AiUtils get aiUtils {
    _$aiUtilsAtom.reportRead();
    return super.aiUtils;
  }

  bool _aiUtilsIsInitialized = false;

  @override
  set aiUtils(AiUtils value) {
    _$aiUtilsAtom
        .reportWrite(value, _aiUtilsIsInitialized ? super.aiUtils : null, () {
      super.aiUtils = value;
      _aiUtilsIsInitialized = true;
    });
  }

  late final _$feedItemSummarizedAtom =
      Atom(name: '_StoryStore.feedItemSummarized', context: context);

  @override
  bool get feedItemSummarized {
    _$feedItemSummarizedAtom.reportRead();
    return super.feedItemSummarized;
  }

  @override
  set feedItemSummarized(bool value) {
    _$feedItemSummarizedAtom.reportWrite(value, super.feedItemSummarized, () {
      super.feedItemSummarized = value;
    });
  }

  late final _$aiLoadingAtom =
      Atom(name: '_StoryStore.aiLoading', context: context);

  @override
  bool get aiLoading {
    _$aiLoadingAtom.reportRead();
    return super.aiLoading;
  }

  @override
  set aiLoading(bool value) {
    _$aiLoadingAtom.reportWrite(value, super.aiLoading, () {
      super.aiLoading = value;
    });
  }

  late final _$hideSummaryAtom =
      Atom(name: '_StoryStore.hideSummary', context: context);

  @override
  bool get hideSummary {
    _$hideSummaryAtom.reportRead();
    return super.hideSummary;
  }

  bool _hideSummaryIsInitialized = false;

  @override
  set hideSummary(bool value) {
    _$hideSummaryAtom.reportWrite(
        value, _hideSummaryIsInitialized ? super.hideSummary : null, () {
      super.hideSummary = value;
      _hideSummaryIsInitialized = true;
    });
  }

  late final _$firestoreAtom =
      Atom(name: '_StoryStore.firestore', context: context);

  @override
  FirebaseFirestore get firestore {
    _$firestoreAtom.reportRead();
    return super.firestore;
  }

  @override
  set firestore(FirebaseFirestore value) {
    _$firestoreAtom.reportWrite(value, super.firestore, () {
      super.firestore = value;
    });
  }

  late final _$htmlWidgetKeyAtom =
      Atom(name: '_StoryStore.htmlWidgetKey', context: context);

  @override
  UniqueKey get htmlWidgetKey {
    _$htmlWidgetKeyAtom.reportRead();
    return super.htmlWidgetKey;
  }

  @override
  set htmlWidgetKey(UniqueKey value) {
    _$htmlWidgetKeyAtom.reportWrite(value, super.htmlWidgetKey, () {
      super.htmlWidgetKey = value;
    });
  }

  late final _$hideBarAtom =
      Atom(name: '_StoryStore.hideBar', context: context);

  @override
  bool get hideBar {
    _$hideBarAtom.reportRead();
    return super.hideBar;
  }

  @override
  set hideBar(bool value) {
    _$hideBarAtom.reportWrite(value, super.hideBar, () {
      super.hideBar = value;
    });
  }

  late final _$webviewLastScrollYAtom =
      Atom(name: '_StoryStore.webviewLastScrollY', context: context);

  @override
  int get webviewLastScrollY {
    _$webviewLastScrollYAtom.reportRead();
    return super.webviewLastScrollY;
  }

  @override
  set webviewLastScrollY(int value) {
    _$webviewLastScrollYAtom.reportWrite(value, super.webviewLastScrollY, () {
      super.webviewLastScrollY = value;
    });
  }

  late final _$readingStatAtom =
      Atom(name: '_StoryStore.readingStat', context: context);

  @override
  ReadingStats get readingStat {
    _$readingStatAtom.reportRead();
    return super.readingStat;
  }

  @override
  set readingStat(ReadingStats value) {
    _$readingStatAtom.reportWrite(value, super.readingStat, () {
      super.readingStat = value;
    });
  }

  late final _$showArchiveButtonAtom =
      Atom(name: '_StoryStore.showArchiveButton', context: context);

  @override
  bool get showArchiveButton {
    _$showArchiveButtonAtom.reportRead();
    return super.showArchiveButton;
  }

  @override
  set showArchiveButton(bool value) {
    _$showArchiveButtonAtom.reportWrite(value, super.showArchiveButton, () {
      super.showArchiveButton = value;
    });
  }

  late final _$hasAlertAtom =
      Atom(name: '_StoryStore.hasAlert', context: context);

  @override
  bool get hasAlert {
    _$hasAlertAtom.reportRead();
    return super.hasAlert;
  }

  @override
  set hasAlert(bool value) {
    _$hasAlertAtom.reportWrite(value, super.hasAlert, () {
      super.hasAlert = value;
    });
  }

  late final _$shortAlertAtom =
      Atom(name: '_StoryStore.shortAlert', context: context);

  @override
  bool get shortAlert {
    _$shortAlertAtom.reportRead();
    return super.shortAlert;
  }

  @override
  set shortAlert(bool value) {
    _$shortAlertAtom.reportWrite(value, super.shortAlert, () {
      super.shortAlert = value;
    });
  }

  late final _$alertMessageAtom =
      Atom(name: '_StoryStore.alertMessage', context: context);

  @override
  String get alertMessage {
    _$alertMessageAtom.reportRead();
    return super.alertMessage;
  }

  @override
  set alertMessage(String value) {
    _$alertMessageAtom.reportWrite(value, super.alertMessage, () {
      super.alertMessage = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_StoryStore.init', context: context);

  @override
  Future<void> init(FeedItem item, BuildContext context, SettingsStore setStore,
      AuthStore authStore) {
    return _$initAsyncAction
        .run(() => super.init(item, context, setStore, authStore));
  }

  late final _$checkPaywallOrBotBlockAsyncAction =
      AsyncAction('_StoryStore.checkPaywallOrBotBlock', context: context);

  @override
  Future<void> checkPaywallOrBotBlock() {
    return _$checkPaywallOrBotBlockAsyncAction
        .run(() => super.checkPaywallOrBotBlock());
  }

  late final _$getArchivedArticleAsyncAction =
      AsyncAction('_StoryStore.getArchivedArticle', context: context);

  @override
  Future<bool> getArchivedArticle({bool fromError = false}) {
    return _$getArchivedArticleAsyncAction
        .run(() => super.getArchivedArticle(fromError: fromError));
  }

  late final _$compareReaderModeLengthToPageHtmlAsyncAction = AsyncAction(
      '_StoryStore.compareReaderModeLengthToPageHtml',
      context: context);

  @override
  Future<void> compareReaderModeLengthToPageHtml(BuildContext context) {
    return _$compareReaderModeLengthToPageHtmlAsyncAction
        .run(() => super.compareReaderModeLengthToPageHtml(context));
  }

  late final _$onProgressChangedAsyncAction =
      AsyncAction('_StoryStore.onProgressChanged', context: context);

  @override
  Future<void> onProgressChanged(InAppWebViewController controller, int prog) {
    return _$onProgressChangedAsyncAction
        .run(() => super.onProgressChanged(controller, prog));
  }

  late final _$onLoadStopAsyncAction =
      AsyncAction('_StoryStore.onLoadStop', context: context);

  @override
  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url) {
    return _$onLoadStopAsyncAction.run(() => super.onLoadStop(controller, url));
  }

  late final _$summarizeArticleAsyncAction =
      AsyncAction('_StoryStore.summarizeArticle', context: context);

  @override
  Future<void> summarizeArticle(BuildContext context,
      {bool longSummaryAccepted = false}) {
    return _$summarizeArticleAsyncAction.run(() => super
        .summarizeArticle(context, longSummaryAccepted: longSummaryAccepted));
  }

  late final _$evaluateSummaryAsyncAction =
      AsyncAction('_StoryStore.evaluateSummary', context: context);

  @override
  Future<void> evaluateSummary(
      String article, String summary, BuildContext context) {
    return _$evaluateSummaryAsyncAction
        .run(() => super.evaluateSummary(article, summary, context));
  }

  late final _$onLoadStartAsyncAction =
      AsyncAction('_StoryStore.onLoadStart', context: context);

  @override
  Future<void> onLoadStart(InAppWebViewController controller, WebUri? url) {
    return _$onLoadStartAsyncAction
        .run(() => super.onLoadStart(controller, url));
  }

  late final _$_StoryStoreActionController =
      ActionController(name: '_StoryStore', context: context);

  @override
  void webviewInit() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.webviewInit');
    try {
      return super.webviewInit();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo =
        _$_StoryStoreActionController.startAction(name: '_StoryStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getSettingsStoreValues() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.getSettingsStoreValues');
    try {
      return super.getSettingsStoreValues();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Map<String, String>? buildStyle(BuildContext context, dom.Element element) {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.buildStyle');
    try {
      return super.buildStyle(context, element);
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleReaderMode() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.toggleReaderMode');
    try {
      return super.toggleReaderMode();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hideAiSummary() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.hideAiSummary');
    try {
      return super.hideAiSummary();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void bookmarkItem() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.bookmarkItem');
    try {
      return super.bookmarkItem();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showImage(String imageUrl, BuildContext context) {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.showImage');
    try {
      return super.showImage(imageUrl, context);
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool notificationListener(ScrollNotification notification) {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.notificationListener');
    try {
      return super.notificationListener(notification);
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void webviewScrollListener(InAppWebViewController controller, int x, int y) {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.webviewScrollListener');
    try {
      return super.webviewScrollListener(controller, x, y);
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void endReading() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.endReading');
    try {
      return super.endReading();
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void shareArticle(BuildContext context) {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.shareArticle');
    try {
      return super.shareArticle(context);
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchInArticle(BuildContext context) {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.searchInArticle');
    try {
      return super.searchInArticle(context);
    } finally {
      _$_StoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dbUtils: ${dbUtils},
feedItem: ${feedItem},
htmlContent: ${htmlContent},
showReaderMode: ${showReaderMode},
isBookmarked: ${isBookmarked},
canGoForward: ${canGoForward},
canGoBack: ${canGoBack},
progress: ${progress},
loading: ${loading},
isLocked: ${isLocked},
isCollapsed: ${isCollapsed},
isExpanded: ${isExpanded},
controller: ${controller},
initialized: ${initialized},
adUrlFilters: ${adUrlFilters},
contentBlockers: ${contentBlockers},
settings: ${settings},
aiUtils: ${aiUtils},
feedItemSummarized: ${feedItemSummarized},
aiLoading: ${aiLoading},
hideSummary: ${hideSummary},
firestore: ${firestore},
htmlWidgetKey: ${htmlWidgetKey},
hideBar: ${hideBar},
webviewLastScrollY: ${webviewLastScrollY},
readingStat: ${readingStat},
showArchiveButton: ${showArchiveButton},
hasAlert: ${hasAlert},
shortAlert: ${shortAlert},
alertMessage: ${alertMessage},
hasImageInArticle: ${hasImageInArticle}
    ''';
  }
}
