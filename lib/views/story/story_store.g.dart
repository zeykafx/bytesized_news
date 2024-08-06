// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StoryStore on _StoryStore, Store {
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

  late final _$bsbControllerAtom =
      Atom(name: '_StoryStore.bsbController', context: context);

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

  late final _$controllerAtom =
      Atom(name: '_StoryStore.controller', context: context);

  @override
  WebViewController get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(WebViewController value) {
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

  late final _$_StoryStoreActionController =
      ActionController(name: '_StoryStore', context: context);

  @override
  void onBsbChanged() {
    final _$actionInfo = _$_StoryStoreActionController.startAction(
        name: '_StoryStore.onBsbChanged');
    try {
      return super.onBsbChanged();
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
  String toString() {
    return '''
dbUtils: ${dbUtils},
feedItem: ${feedItem},
isBookmarked: ${isBookmarked},
canGoForward: ${canGoForward},
canGoBack: ${canGoBack},
progress: ${progress},
loading: ${loading},
isLocked: ${isLocked},
isCollapsed: ${isCollapsed},
isExpanded: ${isExpanded},
bsbController: ${bsbController},
controller: ${controller},
initialized: ${initialized}
    ''';
  }
}