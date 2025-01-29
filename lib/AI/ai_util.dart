import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AiUtils {
  int maxSummaryLength = 3;

  OpenAIClient client = OpenAIClient(apiKey: dotenv.env['GROQ_API_KEY']!, baseUrl: "https://api.groq.com/openai/v1");

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: "europe-west1");
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> summarizeWithFirebase(FeedItem feedItem, String content) async {
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
    // check firestore for existing summary
    var existingSummary = await firestore.collection("summaries").where("url", isEqualTo: feedItem.url).get();

    if (existingSummary.docs.isNotEmpty) {
      if (kDebugMode) {
        print("Summary found in Firestore");
      }
      return existingSummary.docs.first.get("summary");
    }

    if (kDebugMode) {
      print("Calling OpenAI API...");
    }
    // get the summary of the article using OpenAI's API
    CreateChatCompletionResponse res = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.modelId(
          // 'gpt-4o-mini',
          "llama-3.2-1b-preview",
        ),
        messages: [
          ChatCompletionMessage.system(
            content: "Summarize the article in $maxSummaryLength sentences, NOT MORE! Stick to the information in the article. " +
                "Do not add any new information, if an article refers to Twitter as 'X' do not do the same," +
                " instead refer to it as 'Twitter. Always provide a translation of the units of measurements " +
                "used in the article (do so in parentheses). ONLY OUTPUT THE SUMMARY, NO INTRODUCTION LIKE \"Here is a summary...\"!",
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(text),
          ),
        ],
        temperature: 0,
      ),
    );

    if (kDebugMode) {
      print("Response: ${res.choices.first.message.content}");
    }

    var ret = await firestore.collection("summaries").add({
      "url": feedItem.url,
      "summary": res.choices.first.message.content,
      "generatedAt": DateTime.now().millisecondsSinceEpoch,
    });

    if (kDebugMode) {
      print("Summary added to Firestore: ${ret.id}");
    }

    return res.choices.first.message.content ?? "No summary available";
  }
}
