import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:isar/isar.dart';

part 'story_reading.g.dart';

@collection
class StoryReading {
  Id id = Isar.autoIncrement;
  int feedItemId;
  int feedId;

  int readingDuration;
  List<DateTime> readLog = [];

  @ignore
  late Feed feed;
  @ignore
  late DbUtils dbUtils;
  @ignore
  Isar isar = Isar.getInstance()!;

  StoryReading(this.feedItemId, this.feedId, this.readingDuration, this.readLog);

  void initFeed() {
    dbUtils = DbUtils(isar: isar);

    Feed? feedOrNull = dbUtils.getFeedWithId(feedId);

    if (feedOrNull == null) {
      throw Exception("Feed is null for reading id $id, with feedId $feedId, and feed item id $feedItemId");
    }

    feed = feedOrNull;
  }

  @override
  String toString() {
    return "StoryReading{id: $id, feedItemId: $feedItemId, feedId: $feedId, readingDuration: $readingDuration, readLog: ${readLog.toString()}}";
  }
}
