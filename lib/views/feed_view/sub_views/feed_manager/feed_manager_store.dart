import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';

part 'feed_manager_store.g.dart';

class FeedManagerStore = _FeedManagerStore with _$FeedManagerStore;

abstract class _FeedManagerStore with Store {
  late FeedStore feedStore;
  @observable
  bool selectionMode = false;

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

  @action
  Future<void> init({required FeedStore feedStore}) async {
    dbUtils = DbUtils(isar: isar);
    this.feedStore = feedStore;
  }

  @action
  void toggleSelectionMode() {
    selectionMode = !selectionMode;
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
  Future<void> addFeedsToFeedGroup(List<FeedGroup> feedGroupsToAddFeedsTo) async {
    for (FeedGroup feedGroup in feedGroupsToAddFeedsTo) {
      // remove the selected feeds that are already in the feedGroup
      List<Feed> localSelectedFeeds = List.from(selectedFeeds);
      localSelectedFeeds.removeWhere((feed) => feedGroup.feedNames.contains(feed.name));

      feedGroup.feeds.addAll(localSelectedFeeds);
      feedGroup.feedNames = feedGroup.feedNames + localSelectedFeeds.map((feed) => feed.name).toList();
      await dbUtils.addFeedsToFeedGroup(feedGroup);
    }
  }

  @action
  Future<void> handleDelete() async {
    if (areFeedGroupsSelected) {
      // Delete selected feed groups
      await dbUtils.deleteFeedGroups(selectedFeedGroups);
      feedStore.feedGroups.removeWhere((feedGroup) => selectedFeedGroups.contains(feedGroup));
      toggleSelectionMode();
    } else {
      // Delete selected feeds
      await dbUtils.deleteFeeds(selectedFeeds);
      feedStore.feeds.removeWhere((feed) => selectedFeeds.contains(feed));

      // also remove feedItems from the feed in the db
      for (Feed feed in selectedFeeds) {
        feedStore.feedItems.removeWhere((item) => item.feedName == feed.name);
        await dbUtils.deleteFeedItems(feed);

        // also remove the feed from any feedGroups that it might be in
        for (FeedGroup feedGroup in feedStore.feedGroups) {
          if (feedGroup.feedNames.contains(feed.name)) {
            feedGroup.feedNames.remove(feed.name);
            feedGroup.feeds.removeWhere((f) => f.name == feed.name);
            await dbUtils.addFeedsToFeedGroup(feedGroup);
          }
        }
        toggleSelectionMode();
      }
    }
  }
}
