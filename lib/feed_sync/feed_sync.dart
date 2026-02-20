import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feed_group/feed_group.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:isar_community/isar.dart';

class FeedSync {
  Isar isar;
  late AuthStore authStore;

  FeedSync({required this.isar, required this.authStore});

  bool checkIsUserPremium() => false;

  void updateFirestoreFeedsAndFeedGroups() {}

  Future<void> updateFirestoreFeeds() async {}

  Future<void> updateFirestoreFeedGroups() async {}

  Future<void> deleteSingleFeedInFirestore(Feed feed, AuthStore authStore) async {}

  Future<void> deleteSingleFeedGroupInFirestore(FeedGroup feedGroup, AuthStore authStore) async {}

  Future<void> updateSingleFeedInFirestore(Feed feed) async {}

  Future<void> updateSingleFeedGroupInFirestore(FeedGroup feedGroup) async {}
}
