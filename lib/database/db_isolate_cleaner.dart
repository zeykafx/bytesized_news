import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbIsolateCleaner {
  /// Delete articles older than 30 days
  static Future cleanOldArticles(
    List<dynamic> args,
  ) async {
    int days = args[0] as int;
    RootIsolateToken rootIsolateToken = args[1] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [FeedItemSchema, FeedSchema, FeedGroupSchema],
      directory: dir.path,
    );

    if (kDebugMode) {
      print("Cleaning articles older than $days");
    }

    int numberDeleted = await isar.writeTxnSync(() => isar.feedItems
        .where()
        .filter()
        .timeFetchedLessThan(DateTime.now().subtract(Duration(days: days)))
        .deleteAllSync());
    if (kDebugMode) {
      print("Deleted $numberDeleted old articles!");
    }
  }
}
