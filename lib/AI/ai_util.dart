import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openai_dart/openai_dart.dart';

class AiUtils {
  int maxSummaryLength = 3;

  OpenAIClient client = OpenAIClient(apiKey: dotenv.env['OPENAI_API_KEY']!);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        model: const ChatCompletionModel.modelId('gpt-4o-mini'),
        messages: [
          ChatCompletionMessage.system(
            content: 'Summarize the article in $maxSummaryLength sentences. Stick to the information in the article. Do not add any new information.',
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
