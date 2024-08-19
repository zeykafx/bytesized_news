import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:isar/isar.dart';

class DbUtils {
  Isar isar;

  DbUtils({required this.isar});

  Future<List<Feed>> getFeeds() async {
    return await isar.feeds.where().findAll();
  }

  Future<void> addFeed(Feed feed) async {
    await isar.writeTxn(() => isar.feeds.put(feed));
  }

  Future<void> deleteFeed(Feed feed) async {
    await isar.writeTxn(() => isar.feeds.delete(feed.id));
  }

  Future<void> deleteFeeds(List<Feed> feeds) async {
    await isar.writeTxn(() => isar.feeds.deleteAll(feeds.map((elem) => elem.id).toList()));
  }

  Future<void> deleteFeedItems(Feed feed) async {
    await isar.writeTxn(() => isar.feedItems.where().filter().feedNameEqualTo(feed.name).deleteAll());
  }

  Future<List<FeedItem>> getItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.where().sortByPublishedDateDesc().findAll();

    // find the corresponding feeds for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.name == item.feedName);
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
      item.feed = feeds.firstWhere((feed) => feed.name == item.feedName);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getUnreadItems(List<Feed> feeds) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().readEqualTo(false).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.name == item.feedName);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getReadItems(List<Feed> feeds) async {
    // return await isar.feedItems.filter().readEqualTo(true).sortByPublishedDateDesc().findAll();
    List<FeedItem> feedItems = await isar.feedItems.filter().readEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.name == item.feedName);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getBookmarkedItems(List<Feed> feeds) async {
    // return await isar.feedItems.filter().bookmarkedEqualTo(true).sortByPublishedDateDesc().findAll();
    List<FeedItem> feedItems = await isar.feedItems.filter().bookmarkedEqualTo(true).sortByPublishedDateDesc().findAll();
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.name == item.feedName);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getItemsFromFeed(Feed feed) async {
    List<FeedItem> feedItems = await isar.feedItems.filter().feedNameContains(feed.name).sortByPublishedDateDesc().findAll();
    // set the feed for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feed;
    }
    return feedItems;
  }

  Future<List<FeedItem>> getItemsFromFeedGroup(FeedGroup feedGroup) async {
    List<FeedItem> feedItems = [];
    for (Feed feed in feedGroup.feeds) {
      feedItems.addAll(await isar.feedItems.filter().feedNameContains(feed.name).sortByPublishedDateDesc().findAll());
    }

    // set the feed for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feedGroup.feeds.firstWhere((feed) => feed.name == item.feedName);
    }

    feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
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
      for (String feedName in item.feedNames) {
        item.feeds.add(feeds.firstWhere((feed) => feed.name == feedName));
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
}
