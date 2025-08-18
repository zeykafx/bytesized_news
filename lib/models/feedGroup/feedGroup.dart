import 'package:bytesized_news/models/feed/feed.dart';
import 'package:isar/isar.dart';

part 'feedGroup.g.dart';

@collection
class FeedGroup {
  Id id = Isar.autoIncrement;
  String name;
  List<String> feedUrls = List.empty(growable: true);
  bool isPinned = false;
  int pinnedPosition = -1;

  @ignore
  List<Feed> feeds = [];

  FeedGroup(this.name);

  @override
  String toString() {
    return 'FeedGroup{id: $id, name: $name, feedUrls: ${feedUrls.toString()}}';
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'feedUrls': feedUrls, 'isPinned': isPinned, 'pinnedPosition': pinnedPosition};
  }

  // fromJson also fetches the feeds corresponding to the feed names
  FeedGroup.fromJson(Map<String, dynamic> json)
    : id = json["id"],
      name = json['name'],
      feedUrls = List<String>.from(json['feedUrls']),
      isPinned = json['isPinned'],
      pinnedPosition = json['pinnedPosition'];
}
