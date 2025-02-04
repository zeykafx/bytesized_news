import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';

part 'feed_manager_store.g.dart';

class FeedManagerStore = _FeedManagerStore with _$FeedManagerStore;

abstract class _FeedManagerStore with Store {
  late FeedStore feedStore;
  @observable
  bool selectionMode = false;

  @observable
  bool pinnedListExpanded = true;

  @observable
  ObservableList<Feed> selectedFeeds = <Feed>[].asObservable();

  @observable
  ObservableList<FeedGroup> selectedFeedGroups = <FeedGroup>[].asObservable();

  @computed
  bool get areFeedGroupsSelected => selectedFeedGroups.isNotEmpty;

  @computed
  bool get areFeedsSelected => selectedFeeds.isNotEmpty;

  @computed
  bool get areMoreThanOneFeedGroupsSelected => selectedFeedGroups.length > 1;

  @observable
  Isar isar = Isar.getInstance()!;

  @observable
  late DbUtils dbUtils;

  @observable
  bool isReordering = false;

  @action
  Future<void> init({required FeedStore feedStore}) async {
    dbUtils = DbUtils(isar: isar);
    this.feedStore = feedStore;
  }

  @action
  void toggleSelectionMode() {
    selectionMode = !selectionMode;
    HapticFeedback.lightImpact();
  }

  @action
  void addSelectedFeed(Feed feed) {
    selectedFeeds.add(feed);
  }

  @action
  void removeSelectedFeed(Feed feed) {
    selectedFeeds.remove(feed);
  }

  @action
  void setSelectedFeed(List<Feed> feeds) {
    selectedFeeds = feeds.asObservable();
  }

  @action
  void addSelectedFeedGroup(FeedGroup feedGroup) {
    selectedFeedGroups.add(feedGroup);
  }

  @action
  void removeSelectedFeedGroup(FeedGroup feedGroup) {
    selectedFeedGroups.remove(feedGroup);
  }

  @action
  void setSelectedFeedGroup(List<FeedGroup> feedGroups) {
    selectedFeedGroups = feedGroups.asObservable();
  }

  @action
  void createFeedGroupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController feedGroupNameController =
              TextEditingController();

