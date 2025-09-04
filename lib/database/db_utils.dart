import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbUtils {
  Isar isar;
  FlutterSecureStorage storage = FlutterSecureStorage();

  DbUtils({required this.isar});

  Future<List<Feed>> getFeeds() async {
    return await isar.feeds.where().findAll();
  }

  Feed? getFeedWithId(int id) {
    return isar.feeds.where().idEqualTo(id).findFirstSync();
  }

  Future<Feed?> findMatchingFeed(Feed otherFeed) async {
    return await isar.feeds.where().idEqualTo(otherFeed.id).findFirst();
  }

  Future<List<Feed>> getFeedsSortedByInterest() async {
    return await isar.feeds.filter().articlesReadGreaterThan(0).sortByArticlesRead().findAll();
  }

  Future<void> addFeed(Feed feed) async {
    await isar.writeTxn(() => isar.feeds.put(feed));
  }

  Future<void> deleteFeed(Feed feed) async {
    await isar.writeTxn(() => isar.feeds.delete(feed.id));
    // also delete all feed items associated with this feed
    await deleteFeedItems(feed);
  }

  Future<void> deleteFeeds(List<Feed> feeds) async {
    // delete all feed items associated with these feeds
    for (Feed feed in feeds) {
      await deleteFeedItems(feed);
    }
    await isar.writeTxn(() => isar.feeds.deleteAll(feeds.map((elem) => elem.id).toList()));
  }

  Future<void> deleteFeedItems(Feed feed) async {
    await isar.writeTxn(() => isar.feedItems.where().filter().feedIdEqualTo(feed.id).deleteAll());
  }

  Future<void> setFeedItemFeed(FeedItem item, List<Feed> feeds) async {
    if (feeds.any((feed) => feed.id == item.feedId)) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    } else {
      if (kDebugMode) {
        print("unknow feed id ${item.feedId}");
        // delete the item if the feed is not found
        await isar.writeTxn(() => isar.feedItems.delete(item.id));
      }
    }
  }

  Future<List<FeedItem>> getItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.where().sortByPublishedDateDesc().limit(1000).findAll();

    // find the corresponding feeds for each feed item
    for (FeedItem item in feedItems) {
      // if (feeds.any((feed) => feed.id == item.feedId)) {
      //   item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      // } else {
      //   if (kDebugMode) {
      //     print("unknow feed id ${item.feedId}");
      //     // delete the item if the feed is not found
      //     await isar.writeTxn(() => isar.feedItems.delete(item.id));
      //   }
      // }
      setFeedItemFeed(item, feeds);
    }

    return feedItems;
  }

  Future<FeedItem?> getFeedItemWithID(int feedItemId, List<Feed> feeds) async {
    FeedItem? item = await isar.feedItems.filter().idEqualTo(feedItemId).sortByPublishedDateDesc().findFirst();
    if (item == null) {
      return null;
    }
    setFeedItemFeed(item, feeds);
    return item;
  }

  Future<List<FeedItem>> getSuggestedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().suggestedEqualTo(true).sortByPublishedDateDesc().findAll();

    // find the corresponding feeds for each feed item
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<void> resetSuggestedArticles() async {
    List<FeedItem> suggested = await isar.feedItems.filter().suggestedEqualTo(true).sortByPublishedDateDesc().findAll();
    await isar.writeTxn(() async {
      for (FeedItem item in suggested) {
        item.suggested = false;
      }
    });
  }

  Future<List<FeedItem>> getTodaysItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems
        .filter()
        .publishedDateBetween(DateTime.now().subtract(const Duration(days: 1)), DateTime.now())
        .sortByPublishedDateDesc()
        .findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getUnreadItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().readEqualTo(false).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getTodaysUnreadItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems
        .filter()
        .readEqualTo(false)
        .publishedDateBetween(DateTime.now().subtract(const Duration(days: 1)), DateTime.now())
        .sortByPublishedDateDesc()
        .findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getReadItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().readEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getDownloadedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().downloadedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getBookmarkedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().bookmarkedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getSummarizedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().summarizedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getItemsFromFeed(Feed feed, List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().feedIdEqualTo(feed.id).sortByPublishedDateDesc().findAll();
    // set the feed for each feed item
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));

    return feedItems;
  }

  Future<List<FeedItem>> getItemsFromFeedGroup(FeedGroup feedGroup, List<Feed> feeds) async {
    List<FeedItem> feedItems = [];
    for (Feed feed in feedGroup.feeds) {
      feedItems.addAll(await getItemsFromFeed(feed, feeds));
    }

    // // set the feed for each feed item
    // for (FeedItem item in feedItems) {
    //   item.feed = feedGroup.feeds.firstWhere((feed) => feed.id == item.feedId);
    // }
    feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));

    return feedItems;
  }

  // Return all the feeditems that contain the search result in their title
  Future<List<FeedItem>> getSearchItems(List<Feed> feeds, String searchTerm) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().titleContains(searchTerm, caseSensitive: false).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      // item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
      setFeedItemFeed(item, feeds);
    }
    return feedItems;
  }

  Future<void> updateItemInDb(FeedItem item) async {
    await isar.writeTxn(() => isar.feedItems.put(item));
  }

  Future<List<FeedItem>> addNewItems(List<FeedItem> items) async {
    List<FeedItem> feedItems = [];

    // only add items that are not already in the database
    await isar.writeTxn(() async {
      for (FeedItem item in items) {
        List<FeedItem> dbItems = await isar.feedItems.where().filter().urlEqualTo(item.url).findAll();
        if (dbItems.isEmpty) {
          // isar.writeTxn(() => isar.feedItems.put(item));
          isar.feedItems.put(item);
          // also add those items to the feedItems list
          feedItems.add(item);
        }
      }
    });

    return feedItems;
  }

  Future<void> markAllAsRead(List<FeedItem> feedItems, bool read) async {
    List<FeedItem> unreadItems;

    if (read) {
      unreadItems = feedItems.where((item) => !item.read).toList();
    } else {
      unreadItems = feedItems.where((item) => item.read).toList();
    }

    for (FeedItem item in unreadItems) {
      item.read = read;
    }
    await isar.writeTxn(() => isar.feedItems.putAll(feedItems));
  }

  Future<List<FeedGroup>> getFeedGroups(List<Feed> feeds) async {
    List<FeedGroup> feedGroups = await isar.feedGroups.where().findAll();

    // find the corresponding feeds for each feed item
    for (FeedGroup item in feedGroups) {
      for (String feedUrl in item.feedUrls) {
        if (feeds.any((Feed fd) => fd.link == feedUrl)) {
          item.feeds.add(feeds.firstWhere((feed) => feed.link == feedUrl));
        } else {
          // no feeds exist, remove from feed group
          continue;
        }
      }
    }

    return feedGroups;
  }

  // can be used as update too
  Future<void> addFeedGroup(FeedGroup feedGroup) async {
    await isar.writeTxn(() => isar.feedGroups.put(feedGroup));
  }

  Future<void> deleteFeedGroup(FeedGroup feedGroup) async {
    await isar.writeTxn(() => isar.feedGroups.delete(feedGroup.id));
  }

  Future<void> deleteFeedGroups(List<FeedGroup> feedGroups) async {
    await isar.writeTxn(() => isar.feedGroups.deleteAll(feedGroups.map((elem) => elem.id).toList()));
  }

  Future<void> addFeedsToFeedGroup(FeedGroup feedGroup) async {
    await isar.writeTxn(() => isar.feedGroups.put(feedGroup));
  }

  // read logs stuff
  Future<void> addReading(StoryReading reading) async {
    await isar.writeTxn(() => isar.storyReadings.put(reading));
  }

  Future<StoryReading?> getReadingWithStoryId(int feedItemId) async {
    StoryReading? reading = await isar.storyReadings.filter().feedItemIdEqualTo(feedItemId).findFirst();
    return reading;
  }

  Future<void> updateReading(StoryReading reading) async {
    await addReading(reading);
  }

  Future<void> deleteReading(StoryReading reading) async {
    await isar.writeTxn(() => isar.storyReadings.delete(reading.id));
  }

  Future<FeedItem?> getArticleForReading(StoryReading reading, List<Feed> feeds) async {
    FeedItem? feedItem = await getFeedItemWithID(reading.feedItemId, feeds);
    if (feedItem == null) {
      return null;
    }

    return feedItem;
  }

  Future<void> getReadArticlesWithStats(Function(StoryReading, FeedItem) addToAllArticles, {bool sortByReadingDuration = false}) async {
    // List<(StoryReading, FeedItem)> articles = [];

    List<Feed> feeds = await getFeeds();

    // get the readings sorted on the reading date or the reading duration (depending on the bool argument)
    List<StoryReading> readings = sortByReadingDuration
        ? await isar.storyReadings.where().sortByReadingDurationDesc().findAll()
        : await isar.storyReadings.where().sortByFirstReadDesc().findAll();

    for (StoryReading reading in readings) {
      FeedItem? feedItem = await getArticleForReading(reading, feeds);
      if (feedItem == null) {
        continue;
      }

      // articles.add((reading, feedItem));
      addToAllArticles(reading, feedItem);
    }
    // return articles;
  }

  Future<List<(StoryReading, FeedItem)>> getReadArticlesWithStatsPaginated({
    bool sortByReadingDuration = false,
    int offset = 0,
    int limit = 20,
  }) async {
    List<(StoryReading, FeedItem)> articles = [];
    List<Feed> feeds = await getFeeds();

    List<StoryReading> readings = sortByReadingDuration
        ? await isar.storyReadings.where().sortByReadingDurationDesc().offset(offset).limit(limit).findAll()
        : await isar.storyReadings.where().sortByFirstReadDesc().offset(offset).limit(limit).findAll();

    for (StoryReading reading in readings) {
      FeedItem? feedItem = await getArticleForReading(reading, feeds);
      if (feedItem == null) {
        continue;
      }
      articles.add((reading, feedItem));
    }
    return articles;
  }

  Future<int> getReadingDaysStreak() async {
    List<StoryReading> items = await isar.storyReadings.where().findAll();

    if (items.isEmpty) {
      return 0;
    }

    // get the unique days normalized to the start of the day
    Set<DateTime> uniqueDates = {};
    for (StoryReading reading in items) {
      DateTime normalized = DateTime(reading.firstRead.year, reading.firstRead.month, reading.firstRead.day);
      uniqueDates.add(normalized);
    }

    List<DateTime> sorted = uniqueDates.toList()..sort((a, b) => b.compareTo(a));

    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    bool hasReadTodayOrYesterday =
        sorted.isNotEmpty && (sorted[0].isAtSameMomentAs(today) || sorted[0].isAtSameMomentAs(today.subtract(const Duration(days: 1))));

    // streak broken
    if (!hasReadTodayOrYesterday) {
      return 0;
    }

    int streak = 1;
    DateTime currentDate = sorted[0];

    for (int i = 1; i < sorted.length; i++) {
      DateTime expectedPrevDay = currentDate.subtract(const Duration(days: 1));

      // if the date matches expected, increase streak
      if (sorted[i].isAtSameMomentAs(expectedPrevDay)) {
        streak++;
        currentDate = sorted[i];
      }
      // date is before expected, streak broken
      else if (sorted[i].isBefore(expectedPrevDay)) {
        break;
      } else if (sorted[i].isAtSameMomentAs(currentDate)) {
        continue;
      } else {
        // gap?
        break;
      }
    }

    return streak;
  }

  Future<int> getNumberArticlesRead() async {
    return await isar.storyReadings.filter().readingDurationGreaterThan(0).count();
  }

  Future<(DateTime, int)> getMostReadDay() async {
    List<StoryReading> readings = await isar.storyReadings.filter().readingDurationGreaterThan(0).findAll();
    List<DateTime> days = readings.map((reading) => reading.firstRead).toList();

    Map<DateTime, int> dayCounts = {};
    for (DateTime day in days) {
      DateTime normalizedDay = DateTime(day.year, day.month, day.day);
      dayCounts[normalizedDay] = (dayCounts[normalizedDay] ?? 0) + 1;
    }

    // get the most represented day in the list of days
    DateTime mostReadDay = DateTime.now();
    int maxCount = 0;
    for (MapEntry<DateTime, int> entry in dayCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostReadDay = entry.key;
      }
    }

    return (mostReadDay, maxCount);
  }

  Future<Duration> getReadingTime() async {
    Duration totalReadingTime = Duration();
    List<StoryReading> items = await isar.storyReadings.filter().readingDurationGreaterThan(0).findAll();

    for (StoryReading reading in items) {
      totalReadingTime += Duration(seconds: reading.readingDuration);
    }
    return totalReadingTime;
  }

  Future<(FeedItem?, StoryReading?)> getLongestReadArticle() async {
    List<StoryReading> topReadings = await isar.storyReadings.filter().readingDurationGreaterThan(0).sortByReadingDurationDesc().findAll();
    // we get the top readings because we might have readings for deleted articles
    List<Feed> feeds = await getFeeds();

    for (StoryReading reading in topReadings) {
      FeedItem? feedItem = await getArticleForReading(reading, feeds);
      // the first feedItem that we find that isn't null is then going to be the most read article (still in the db)
      if (feedItem != null) {
        return (feedItem, reading);
      }
    }

    return (null, null);
  }

  // AI Provider methods
  Future<List<AiProvider>> getAiProviders() async {
    return await isar.aiProviders.where().findAll();
  }

  Future<void> addAiProvider(AiProvider provider) async {
    await isar.writeTxn(() => isar.aiProviders.put(provider));
  }

  Future<void> updateAiProvider(AiProvider provider) async {
    await addAiProvider(provider); // adding a provider that already exists updates the existing one
  }

  Future<void> deleteAllAiProviders() async {
    await isar.writeTxn(() => isar.aiProviders.clear());
  }

  Future<void> deleteAiProvider(AiProvider provider) async {
    await isar.writeTxn(() => isar.aiProviders.delete(provider.id));
  }

  Future<void> seedDefaultAiProvidersIfEmpty() async {
    final existingProviders = await getAiProviders();

    // check if we need to adopt the new configs for each provider
    for (AiProvider provider in existingProviders) {
      for (AiProvider defaultProv in defaultProviders) {
        if (provider.hasConfigChanged(defaultProv)) {
          print("Provider ${provider.devName}'s config has changed, adopting new one");
          provider.adoptNewConfig(defaultProv);
          await updateAiProvider(provider);
        }
      }
    }

    if (existingProviders.isEmpty) {
      // no providers exist, seed with defaults
      await isar.writeTxn(() async {
        for (final provider in defaultProviders) {
          await isar.aiProviders.put(provider);
        }
      });
    }
  }

  Future<AiProvider?> getActiveAiProvider() async {
    AiProvider? aiProvider = await isar.aiProviders.filter().inUseEqualTo(true).findFirst();
    // if (aiProvider != null) {
    //   aiProvider.apiKey = await storage.read(key: "apiKey") ?? "";
    // }
    return aiProvider;
  }

  Future<AiProvider> setActiveAiProvider(AiProvider provider, List<AiProvider> allProviders) async {
    // set all other providers to inactive
    await isar.writeTxn(() async {
      for (final p in allProviders) {
        p.inUse = false;
        await isar.aiProviders.put(p);
      }

      // Then set the selected provider as active
      provider.inUse = true;
      await isar.aiProviders.put(provider);
    });
    return provider;
  }

  // ---- migration
  Future<void> performMigrationIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final latestVersion = 4;
    final currentVersion = prefs.getInt('version') ?? latestVersion;
    if (currentVersion < latestVersion) {
      await migrate();
    }
    // Update version
    await prefs.setInt('version', latestVersion);
  }

  Future<void> migrate() async {
    print("Migrating database");
    final feedCount = await isar.feeds.count();

    // We paginate through the feeds to avoid loading all users into memory at once
    for (var i = 0; i < feedCount; i += 50) {
      final feeds = await isar.feeds.where().offset(i).limit(50).findAll();
      await isar.writeTxn(() async {
        await isar.feeds.putAll(feeds);
      });
    }

    final feedGroupCount = await isar.feedGroups.count();
    for (var i = 0; i < feedGroupCount; i += 50) {
      final feedGroups = await isar.feedGroups.where().offset(i).limit(50).findAll();
      await isar.writeTxn(() async {
        await isar.feedGroups.putAll(feedGroups);
      });
    }

    final feedItemsCount = await isar.feedItems.count();
    for (var i = 0; i < feedItemsCount; i += 50) {
      final feedItems = await isar.feedItems.where().offset(i).limit(50).findAll();
      await isar.writeTxn(() async {
        await isar.feedItems.putAll(feedItems);
      });
    }
  }

  Future<int> numberOfItemsDownloaded() async {
    return await isar.feedItems.where().filter().downloadedEqualTo(true).count();
  }

  // delete download items
  Future<int> deleteDownloadedItems() async {
    List<FeedItem> itemsToDelete = await isar.feedItems.where().filter().downloadedEqualTo(true).findAll();

    // delete all of the images from the cache
    for (FeedItem item in itemsToDelete) {
      dom.Document contentElement = html_parser.parse(item.htmlContent ?? "");
      List<dom.Element> images = contentElement.getElementsByTagName("img")
        ..addAll(contentElement.getElementsByTagName("image"))
        ..addAll(contentElement.getElementsByTagName("picture"));
      for (dom.Element el in images) {
        String imgSrc = "";
        if (el.attributes case {'src': final String src}) {
          imgSrc = src;
        }

        if (imgSrc.isEmpty) {
          continue;
        }

        try {
          await DefaultCacheManager().removeFile(imgSrc);
        } catch (_) {}
      }
    }

    await isar.writeTxn(() async {
      for (FeedItem feedItem in itemsToDelete) {
        feedItem.htmlContent = "";
        feedItem.downloaded = false;
        await isar.feedItems.put(feedItem);
      }
    });

    int numberDeleted = itemsToDelete.length;
    if (kDebugMode) {
      print("Deleted $numberDeleted downloaded articles!");
    }

    return numberDeleted;
  }
}
