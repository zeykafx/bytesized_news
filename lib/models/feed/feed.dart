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

  Feed(this.name, this.link, this.iconUrl);

  static Future<Feed> createFeed(String url, {String feedName = ""}) async {
    Dio dio = Dio();
    Response response = await dio.get(url);
    Document document = parse(response.data);

    String title = "";
    if (feedName.isEmpty) {
      title = document.querySelector('title')?.text ?? "No title";
    } else {
      title = feedName;
    }

    String iconUrl = document.querySelector("icon")?.innerHtml ?? "https://cdn.brandfetch.io/${Uri.parse(url).host}/fallback/lettermark/";

    return Feed(title, url, iconUrl);
  }

  // static Future<String> fetchFavicon(String url) async {
  //   try {
  //     url = url.split("/").getRange(0, 3).join("/");
  //     Uri uri = Uri.parse(url);
  //     http.Response result = await http.get(uri);
  //     if (result.statusCode == 200) {
  //       String htmlStr = result.body;
  //       Document dom = parse(htmlStr);
  //       List<Element> links = dom.getElementsByTagName("link");
  //       for (Element link in links) {
  //         String? rel = link.attributes["rel"];
  //         if ((rel == "icon" || rel == "shortcut icon") && link.attributes.containsKey("href")) {
  //           String? href = link.attributes["href"];
  //           // prefer png over svgs
  //           if (href!.endsWith(".svg")) {
  //             continue;
  //           }
  //
  //           Uri parsedUrl = Uri.parse(url);
  //           if (href.startsWith("//")) {
  //             return "${parsedUrl.scheme}:$href";
  //           } else if (href.startsWith("/")) {
  //             return url + href;
  //           } else {
  //             return href;
  //           }
  //         }
  //       }
  //     }
  //     url = "$url/favicon.ico";
  //     return url;
  //   } catch (exp) {
  //     Uri uri = Uri.parse(url);
  //     return "https://cdn.brandfetch.io/${uri.host}/fallback/lettermark/";
  //   }
  // }

  @override
  String toString() {
    return 'Feed{name: $name, link: $link, iconUrl: $iconUrl}';
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
