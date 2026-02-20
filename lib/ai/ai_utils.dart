import 'package:bytesized_news/ai/ai_service/provider_ai_service.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feed_item/feed_item.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';

class AiUtils {
  late AuthStore authStore;
  late SettingsStore settingsStore;
  late ProviderAiService providerAiService;

  AiUtils(AuthStore aStore, SettingsStore setStore) {
    authStore = aStore;
    settingsStore = setStore;
    providerAiService = ProviderAiService(aStore, setStore);
  }

  Future<String> summarize(String text, FeedItem feedItem) async {
    return providerAiService.summarize(text, feedItem);
  }

  Future<List<FeedItem>> getNewsSuggestions(List<FeedItem> feedItems, List<String> userInterests, List<Feed> mostReadFeeds) async {
    return providerAiService.getNewsSuggestions(feedItems, userInterests, mostReadFeeds);
  }

  Future<List<String>> getFeedCategories(Feed feed) async {
    return providerAiService.getFeedCategories(feed);
  }

  Future<List<String>> buildUserInterests(List<Feed> feeds, List<String> userInterests) async {
    return providerAiService.buildUserInterests(feeds, userInterests);
  }

  /// Evaluates an LLM-generated summary against the full article using a Groq model.
  /// Returns a tuple of (useSummary, accuracyPercentage).
  Future<(bool, double)> evaluateSummary(String articleText, String summaryText) async {
    return providerAiService.evaluateSummary(articleText, summaryText);
  }
}
