import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:isar/isar.dart';

class ReadingStats {
  Isar isar = Isar.getInstance()!;
  late DbUtils dbUtils;
  DateTime lastDateTime = DateTime.now();

  late StoryReading reading;

  ReadingStats() {
    dbUtils = DbUtils(isar: isar);
  }

  Future<void> startReadingStory(FeedItem feedItem) async {
    StoryReading? existingReading = await dbUtils.getReadingWithStoryId(feedItem.id);
    if (existingReading != null) {
      reading = existingReading;
      updateReadingStory(feedItem);
      return;
    }

    List<DateTime> readlog = [DateTime.now()];
    reading = StoryReading(feedItem.id, feedItem.feedId, 0, readlog, DateTime.now());
    reading.initFeed();
    dbUtils.addReading(reading);
  }

  void updateReadingStory(FeedItem feedItem) {
    DateTime now = DateTime.now();

    reading.readLog.add(now);

    Duration duration = now.difference(lastDateTime);
    reading.readingDuration = reading.readingDuration + duration.inSeconds;
    lastDateTime = now;

    dbUtils.updateReading(reading);
  }
}
