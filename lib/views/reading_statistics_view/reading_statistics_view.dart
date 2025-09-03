import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:html/dom.dart' as dom;
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:bytesized_news/views/reading_statistics_view/reading_statistics_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/story/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html/parser.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

class ReadingStatisticsView extends StatefulWidget {
  const ReadingStatisticsView({super.key});

  @override
  State<ReadingStatisticsView> createState() => _ReadingStatisticsViewState();
}

class _ReadingStatisticsViewState extends State<ReadingStatisticsView> {
  ReadingStatisticsStore store = ReadingStatisticsStore();
  late SettingsStore settingsStore;
  late DbUtils dbUtils;

  @override
  initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    dbUtils = DbUtils(isar: Isar.getInstance()!);
    store.init(dbUtils, settingsStore);
  }

  Map<int, String> weekdayIdxToString = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thur",
    5: "Fri",
    6: "Sat",
    7: "Sun",
  };

  Map<int, String> monthIdxToString = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  String getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "th";
    }
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  List<String> getLastFewDays() {
    List<String> daysString = [];

    for (int i = min(store.readingStreak - 1, 5); i >= 0; i--) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      daysString.add("${weekdayIdxToString[day.weekday]} ${monthIdxToString[day.month]} ${day.day}${getOrdinalSuffix(day.day)}");
    }
    return daysString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reading Statistics")),
      body: Observer(
        builder: (context) {
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: settingsStore.maxWidth),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                children: [
                  Center(
                    child: CustomScrollView(
                      controller: store.scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: AnimatedOpacity(
                              duration: 200.ms,
                              opacity: store.loading ? 1 : 0,
                              child: LinearProgressIndicator(),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: [
                              buildReadingTimeCard(),
                              buildArticlesReadCard(context),
                              buildStreakCard(context),
                              buildStatsCardWithArticle(),
                            ],
                          ).animate(delay: 150.ms).fadeIn(),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Read articles",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                                DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(12),
                                  dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
                                  underline: const SizedBox.shrink(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  iconEnabledColor: Theme.of(context).colorScheme.primary,
                                  elevation: 0,
                                  iconSize: 25,
                                  value: store.currentSort,
                                  icon: const Icon(Icons.sort_rounded),
                                  items: [
                                    DropdownMenuItem<String>(value: "by_date", child: Text("Sort by reading date")),
                                    DropdownMenuItem<String>(value: "by_duration", child: Text("Sort by reading duration")),
                                  ],
                                  onChanged: (String? item) => store.sortButtonOnChanged(item),
                                ),
                              ],
                            ),
                          ).animate(delay: 200.ms).fadeIn(),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, idx) {
                              if (idx == store.allArticlesRead.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              var (StoryReading reading, FeedItem feedItem) = store.allArticlesRead[idx];
                              return ReadArticleCard(
                                feedItem: feedItem,
                                reading: reading,
                                store: store,
                              ).animate(delay: 250.ms).slide(duration: 300.ms, begin: Offset(0, -0.1), end: Offset(0, 0), curve: Curves.easeOut).fadeIn();
                            },
                            childCount: store.allArticlesRead.length + (store.isLoadingMore ? 1 : 0),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 80), // space for the scroll to top button
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: AnimatedSlide(
                      duration: 250.ms,
                      curve: Curves.easeInOutQuad,
                      offset: store.showScrollToTop ? Offset(0, 0) : Offset(0, 2),
                      child: FilledButton.icon(
                        onPressed: store.scrollToTop,
                        icon: Icon(Icons.arrow_upward),
                        label: Text("Scroll To Top", style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildStatsCardWithArticle() {
    if (store.longuestReadArticle.$1 == null || store.longuestReadArticle.$2 == null) {
      return const SizedBox.shrink();
    }

    return StatsCardWithArticle(
      title: "Longest Read",
      content: store.longuestReadArticle.$1!.title,
      feedItem: store.longuestReadArticle.$1!,
      reading: store.longuestReadArticle.$2!,
      store: store,
    );
  }

  StatsCard buildReadingTimeCard() {
    double percentageOfYear = (store.totalReadingTime.inMinutes / 5259492) * 100;
    return StatsCard(
      title: "Reading time",
      // content: "${store.totalReadingTime.inHours}h ${store.totalReadingTime.inMinutes.remainder(60)}m",
      content: "",
      widgetContent: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Read for ${percentageOfYear.toStringAsFixed(2)}% of a whole year",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: ui.TextAlign.right,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "${store.totalReadingTime.inHours}h ${store.totalReadingTime.inMinutes.remainder(60)}m",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            textAlign: ui.TextAlign.right,
          ),
        ],
      ),
    );
  }

  StatsCard buildArticlesReadCard(BuildContext context) {
    return StatsCard(
      title: "Articles Read",
      content: "",
      widgetContent: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Read ${store.mostReadDayCount} articles on ${weekdayIdxToString[store.mostReadDay.weekday]}, ${monthIdxToString[store.mostReadDay.month]} ${store.mostReadDay.day}${getOrdinalSuffix(store.mostReadDay.day)} ${store.mostReadDay.year}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: ui.TextAlign.right,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "${store.numberArticlesRead} in total",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }

  StatsCard buildStreakCard(BuildContext context) {
    return StatsCard(
      title: "Daily Streak",
      content: "",
      widgetContent: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                // center: Alignment.topCenter,
                // radius: 1.0,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.4, 1],
                colors: <Color>[
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                  Theme.of(context).colorScheme.secondary,
                ],
              ).createShader(bounds);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // down to up because we reverse the list for the animation (we wan today to bet the first day to show up and animte, then yesterday,...)
              verticalDirection: VerticalDirection.up,
              children: [
                for (var (int idx, String day) in getLastFewDays().reversed.indexed) ...[
                  Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: ui.TextAlign.right,
                  ).animate(delay: 500.ms + (idx * 200).ms).fadeIn(duration: 300.ms, curve: Curves.easeInQuad),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${store.readingStreak} days ${store.readingStreak > 7 ? ("🔥" * min(store.readingStreak ~/ 7, 3)) : ""}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.title,
    required this.content,
    required this.widgetContent,
  });

  final String title;
  final String content;
  final Widget? widgetContent;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child:
                  widgetContent ??
                  Text(
                    content,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsCardWithArticle extends StatelessWidget {
  const StatsCardWithArticle({
    super.key,
    required this.store,
    required this.title,
    required this.content,
    required this.feedItem,
    required this.reading,
  });
  final ReadingStatisticsStore store;
  final String title;
  final String content;
  final FeedItem feedItem;
  final StoryReading reading;

  @override
  Widget build(BuildContext context) {
    Duration readingDuration = Duration(seconds: reading.readingDuration);
    return Card.filled(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => Story(feedItem: feedItem),
                  ),
                )
                .then((_) {
                  store.updateReading(reading);
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Tooltip(
                      message: content,
                      child: Text(
                        content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    Text(
                      "Read ${formatTime(reading.firstRead.millisecondsSinceEpoch)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                    Text(
                      "for ${readingDuration.inMinutes} minutes in total",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton.filled(
                    icon: Icon(
                      LucideIcons.arrow_up_right,
                      size: 15,
                    ),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => Story(feedItem: feedItem),
                            ),
                          )
                          .then((_) {
                            store.updateReading(reading);
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReadArticleCard extends StatelessWidget {
  const ReadArticleCard({
    super.key,
    required this.feedItem,
    required this.reading,
    required this.store,
  });

  final FeedItem feedItem;
  final StoryReading reading;
  final ReadingStatisticsStore store;

  @override
  Widget build(BuildContext context) {
    String parsedTitle = "";

    // Parse the title from html (it might be html escaped)
    dom.Document doc = parse(feedItem.title);
    if (doc.body != null) {
      parsedTitle = parse(doc.body!.text).documentElement!.text;
    } else {
      parsedTitle = feedItem.title;
    }

    Duration readingDuration = Duration(seconds: reading.readingDuration);
    String readingTimeText = readingDuration.inMinutes > 0 ? "Read for ${readingDuration.inMinutes}m" : "Read for ${readingDuration.inSeconds}s";

    return Card.filled(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => Story(feedItem: feedItem),
                  ),
                )
                .then((_) {
                  store.updateReading(reading);
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // duration and timestamp
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        readingTimeText,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatTime(reading.firstRead.millisecondsSinceEpoch),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // title
                Text(
                  parsedTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // feed name and button
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (feedItem.feed != null) ...[
                      Flexible(
                        child: Text(
                          feedItem.feed!.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],

                    Row(
                      spacing: 5,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.trash,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              store.deleteReading(reading);
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.arrow_up_right,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Story(feedItem: feedItem),
                                ),
                              );
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
