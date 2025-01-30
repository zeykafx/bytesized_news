import 'dart:isolate';

import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbIsolateCleaner {
  /// Delete articles older than 30 days
  static Future cleanOldArticles(RootIsolateToken rootIsolateToken) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [FeedItemSchema, FeedSchema, FeedGroupSchema],
      directory: dir.path,
    );

    int numberDeleted = await isar.writeTxnSync(() => isar.feedItems
        .where()
        .filter()
        .timeFetchedLessThan(DateTime.now().subtract(Duration(days: 30)))
        .deleteAllSync());
    if (kDebugMode) {
      print("Deleted $numberDeleted old articles!");
    }
  }
}
