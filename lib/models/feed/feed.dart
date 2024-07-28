import 'package:isar/isar.dart';

part 'feed.g.dart';

@collection
class Feed {
  Id id = Isar.autoIncrement;
  final String name;
  final String link;
  final String description;

  Feed(this.name, this.link, this.description);

  @override
  String toString() {
    return 'Feed{name: $name, link: $link, description: $description}';
  }
}
