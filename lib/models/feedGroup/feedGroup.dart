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
}
