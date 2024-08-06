import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/atom_item.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:rss_dart/domain/rss_item.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  @observable
  List<Feed> feeds = [];

  @observable
  List<FeedItem> feedItems = [];

  @observable
  bool initialized = false;

  @observable
  bool loading = false;

  @observable
  Isar isar = Isar.getInstance()!;

  @observable
  late DbUtils dbUtils;

  @action
  Future<bool> init() async {
    dbUtils = DbUtils(isar: isar);
    feeds = await dbUtils.getFeeds();

    if (kDebugMode) {
      print("Fetched ${feeds.length} feeds from Isar");
    }

    if (feeds.isEmpty) {
      isar.writeTxn(
        () => isar.feeds.putAll([
          Feed("The Verge", "http://www.theverge.com/rss/frontpage", "The Verge is a technology news site"),
        ]),
      );

      feeds = await dbUtils.getFeeds();
    }
    return true;
  }

  @action
  Future<void> getItems() async {
    // get all feed items from Isar, sorted by published date
    feedItems = await dbUtils.getItems(feeds);
    if (kDebugMode) {
      print("Fetched ${feedItems.length} feed items from Isar");
    }

    // if (feedItems.isEmpty || feedItems.first.timeFetched.difference(DateTime.now()).inMinutes > 15) {
    fetchItems();
    // }
  }

  @action
  Future<void> fetchItems() async {
    Dio dio = Dio();

    loading = true;
    // String url = "http://www.theverge.com/rss/frontpage";
    for (Feed feed in feeds) {
      if (kDebugMode) {
        print("Fetching feed items for ${feed.name}");
      }
      List<FeedItem> items = [];
      Response res = await dio.get(feed.link);

      bool usingRssFeed = true;

      late RssFeed rssFeed;
      late AtomFeed atomFeed;
      try {
        rssFeed = RssFeed.parse(res.data);
      } catch (e) {
        atomFeed = AtomFeed.parse(res.data);
        usingRssFeed = false;
        if (kDebugMode) {
          print("Using Atom feed");
        }
      }

      if (usingRssFeed) {
        items.addAll(rssFeed.items.map((RssItem item) => FeedItem.fromRssItem(item: item, feed: feed)).toList());
      } else {
        items.addAll(atomFeed.items.map((AtomItem item) => FeedItem.fromAtomItem(item: item, feed: feed)).toList());
      }

      feedItems.addAll(await dbUtils.addNewItems(items));
    }

    // sort feed items by published date
    feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    loading = false;
  }

  Future<void> toggleItemRead(int itemId, {bool toggle = false}) async {
    feedItems[itemId].read = toggle ? !feedItems[itemId].read : true;

    await dbUtils.updateItemInDb(feedItems[itemId]);
  }
}
