import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbIsolateCleaner {
  /// Delete articles older than a certain number of days
  static Future cleanOldArticles(
    List<dynamic> args,
  ) async {
    // Since the compute method only allows one argument, we pass the arguments as a list
    int days = args[0] as int;
    RootIsolateToken rootIsolateToken = args[1] as RootIsolateToken;

    // This is required for some reason
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    // Open the isar instance in this thread
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [FeedItemSchema, FeedSchema, FeedGroupSchema, StoryReadingSchema],
      directory: dir.path,
    );

    if (kDebugMode) {
      print("Cleaning articles older than $days");
    }

    // Delete all the articles older than 'days' from the db (in a synchronous transaction)
    int numberDeleted = await isar.writeTxnSync(() => isar.feedItems
        .where()
        .filter()
        .bookmarkedEqualTo(false) // don't delete bookmarked items
        .timeFetchedLessThan(DateTime.now().subtract(Duration(days: days)))
        .deleteAllSync());

    if (kDebugMode) {
      print("Deleted $numberDeleted old articles!");
    }
  }
}
