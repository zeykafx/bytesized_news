import 'package:bytesized_news/models/feed/feed.dart';
import 'package:isar/isar.dart';

part 'feedGroup.g.dart';

@collection
class FeedGroup {
  Id id = Isar.autoIncrement;
  final String name;
  List<String> feedNames = List.empty(growable: true);

  @ignore
  List<Feed> feeds = [];

  FeedGroup(this.name);
}
