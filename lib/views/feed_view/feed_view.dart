import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/profile.dart';
import 'package:bytesized_news/views/feed_view/bsb_feed_button.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_search.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_story_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:provider/provider.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late SettingsStore settingsStore;
  late AuthStore authStore;
  final FeedStore feedStore = FeedStore();

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
    init();
  }

  Future<void> init() async {
    await feedStore.init(setStore: settingsStore, authStore: authStore);
    await feedStore.getItems();
    setState(() {});
  }

  Future<void> wrappedGetFeeds() async {
    await feedStore.getFeeds();
    setState(() {});
  }

  Future<void> wrappedGetFeedGroups() async {
    await feedStore.getFeedGroups();
    setState(() {});
  }

  Future<void> wrappedGetItems() async {
    await feedStore.getItems();
    setState(() {});
  }

  Future<void> wrappedGetPinnedFeedsOrFeedGroups() async {
    await feedStore.getPinnedFeedsOrFeedGroups();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bytesized News"),
        // profile button
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Profile(),
              ),
            );
          },
          icon: const Icon(Icons.account_circle),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FeedSearch(feedStore: feedStore),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              )
                  .then((_) async {
                await feedStore.getFeeds();
                await feedStore.getFeedGroups();
                await feedStore.getItems();
                setState(() {});
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Observer(builder: (context) {
        return BottomSheetBar(
          controller: feedStore.bsbController,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          borderRadiusExpanded: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
          color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 1),
          locked: feedStore.isLocked,
          body: RefreshIndicator(
            onRefresh: () async {
              feedStore.fetchItems();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.2),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Top bar: Current Sorting mode, mark all as read button
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PopupMenuButton(
                                elevation: 20,
                                child: TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Theme.of(context).textTheme.bodyLarge!.color,
                                  ),
                                  label: Text(
                                    feedListSortToString(feedStore.settingsStore.sort),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                onSelected: (int value) {
                                  switch (value) {
                                    case 0:
                                      {
                                        feedStore.changeSort(FeedListSort.byDate);
                                        break;
                                      }
                                    case 1:
                                      {
                                        feedStore.changeSort(FeedListSort.today);
                                        break;
                                      }
                                    case 2:
                                      {
                                        feedStore.changeSort(FeedListSort.unread);
                                        break;
                                      }
                                    case 3:
                                      {
                                        feedStore.changeSort(FeedListSort.read);
                                        break;
                                      }
                                    case 4:
                                      {
                                        feedStore.changeSort(FeedListSort.summarized);
                                        break;
                                      }
                                    case 5:
                                      {
                                        feedStore.changeSort(FeedListSort.downloaded);
                                        break;
                                      }
                                    case 6:
                                      {
                                        feedStore.changeSort(FeedListSort.bookmarked);
                                        break;
                                      }
                                  }
                                },
                                // by date, today, unread, read, bookmarked
                                itemBuilder: (BuildContext _) {
                                  return [
                                    const PopupMenuItem(
                                      value: 0,
                                      child: Text("All Articles"),
                                    ),
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Text("Today"),
                                    ),
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Text("Unread"),
                                    ),
                                    const PopupMenuItem(
                                      value: 3,
                                      child: Text("Read"),
                                    ),
                                    const PopupMenuItem(
                                      value: 4,
                                      child: Text("Summarized"),
                                    ),
                                    const PopupMenuItem(
                                      value: 5,
                                      child: Text("Downloaded"),
                                    ),
                                    const PopupMenuItem(
                                      value: 6,
                                      child: Text("Bookmarked"),
                                    ),
                                  ];
                                }),
                            TextButton.icon(
                              onPressed: () {
                                bool allRead = feedStore.feedItems.every((item) => item.read);
                                if (allRead) {
                                  feedStore.markAllAsRead(false);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Text("Marked all as unread!"),
                                    action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          feedStore.markAllAsRead(true);
                                          setState(() {});
                                        }),
                                  ));
                                } else {
                                  List<FeedItem> unreadItems = feedStore.feedItems.where((item) => !item.read).toList();
                                  feedStore.markAllAsRead(true);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Marked all as read!"),
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          feedStore.markAllAsRead(false, unreadItems: unreadItems);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              label: Text(feedStore.feedItems.any((item) => !item.read) ? "Mark all as read" : "Mark as unread"),
                              icon: const Icon(Icons.playlist_add_check_rounded),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (feedStore.loading) ...[
                                const Center(child: LinearProgressIndicator()),
                              ],
                              if (feedStore.feedItems.isEmpty && !feedStore.loading) ...[
                                const Center(child: Text("Nothing loaded. Refresh to fetch posts!")),
                              ],
                              if (feedStore.suggestionsLoading) ...[
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Text("Fetching suggestions").animate().fadeIn().animate(onPlay: (controller) => controller.repeat()).shimmer(
                                        duration: const Duration(milliseconds: 1500),
                                        colors: [
                                          const Color(0xBFFFFF00),
                                          const Color(0xBF00FF00),
                                          const Color(0xBF00FFFF),
                                          const Color(0xBF0033FF),
                                          const Color(0xBFFF00FF),
                                          const Color(0xBFFF0000),
                                          const Color(0xBFFFFF00),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              Expanded(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: ListView.builder(
                                          itemCount: feedStore.feedItems.length +
                                              (feedStore.settingsStore.sort == FeedListSort.byDate && feedStore.suggestedFeedItems.isNotEmpty ? 1 : 0),
                                          cacheExtent: 300,
                                          controller: feedStore.scrollController,
                                          addRepaintBoundaries: false,
                                          addAutomaticKeepAlives: false,
                                          itemBuilder: (context, idx) {
                                            if (feedStore.suggestedFeedItems.isNotEmpty && feedStore.settingsStore.sort == FeedListSort.byDate && idx == 0) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 0.0,
                                                  vertical: 10.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Tooltip(
                                                      message:
                                                          "Suggested articles based on your interests and taste profile. Can be refreshed once per 10 minutes.",
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 5.0,
                                                        ),
                                                        child: Text(
                                                          "Suggested Articles:",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 140,
                                                      child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          controller: feedStore.suggestionsScrollController,
                                                          itemCount: feedStore.suggestedFeedItems.length,
                                                          cacheExtent: 300,
                                                          addRepaintBoundaries: false,
                                                          addAutomaticKeepAlives: false,
                                                          itemBuilder: (context, idx) {
                                                            FeedItem item = feedStore.suggestedFeedItems[idx];

                                                            return SizedBox(
                                                              width: 350,
                                                              child: FeedStoryTile(
                                                                feedStore: feedStore,
                                                                item: item,
                                                                isSuggestion: true,
                                                              ),
                                                            )
                                                                .animate(
                                                                  delay: 200.ms,
                                                                )
                                                                .slide(
                                                                  begin: Offset(
                                                                    -0.1,
                                                                    0,
                                                                  ),
                                                                  end: Offset(0, 0),
                                                                  curve: Curves.easeOut,
                                                                )
                                                                .fadeIn();
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ).animate(delay: Duration(milliseconds: 100)).fadeIn();
                                            }

                                            int index = feedStore.suggestedFeedItems.isNotEmpty && settingsStore.sort == FeedListSort.byDate ? idx - 1 : idx;
                                            FeedItem item = feedStore.feedItems[index];

                                            return FeedStoryTile(
                                              feedStore: feedStore,
                                              item: item,
                                            )
                                                .animate(
                                                  delay: 250.ms,
                                                )
                                                .slide(
                                                  duration: 300.ms,
                                                  begin: Offset(0, -0.1),
                                                  end: Offset(0, 0),
                                                  curve: Curves.easeOut,
                                                )
                                                .fadeIn();
                                          }),
                                    ),

                                    // SCROLL TO TOP BUTTON
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: AnimatedSlide(
                                        duration: 250.ms,
                                        curve: Curves.easeInOutQuad,
                                        offset: feedStore.showScrollToTop && !feedStore.isExpanded ? Offset(-0.05, -0.1) : Offset(-0.05, 2),
                                        // visible: feedStore.showScrollToTop && !feedStore.isExpanded,
                                        child: ClipRect(
                                          child: AnimatedCrossFade(
                                            crossFadeState: !feedStore.showSmallScrollToTop ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                            alignment: Alignment.bottomRight,
                                            firstCurve: Curves.easeInOutQuad,
                                            secondCurve: Curves.easeInOutQuad,
                                            sizeCurve: Curves.easeInOutQuad,
                                            duration: 150.ms,
                                            firstChild: FilledButton.tonalIcon(
                                              onPressed: feedStore.scrollToTop,
                                              icon: Icon(Icons.arrow_upward),
                                              label: Text(
                                                "Scroll To Top",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            secondChild: IconButton.filledTonal(
                                              icon: Icon(Icons.arrow_upward),
                                              onPressed: feedStore.scrollToTop,
                                            ),
                                            layoutBuilder: (
                                              Widget topChild,
                                              Key topChildKey,
                                              Widget bottomChild,
                                              Key bottomChildKey,
                                            ) {
                                              return Stack(
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.center,
                                                children: [
                                                  PositionedDirectional(
                                                    key: bottomChildKey,
                                                    top: 0,
                                                    child: bottomChild,
                                                  ),
                                                  PositionedDirectional(
                                                    key: topChildKey,
                                                    child: topChild,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          expandedBuilder: (ScrollController controller) {
            return FeedManager(
              feedStore: feedStore,
              wrappedGetFeeds: wrappedGetFeeds,
              wrappedGetFeedGroups: wrappedGetFeedGroups,
              wrappedGetItems: wrappedGetItems,
              wrappedGetPinnedFeedsOrFeedGroups: wrappedGetPinnedFeedsOrFeedGroups,
              scrollController: controller,
            );
          },
          height: feedStore.bsbHeight,
          collapsed: Observer(builder: (BuildContext _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // little handle
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 3),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // all feeds button
                        Card.outlined(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: settingsStore.sort != FeedListSort.feed && settingsStore.sort != FeedListSort.feedGroup
                                  ? Theme.of(context).colorScheme.primaryFixedDim
                                  : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                              width: settingsStore.sort != FeedListSort.feed && settingsStore.sort != FeedListSort.feedGroup ? 3 : 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              feedStore.scrollToTop();

                              await feedStore.changeSort(FeedListSort.byDate);
                              await feedStore.fetchItems();
                            },
                            icon: const Icon(Icons.all_inbox_rounded),
                          ),
                        ),

                        ...feedStore.pinnedFeedsOrFeedGroups.map((elem) {
                          return BsbFeedButton(elem: elem, feedStore: feedStore);
                        }),
                        // If nothing is pinned, show the n-th first feed groups and feeds
                        if (feedStore.pinnedFeedsOrFeedGroups.isEmpty) ...[
                          ...feedStore.feedGroups.map((elem) {
                            return BsbFeedButton(elem: elem, feedStore: feedStore);
                          }),
                          ...feedStore.feeds.map((elem) {
                            return BsbFeedButton(elem: elem, feedStore: feedStore);
                          }),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      }),
    );
  }
}
