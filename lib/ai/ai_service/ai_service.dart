import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feed_item/feed_item.dart';

abstract class AiService {
  Future<String> summarize(String text, FeedItem feedItem);

  Future<List<FeedItem>> getNewsSuggestions(List<FeedItem> feedItems, List<String> userInterests, List<Feed> mostReadFeeds);
}
