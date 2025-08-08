import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class DbUtils {
  Isar isar;

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

  Future<List<FeedItem>> getItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.where().sortByPublishedDateDesc().findAll();

    // find the corresponding feeds for each feed item
    for (FeedItem item in feedItems) {
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
    return feedItems;
  }

  Future<List<FeedItem>> getSuggestedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().suggestedEqualTo(true).sortByPublishedDateDesc().findAll();

    // find the corresponding feeds for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getTodaysItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems
        .filter()
        .publishedDateBetween(DateTime.now().subtract(const Duration(days: 1)), DateTime.now())
        .sortByPublishedDateDesc()
        .findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getUnreadItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().readEqualTo(false).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
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
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getReadItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().readEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getDownloadedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().downloadedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getBookmarkedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().bookmarkedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getSummarizedItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().summarizedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getItemsFromFeed(Feed feed) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().feedIdEqualTo(feed.id).sortByPublishedDateDesc().findAll();
    // set the feed for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feed;
    }
    return feedItems;
  }

  Future<List<FeedItem>> getItemsFromFeedGroup(FeedGroup feedGroup) async {
    List<FeedItem> feedItems = [];
    for (Feed feed in feedGroup.feeds) {
      feedItems.addAll(await isar.feedItems.filter().feedIdEqualTo(feed.id).sortByPublishedDateDesc().findAll());
    }

    // set the feed for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feedGroup.feeds.firstWhere((feed) => feed.id == item.feedId);
    }

    feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    return feedItems;
  }

  // Return all the feeditems that contain the search result in their title
  Future<List<FeedItem>> getSearchItems(List<Feed> feeds, String searchTerm) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().titleContains(searchTerm, caseSensitive: false).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.id == item.feedId);
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
        item.feeds.add(feeds.firstWhere((feed) => feed.link == feedUrl));
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
}