          return AlertDialog(
            title: const Text("Create Feed Group"),
            content: TextField(
              controller: feedGroupNameController,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Feed Group Name",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  feedStore.createFeedGroup(
                      feedGroupNameController.text, context);
                  Navigator.of(context).pop();
                },
                child: const Text("Create"),
              ),
            ],
          );
        });
  }

  @action
  Future<void> addSelectedFeedsToAFeedGroup(
      List<Feed> feeds, FeedGroup feedGroup) async {
    for (Feed feed in feeds) {
      if (kDebugMode) {
        print("Adding ${feed.name} to ${feedGroup.name}");
      }

      if (!feedGroup.feeds.contains(feed)) {
        feedGroup.feeds.add(feed);
        feedGroup.feedNames = feedGroup.feedNames + [feed.name];
        await dbUtils.addFeedGroup(feedGroup);
      }
    }
  }

  @action
  Future<void> addFeedsToFeedGroup(
      List<FeedGroup> feedGroupsToAddFeedsTo) async {
    for (FeedGroup feedGroup in feedGroupsToAddFeedsTo) {
      if (kDebugMode) {
        print(
            "Adding ${selectedFeeds.map((feed) => feed.name).toList()} to feed group: ${feedGroup.name}");
      }
      // remove the selected feeds that are already in the feedGroup
      List<Feed> localSelectedFeeds = selectedFeeds
          .where((feed) => !feedGroup.feedNames.contains(feed.name))
          .toList();

      feedGroup.feeds.addAll(localSelectedFeeds);
      feedGroup.feedNames = feedGroup.feedNames +
          localSelectedFeeds.map((feed) => feed.name).toList();
      await dbUtils.addFeedsToFeedGroup(feedGroup);
    }
  }

  @action
  void handleFeedTileLongPress(Feed feed) {
    if (!selectionMode) {
      toggleSelectionMode();
    }
    if (!selectedFeeds.contains(feed)) {
      addSelectedFeed(feed);
    } else {
      removeSelectedFeed(feed);
      if (selectedFeeds.isEmpty && selectedFeedGroups.isEmpty) {
        toggleSelectionMode();
      }
    }
  }

  @action
  void handleFeedTileTap(Feed feed) {
    if (selectionMode && !selectedFeeds.contains(feed)) {
      addSelectedFeed(feed);
    } else if (selectionMode) {
      removeSelectedFeed(feed);
      if (selectedFeeds.isEmpty && selectedFeedGroups.isEmpty) {
        toggleSelectionMode();
      }
    }
  }

  @action
  void handleFeedGroupLongPress(FeedGroup feedGroup) {
    if (!selectionMode) {
      toggleSelectionMode();
    }
    if (!selectedFeedGroups.contains(feedGroup)) {
      addSelectedFeedGroup(feedGroup);
    } else {
      removeSelectedFeedGroup(feedGroup);
      if (selectedFeedGroups.isEmpty && selectedFeeds.isEmpty) {
        toggleSelectionMode();
      }
    }
  }

  @action
  void handleFeedGroupTap(FeedGroup feedGroup) {
    if (selectionMode && !selectedFeedGroups.contains(feedGroup)) {
      addSelectedFeedGroup(feedGroup);
    } else if (selectionMode) {
      removeSelectedFeedGroup(feedGroup);
      if (selectedFeedGroups.isEmpty && selectedFeeds.isEmpty) {
        toggleSelectionMode();
      }
    }
  }

  @action
  Future<void> handleDelete({bool toggleSelection = true}) async {
    if (areFeedGroupsSelected) {
      // remove from the pinned list
      feedStore.pinnedFeedsOrFeedGroups.removeWhere((feedGroup) =>
          selectedFeedGroups
              .where((FeedGroup group) =>
                  group.name == feedGroup.name &&
                  group.feedNames == feedGroup.feedNames)
              .isNotEmpty);

      // Delete selected feed groups
      await dbUtils.deleteFeedGroups(selectedFeedGroups);
      feedStore.feedGroups
          .removeWhere((feedGroup) => selectedFeedGroups.contains(feedGroup));

      // if this group was the current sort, remove it
      if (feedStore.settingsStore.sort == FeedListSort.feedGroup &&
          feedStore.settingsStore.sortFeedGroup != null &&
          selectedFeedGroups.contains(feedStore.settingsStore.sortFeedGroup!)) {
        feedStore.settingsStore.sortFeedGroup = null;
        feedStore.settingsStore.sortFeedGroupName = null;
        feedStore.changeSort(FeedListSort.byDate);
      }
    }

    if (areFeedsSelected) {
      // Delete selected feeds
      await dbUtils.deleteFeeds(selectedFeeds);
      feedStore.feeds.removeWhere((feed) => selectedFeeds.contains(feed));

      // also remove from the pinned list
      feedStore.pinnedFeedsOrFeedGroups
          .removeWhere((feed) => selectedFeeds.contains(feed));

      // also remove feedItems from the feed in the db
      for (Feed feed in selectedFeeds) {
        feedStore.feedItems.removeWhere((item) => item.feedName == feed.name);
        await dbUtils.deleteFeedItems(feed);

        // if this group was the current sort, remove it
        if (feedStore.settingsStore.sort == FeedListSort.feed &&
            feedStore.settingsStore.sortFeed != null &&
            feedStore.settingsStore.sortFeed == feed) {
          feedStore.settingsStore.sortFeed = null;
          feedStore.settingsStore.sortFeedName = null;
          feedStore.changeSort(FeedListSort.byDate);
        }

        // also remove the feed from any feedGroups that it might be in
        for (FeedGroup feedGroup in feedStore.feedGroups) {
          if (feedGroup.feedNames.contains(feed.name)) {
            feedGroup.feedNames =
                feedGroup.feedNames.where((name) => name != feed.name).toList();
            // feedGroup.feedNames.remove(feed.name);
            feedGroup.feeds.removeWhere((f) => f.name == feed.name);
            await dbUtils.addFeedsToFeedGroup(feedGroup);
          }
        }
      }
    }

    if (toggleSelection) {
      toggleSelectionMode();
    }
    selectedFeeds.clear();
    selectedFeedGroups.clear();
  }

  @action
  Future<void> pinOrUnpinItem(dynamic feedOrFeedGroup, bool pin,
      {bool toggleSelection = true}) async {
    if (feedOrFeedGroup.runtimeType == Feed) {
      Feed feed = feedOrFeedGroup;
      feed.isPinned = pin;
      if (pin) {
        feedStore.pinnedFeedsOrFeedGroups.add(feed);
        // yes, this is stupid. like, i know the item is gonna be at the end of the list, but I'm doing this because,
        // idk, there might be multiple items added at once and maybe, somehow, someway, it might get messed up or something?
        feed.pinnedPosition = feedStore.pinnedFeedsOrFeedGroups.indexOf(feed);
      } else {
        feedStore.pinnedFeedsOrFeedGroups.remove(feed);
        feed.pinnedPosition = -1;
      }

      await dbUtils.addFeed(feed);
    } else {
      FeedGroup feedGroup = feedOrFeedGroup;
      feedGroup.isPinned = pin;
      if (pin) {
        feedStore.pinnedFeedsOrFeedGroups.add(feedGroup);
        feedGroup.pinnedPosition =
            feedStore.pinnedFeedsOrFeedGroups.indexOf(feedGroup);
      } else {
        feedStore.pinnedFeedsOrFeedGroups.remove(feedGroup);
        feedGroup.pinnedPosition = -1;
      }

      await dbUtils.addFeedGroup(feedGroup);
    }

    if (toggleSelection) {
      selectedFeeds.clear();
      selectedFeedGroups.clear();
      toggleSelectionMode();
    }
  }

  @action
  Future<void> reorderPinnedFeedsOrFeedGroups(
      int oldIndex, int newIndex) async {
    // check the index bounds
    if (newIndex >= feedStore.pinnedFeedsOrFeedGroups.length) {
      newIndex = feedStore.pinnedFeedsOrFeedGroups.length - 1;
    }

    if (newIndex < 0) {
      newIndex = 0;
    }

    final item = feedStore.pinnedFeedsOrFeedGroups.removeAt(oldIndex);
    feedStore.pinnedFeedsOrFeedGroups.insert(newIndex, item);

    for (int i = 0; i < feedStore.pinnedFeedsOrFeedGroups.length; i++) {
      feedStore.pinnedFeedsOrFeedGroups[i].pinnedPosition = i;

      if (feedStore.pinnedFeedsOrFeedGroups[i] is Feed) {
        await dbUtils.addFeed(feedStore.pinnedFeedsOrFeedGroups[i]);
      } else if (feedStore.pinnedFeedsOrFeedGroups[i] is FeedGroup) {
        await dbUtils.addFeedGroup(feedStore.pinnedFeedsOrFeedGroups[i]);
      }
    }
  }

  @action
  void handlePinnedExpandedButtonTap() {
    pinnedListExpanded = !pinnedListExpanded;
  }
}
