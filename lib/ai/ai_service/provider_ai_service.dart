import 'dart:convert';

import 'package:bytesized_news/AI/ai_service/ai_service.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feed_item/feed_item.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    if (aiProvider.apiKey.isEmpty && aiProvider.needsApiKey) {
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
      print("Fetching suggestions from provider ${aiProvider.name} with model $modelToUse");
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
    // String actualResponse = response.text ?? "{}";
    // print(response.text);
    // if (response.text != null && response.text!.contains("<answer>")) {
    //   int answerStart = response.text!.indexOf("<answser>");
    //   int answerEnd = response.text!.indexOf("</answser>");
    //   print("answer start: $answerStart");
    //   actualResponse = response.text!.substring(answerStart, answerEnd);
    //   print(actualResponse);
    // }
    var jsonOutput = response.text ?? "{}";

    if (jsonOutput.startsWith("```json")) {
      jsonOutput = jsonOutput.replaceAll("```json", "");
      jsonOutput = jsonOutput.replaceAll("```", "");
    }

    var jsonData = jsonDecode(jsonOutput);
    List<FeedItem> suggestedArticles = [];
    for (var article in jsonData['articles']) {
      if (article is Map && article.containsKey("id")) {
        int id;
        if (article["id"] is String) {
          id = int.parse(article["id"]);
        } else {
          id = article['id'];
        }
        FeedItem feedItem;
        try {
          feedItem = feedItems.firstWhere((item) => item.id == id);
          suggestedArticles.add(feedItem);
        } catch (e, stack) {
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);

          continue;
        }
      } else if (article is int) {
        try {
          FeedItem feedItem = feedItems.firstWhere((item) => item.id == article);
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

    authStore.lastSuggestionDate = DateTime.now().toUtc();
    return suggestedArticles;
  }

  Future<List<String>> buildUserInterests(List<Feed> feeds, List<String> userInterests) async {
    String mostReadFeedsString = feeds
        .map((Feed feed) => "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}, Categories: ${feed.categories.join(",")}")
        .join(",");

    String currentInterests = userInterests.join(", ");

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
          .temperature(0.5)
          .responseFormat("json")
          .build();
    } else {
      provider = await createProvider(
        providerId: aiProvider.devName,
        apiKey: aiProvider.apiKey,
        model: modelToUse,
        baseUrl: aiProvider.apiLink,
        temperature: 0.5,
        extensions: {"responseFormat": "json"},
      );
    }

    if (kDebugMode) {
      print("Calling ${aiProvider.name} with model $modelToUse to build user interests.");
    }

    List<ChatMessage> messages = [
      ChatMessage.system("""
        ### Role
        You are an expert user interest analyzer for a news recommendation system. Your task is to analyze RSS feed data to identify the user's true interests based on their reading patterns.

        ### Input Data Format
        You'll receive feed information in this format:
        "FeedName: [name] - ArticlesRead: [count], Categories: [category1,category2,...]" (categories may be empty)

        ### Analysis Instructions
        1. Prioritize feeds with higher article counts as stronger interest indicators
        2. Consider both explicit feed categories and implicit topics from feed names
        3. Balance between specific interests (e.g., "iOS Development") and broader categories (e.g., "Technology")
        4. Identify patterns across multiple feeds that suggest common interests
        5. Infer likely interests even when categories aren't explicitly provided
        6. Use the user's current interests to refine their taste profile

        ### Response Requirements
        - Extract 3-5 most relevant interest categories based on reading patterns
        - Include a mix of specific and general interests when appropriate
        - Avoid overly broad categories unless clearly dominant
        - Ensure categories are useful for content recommendation

        ### OUTPUT FORMAT
        Return ONLY a valid JSON object with a "categories" array containing 3-5 string values.
        Do not include explanations, markdown formatting, or code blocks.

        Example response: {"categories": ["Technology", "Politics", ...]}
        """),
      ChatMessage.user("Most Read Feeds: $mostReadFeedsString"),
      ChatMessage.user("User's current interests: $currentInterests"),
    ];
    ChatResponse response = await provider.chat(messages);
    var jsonOutput = response.text ?? "{}";

    if (jsonOutput.startsWith("```json")) {
      jsonOutput = jsonOutput.replaceAll("```json", "");
      jsonOutput = jsonOutput.replaceAll("```", "");
    }

    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      if (!userInterests.contains(category)) {
        categories.add(category);
      }
    }

    if (kDebugMode) {
      print("User interest categories: $categories");
    }
    return categories;
  }

  Future<(bool, double)> evaluateSummary(String articleText, String summaryText) async {
    if (articleText.isEmpty || summaryText.isEmpty) {
      throw Exception("Missing article text or summary text");
    }

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
          .temperature(0.5)
          .responseFormat("json")
          .build();
    } else {
      provider = await createProvider(
        providerId: aiProvider.devName,
        apiKey: aiProvider.apiKey,
        model: modelToUse,
        baseUrl: aiProvider.apiLink,
        temperature: 0.5,
        extensions: {"responseFormat": "json"},
      );
    }

    if (kDebugMode) {
      print("Calling ${aiProvider.name} with model $modelToUse to evaluate the summary for an article");
    }

    List<ChatMessage> messages = [
      ChatMessage.system("""
        ### Role
        You are an expert summary evaluation system. Your task is to assess the quality, accuracy, and usability of article summaries.

        ### Evaluation Criteria
        Carefully analyze the original article and summary for:

        1. Factual Accuracy:
           - Are all stated facts consistent with the original article?
           - Are there any hallucinations or fabricated information?
           - Weight: 40% of total score

        2. Comprehensiveness:
           - Does the summary include the most important points from the article?
           - Are key statistics, names, and events preserved?
           - Weight: 30% of total score

        3. Clarity & Usability:
           - Is the summary well-structured and easy to understand?
           - Does it follow the requested bullet point format?
           - Does it maintain proper context for statements?
           - Weight: 30% of total score

        ### Scoring Guidelines
        - Critical factual errors automatically reduce accuracy below 70%
        - Multiple hallucinations should result in a "do not use" recommendation
        - Minor omissions of secondary details are acceptable
        - Summaries below 75% accuracy should generally not be used

        ### OUTPUT FORMAT
        OUTPUT ONLY THE JSON STRING, this string is parsed as json directly
        Return ONLY a JSON object with these exact keys:
        - "useSummary" (boolean): true if summary meets minimum quality standards
        - "accuracy" (float): percentage score from 0.0 to 100.0

        Example: {"useSummary": true, "accuracy": 85.5}
        """),
      ChatMessage.user("Article: $articleText"),
      ChatMessage.user("Summary: $summaryText"),
    ];
    ChatResponse response = await provider.chat(messages);
    var jsonOutput = response.text ?? "{}";

    if (jsonOutput.startsWith("```json")) {
      jsonOutput = jsonOutput.replaceAll("```json", "");
      jsonOutput = jsonOutput.replaceAll("```", "");
    }

    var jsonData = jsonDecode(jsonOutput);
    bool useSummary = jsonData["useSummary"];
    double accuracy = jsonData["accuracy"];
    return (useSummary, accuracy);
  }

  Future<List<String>> getFeedCategories(Feed feed) async {
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
          .temperature(0.5)
          .responseFormat("json")
          .build();
    } else {
      provider = await createProvider(
        providerId: aiProvider.devName,
        apiKey: aiProvider.apiKey,
        model: modelToUse,
        baseUrl: aiProvider.apiLink,
        temperature: 0.5,
        extensions: {"responseFormat": "json"},
      );
    }

    if (kDebugMode) {
      print("Calling ${aiProvider.name} with model $modelToUse to get ${feed.name} categories.");
    }

    List<ChatMessage> messages = [
      ChatMessage.system("""
        Role:
        You are a content categorization specialist. Your task is to analyze RSS feed information and determine the most relevant content categories.

        INPUT ANALYSIS:
        - Examine the feed name for topic-specific keywords, brand indicators, and subject matter clues
        - Analyze the URL domain and path for additional context (e.g., tech.com, sports/basketball, finance/markets)
        - Consider both explicit terms and implicit meanings (e.g., "Hacker News" relates to Technology, not illegal activities)

        CATEGORIZATION GUIDELINES:
        - Generate 3-5 categories that best represent the feed's content scope
        - Use clear, standardized category names (e.g., "Technology", "Sports", "Politics", "Business", "Science")
        - Balance between specific niches and broader topics for better discoverability
        - Prioritize categories that users would likely search for or filter by
        - Avoid overly generic terms like "News" or "Articles" unless specifically appropriate

        EXAMPLES:
        - "TechCrunch" → Technology, Startups, Business, Innovation
        - "ESPN NBA" → Sports, Basketball, Entertainment
        - "The Economist" → Business, Politics, Economics, Finance
        - "Science Daily" → Science, Research, Technology, Health

        OUTPUT REQUIREMENTS:
        - Return ONLY valid JSON in this exact format: {"categories": ["Category1", "Category2", "Category3"]}
        - Use proper JSON syntax with double quotes
        - OUTPUT ONLY THE JSON STRING, this string is parsed as json directly
        - Include 3-5 categories maximum
        - Categories should be title-cased (first letter capitalized)
        """),
      ChatMessage.user("Feed name: ${feed.name}"),
      ChatMessage.user("Feed link: ${feed.link}"),
    ];
    ChatResponse response = await provider.chat(messages);
    var jsonOutput = response.text ?? "{}";

    if (jsonOutput.startsWith("```json")) {
      jsonOutput = jsonOutput.replaceAll("```json", "");
      jsonOutput = jsonOutput.replaceAll("```", "");
    }

    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      categories.add(category);
    }

    if (kDebugMode) {
      print("Categories for ${feed.name}: $categories");
    }
    return categories;
  }
}
