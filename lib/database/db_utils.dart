import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:isar/isar.dart';

class DbUtils {
  Isar isar;

  DbUtils({required this.isar});

  Future<List<Feed>> getFeeds() async {
    return await isar.feeds.where().findAll();
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
    return await isar.feedItems.filter().feedNameContains(feed.name).sortByPublishedDateDesc().findAll();
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
}
