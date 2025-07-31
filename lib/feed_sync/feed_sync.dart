import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class FeedSync {
  Isar isar;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DbUtils dbUtils;

  FeedSync({required this.isar}) {
    dbUtils = DbUtils(isar: isar);
  }

  void updateFirestoreFeedsAndFeedGroups(AuthStore authStore) {
    updateFirestoreFeedGroups(authStore);
    updateFirestoreFeeds(authStore);
  }

  Future<void> updateFirestoreFeeds(AuthStore authStore) async {
    List<Feed> feeds = await dbUtils.getFeeds();
    final batch = FirebaseFirestore.instance.batch();
    final userDocRef = FirebaseFirestore.instance.doc("/users/${authStore.user!.uid}");

    // convert feeds to a map structure
    Map<String, dynamic> feedsMap = {};
    for (Feed feed in feeds) {
      feedsMap[feed.id.toString()] = feed.toJson();
    }

    batch.update(userDocRef, {"feeds": feedsMap});

    await batch.commit();

    if (kDebugMode) {
      print("Batch updated ${feedsMap.length} feeds in firestore");
    }
  }

  Future<void> updateFirestoreFeedGroups(AuthStore authStore) async {
    List<Feed> feeds = await dbUtils.getFeeds();
    List<FeedGroup> feedGroups = await dbUtils.getFeedGroups(feeds);

    // convert to map structure with feedGroup names as keys
    Map<String, dynamic> feedGroupsMap = {};
    for (FeedGroup feedGroup in feedGroups) {
      feedGroupsMap[feedGroup.name] = feedGroup.toJson();
    }

    // replace the entire feedGroups map
    await firestore.doc("/users/${authStore.user!.uid}").update({
      "feedGroups": feedGroupsMap,
    });

    if (kDebugMode) {
      print("Updated ${feedGroupsMap.length} feed groups in firestore");
    }
  }

  Future<void> updateSingleFeedInFirestore(Feed feed, AuthStore authStore) async {
    await firestore.doc("/users/${authStore.user!.uid}").update({
      "feeds.${feed.id}": feed.toJson(),
    });
  }

  Future<void> updateSingleFeedGroupInFirestore(FeedGroup feedGroup, AuthStore authStore) async {
    await firestore.doc("/users/${authStore.user!.uid}").update({
      "feedGroups.${feedGroup.name}": feedGroup.toJson(),
    });
  }
}
