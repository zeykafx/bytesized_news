import 'dart:convert';

import 'package:bytesized_news/AI/ai_service/ai_service.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAiService extends AiService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: "europe-west1");
  FirebaseAuth auth = FirebaseAuth.instance;
  late AuthStore authStore;
  late SettingsStore settingsStore;

  FirebaseAiService(AuthStore aStore, SettingsStore setStore) {
    authStore = aStore;
    settingsStore = setStore;
  }

  @override
  Future<String> summarize(String text, FeedItem feedItem) async {
    if (authStore.userTier != Tier.premium) {
      if (kDebugMode) {
        print("Error: Not a premium account");
      }
      throw Exception("Error: You are not allowed to perform this operation.");
    }

    if (text.length < 500) {
      throw Exception("Error: The article is too short to summarize.");
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
    final result = await functions.httpsCallable('summarize').call({
      "text": feedItem.url,
      "title": feedItem.title,
      "content": text,
      "length": settingsStore.summaryLength,
    });
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }
    String summary = response["summary"];

    if (kDebugMode) {
      print("Received summary from cloud function");
    }

    authStore.summariesLeftToday = response["summariesLeftToday"];
    authStore.lastSummaryDate = DateTime.now().toUtc();
    return summary;
  }

  @override
  Future<List<FeedItem>> getNewsSuggestions(List<FeedItem> feedItems, List<String> userInterests, List<Feed> mostReadFeeds) async {
    if (authStore.userTier != Tier.premium) {
      if (kDebugMode) {
        print("Error: Not a premium account");
      }
      throw Exception("Error: You are not allowed to perform this operation.");
    }

    if (kDebugMode) {
      print("Calling AI API to get suggested news");
    }

    String todaysArticles = feedItems.map((item) => "ID:${item.id}, Title: ${item.title}, FeedName: ${item.feed?.name}").join(", ");

    String mostReadFeedsString = mostReadFeeds.map((Feed feed) => "FeedName: ${feed.name}, ArticlesRead: ${feed.articlesRead}").join(",");

    String userInterestsString = userInterests.take(30).join(',');

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
      if (article.containsKey("id")) {
        int id = article['id'];
        FeedItem feedItem;
        try {
          feedItem = feedItems.firstWhere((item) => item.id == id);
          suggestedArticles.add(feedItem);
        } catch (e, stack) {
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
          
          continue;
        }
      } else {
        continue;
      }
    }

    // Filter out duplicates
    suggestedArticles = suggestedArticles.toSet().toList();

    authStore.suggestionsLeftToday = response["suggestionsLeftToday"];
    authStore.lastSuggestionDate = DateTime.now().toUtc();

    return suggestedArticles;
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
      print("Calling firebase AI service to build user interests.");
    }

    String mostReadFeedsString = feeds
        .map((Feed feed) => "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}, Categories: ${feed.categories.join(",")}")
        .join(",");

    String currentInterests = userInterests.join(", ");

    final result = await functions.httpsCallable('buildUserInterests').call({"mostReadFeedsString": mostReadFeedsString, "currentInterests": currentInterests});
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }

    var jsonOutput = response["categoriesJson"];
    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      if (!userInterests.contains(category)) {
        categories.add(category);
      }
    }
    return categories;
  }
  
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
