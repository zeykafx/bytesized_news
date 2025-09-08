import 'package:bytesized_news/background/life_cycle_event_handler.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed_item/feed_item.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

class ReadingStats {
  Isar isar = Isar.getInstance()!;
  late DbUtils dbUtils;

  // current reading session tracking
  DateTime? sessionStartTime;
  bool isTracking = false;
  bool isPaused = false;
  int currentSessionDuration = 0; // seconds accumulated in current session

  late StoryReading reading;

  ReadingStats() {
    dbUtils = DbUtils(isar: isar);
  }

  Future<void> startReadingStory(FeedItem feedItem) async {
    StoryReading? existingReading = await dbUtils.getReadingWithStoryId(feedItem.id);
    if (existingReading != null) {
      reading = existingReading;
    } else {
      List<DateTime> readlog = [DateTime.now()];
      reading = StoryReading(feedItem.id, feedItem.feedId, 0, readlog, DateTime.now());
      reading.initFeed();
      await dbUtils.addReading(reading);
    }

    startTrackingSession();
  }

  void startTrackingSession() {
    if (!isTracking) {
      isTracking = true;
      currentSessionDuration = 0;

      // only start timing if app is in foreground
      if (!lifecycleEventHandler.inBackground) {
        sessionStartTime = DateTime.now();
        isPaused = false;
      } else {
        sessionStartTime = null;
        isPaused = true;
      }

      if (kDebugMode) {
        print('Started reading session. App in background: ${lifecycleEventHandler.inBackground}');
      }
    }
  }

  void pauseTracking() {
    if (isTracking && !isPaused && sessionStartTime != null) {
      final currentTime = DateTime.now();
      final sessionTime = currentTime.difference(sessionStartTime!).inSeconds;
      currentSessionDuration += sessionTime;

      sessionStartTime = null;
      isPaused = true;

      if (kDebugMode) {
        print('Paused reading tracking. Session time so far: ${currentSessionDuration}s');
      }
    }
  }

  void resumeTracking() {
    if (isTracking && isPaused) {
      sessionStartTime = DateTime.now();
      isPaused = false;

      if (kDebugMode) {
        print('Resumed reading tracking');
      }
    }
  }

  void endReading(FeedItem feedItem) {
    if (!isTracking) return;
    int totalSessionTime = currentSessionDuration;

    if (!isPaused && sessionStartTime != null) {
      final currentTime = DateTime.now();
      final finalSessionTime = currentTime.difference(sessionStartTime!).inSeconds;
      totalSessionTime += finalSessionTime;
    }

    // only count sessions longer than 2 seconds, that way we avoid accidental taps
    if (totalSessionTime >= 2) {
      reading.readingDuration = reading.readingDuration + totalSessionTime;
      reading.readLog.add(DateTime.now());
      dbUtils.updateReading(reading);

      if (kDebugMode) {
        print('Ended reading session. Total session time: ${totalSessionTime}s, Total reading time: ${reading.readingDuration}s');
      }
    } else {
      if (kDebugMode) {
        print('Session too short (${totalSessionTime}s), not counting');
      }
    }

    isTracking = false;
    isPaused = false;
    sessionStartTime = null;
    currentSessionDuration = 0;
  }

  void handleAppPaused() {
    pauseTracking();
  }

  void handleAppResumed() {
    resumeTracking();
  }

  bool get isActivelyTracking => isTracking && !isPaused && sessionStartTime != null;

  int get currentSessionDurationSeconds {
    if (!isTracking) return 0;

    int duration = currentSessionDuration;
    if (!isPaused && sessionStartTime != null) {
      duration += DateTime.now().difference(sessionStartTime!).inSeconds;
    }
    return duration;
  }

  // on link clicked, pause and resume automatically
  void handleLinkClick() {
    if (isTracking && !isPaused) {
      pauseTracking();

      // resume after a short delay to account for brief browser opening
      Future.delayed(const Duration(seconds: 3), () {
        // only resume if app is back in foreground and we're still tracking
        if (isTracking && lifecycleEventHandler.inBackground == false) {
          resumeTracking();
        }
      });

      if (kDebugMode) {
        print('Link clicked - pausing tracking with auto-resume');
      }
    }
  }

  void forceStopTracking() {
    isTracking = false;
    isPaused = false;
    sessionStartTime = null;
    currentSessionDuration = 0;
  }

  // real time reading stats for debugging
  Map<String, dynamic> getRealTimeStats() {
    return {
      'isTracking': isTracking,
      'isPaused': isPaused,
      'isActivelyTracking': isActivelyTracking,
      'sessionStartTime': sessionStartTime?.toIso8601String(),
      'currentSessionDurationSeconds': currentSessionDurationSeconds,
      'accumulatedDurationSeconds': currentSessionDuration,
      'totalReadingDurationSeconds': isTracking ? reading.readingDuration : null,
      'readingSessions': isTracking ? reading.readLog.length : null,
      'firstReadTime': isTracking ? reading.firstRead.toIso8601String() : null,
      'appInBackground': lifecycleEventHandler.inBackground,
    };
  }
}
