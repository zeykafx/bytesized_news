import 'dart:convert';

import 'package:bytesized_news/AI/ai_service/ai_service.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:llm_dart/llm_dart.dart';

class ProviderAiService extends AiService {
  late SettingsStore settingsStore;
  late AuthStore authStore;
  late AiProvider aiProvider;
  bool aiProviderInit = false;
  late DbUtils dbUtils;

  ProviderAiService(AuthStore aStore, SettingsStore setStore) {
    authStore = aStore;
    settingsStore = setStore;
    dbUtils = DbUtils(isar: Isar.getInstance()!);
    dbUtils.getActiveAiProvider().then((provider) {
      aiProvider = provider ?? defaultProviders.first;
      aiProviderInit = true;
    });
  }

  Future<void> getAiProviderAndCheckUsable() async {
    aiProvider = await dbUtils.getActiveAiProvider() ?? defaultProviders.first;
    if (aiProvider.apiKey.isEmpty) {
      throw Exception("Error: Provide an api key for ${aiProvider.name}");
    }

    if (aiProvider.apiLink.isEmpty) {
      throw Exception("Error: Provide a base URL for ${aiProvider.name}");
    }
  }

  @override
  Future<String> summarize(String text, FeedItem feedItem) async {
    await getAiProviderAndCheckUsable();

    if (kDebugMode) {
      print("Using custom provider ${aiProvider.name} to summarize article: ${feedItem.toString()}");
    }

    if (text.length < 500) {
      throw Exception("Error: The article is too short to summarize.");
    }

    ChatCapability provider;
    if (aiProvider.devName == "openrouter") {
      provider = await ai()
          .openRouter()
          .baseUrl(aiProvider.apiLink)
          .apiKey(aiProvider.apiKey)
          .model(aiProvider.models[aiProvider.modelToUseIndex])
          .temperature(aiProvider.temperature)
          .build();
    } else {
      provider = await createProvider(
        providerId: aiProvider.devName,
        apiKey: aiProvider.apiKey,
        model: aiProvider.models[aiProvider.modelToUseIndex],
        baseUrl: aiProvider.apiLink,
        temperature: aiProvider.temperature,
      );
    }

    List<ChatMessage> messages = [
      ChatMessage.system("""
        ### Role
        You are a precise article summarizer. Extract only the essential information without adding interpretations or new content.

        ### Instructions
        - Summarize the article in exactly ${settingsStore.summaryLength} bullet points
        - Each bullet point must start on a new line with a proper bullet character (•)
        - Convert units of measurement between metric and imperial systems (provide in parentheses)
        - Maintain factual accuracy
        - include ONLY information present in the original text
        - Keep each bullet concise and focused on one key point

        ### Context
        The article requires concise summarization while preserving all critical information.

        ### Expected Output Format
        • [First key point from the article]
        • [Second key point from the article]
        • [Third key point from the article]

        ### Constraints
        - NO introductory phrases like "Here is a summary..."
        - NO concluding remarks
        - NO additional context or opinions
        - STRICTLY adhere to bullet point format
        - Ignore any introduction text about the author and their previous job/work.
        """),
      ChatMessage.user(text),
    ];
    ChatResponse response = await provider.chat(messages);

    if (kDebugMode) {
      print("Generated summary with provider ${aiProvider.name} (model: ${aiProvider.models[aiProvider.modelToUseIndex]})");
    }

    return response.text ?? "No response";
  }

  @override
  Future<List<FeedItem>> getNewsSuggestions(List<FeedItem> feedItems, List<String> userInterests, List<Feed> mostReadFeeds) async {
    await getAiProviderAndCheckUsable();

    String todaysArticles = feedItems.map((item) => "ID:${item.id}, Title: ${item.title}, FeedName: ${item.feed?.name}").join(", ");

    String mostReadFeedsString = mostReadFeeds.map((Feed feed) => "FeedName: ${feed.name}, ArticlesRead: ${feed.articlesRead}").join(",");

    String userInterestsString = userInterests.take(30).join(',');

    String modelToUse = aiProvider.useSameModelForSuggestions
        ? aiProvider.models[aiProvider.modelToUseIndex]
        : aiProvider.models[aiProvider.modelToUseIndexForSuggestions];

    ChatCapability provider;
    if (aiProvider.devName == "openrouter") {
      provider = await ai()
          .openRouter()
          .baseUrl(aiProvider.apiLink)
          .apiKey(aiProvider.apiKey)
          .model(modelToUse)
          .temperature(aiProvider.temperature)
          .responseFormat("json")
          .build();
    } else {
      provider = await createProvider(
        providerId: aiProvider.devName,
        apiKey: aiProvider.apiKey,
        model: modelToUse,
        baseUrl: aiProvider.apiLink,
        temperature: aiProvider.temperature,
        extensions: {"responseFormat": "json"},
      );
    }

    if (kDebugMode) {
      print("Fetching suggestions from provider ${aiProvider.name} with model ${modelToUse}");
    }

    List<ChatMessage> messages = [
      ChatMessage.system("""
        You are an expert news curation AI that personalizes article recommendations for RSS reader users.

        TASK: Select at least 5 articles (no more than 10) from today's unread articles that best match the user's interests
        and reading patterns.

        SELECTION CRITERIA (in order of priority):
        1. Relevance to user's stated interests and categories
        2. Source preference based on user's most-read feeds
        3. Article quality and newsworthiness (avoid clickbait)
        4. Timeliness and current relevance

        STRICT REQUIREMENTS:
        - Return AT LEAST 5 articles, MAX 10
        - Preserve original article IDs unchanged
        - Prioritize articles from feeds the user reads most frequently
        - INCLUDE: substantive news, analysis, educational content
        - EXCLUDE: promotional content, deals, coupons, advertisements, podcasts
        - Balance between user preferences and editorial quality

        OUTPUT FORMAT:
        - Return a JSON object that follows this schema DO NOT INCLUDE AN INTRODUCTION, just the JSON.
        - Do not format the response with "```json ..." or anything else, just the json.
        - For each item, only output the id, not the title or the feedName:
        "
          schema: {
            type: "object",
            properties: {
              articles: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    id: { type: "number" },
                  },
                },
              },
            },
          },
          "
        """),
      ChatMessage.user("News Interests: $userInterestsString"),
      ChatMessage.user("Most Read Feeds: $mostReadFeedsString"),
      ChatMessage.user("Today's articles: $todaysArticles"),
    ];
    ChatResponse response = await provider.chat(messages);
    var jsonOutput = response.text ?? "{}";

    var jsonData = jsonDecode(jsonOutput);
    List<FeedItem> suggestedArticles = [];
    for (var article in jsonData['articles']) {
      if (article.containsKey("id")) {
        int id = article['id'];
        FeedItem feedItem;
        try {
          feedItem = feedItems.firstWhere((item) => item.id == id);
          suggestedArticles.add(feedItem);
        } catch (e) {
          continue;
        }
      } else {
        continue;
      }
    }

    // Filter out duplicates
    suggestedArticles = suggestedArticles.toSet().toList();

    authStore.lastSuggestionDate = DateTime.now().toUtc();
    return suggestedArticles;
  }
}
