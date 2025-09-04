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
    if (settingsStore.enableCustomAiProvider) {
      return providerAiService.getFeedCategories(feed);
    } else {
      return firebaseAiService.getFeedCategories(feed);
    }
  }

  Future<List<String>> buildUserInterests(List<Feed> feeds, List<String> userInterests) async {
    if (settingsStore.enableCustomAiProvider) {
      return providerAiService.buildUserInterests(feeds, userInterests);
    } else {
      return firebaseAiService.buildUserInterests(feeds, userInterests);
    }
  }

  /// Evaluates an LLM-generated summary against the full article using a Groq model.
  /// Returns a tuple of (useSummary, accuracyPercentage).
  Future<(bool, double)> evaluateSummary(String articleText, String summaryText) async {
    if (settingsStore.enableCustomAiProvider) {
      return providerAiService.evaluateSummary(articleText, summaryText);
    } else {
      return firebaseAiService.evaluateSummary(articleText, summaryText);
    }
  }
}
