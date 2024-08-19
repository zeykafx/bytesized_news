import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/atom_item.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:rss_dart/domain/rss_item.dart';

import '../auth/auth_store.dart';

part 'feed_store.g.dart';

class FeedStore = _FeedStore with _$FeedStore;

abstract class _FeedStore with Store {
  @observable
  List<Feed> feeds = [];

  @observable
  ObservableList<dynamic> pinnedFeedsOrFeedGroups = <dynamic>[].asObservable(); // Feed or FeedGroup

  @observable
  ObservableList<FeedGroup> feedGroups = <FeedGroup>[].asObservable();

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

  @observable
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  late User? user;

  @observable
  late SettingsStore settingsStore;

  @observable
  late AuthStore authStore;

  @observable
  bool isLocked = false;

  @observable
  bool isCollapsed = false;

  @observable
  bool isExpanded = false;

  @observable
  BottomSheetBarController bsbController = BottomSheetBarController();

  @action
  Future<bool> init({required SettingsStore setStore, required AuthStore authStore}) async {
    settingsStore = setStore;
    this.authStore = authStore;

    dbUtils = DbUtils(isar: isar);

    bsbController.addListener(onBsbChanged);

    feeds = await dbUtils.getFeeds();
    if (kDebugMode) {
      print("Fetched ${feeds.length} feeds from Isar");
    }

    // if (feeds.isEmpty) {
    //   await isar.writeTxn(
    //     () => isar.feeds.putAll([
    //       Feed("The Verge", "http://www.theverge.com/rss/frontpage"),
    //       Feed("Vox", "https://www.vox.com/rss/index.xml"),
    //     ]),
    //   );
    //
    //   feeds = await dbUtils.getFeeds();
    // }

    feedGroups = (await dbUtils.getFeedGroups(feeds)).asObservable();
    if (kDebugMode) {
      print("Fetched ${feedGroups.length} feedGroups from Isar");
    }

    await getPinnedFeedsOrFeedGroups();

    user = auth.currentUser;

    initialized = true;
    return true;
  }

  @action
  Future<void> getFeeds() async {
    feeds = await dbUtils.getFeeds();
  }

  @action
  Future<void> getFeedGroups() async {
    feedGroups = (await dbUtils.getFeedGroups(feeds)).asObservable();
  }

  @action
  Future<void> getPinnedFeedsOrFeedGroups() async {
    await getFeeds();
    await getFeedGroups();
    pinnedFeedsOrFeedGroups = [].asObservable();
    for (Feed feed in feeds) {
      if (feed.isPinned) {
        pinnedFeedsOrFeedGroups.add(feed);
      }
    }

    for (FeedGroup feedGroup in feedGroups) {
      if (feedGroup.isPinned) {
        pinnedFeedsOrFeedGroups.add(feedGroup);
      }
    }

    // sort based on pinnedPosition
    pinnedFeedsOrFeedGroups.sort((a, b) => a.pinnedPosition.compareTo(b.pinnedPosition));
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
    for (Feed feed in feeds) {
      if (settingsStore.sortFeed != null && feed.name != settingsStore.sortFeed!.name) {
        continue;
      }

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
        for (RssItem item in rssFeed.items.take(20)) {
          items.add(await FeedItem.fromRssItem(item: item, feed: feed, userTier: authStore.userTier));
        }
      } else {
        // items.addAll(atomFeed.items.map((AtomItem item) => FeedItem.fromAtomItem(item: item, feed: feed)).toList());
        for (AtomItem item in atomFeed.items.take(20)) {
          items.add(await FeedItem.fromAtomItem(item: item, feed: feed, userTier: authStore.userTier));
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

    if (kDebugMode) {
      print("Changing sort to $sort");
    }
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
      case FeedListSort.feed:
        if (settingsStore.sortFeed == null) {
          throw Exception("sortFeed cannot be null when changing sort to FeedListSort.Feed.");
        }
        feedItems = (await dbUtils.getItemsFromFeed(settingsStore.sortFeed!)).asObservable();
      case FeedListSort.feedGroup:
        if (settingsStore.sortFeedGroup == null) {
          throw Exception("sortFeedGroup cannot be null when changing sort to FeedListSort.FeedGroup.");
        }
        feedItems = (await dbUtils.getItemsFromFeedGroup(settingsStore.sortFeedGroup!)).asObservable();
    }
  }

  Future<void> markAllAsRead(bool read, {List<FeedItem>? unreadItems}) async {
    if (unreadItems != null) {
      await dbUtils.markAllAsRead(unreadItems, read);
    } else {
      await dbUtils.markAllAsRead(feedItems, read);
    }
  }

  @action
  void onBsbChanged() {
    if (bsbController.isCollapsed && !isCollapsed) {
      isCollapsed = true;
      isExpanded = false;
    } else if (bsbController.isExpanded && !isExpanded) {
      isCollapsed = false;
      isExpanded = true;
    }
  }

  @action
  Future<void> createFeedGroup(String feedGroupName, BuildContext context) async {
    FeedGroup feedGroup = FeedGroup(feedGroupName);
    try {
      await dbUtils.addFeedGroup(feedGroup);
      feedGroups.add(feedGroup);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully created Feed Group!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create Feed Group: error: ${e.toString()}"),
      ));
    }
  }
}
