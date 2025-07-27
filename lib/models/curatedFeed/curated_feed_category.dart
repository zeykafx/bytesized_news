import 'package:bytesized_news/models/curatedFeed/curated_feed.dart';

class CuratedFeedCategory {
  final String name;
  final List<CuratedFeed> curatedFeeds;

  CuratedFeedCategory({required this.name, required this.curatedFeeds});
}
