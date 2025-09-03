import 'dart:io';
import 'dart:math';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/atom_item.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:rss_dart/domain/rss_item.dart';

class BackgroundFetch {
  static Future<bool> runBackgroundFetch() async {
    // if (!lifecycleEventHandler.inBackground) {
    //   if (kDebugMode) {
    //     print("The app is also running in the foreground, bg worker stopping.");
    //   }
    //   return true;
    // }

    if (kDebugMode) {
      print("BG Worker starting");
    }

    // Open the isar instance in this thread
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([FeedItemSchema, FeedSchema, FeedGroupSchema, StoryReadingSchema], directory: dir.path);

    DbUtils dbUtils = DbUtils(isar: isar);

    List<Feed> feeds = await dbUtils.getFeeds();

    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
    // init the notification plugin if the user wants to be notified for even just one feed
    if (feeds.any((feed) => feed.notifyAfterBgSync)) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('icon');
      final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: null,
        linux: null,
        windows: null,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }

    Dio dio = Dio();

    List<FeedItem> items = [];
    for (Feed feed in feeds) {
      List<FeedItem> itemsForFeed = [];

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
          itemsForFeed.add(feedItem);
        }
      } else {
        for (AtomItem item in atomFeed.items.take(20)) {
          // check if the item is already in the list of feed items
          if (items.any((element) => element.url == item.links.first.href)) {
            continue;
          }

          FeedItem feedItem = await FeedItem.fromAtomItem(item: item, feed: feed);
          feedItem.fetchedInBg = true;
          itemsForFeed.add(feedItem);
        }
      }

      items.addAll(itemsForFeed);
    }

    List<FeedItem> newItems = await dbUtils.addNewItems(items);
    Map<Feed, List<FeedItem>> itemsForFeeds = {};

    // group new items by feed
    for (FeedItem item in newItems) {
      if (!itemsForFeeds.containsKey(item.feed) && item.feed != null) {
        itemsForFeeds[item.feed!] = [];
      }
      itemsForFeeds[item.feed]!.add(item);
    }

    for (MapEntry<Feed, List<FeedItem>> entry in itemsForFeeds.entries) {
      Feed feed = entry.key;
      List<FeedItem> itemsForFeed = entry.value;

      if (feed.notifyAfterBgSync && flutterLocalNotificationsPlugin != null && Platform.isAndroid && itemsForFeed.isNotEmpty) {
        const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          'Bytesized News',
          'Background Synchronization',
          channelDescription: 'Notification about new articles for select feeds',
          importance: Importance.low,
          priority: Priority.low,
          enableVibration: false,
        );
        const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

        int lengthOrThree = min(3, itemsForFeed.length);
        String top3 = itemsForFeed
            .take(lengthOrThree)
            .map((FeedItem feedItem) {
              dom.Document doc = parse(feedItem.title);
              String parsedTitle = parse(doc.body!.text).documentElement!.text;
              return parsedTitle;
            })
            .join('", "');
        int len = itemsForFeed.length - lengthOrThree;

        await flutterLocalNotificationsPlugin.show(
          feed.id,
          'Bytesized News - ${feed.name}',
          'New articles: "$top3" ${len > 0 ? 'and $len more' : ''}',
          notificationDetails,
        );
      }
    }
    // if (feed.notifyAfterBgSync && flutterLocalNotificationsPlugin != null && Platform.isAndroid) {
    //   const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    //     'Bytesized News',
    //     'Background Synchronization',
    //     channelDescription: 'Notification about new articles for select feeds',
    //     importance: Importance.low,
    //     priority: Priority.low,
    //     enableVibration: false,
    //   );
    //   const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    //   if (itemsForFeed.isNotEmpty) {
    //     int lengthOrThree = min(3, itemsForFeed.length);
    //     String top3 = itemsForFeed.take(lengthOrThree).map((FeedItem feedItem) => feedItem.title).join('", "');
    //     int len = itemsForFeed.length - lengthOrThree;

    //     await flutterLocalNotificationsPlugin.show(feed.id, 'Bytesized News', 'New articles: "$top3" ${len > 0 ? 'and $len more' : ''}', notificationDetails);
    //   }
    // }
    return true;
  }
}
