import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:isar/isar.dart';

part 'feed.g.dart';

@collection
class Feed {
  Id id = Isar.autoIncrement;
  final String name;
  final String link;
  late String iconUrl;

  bool isPinned = false;
  int pinnedPosition = -1;

  Feed(this.name, this.link) {
    Uri uri = Uri.parse(link);
    // iconUrl = "https://icon.horse/icon/${uri.host}";
    iconUrl = "https://cdn.brandfetch.io/${uri.host}/fallback/lettermark/";
  }

  static Future<Feed> createFeed(String url) async {
    Dio dio = Dio();
    Response response = await dio.get(url);
    Document document = parse(response.data);
    String? title = document.querySelector('title')?.text;

    return Feed(title ?? 'Untitled Feed', url);
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
    };
  }

  // fromJson
  Feed.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'] ?? 0,
        link = json['link'],
        iconUrl = json['iconUrl'],
        isPinned = json['isPinned'],
        pinnedPosition = json['pinnedPosition'];
}
