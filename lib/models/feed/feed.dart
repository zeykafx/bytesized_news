import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:isar/isar.dart';

part 'feed.g.dart';

@collection
class Feed {
  Id id = Isar.autoIncrement;
  String name;
  String link;
  late String iconUrl;

  bool isPinned = false;
  int pinnedPosition = -1;
  int articlesRead = 0;

  List<String> categories = [];

  Feed(this.name, this.link, this.iconUrl);

  static Future<Feed?> createFeed(String url, {String feedName = ""}) async {
    Dio dio = Dio();
    Response response;
    try {
      response = await dio.get(url, options: Options(receiveTimeout: Duration(seconds: 5)));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }

    Document document = parse(response.data);

    String title = "";
    if (feedName.isEmpty) {
      title = _cleanTitle(document.querySelector('title')?.text ?? "No title");
    } else {
      title = feedName;
    }

    String iconUrl = document.querySelector("icon")?.innerHtml ?? "https://cdn.brandfetch.io/${Uri.parse(url).host}/fallback/lettermark?c=1ida5nT4eR28egqMeiL";

    return Feed(title, url, iconUrl);
  }

  static String _cleanTitle(String rawTitle) {
    // remove CDATA markers
    String cleaned = rawTitle.replaceAll(RegExp(r'<!\[CDATA\['), '');
    cleaned = cleaned.replaceAll(RegExp(r'\]\]>'), '');

    return cleaned.trim();
  }

  @override
  String toString() {
    return 'Feed{id: $id, name: $name, link: $link, iconUrl: $iconUrl}';
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'iconUrl': iconUrl,
      'isPinned': isPinned,
      'pinnedPosition': pinnedPosition,
      'articlesRead': articlesRead,
      "categories": categories,
    };
  }

  // fromJson
  Feed.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'] ?? 0,
        link = json['link'],
        iconUrl = json['iconUrl'],
        isPinned = json['isPinned'],
        pinnedPosition = json['pinnedPosition'],
        articlesRead = json["articlesRead"],
        categories = List.from(json["categories"]);
}
