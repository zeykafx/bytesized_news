import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/feed_sync/feed_sync.dart';
import 'package:bytesized_news/models/curatedFeed/curated_feed.dart';
import 'package:bytesized_news/models/curatedFeed/curated_feed_category.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:opml/opml.dart';

part 'curated_feeds_store.g.dart';

class CuratedFeedsStore = _CuratedFeedsStore with _$CuratedFeedsStore;

abstract class _CuratedFeedsStore with Store {
  String curatedFeedsPath = "assets/feeds";
  List<String> curatedFeedsFilenames = ["curated_feeds.xml"];

  @observable
  List<CuratedFeedCategory> curatedCategories = [];

  @observable
  bool loading = false;

  @observable
  ObservableSet<CuratedFeed> selectedFeeds = ObservableSet<CuratedFeed>();

  @observable
  ObservableSet<CuratedFeedCategory> selectedCategories = ObservableSet<CuratedFeedCategory>();

  @observable
  Isar isar = Isar.getInstance()!;

  @observable
  late DbUtils dbUtils;

  @observable
  late FeedSync feedSync;

  @observable
  ObservableList<Feed> followedFeeds = <Feed>[].asObservable();

  @observable
  ObservableList<FeedGroup> followedFeedGroup = <FeedGroup>[].asObservable();

  @action
  Future<void> readCuratedFeeds(BuildContext context, AuthStore authStore) async {
    dbUtils = DbUtils(isar: isar);
    feedSync = FeedSync(isar: isar, authStore: authStore);

    loading = true;

    // get the followed feeds and groups
    followedFeeds = (await dbUtils.getFeeds()).asObservable();
    followedFeedGroup = (await dbUtils.getFeedGroups(followedFeeds)).asObservable();

    try {
      for (String filename in curatedFeedsFilenames) {
        String fileContent = await rootBundle.loadString("$curatedFeedsPath/$filename");

        OpmlDocument opml = OpmlDocument.parse(fileContent);

        for (OpmlOutline outline in opml.body) {
          // get category name
          String categoryName = "";
          if (outline.text != null) {
            categoryName = outline.text!;
          } else if (outline.title != null) {
            categoryName = outline.title!;
          }

          // get all the feeds in the category
          List<CuratedFeed> categoryFeeds = [];
          for (OpmlOutline child in outline.children!) {
            if (child.xmlUrl != null) {
              String childTitle = "Unnamed feed";
              if (child.title != null) {
                childTitle = child.title!;
              } else if (child.text != null) {
                childTitle = child.text!;
              }
              CuratedFeed feed = CuratedFeed(title: childTitle, link: child.xmlUrl!);
              categoryFeeds.add(feed);
            }
          }

          // create the category and add it to the list of curated categories of feeds
          CuratedFeedCategory category = CuratedFeedCategory(
            name: categoryName,
            curatedFeeds: categoryFeeds,
          );
          curatedCategories.add(category);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    } finally {
      loading = false;
    }
  }

  @action
  bool isFeedAlreadyFollowed(CuratedFeed feed) {
    return followedFeeds.any((followdFeed) => followdFeed.link == feed.link);
  }

  @action
  bool isCategoryAlreadyFollowed(CuratedFeedCategory cat) {
    return followedFeedGroup.any((FeedGroup feedGroup) => feedGroup.feedUrls == (cat.curatedFeeds.map((feed) => feed.link)));
  }

  @action
  void toggleFeedSelection(CuratedFeed feed, CuratedFeedCategory category) {
    if (selectedFeeds.contains(feed)) {
      selectedFeeds.remove(feed);
      selectedCategories.remove(category);
      if (kDebugMode) {
        print("Deselected feed: ${feed.title}");
      }
    } else {
      selectedFeeds.add(feed);
      // auto select the category
      selectedCategories.add(category);
      if (kDebugMode) {
        print("Selected feed: ${feed.title}");
      }

      // // Check if all feeds in this category are now selected
      // bool allFeedsSelected = category.curatedFeeds.every((feed) => selectedFeeds.contains(feed));

      // if (allFeedsSelected && !selectedCategories.contains(category)) {
      //   selectedCategories.add(category);
      //   print("Auto-selected category: ${category.name} (all feeds selected)");
      // }
    }
  }

  @action
  void toggleCategorySelection(CuratedFeedCategory category) {
    if (selectedCategories.contains(category)) {
      // Deselect category and all its feeds
      selectedCategories.remove(category);
      for (CuratedFeed feed in category.curatedFeeds) {
        selectedFeeds.remove(feed);
      }
      if (kDebugMode) {
        print("Deselected category: ${category.name}");
      }
    } else {
      if (isCategoryAlreadyFollowed(category)) {
        return;
      }
      // Select category and all its feeds
      selectedCategories.add(category);
      for (CuratedFeed feed in category.curatedFeeds) {
        if (!isFeedAlreadyFollowed(feed)) {
          selectedFeeds.add(feed);
        }
      }
      // if no feeds were selected (because the user already follows all the feeds in the cat, don't select the category)
      if (selectedFeeds.isEmpty) {
        selectedCategories.remove(category);
      } else {
        if (kDebugMode) {
          print("Selected category: ${category.name}");
        }
      }
    }
  }

  bool isFeedSelected(CuratedFeed feed) {
    return selectedFeeds.contains(feed);
  }

  bool isCategorySelected(CuratedFeedCategory category) {
    return selectedCategories.contains(category);
  }

  @action
  void clearSelections() {
    selectedFeeds.clear();
    selectedCategories.clear();
    if (kDebugMode) {
      print("Cleared all selections");
    }
  }

  Future<void> followSelectedFeeds(BuildContext context) async {
    if (kDebugMode) {
      print("=== FOLLOWING FEEDS ===");
      for (CuratedFeedCategory category in selectedCategories) {
        print("Following entire category: ${category.name} with ${category.curatedFeeds.length} feeds");
        for (CuratedFeed feed in category.curatedFeeds) {
          print("  - ${feed.title} (${feed.link})");
        }
      }
      for (CuratedFeed feed in selectedFeeds) {
        print("Following individual feed: ${feed.title} (${feed.link})");
      }
      print("=======================");
    }

    // do something like this:

    for (CuratedFeedCategory category in selectedCategories) {
      FeedGroup feedGroup = FeedGroup(category.name);

      // TODO: only follow the specific feeds selected
      // 
      for (CuratedFeed feed in category.curatedFeeds) {
        Feed? dbFeed = await Feed.createFeed(feed.link, feedName: feed.title);

        if (dbFeed == null) {
          if (kDebugMode) {
            print("Error following feed ${feed.title}");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error following feed ${feed.title}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          continue;
        }

        feedGroup.feedUrls.add(dbFeed.link);
        feedGroup.feeds.add(dbFeed);

        await dbUtils.addFeed(dbFeed);

        selectedFeeds.remove(feed);
      }

      await dbUtils.addFeedGroup(feedGroup);
    }

    for (CuratedFeed feed in selectedFeeds) {
      print(feed.link);
      Feed? dbFeed = await Feed.createFeed(feed.link, feedName: feed.title);

      if (dbFeed == null) {
        if (kDebugMode) {
          print("Error following feed ${feed.title}");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error following feed ${feed.title}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      await dbUtils.addFeed(dbFeed);
    }

    feedSync.updateFirestoreFeedsAndFeedGroups();

    Navigator.of(context).pop();

    // Clear selections after following
    clearSelections();
  }
}
