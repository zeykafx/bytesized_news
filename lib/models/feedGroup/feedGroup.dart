import 'package:bytesized_news/models/feed/feed.dart';
import 'package:isar/isar.dart';

part 'feedGroup.g.dart';

@collection
class FeedGroup {
  Id id = Isar.autoIncrement;
  String name;
  List<String> feedNames = List.empty(growable: true);
  bool isPinned = false;
  int pinnedPosition = -1;

  @ignore
  List<Feed> feeds = [];

  FeedGroup(this.name);

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'feedNames': feedNames,
      'isPinned': isPinned,
      'pinnedPosition': pinnedPosition,
    };
  }

  // fromJson also fetches the feeds corresponding to the feed names
  FeedGroup.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        feedNames = List<String>.from(json['feedNames']),
        isPinned = json['isPinned'],
        pinnedPosition = json['pinnedPosition'] {
    // for (String feedName in feedNames) {}
  }
}
