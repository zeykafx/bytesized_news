import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/atom_item.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:rss_dart/domain/rss_item.dart';

part 'feed_store.g.dart';

class FeedStore = _FeedStore with _$FeedStore;

abstract class _FeedStore with Store {
  @observable
  List<Feed> feeds = [];

  @observable
  ObservableList<FeedItem> feedItems = <FeedItem>[].asObservable();

  @observable
  bool initialized = false;

  @observable
  bool loading = false;

  @observable
  Isar isar = Isar.getInstance()!;

  @observable
  late DbUtils dbUtils;

  // @observable
  // FeedListSort sort = FeedListSort.byDate;

  @observable
  late SettingsStore settingsStore;

  @action
  Future<bool> init({required SettingsStore setStore}) async {
    settingsStore = setStore;
    dbUtils = DbUtils(isar: isar);

    feeds = await dbUtils.getFeeds();

    if (kDebugMode) {
      print("Fetched ${feeds.length} feeds from Isar");
    }

    if (feeds.isEmpty) {
      await isar.writeTxn(
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
    // feedItems = (await dbUtils.getItems(feeds)).asObservable();

    // this doesn't change the sort but it does fetch the right items from the DB for the current sort
    await changeSort(settingsStore.sort);

    if (kDebugMode) {
      print("Fetched ${feedItems.length} feed items from Isar");
    }

    // only fetch items from the feeds if we are sorting by date, today, or unread, the rest of the sorts do not require fetching new items
    // if (settingsStore.sort == FeedListSort.byDate || settingsStore.sort == FeedListSort.today || settingsStore.sort == FeedListSort.unread) {
    await fetchItems();
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
        // items.addAll(rssFeed.items.map((RssItem item) => FeedItem.fromRssItem(item: item, feed: feed)).toList());
        for (RssItem item in rssFeed.items) {
          items.add(await FeedItem.fromRssItem(item: item, feed: feed));
        }
      } else {
        // items.addAll(atomFeed.items.map((AtomItem item) => FeedItem.fromAtomItem(item: item, feed: feed)).toList());
        for (AtomItem item in atomFeed.items) {
          items.add(await FeedItem.fromAtomItem(item: item, feed: feed));
        }
      }

      feedItems.addAll(await dbUtils.addNewItems(items));
    }

    // sort feed items by published date
    feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    loading = false;
  }

  @action
  Future<void> toggleItemRead(int itemId, {bool toggle = false}) async {
    feedItems[itemId].read = toggle ? !feedItems[itemId].read : true;

    await dbUtils.updateItemInDb(feedItems[itemId]);
  }

  @action
  Future<void> toggleItemBookmarked(int itemId, {bool toggle = false}) async {
    feedItems[itemId].bookmarked = toggle ? !feedItems[itemId].bookmarked : true;

    await dbUtils.updateItemInDb(feedItems[itemId]);
  }

  @action
  Future<void> changeSort(FeedListSort sort) async {
    settingsStore.setSort(sort);

    switch (sort) {
      case FeedListSort.byDate:
        feedItems = (await dbUtils.getItems(feeds)).asObservable();
        // feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        break;
      case FeedListSort.today:
        feedItems = (await dbUtils.getTodaysItems(feeds)).asObservable();
        // feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        // feedItems = feedItems.where((item) => item.publishedDate.day == DateTime.now().day).toList().asObservable();
        break;
      case FeedListSort.unread:
        feedItems = (await dbUtils.getUnreadItems(feeds)).asObservable();
        // feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        // feedItems = feedItems.where((item) => !item.read).toList().asObservable();
        break;
      case FeedListSort.read:
        feedItems = (await dbUtils.getReadItems(feeds)).asObservable();
        // feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        // feedItems = feedItems.where((item) => item.read).toList().asObservable();
        break;
      case FeedListSort.bookmarked:
        feedItems = (await dbUtils.getBookmarkedItems(feeds)).asObservable();
        // feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        // feedItems = feedItems.where((item) => item.bookmarked).toList().asObservable();
        break;
    }
  }

  Future<void> markAllAsRead(bool read) async {
    await dbUtils.markAllAsRead(feedItems, read);
  }
}
