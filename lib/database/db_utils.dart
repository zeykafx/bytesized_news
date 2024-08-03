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
    List<FeedItem> feedItems = [];
    feedItems = await isar.feedItems.where().sortByPublishedDateDesc().findAll();

    // find the corresponding feeds for each feed item
    for (FeedItem item in feedItems) {
      item.feed = feeds.firstWhere((feed) => feed.name == item.feedName);
    }
    return feedItems;
  }

  Future<List<FeedItem>> getUnreadItems() async {
    return await isar.feedItems.filter().readEqualTo(false).sortByPublishedDateDesc().findAll();
  }

  Future<List<FeedItem>> getReadItems() async {
    return await isar.feedItems.filter().readEqualTo(true).sortByPublishedDateDesc().findAll();
  }

  Future<List<FeedItem>> getBookmarkedItems() async {
    return await isar.feedItems.filter().bookmarkedEqualTo(true).sortByPublishedDateDesc().findAll();
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
    for (FeedItem item in items) {
      List<FeedItem> dbItems = await isar.feedItems.where().filter().urlEqualTo(item.url).findAll();
      if (dbItems.isEmpty) {
        isar.writeTxn(() => isar.feedItems.put(item));
        // also add those items to the feedItems list
        feedItems.add(item);
      }
    }
    return feedItems;
  }
}
