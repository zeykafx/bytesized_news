import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class DbIsolateCleaner {
  /// Delete articles older than a certain number of days
  static Future cleanOldArticles(List<dynamic> args) async {
    // Since the compute method only allows one argument, we pass the arguments as a list
    int days = args[0] as int;
    RootIsolateToken rootIsolateToken = args[1] as RootIsolateToken;

    // This is required for some reason
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    // Open the isar instance in this thread
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([FeedItemSchema, FeedSchema, FeedGroupSchema, StoryReadingSchema], directory: dir.path);

    if (kDebugMode) {
      print("Cleaning unread articles older than $days");
    }

    List<FeedItem> itemsToDelete = await isar.feedItems
        .where()
        .filter()
        .bookmarkedEqualTo(false) // don't delete bookmarked items
        .readEqualTo(false) // don't delete read items
        .timeFetchedLessThan(DateTime.now().subtract(Duration(days: days)))
        .findAll();

    // delete all of the images from the cache
    for (FeedItem item in itemsToDelete) {
      dom.Document contentElement = html_parser.parse(item.htmlContent ?? "");
      List<dom.Element> images = contentElement.getElementsByTagName("img")
        ..addAll(contentElement.getElementsByTagName("image"))
        ..addAll(contentElement.getElementsByTagName("picture"));
      for (dom.Element el in images) {
        String imgSrc = "";
        if (el.attributes case {'src': final String src}) {
          imgSrc = src;
        }

        if (imgSrc.isEmpty) {
          continue;
        }

        try {
          await DefaultCacheManager().removeFile(imgSrc);
        } catch (_) {}
      }
    }

    int numberDeleted = await isar.writeTxn(() => isar.feedItems.deleteAll(itemsToDelete.map((elem) => elem.id).toList()));

    if (kDebugMode) {
      print("Deleted $numberDeleted old articles!");
    }
  }
}
