import 'package:bytesized_news/models/feed/feed.dart';
import 'package:html/dom.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:isar/isar.dart';
import 'package:datify/datify.dart';

part "feedItem.g.dart";

@collection
class FeedItem {
  Id id = Isar.autoIncrement;
  late String title;
  late String description;
  late List<String> authors;
  late DateTime publishedDate;
  late DateTime timeFetched;
  IsarLink<Feed> feed = IsarLink<Feed>();

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

  static FeedItem fromAtomItem({
    required AtomItem item,
    required Feed feed,
  }) {
    FeedItem feedItem = FeedItem();

    feedItem.title = item.title!;
    feedItem.authors = item.authors.map((author) => author.name!).toList();
    feedItem.publishedDate = Datify.parse(item.published!).result.date!;

    // parse html content into description
    final document = html_parser.parse(item.content!);
    Element mainElement = readabilityMainElement(document.documentElement!, config);
    feedItem.description = mainElement.text.trim();
    feedItem.timeFetched = DateTime.now();
    feedItem.feed.value = feed;

    return feedItem;
  }

  static FeedItem fromRssItem({
    required RssItem item,
    required Feed feed,
  }) {
    FeedItem feedItem = FeedItem();
    feedItem.title = item.title!;
    feedItem.authors = item.author != null ? item.author!.split(",") : [];
    print(item.pubDate);
    feedItem.publishedDate = Datify.parse(item.pubDate!).result.date!;

    // parse html content into description
    final document = html_parser.parse(item.content ?? item.description!);
    Element mainElement = readabilityMainElement(document.documentElement!, config);
    feedItem.description = mainElement.text.trim();
    feedItem.timeFetched = DateTime.now();
    feedItem.feed.value = feed;

    return feedItem;
  }
}
