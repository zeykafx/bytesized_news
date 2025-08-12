import 'package:any_date/any_date.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:html/dom.dart' as dom;
import 'package:readability/article.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:isar/isar.dart';
import 'package:readability/readability.dart' as readability;

part "feedItem.g.dart";

@collection
class FeedItem {
  Id id = Isar.autoIncrement;

  @Index()
  late String url;

  late String title;
  late String description;
  late String imageUrl;
  late List<String> authors;
  late DateTime publishedDate;
  late DateTime timeFetched;
  late int feedId;

  bool read = false;
  bool bookmarked = false;

  String aiSummary = "";
  bool summarized = false;
  bool suggested = false;
  bool downloaded = false;
  String? htmlContent;
  int estReadingTimeMinutes = 0;
  bool? fetchedInBg = false;

  @ignore
  Feed? feed;

  @ignore
  late DbUtils dbUtils;

  @ignore
  Isar isar = Isar.getInstance()!;

  @ignore
  static const readingSpeed = 200;

  FeedItem() {
    dbUtils = DbUtils(isar: isar);
  }

  static Future<FeedItem> fromAtomItem({
    required AtomItem item,
    required Feed feed,
  }) async {
    FeedItem feedItem = FeedItem();

    feedItem.url = item.links.first.href ?? "no link";

    feedItem.title = item.title!.trim();
    feedItem.authors = item.authors.map((author) => author.name!).toList();

    AnyDate parser = const AnyDate();
    feedItem.publishedDate = parser.parse(item.published ?? DateTime.now().millisecondsSinceEpoch.toString());

    // parse html content into description

    if (item.content != null) {
      dom.Document document = html_parser.parse(item.content!);

      if (item.media != null && item.media!.thumbnails.isNotEmpty) {
        feedItem.imageUrl = item.media!.thumbnails.first.url ?? "";
      } else {
        // find the image and print the src
        dom.Element? img = document.querySelector('img');
        if (img != null) {
          feedItem.imageUrl = img.attributes['src']!;
        } else {
          feedItem.imageUrl = "";
        }
      }

      feedItem.description = document.documentElement!.text.trim();
    } else {
      if (item.media != null && item.media!.thumbnails.isNotEmpty) {
        feedItem.imageUrl = item.media?.thumbnails.first.url ?? "";
      } else {
        feedItem.imageUrl = "";
      }
      feedItem.description = "";
    }

    // Element mainElement = readabilityMainElement(document.documentElement!, config);
    feedItem.timeFetched = DateTime.now();
    feedItem.feedId = feed.id;
    feedItem.feed = feed;

    return feedItem;
  }

  static Future<FeedItem> fromRssItem({
    required RssItem item,
    required Feed feed,
  }) async {
    FeedItem feedItem = FeedItem();

    feedItem.url = item.link ?? "no link";

    feedItem.title = item.title!.trim();
    feedItem.authors = item.author != null ? item.author!.split(",") : [];
    // print(item.pubDate);

    AnyDate parser = const AnyDate();
    feedItem.publishedDate = parser.parse(item.pubDate ?? DateTime.now().millisecondsSinceEpoch.toString());

    dom.Document? document;
    // parse html content into description
    if (item.content != null) {
      document = html_parser.parse(item.content!.value);
      feedItem.description = document.documentElement!.text.trim();
    } else {
      feedItem.description = "";
    }

    feedItem.imageUrl = "";

    // search for media:content tag
    if (item.media != null && item.media!.contents.isNotEmpty) {
      String? url = item.media?.contents.first.url;
      if (url != null && url.isNotEmpty) {
        feedItem.imageUrl = url;
      } else {
        if (document != null) {
          var img = document.querySelector('img');
          if (img != null) {
            feedItem.imageUrl = img.attributes['src']!;
          } else {
            img = document.querySelector("image");
            if (img != null) {
              feedItem.imageUrl = img.attributes['src']!;
            }
          }
        }
      }
    }

    feedItem.timeFetched = DateTime.now();
    feedItem.feedId = feed.id;
    feedItem.feed = feed;

    return feedItem;
  }

  Future<String> fetchHtmlContent() async {
    Article result = await readability.parseAsync(url);
    if (result.content == null) {
      estReadingTimeMinutes = 0;
      return "";
    }
    int wordCount = result.content!.split(" ").length;

    if (imageUrl.isEmpty && result.imageUrl != null && result.imageUrl!.isNotEmpty) {
      imageUrl = result.imageUrl!;
    }

    // estReadingTime = Duration(minutes: (wordCount / readingSpeed).toInt());
    estReadingTimeMinutes = (wordCount / readingSpeed).toInt();

    htmlContent = result.content!.split("\n").toSet().join("\n");
    downloaded = true;

    dom.Document contentElement = html_parser.parse(htmlContent);
    List<dom.Element> images = contentElement.getElementsByTagName("img")
      ..addAll(contentElement.getElementsByTagName("image"))
      ..addAll(contentElement.getElementsByTagName("picture"));
    for (dom.Element el in images) {
      String imgSrc = "";
      if (el.attributes case {'src': final String src}) {
        imgSrc = src;
        imageUrl = imgSrc;
      }

      if (imgSrc.isEmpty) {
        continue;
      }

      await DefaultCacheManager().downloadFile(imgSrc, force: true);
    }

    await dbUtils.updateItemInDb(this);

    return htmlContent!;
  }

  @override
  int get hashCode =>
      id.hashCode ^ url.hashCode ^ title.hashCode ^ description.hashCode ^ authors.hashCode ^ publishedDate.hashCode ^ timeFetched.hashCode ^ feedId.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeedItem &&
        other.id == id &&
        other.url == url &&
        other.title == title &&
        other.description == description &&
        other.authors == authors &&
        other.publishedDate == publishedDate &&
        other.timeFetched == timeFetched &&
        other.feedId == feedId &&
        other.feed == feed;
  }
}
