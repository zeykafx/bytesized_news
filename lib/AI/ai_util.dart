import 'dart:convert';

import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AiUtils {
  int maxSummaryLength = 3;

  OpenAIClient client = OpenAIClient(
      apiKey: dotenv.env['GROQ_API_KEY']!,
      baseUrl: "https://api.groq.com/openai/v1");

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseFunctions functions =
      FirebaseFunctions.instanceFor(region: "europe-west1");
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> summarizeWithFirebase(
      FeedItem feedItem, String content) async {
    final result = await functions.httpsCallable('summarize').call(
      {
        "text": feedItem.url,
        "title": feedItem.title,
        "content": content,
      },
    );
    var response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      throw Exception(response["error"]);
    }
    return response["summary"];
  }

  Future<String> summarize(String text, FeedItem feedItem) async {
    // // check firestore for existing summary
    // var existingSummary = await firestore
    //     .collection("summaries")
    //     .where("url", isEqualTo: feedItem.url)
    //     .get();

    // if (existingSummary.docs.isNotEmpty) {
    //   if (kDebugMode) {
    //     print("Summary found in Firestore");
    //   }
    //   return existingSummary.docs.first.get("summary");
    // }

    if (kDebugMode) {
      print("Calling AI API...");
    }
    // get the summary of the article using OpenAI's API
    CreateChatCompletionResponse res = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.modelId(
          // 'gpt-4o-mini',
          // "llama-3.2-1b-preview",
          "llama-3.1-8b-instant",
        ),
        messages: [
          ChatCompletionMessage.system(
            content:
                "Summarize the article in $maxSummaryLength sentences, DO NOT OUTPUT A SUMMARY LONGER THAN $maxSummaryLength SENTENCES!! Stick to the information in the article. "
                "Do not add any new information, if an article refers to Twitter as 'X' do not do the same,"
                " instead refer to it as 'Twitter. Always provide a translation of the units of measurements "
                "used in the article (do so in parentheses). ONLY OUTPUT THE SUMMARY, NO INTRODUCTION LIKE \"Here is a summary...\"!"
                "If you can, use bullet points with proper formatting such that each bullet point starts on its own line.",
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(text),
          ),
        ],
        temperature: 0.3,
      ),
    );

    String summary =
        res.choices.first.message.content ?? "No summary was received...";

    if (kDebugMode) {
      print("Response: $summary");
    }

    var ret = await firestore.collection("summaries").add({
      "url": feedItem.url,
      "title": feedItem.title,
      "summary": summary,
      "generatedAt": DateTime.now().millisecondsSinceEpoch,
      "expirationTimestamp": DateTime.now().add(Duration(days: 30)),
    });

    if (kDebugMode) {
      print("Summary added to Firestore: ${ret.id}");
    }

    return summary;
  }

  Future<List<FeedItem>> getNewsSuggestions(
    List<FeedItem> feedItems,
    List<String> userInterests,
    List<Feed> mostReadFeeds,
  ) async {
    if (kDebugMode) {
      print("Calling AI API to get suggested news");
    }

    String todaysArticles = feedItems
        .map((item) =>
            "ID: ${item.id} - Title: ${item.title} - FeedName: ${item.feedName}")
        .join(", ");

    String mostReadFeedsString = mostReadFeeds
        .map((Feed feed) =>
            "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}, Categories: ${feed.categories.join(",")}")
        .join(",");

    if (kDebugMode) {
      print("today's articles: $todaysArticles");
    }

    // get the summary of the article using OpenAI's API
    CreateChatCompletionResponse res = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        responseFormat: ResponseFormat.jsonObject(),
        model: const ChatCompletionModel.modelId(
          // "llama-3.1-8b-instant",
          "llama-3.2-3b-preview",
          // "llama-3.3-70b-versatile",
          // "deepseek-r1-distill-llama-70b",
        ),
        messages: [
          ChatCompletionMessage.system(
            content:
                "You are a helpful news suggestion AI, you will receive a list of categories that the user is interested in, the feeds that the user reads the most, and today's unread articles"
                "You must return a list of the top 5 most interesting articles (in json format) for this user based on their interests while considering which articles would get the most clicks online and their interest in that feed. the article's IDs must not be changed (Ignore any article advertising deals/coupons or podcasts!)"
                "The format must be the following: A json object with the key 'articles' which is an array of json object, each object has an ID (number), a title (string) and the feed name (string)",
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
                "News interests: ${userInterests.join(',')}"),
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
                "Most Read Feeds: $mostReadFeedsString"),
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
                "Today's articles: $todaysArticles"),
          ),
        ],
        temperature: 0.6,
      ),
    );

    String jsonOutput = res.choices.first.message.content ?? "[]";
    var jsonData = jsonDecode(jsonOutput);
    List<FeedItem> suggestedArticles = [];
    for (var article in jsonData['articles']) {
      int id = article['ID'];
      var feedItem = feedItems.firstWhere((item) => item.id == id,
          orElse: () => feedItems[0]);
      suggestedArticles.add(feedItem);
    }

    // Filter out duplicates
    suggestedArticles = suggestedArticles.toSet().toList();

    return suggestedArticles;
  }

  Future<List<String>> getFeedCategories(Feed feed) async {
    if (kDebugMode) {
      print("Calling AI API to get feed summaries.");
    }

    CreateChatCompletionResponse res = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        responseFormat: ResponseFormat.jsonObject(),
        model: const ChatCompletionModel.modelId(
          "llama-3.1-8b-instant",
        ),
        messages: [
          ChatCompletionMessage.system(
            content: """
                Analyze the following RSS Feed name and URL to infer relevant content categories. Consider keywords in both the name and URL path/domain. Return a JSON array of 3-5 most relevant categories under a "categories" key. Only output JSON.
                Example response for "TechCrunch": {"categories": ["Technology", "Startups", "Business", "Innovation"]}
                """,
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
              "Name: ${feed.name}, Link: ${feed.link}",
            ),
          ),
        ],
        temperature: 0.6,
      ),
    );

    String jsonOutput = res.choices.first.message.content ?? "[]";
    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      categories.add(category);
    }
    return categories;
  }

  Future<List<String>> buildUserInterests(
    List<Feed> feeds,
    List<String> userInterests,
  ) async {
    if (kDebugMode) {
      print("Calling AI API to build user interests.");
    }

    String mostReadFeedsString = feeds
        .map((Feed feed) =>
            "FeedName: ${feed.name} - ArticlesRead: ${feed.articlesRead}, Categories: ${feed.categories.join(",")}")
        .join(",");

    CreateChatCompletionResponse res = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        responseFormat: ResponseFormat.jsonObject(),
        model: const ChatCompletionModel.modelId(
          "llama-3.1-8b-instant",
        ),
        messages: [
          ChatCompletionMessage.system(
            content: """
                Analyze the following RSS Feeds names, categories, and the number of articles read from that feed to infer the user's categories of interest. Return a JSON array of 3-5 most relevant categories under a "categories" key. Only output JSON.
                Example response: {"categories": ["Technology", "Politics", "Android", "Mobile Phones"]}
                """,
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
              mostReadFeedsString,
            ),
          ),
        ],
        temperature: 0.6,
      ),
    );

    String jsonOutput = res.choices.first.message.content ?? "[]";
    var jsonData = jsonDecode(jsonOutput);
    List<String> categories = [];
    for (var category in jsonData['categories']) {
      categories.add(category);
    }
    return categories;
  }
}
