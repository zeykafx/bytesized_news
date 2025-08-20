import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
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
    });
  }

  @action
  Future<void> getReadingStatistics() async {
    loading = true;
    readingStreak = await dbUtils.getReadingDaysStreak();
    numberArticlesRead = await dbUtils.getNumberArticlesRead();
    totalReadingTime = await dbUtils.getReadingTime();
    longuestReadArticle = await dbUtils.getLongestReadArticle();
    final result = await dbUtils.getMostReadDay();
    mostReadDay = result.$1;
    mostReadDayCount = result.$2;

    allArticlesRead = (await dbUtils.getReadArticlesWithStats()).asObservable();
    loading = false;
  }

  @action
  void scrollToTop() {
    scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
