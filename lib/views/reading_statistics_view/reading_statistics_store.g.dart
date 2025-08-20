// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_statistics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReadingStatisticsStore on _ReadingStatisticsStore, Store {
  late final _$settingsStoreAtom =
      Atom(name: '_ReadingStatisticsStore.settingsStore', context: context);

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

  late final _$dbUtilsAtom =
      Atom(name: '_ReadingStatisticsStore.dbUtils', context: context);

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

  late final _$readingStreakAtom =
      Atom(name: '_ReadingStatisticsStore.readingStreak', context: context);

  @override
  int get readingStreak {
    _$readingStreakAtom.reportRead();
    return super.readingStreak;
  }

  @override
  set readingStreak(int value) {
    _$readingStreakAtom.reportWrite(value, super.readingStreak, () {
      super.readingStreak = value;
    });
  }

  late final _$totalReadingTimeAtom =
      Atom(name: '_ReadingStatisticsStore.totalReadingTime', context: context);

  @override
  Duration get totalReadingTime {
    _$totalReadingTimeAtom.reportRead();
    return super.totalReadingTime;
  }

  @override
  set totalReadingTime(Duration value) {
    _$totalReadingTimeAtom.reportWrite(value, super.totalReadingTime, () {
      super.totalReadingTime = value;
    });
  }

  late final _$numberArticlesReadAtom = Atom(
      name: '_ReadingStatisticsStore.numberArticlesRead', context: context);

  @override
  int get numberArticlesRead {
    _$numberArticlesReadAtom.reportRead();
    return super.numberArticlesRead;
  }

  @override
  set numberArticlesRead(int value) {
    _$numberArticlesReadAtom.reportWrite(value, super.numberArticlesRead, () {
      super.numberArticlesRead = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_ReadingStatisticsStore.loading', context: context);

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

  late final _$currentSortAtom =
      Atom(name: '_ReadingStatisticsStore.currentSort', context: context);

  @override
  String get currentSort {
    _$currentSortAtom.reportRead();
    return super.currentSort;
  }

  @override
  set currentSort(String value) {
    _$currentSortAtom.reportWrite(value, super.currentSort, () {
      super.currentSort = value;
    });
  }

  late final _$longuestReadArticleAtom = Atom(
      name: '_ReadingStatisticsStore.longuestReadArticle', context: context);

  @override
  (FeedItem?, StoryReading?) get longuestReadArticle {
    _$longuestReadArticleAtom.reportRead();
    return super.longuestReadArticle;
  }

  @override
  set longuestReadArticle((FeedItem?, StoryReading?) value) {
    _$longuestReadArticleAtom.reportWrite(value, super.longuestReadArticle, () {
      super.longuestReadArticle = value;
    });
  }

  late final _$mostReadDayAtom =
      Atom(name: '_ReadingStatisticsStore.mostReadDay', context: context);

  @override
  DateTime get mostReadDay {
    _$mostReadDayAtom.reportRead();
    return super.mostReadDay;
  }

  @override
  set mostReadDay(DateTime value) {
    _$mostReadDayAtom.reportWrite(value, super.mostReadDay, () {
      super.mostReadDay = value;
    });
  }

  late final _$mostReadDayCountAtom =
      Atom(name: '_ReadingStatisticsStore.mostReadDayCount', context: context);

  @override
  int get mostReadDayCount {
    _$mostReadDayCountAtom.reportRead();
    return super.mostReadDayCount;
  }

  @override
  set mostReadDayCount(int value) {
    _$mostReadDayCountAtom.reportWrite(value, super.mostReadDayCount, () {
      super.mostReadDayCount = value;
    });
  }

  late final _$allArticlesReadAtom =
      Atom(name: '_ReadingStatisticsStore.allArticlesRead', context: context);

  @override
  ObservableList<(StoryReading, FeedItem)> get allArticlesRead {
    _$allArticlesReadAtom.reportRead();
    return super.allArticlesRead;
  }

  @override
  set allArticlesRead(ObservableList<(StoryReading, FeedItem)> value) {
    _$allArticlesReadAtom.reportWrite(value, super.allArticlesRead, () {
      super.allArticlesRead = value;
    });
  }

  late final _$showScrollToTopAtom =
      Atom(name: '_ReadingStatisticsStore.showScrollToTop', context: context);

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

  late final _$scrollControllerAtom =
      Atom(name: '_ReadingStatisticsStore.scrollController', context: context);

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

  late final _$getReadingStatisticsAsyncAction = AsyncAction(
      '_ReadingStatisticsStore.getReadingStatistics',
      context: context);

  @override
  Future<void> getReadingStatistics() {
    return _$getReadingStatisticsAsyncAction
        .run(() => super.getReadingStatistics());
  }

  late final _$sortButtonOnChangedAsyncAction = AsyncAction(
      '_ReadingStatisticsStore.sortButtonOnChanged',
      context: context);

  @override
  Future<void> sortButtonOnChanged(String? item) {
    return _$sortButtonOnChangedAsyncAction
        .run(() => super.sortButtonOnChanged(item));
  }

  late final _$_ReadingStatisticsStoreActionController =
      ActionController(name: '_ReadingStatisticsStore', context: context);

  @override
  void init(DbUtils dbUtils, SettingsStore settingsStore) {
    final _$actionInfo = _$_ReadingStatisticsStoreActionController.startAction(
        name: '_ReadingStatisticsStore.init');
    try {
      return super.init(dbUtils, settingsStore);
    } finally {
      _$_ReadingStatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void scrollToTop() {
    final _$actionInfo = _$_ReadingStatisticsStoreActionController.startAction(
        name: '_ReadingStatisticsStore.scrollToTop');
    try {
      return super.scrollToTop();
    } finally {
      _$_ReadingStatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
settingsStore: ${settingsStore},
dbUtils: ${dbUtils},
readingStreak: ${readingStreak},
totalReadingTime: ${totalReadingTime},
numberArticlesRead: ${numberArticlesRead},
loading: ${loading},
currentSort: ${currentSort},
longuestReadArticle: ${longuestReadArticle},
mostReadDay: ${mostReadDay},
mostReadDayCount: ${mostReadDayCount},
allArticlesRead: ${allArticlesRead},
showScrollToTop: ${showScrollToTop},
scrollController: ${scrollController}
    ''';
  }
}
