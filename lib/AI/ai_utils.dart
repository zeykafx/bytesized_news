import 'dart:convert';

import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AiUtils {
  int maxSummaryLength = 3;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: "europe-west1");
  FirebaseAuth auth = FirebaseAuth.instance;
  late AuthStore authStore;

  AiUtils(AuthStore aStore) {
    authStore = aStore;
  }

  Future<(String, int)> summarize(String text, FeedItem feedItem) async {
    if (authStore.userTier != Tier.premium) {
      if (kDebugMode) {
        print("Error: Not a premium account");
      }
      throw Exception("Error: You are not allowed to perform this operation.");
    }
    if (authStore.summariesLeftToday <= 0) {
      if (kDebugMode) {
        print("Error: No more summaries today");
      }
      throw Exception("Error: You reached the daily limit of summaries.");
    }

    if (kDebugMode) {
      print("Calling AI API...");
    }
    final result = await functions.httpsCallable('summarize').call({"text": feedItem.url, "title": feedItem.title, "content": text});
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }
    String summary = response["summary"];
    int summariesLeftToday = response["summariesLeftToday"];
    return (summary, summariesLeftToday);
  }

  Future<(List<FeedItem>, int)> getNewsSuggestions(List<FeedItem> feedItems, List<String> userInterests, List<Feed> mostReadFeeds) async {
    if (authStore.userTier != Tier.premium) {
      if (kDebugMode) {
        print("Error: Not a premium account");
      }
      throw Exception("Error: You are not allowed to perform this operation.");
    }

    if (kDebugMode) {
      print("Calling AI API to get suggested news");
    }

    String todaysArticles = feedItems.map((item) => "ID: ${item.id} - Title: ${item.title} - FeedName: ${item.feed?.name}").join(", ");

    String mostReadFeedsString = mostReadFeeds.map((Feed feed) => "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}").join(",");

    String userInterestsString = userInterests.join(',');

    if (kDebugMode) {
      print("today's articles: $todaysArticles");
    }

    final result = await functions.httpsCallable('getNewsSuggestions').call({
      "todaysArticles": todaysArticles,
      "mostReadFeedsString": mostReadFeedsString,
      "userInterestsString": userInterestsString,
    });
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }

    var jsonOutput = response["suggestions"];

    var jsonData = jsonDecode(jsonOutput);
    List<FeedItem> suggestedArticles = [];
    for (var article in jsonData['articles']) {
      int id = article['id'] ?? 0;
      var feedItem = feedItems.firstWhere((item) => item.id == id, orElse: () => feedItems[0]);
      suggestedArticles.add(feedItem);
    }

    // Filter out duplicates
    suggestedArticles = suggestedArticles.toSet().toList();

    int suggestionsLeftToday = response["suggestionsLeftToday"];
    return (suggestedArticles, suggestionsLeftToday);
  }

  Future<List<String>> getFeedCategories(Feed feed) async {
    if (authStore.userTier != Tier.premium) {
      if (kDebugMode) {
        print("Error: Not a premium account");
      }
      throw Exception("Error: You are not allowed to perform this operation.");
    }
    if (kDebugMode) {
      print("Calling AI API to get feed summaries.");
    }

    final result = await functions.httpsCallable('analyzeFeedCategories').call({"feedName": feed.name, "feedLink": feed.link});
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }

    var jsonOutput = response["categoriesJson"];

    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      categories.add(category);
    }
    return categories;
  }

  Future<List<String>> buildUserInterests(List<Feed> feeds, List<String> userInterests) async {
    if (kDebugMode) {
      print("Calling AI API to build user interests.");
    }

    String mostReadFeedsString = feeds
        .map((Feed feed) => "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}, Categories: ${feed.categories.join(",")}")
        .join(",");

    final result = await functions.httpsCallable('buildUserInterests').call({"mostReadFeedsString": mostReadFeedsString});
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }

    var jsonOutput = response["categoriesJson"];
    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      categories.add(category);
    }
    return categories;
  }

  /// Evaluates an LLM-generated summary against the full article using a Groq model.
  /// Returns a tuple of (useSummary, accuracyPercentage).
  Future<(bool, double)> evaluateSummary(String articleText, String summaryText) async {
    if (authStore.userTier != Tier.premium) {
      if (kDebugMode) {
        print("Error: Not a premium account");
      }
      throw Exception("Error: You are not allowed to perform this operation.");
    }

    if (kDebugMode) {
      print("Calling AI API to evaluate summary...");
    }
    final result = await functions.httpsCallable('evaluateSummary').call({'articleText': articleText, 'summaryText': summaryText});
    var response = result.data as Map<String, dynamic>;
    if (response['error'] != null) {
      throw Exception(response['error']);
    }

    bool useSummary = response['useSummary'] as bool;
    double accuracy = (response['accuracy'] as num).toDouble();
    return (useSummary, accuracy);
  }
}
