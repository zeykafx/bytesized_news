import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed_item/feed_item.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'reading_statistics_store.g.dart';

class ReadingStatisticsStore = _ReadingStatisticsStore with _$ReadingStatisticsStore;

abstract class _ReadingStatisticsStore with Store {
  @observable
  late SettingsStore settingsStore;
  @observable
  late DbUtils dbUtils;

  @observable
  int readingStreak = 0;

  @observable
  Duration totalReadingTime = Duration(hours: 0);

  @observable
  int numberArticlesRead = 0;

  @observable
  bool loading = false;

  @observable
  String currentSort = "by_date";

  @observable
  (FeedItem?, StoryReading?) longuestReadArticle = (null, null);

  @observable
  DateTime mostReadDay = DateTime.now();

  @observable
  int mostReadDayCount = 0;

  @observable
  ObservableList<(StoryReading, FeedItem)> allArticlesRead = <(StoryReading, FeedItem)>[].asObservable();

  @observable
  bool showScrollToTop = false;

  @observable
  ScrollController scrollController = ScrollController();

  @observable
  int page = 0;

  @observable
  bool isLoadingMore = false;

  @observable
  bool hasMore = true;

  final int pageSize = 20;

  @action
  void init(DbUtils dbUtils, SettingsStore settingsStore) {
    this.dbUtils = dbUtils;
    this.settingsStore = settingsStore;
    getReadingStatistics();

    scrollController.addListener(() {
      if (scrollController.offset > 400 && !showScrollToTop) {
        showScrollToTop = true;
      } else if (scrollController.offset < 400 && showScrollToTop) {
        showScrollToTop = false;
      }

      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchMoreReadings();
      }
    });
  }

  @action
  Future<void> getReadingStatistics() async {
    loading = true;
    page = 0;
    hasMore = true;
    allArticlesRead.clear();

    readingStreak = await dbUtils.getReadingDaysStreak();
    numberArticlesRead = await dbUtils.getNumberArticlesRead();
    totalReadingTime = await dbUtils.getReadingTime();
    longuestReadArticle = await dbUtils.getLongestReadArticle();
    final result = await dbUtils.getMostReadDay();
    mostReadDay = result.$1;
    mostReadDayCount = result.$2;

    final articles = await dbUtils.getReadArticlesWithStatsPaginated(
      sortByReadingDuration: (currentSort == "by_duration"),
      offset: page * pageSize,
      limit: pageSize,
    );
    allArticlesRead.addAll(articles);
    page++;

    loading = false;
  }

  @action
  Future<void> fetchMoreReadings() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;

    final articles = await dbUtils.getReadArticlesWithStatsPaginated(
      sortByReadingDuration: (currentSort == "by_duration"),
      offset: page * pageSize,
      limit: pageSize,
    );

    if (articles.length < pageSize) {
      hasMore = false;
    }

    allArticlesRead.addAll(articles);
    page++;
    isLoadingMore = false;
  }

  @action
  void scrollToTop() {
    scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @action
  Future<void> sortButtonOnChanged(String? item) async {
    currentSort = item ?? "by_date";
    await getReadingStatistics();
  }

  @action
  Future<void> deleteReading(StoryReading reading) async {
    final index = allArticlesRead.indexWhere((element) => element.$1.id == reading.id);
    if (index != -1) {
      final removedArticle = allArticlesRead.removeAt(index);
      await dbUtils.deleteReading(reading);
      numberArticlesRead--;
      totalReadingTime -= Duration(seconds: removedArticle.$1.readingDuration);
    }
  }

  @action
  Future<void> updateReading(StoryReading reading) async {
    final index = allArticlesRead.indexWhere((element) => element.$1.id == reading.id);
    if (index != -1) {
      final feedItem = allArticlesRead[index].$2;
      final updatedReading = await dbUtils.getReadingWithStoryId(feedItem.id);
      if (updatedReading != null) {
        final oldDuration = allArticlesRead[index].$1.readingDuration;
        allArticlesRead[index] = (updatedReading, feedItem);
        totalReadingTime += Duration(seconds: updatedReading.readingDuration) - Duration(seconds: oldDuration);
      }
    }
  }
}
