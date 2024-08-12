import 'package:bytesized_news/models/feed/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:html/dom.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:isar/isar.dart';

part "feedItem.g.dart";

@collection
class FeedItem {
  Id id = Isar.autoIncrement;

  @Index()
  late String url;

  late String title;
  late String description;
  late List<String> authors;
  late DateTime publishedDate;
  late DateTime timeFetched;
  late String feedName;

  bool read = false;
  bool bookmarked = false;

  String aiSummary = "";
  bool summarized = false;

  @ignore
  Feed? feed;

  static ReadabilityConfig config = ReadabilityConfig(
    readableTags: [
      'p',
      'div',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'td',
      'pre',
    ],
    positiveClasses: [
      'article',
      'body',
      'content',
      'entry',
      'hentry',
      'h-entry',
      'main',
      'page',
      'pagination',
      'post',
      'text',
      'blog',
      'feedItem',
    ],
    negativeClasses: [
      'hidden',
      ' hid ',
      'banner',
      'image',
      'img',
      'figure',
      'figcaption',
      'combx',
      'comment',
      'com-',
      'contact',
      'foot',
      'footer',
      'footnote',
      'gdpr',
      'masthead',
      'media',
      'meta',
      'outbrain',
      'promo',
      'related',
      'scroll',
      'share',
      'shoutbox',
      'sidebar',
      'skyscraper',
      'sponsor',
      'shopping',
      'tags',
      'tool',
      'widget',
    ],
  );

  static Future<FeedItem> fromAtomItem({
    required AtomItem item,
    required Feed feed,
  }) async {
    FeedItem feedItem = FeedItem();

    feedItem.url = item.links.first.href ?? "no link";

    feedItem.title = item.title!.trim();
    feedItem.authors = item.authors.map((author) => author.name!).toList();
    feedItem.publishedDate = DateTime.parse(item.published!);

    // parse html content into description
    final document = html_parser.parse(item.content!);
    Element mainElement = readabilityMainElement(document.documentElement!, config);
    feedItem.description = mainElement.text.trim();
    feedItem.timeFetched = DateTime.now();
    feedItem.feedName = feed.name;
    feedItem.feed = feed;

    fb.FirebaseFirestore firestore = fb.FirebaseFirestore.instance;
    var existingSummary = await firestore.collection("summaries").where("url", isEqualTo: feedItem.url).get();
    if (existingSummary.docs.isNotEmpty) {
      feedItem.aiSummary = existingSummary.docs.first.get("summary");
      feedItem.summarized = true;
    }

    return feedItem;
  }

  static Future<FeedItem> fromRssItem({
    required RssItem item,
    required Feed feed,
  }) async {
    FeedItem feedItem = FeedItem();

    feedItem.url = item.source?.value ?? "no link";

    feedItem.title = item.title!.trim();
    feedItem.authors = item.author != null ? item.author!.split(",") : [];
    // print(item.pubDate);
    feedItem.publishedDate = DateTime.parse(item.pubDate!);

    // parse html content into description
    final document = html_parser.parse(item.content ?? item.description!);
    Element mainElement = readabilityMainElement(document.documentElement!, config);
    feedItem.description = mainElement.text.trim();
    feedItem.timeFetched = DateTime.now();
    feedItem.feedName = feed.name;
    feedItem.feed = feed;

    fb.FirebaseFirestore firestore = fb.FirebaseFirestore.instance;
    var existingSummary = await firestore.collection("summaries").where("url", isEqualTo: feedItem.url).get();
    if (existingSummary.docs.isNotEmpty) {
      feedItem.aiSummary = existingSummary.docs.first.get("summary");
      feedItem.summarized = true;
    }

    return feedItem;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      url.hashCode ^
      title.hashCode ^
      description.hashCode ^
      authors.hashCode ^
      publishedDate.hashCode ^
      timeFetched.hashCode ^
      feedName.hashCode ^
      read.hashCode ^
      bookmarked.hashCode ^
      feed.hashCode.hashCode;

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
        other.feedName == feedName &&
        other.read == read &&
        other.bookmarked == bookmarked &&
        other.feed == feed;
  }
}
