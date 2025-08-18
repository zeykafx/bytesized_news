import 'package:bytesized_news/background/LifecycleEventHandler.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/atom_item.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:rss_dart/domain/rss_item.dart';

class BackgroundFetch {
  static Future<bool> runBackgroundFetch() async {
    if (!lifecycleEventHandler.inBackground) {
      if (kDebugMode) {
        print("The app is also running in the foreground, bg worker stopping.");
      }
      return true;
    }

    // Open the isar instance in this thread
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([FeedItemSchema, FeedSchema, FeedGroupSchema, StoryReadingSchema], directory: dir.path);

    DbUtils dbUtils = DbUtils(isar: isar);

    List<Feed> feeds = await dbUtils.getFeeds();

    Dio dio = Dio();

    List<FeedItem> items = [];
    for (Feed feed in feeds) {
      if (kDebugMode) {
        print("Fetching items for ${feed.name} from the background worker!");
      }

      Response res;
      try {
        res = await dio.get(feed.link, options: Options(receiveTimeout: Duration(seconds: 5)));
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
          if (items.any((element) => element.url == item.link)) {
            continue;
          }

          FeedItem feedItem = await FeedItem.fromRssItem(item: item, feed: feed);
          feedItem.fetchedInBg = true;
          items.add(feedItem);
        }
      } else {
        for (AtomItem item in atomFeed.items.take(20)) {
          // check if the item is already in the list of feed items
          if (items.any((element) => element.url == item.links.first.href)) {
            continue;
          }

          FeedItem feedItem = await FeedItem.fromAtomItem(item: item, feed: feed);
          feedItem.fetchedInBg = true;
          items.add(feedItem);
        }
      }
    }

    await dbUtils.addNewItems(items);

    return true;
  }
}
