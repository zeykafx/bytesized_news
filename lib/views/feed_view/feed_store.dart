import 'dart:isolate';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/AI/ai_util.dart';
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
  ObservableList<dynamic> pinnedFeedsOrFeedGroups =
      <dynamic>[].asObservable(); // Feed or FeedGroup

  @observable
  ObservableList<FeedGroup> feedGroups = <FeedGroup>[].asObservable();

  @observable
  ObservableList<FeedItem> feedItems = <FeedItem>[].asObservable();

  @observable
  ObservableList<FeedItem> searchResults = <FeedItem>[].asObservable();

  @observable
  ObservableList<FeedItem> suggestedFeedItems = <FeedItem>[].asObservable();

  @observable
  bool initialized = false;

  @observable
  bool loading = false;

  @observable
  Isar isar = Isar.getInstance()!;

  @observable
  late DbUtils dbUtils;

  @observable
  AiUtils aiUtils = AiUtils();

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

  @observable
  ScrollController scrollController = ScrollController();

  @observable
  bool showScrollToTop = false;

  @observable
  bool hasCreatedNewSuggestion = false;

  @action
  Future<bool> init(
      {required SettingsStore setStore, required AuthStore authStore}) async {
    settingsStore = setStore;
    this.authStore = authStore;

    dbUtils = DbUtils(isar: isar);

    bsbController.addListener(onBsbChanged);

    feeds = await dbUtils.getFeeds();
    if (kDebugMode) {
      print("Fetched ${feeds.length} feeds from Isar");
    }

    feedGroups = (await dbUtils.getFeedGroups(feeds)).asObservable();
    if (kDebugMode) {
      print("Fetched ${feedGroups.length} feedGroups from Isar");
    }

    await getPinnedFeedsOrFeedGroups();

    user = auth.currentUser;

    scrollController.addListener(() {
      if (scrollController.offset > 200 && !showScrollToTop) {
        showScrollToTop = true;
      } else if (scrollController.offset < 200 && showScrollToTop) {
        showScrollToTop = false;
      }
    });

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
    pinnedFeedsOrFeedGroups
        .sort((a, b) => a.pinnedPosition.compareTo(b.pinnedPosition));
  }

  @action
  Future<void> getItems() async {
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
      // if the sort is for feeds, and the current feed is not the same as the feed we are sorting for, continue
      if (settingsStore.sort == FeedListSort.feed &&
          settingsStore.sortFeed != null &&
          feed.name != settingsStore.sortFeed!.name) {
        continue;
      }

      // if the sort is for feed groups, and the current feed is not in the group, do not fetch items for it
      if (settingsStore.sort == FeedListSort.feedGroup &&
          settingsStore.sortFeedGroup != null &&
          !settingsStore.sortFeedGroup!.feedNames.contains(feed.name)) {
        continue;
      }

      if (kDebugMode) {
        print("Fetching feed items for ${feed.name}");
      }
      List<FeedItem> items = [];
      Response res;
      try {
        res = await dio.get(feed.link);
      } catch (e) {
        continue;
      }

      bool usingRssFeed = true;

      late RssFeed rssFeed;
      late AtomFeed atomFeed;
      try {
        rssFeed = RssFeed.parse(res.data);
      } catch (e) {
        atomFeed = AtomFeed.parse(res.data);
        usingRssFeed = false;
      }

      if (usingRssFeed) {
        for (RssItem item in rssFeed.items.take(20)) {
          // check if the item is already in the list of feed items
          if (feedItems.any((element) => element.url == item.link)) {
            continue;
          }

          FeedItem feedItem = await FeedItem.fromRssItem(
              item: item, feed: feed, userTier: authStore.userTier);
          items.add(feedItem);
        }
      } else {
        for (AtomItem item in atomFeed.items.take(20)) {
          // check if the item is already in the list of feed items
          if (feedItems
              .any((element) => element.url == item.links.first.href)) {
            continue;
          }

          FeedItem feedItem = await FeedItem.fromAtomItem(
              item: item, feed: feed, userTier: authStore.userTier);
          items.add(feedItem);
        }
      }

      if (items.isEmpty) {
        continue;
      }

      // items.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
      feedItems.addAll(await dbUtils.addNewItems(items));
      feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    }

    loading = false;

    // if (!hasCreatedNewSuggestion) {
    await createNewsSuggestion();
    // }
  }

  @action
  Future<void> toggleItemRead(FeedItem item, {bool toggle = false}) async {
    item.read = toggle ? !item.read : true;

    await dbUtils.updateItemInDb(item);
  }

  @action
  Future<void> toggleItemBookmarked(FeedItem item,
      {bool toggle = false}) async {
    item.bookmarked = toggle ? !item.bookmarked : true;

    await dbUtils.updateItemInDb(item);
  }

  @action
  Future<void> changeSort(FeedListSort sort) async {
    settingsStore.setSort(sort);

    // if (kDebugMode) {
    //   print("Changing sort to $sort");
    // }
    switch (sort) {
      case FeedListSort.byDate:
        feedItems = (await dbUtils.getItems(feeds)).asObservable();
        // feedItems.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        break;
      case FeedListSort.today:
        feedItems = (await dbUtils.getTodaysItems(feeds)).asObservable();
        break;
      case FeedListSort.unread:
        feedItems = (await dbUtils.getUnreadItems(feeds)).asObservable();
        break;
      case FeedListSort.read:
        feedItems = (await dbUtils.getReadItems(feeds)).asObservable();
        break;
      case FeedListSort.bookmarked:
        feedItems = (await dbUtils.getBookmarkedItems(feeds)).asObservable();
        break;
      case FeedListSort.feed:
        if (settingsStore.sortFeed == null) {
          throw Exception(
              "sortFeed cannot be null when changing sort to FeedListSort.Feed.");
        }
        feedItems = (await dbUtils.getItemsFromFeed(settingsStore.sortFeed!))
            .asObservable();
      case FeedListSort.feedGroup:
        if (settingsStore.sortFeedGroup == null) {
          throw Exception(
              "sortFeedGroup cannot be null when changing sort to FeedListSort.FeedGroup.");
        }
        feedItems =
            (await dbUtils.getItemsFromFeedGroup(settingsStore.sortFeedGroup!))
                .asObservable();
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
  Future<void> createFeedGroup(
      String feedGroupName, BuildContext context) async {
    FeedGroup feedGroup = FeedGroup(feedGroupName);
    try {
      await dbUtils.addFeedGroup(feedGroup);
      feedGroups.add(feedGroup);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully created Feed Group!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create Feed Group: error: ${e.toString()}"),
      ));
    }
  }

  @action
  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @action
  Future<void> searchFeedItems(String searchTerm) async {
    searchResults.clear();
    searchResults.addAll(await dbUtils.getSearchItems(feeds, searchTerm));
  }

  @action
  Future<void> createNewsSuggestion() async {
    if (settingsStore.sort != FeedListSort.byDate) {
      return;
    }

    if (settingsStore.lastSuggestionDate != null &&
        settingsStore.lastSuggestionDate!.difference(DateTime.now()).inDays ==
            0 && settingsStore.lastSuggestionDate!.day == DateTime.now().day) {
      if (kDebugMode) {
        print("SUGGESTIONS LEFT: ${settingsStore.suggestionsLeftToday}");
      }
      if (settingsStore.suggestionsLeftToday <= 0) {
        return;
      }
      settingsStore.suggestionsLeftToday--;
    } else {
      if (kDebugMode) {
        print("SUGGESTIONS LEFT: ${settingsStore.suggestionsLeftToday}");
      }
      settingsStore.lastSuggestionDate = DateTime.now();
      settingsStore.suggestionsLeftToday = 9;
    }

    if (kDebugMode) {
      print("Will fetch unread items to get news suggestions");
    }

    List<FeedItem> todaysUnreadItems = await dbUtils.getTodaysUnreadItems(feeds)
      ..take(25);
    if (todaysUnreadItems.isEmpty) {
      return;
    }
    List<String> userInterest = settingsStore.userInterests;

    List<FeedItem> suggestedArticles =
        await aiUtils.getNewsSuggestions(todaysUnreadItems, userInterest);

    suggestedFeedItems.clear();
    suggestedFeedItems.addAll(suggestedArticles);

    // hasCreatedNewSuggestion = true;
  }
}
