import 'dart:convert';

import 'package:bytesized_news/AI/ai_service/firebase_ai_service.dart';
import 'package:bytesized_news/AI/ai_service/provider_ai_service.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AiUtils {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: "europe-west1");
  FirebaseAuth auth = FirebaseAuth.instance;
  late AuthStore authStore;
  late SettingsStore settingsStore;
  late FirebaseAiService firebaseAiService;
  late ProviderAiService providerAiService;

  AiUtils(AuthStore aStore, SettingsStore setStore) {
    authStore = aStore;
    settingsStore = setStore;
    firebaseAiService = FirebaseAiService(aStore, setStore);
    providerAiService = ProviderAiService(aStore, setStore);
  }

  Future<String> summarize(String text, FeedItem feedItem) async {
    if (settingsStore.enableCustomAiProvider) {
      return providerAiService.summarize(text, feedItem);
    } else {
      return firebaseAiService.summarize(text, feedItem);
    }
  }

  Future<List<FeedItem>> getNewsSuggestions(List<FeedItem> feedItems, List<String> userInterests, List<Feed> mostReadFeeds) async {
    if (settingsStore.enableCustomAiProvider) {
      return providerAiService.getNewsSuggestions(feedItems, userInterests, mostReadFeeds);
    } else {
      return firebaseAiService.getNewsSuggestions(feedItems, userInterests, mostReadFeeds);
    }
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
    if (settingsStore.enableCustomAiProvider) {
      return providerAiService.buildUserInterests(feeds, userInterests);
    } else {
      return firebaseAiService.buildUserInterests(feeds, userInterests);
    }
  }
  // Future<List<String>> buildUserInterests(List<Feed> feeds, List<String> userInterests) async {
  //   if (kDebugMode) {
  //     print("Calling AI API to build user interests.");
  //   }

  //   String mostReadFeedsString = feeds
  //       .map((Feed feed) => "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}, Categories: ${feed.categories.join(",")}")
  //       .join(",");

  //   final result = await functions.httpsCallable('buildUserInterests').call({"mostReadFeedsString": mostReadFeedsString});
  //   var response = result.data as Map<String, dynamic>;
  //   if (response["error"] != null) {
  //     throw Exception(response["error"]);
  //   }

  //   var jsonOutput = response["categoriesJson"];
  //   var jsonData = jsonDecode(jsonOutput);
  //   List<String> categories = [];
  //   for (var category in jsonData['categories']) {
  //     categories.add(category);
  //   }
  //   return categories;
  // }

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
