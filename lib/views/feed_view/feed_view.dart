import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/profile.dart';
import 'package:bytesized_news/views/feed_view/bsb_feed_button.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_manager/feed_manager.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_search.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_story_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late SettingsStore settingsStore;
  late AuthStore authStore;
  final FeedStore feedStore = FeedStore();
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
    init();

    reactionDisposer = reaction((_) => feedStore.hasAlert, (bool hasAlert) {
      // if there is an alert to show, show it in a snackbar
      if (hasAlert) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(feedStore.alertMessage), showCloseIcon: true, duration: Duration(seconds: 10), behavior: SnackBarBehavior.floating),
        );
        feedStore.hasAlert = false;
        feedStore.alertMessage = "";
      }
    });
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
  void dispose() {
    super.dispose();
    reactionDisposer();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Bytesized News"),
            // profile button
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Profile()));
              },
              icon: const Icon(Icons.account_circle),
            ),
            actions: [
              AnimatedOpacity(
                opacity: feedStore.isExpanded ? 0 : 1,
                duration: 200.ms,
                curve: Curves.easeInOutQuad,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedSearch(feedStore: feedStore)));
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings())).then((_) async {
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
          body: BottomSheetBar(
            controller: feedStore.bsbController,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            borderRadiusExpanded: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
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
                        buildTopBar(context),

                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: settingsStore.maxWidth),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (feedStore.loading) ...[const Center(child: LinearProgressIndicator())],
                                if (feedStore.feedItems.isEmpty && !feedStore.loading) ...[
                                  const Center(child: Text("Nothing loaded. Refresh to fetch posts!")),
                                ],
                                if (feedStore.suggestionsLoading) ...[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Opacity(
                                        opacity: 0.5,
                                        child: Text("Fetching suggestions")
                                            .animate()
                                            .fadeIn()
                                            .animate(onPlay: (controller) => controller.repeat())
                                            .shimmer(
                                              duration: const Duration(milliseconds: 1500),
                                              colors: [
                                                Theme.of(context).colorScheme.primary,
                                                Theme.of(context).colorScheme.inversePrimary,
                                                Theme.of(context).colorScheme.primary,
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
                                          itemCount:
                                              feedStore.feedItems.length +
                                              (feedStore.settingsStore.sort == FeedListSort.byDate && feedStore.suggestedFeedItems.isNotEmpty ? 1 : 0),
                                          cacheExtent: 300,
                                          controller: feedStore.scrollController,
                                          addRepaintBoundaries: false,
                                          addAutomaticKeepAlives: false,
                                          itemBuilder: (context, idx) {
                                            if (settingsStore.suggestionEnabled) {
                                              // Suggestions
                                              if (feedStore.suggestedFeedItems.isNotEmpty && feedStore.settingsStore.sort == FeedListSort.byDate && idx == 0) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                                                  child: Card(
                                                    margin: EdgeInsets.zero,
                                                    elevation: 0,
                                                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Tooltip(
                                                          message:
                                                              "Suggested articles based on your interests and taste profile. Suggested ${formatTime(feedStore.authStore.lastSuggestionDate!.microsecondsSinceEpoch)}",
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                                            child: Text("Suggested Articles", style: TextStyle(fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          height: 315,
                                                          child: CarouselView(
                                                            itemExtent: 350,
                                                            scrollDirection: Axis.horizontal,
                                                            itemSnapping: true,
                                                            enableSplash: false,
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                                            children: [
                                                              for (FeedItem item in feedStore.suggestedFeedItems) ...[
                                                                SizedBox(
                                                                  width: 350,
                                                                  child: FeedStoryTile(feedStore: feedStore, item: item, isSuggestion: true),
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ).animate(delay: Duration(milliseconds: 100)).fadeIn();
                                              }
                                            }

                                            int index = feedStore.suggestedFeedItems.isNotEmpty && settingsStore.sort == FeedListSort.byDate ? idx - 1 : idx;
                                            FeedItem item = feedStore.feedItems[index];

                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                                              child: FeedStoryTile(feedStore: feedStore, item: item)
                                                  .animate(delay: 250.ms)
                                                  .slide(duration: 300.ms, begin: Offset(0, -0.1), end: Offset(0, 0), curve: Curves.easeOut)
                                                  .fadeIn(),
                                            );
                                          },
                                        ),
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
                                                label: Text("Scroll To Top", style: TextStyle(fontSize: 12)),
                                              ),
                                              secondChild: IconButton.filledTonal(icon: Icon(Icons.arrow_upward), onPressed: feedStore.scrollToTop),
                                              layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
                                                return Stack(
                                                  clipBehavior: Clip.none,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    PositionedDirectional(key: bottomChildKey, top: 0, child: bottomChild),
                                                    PositionedDirectional(key: topChildKey, child: topChild),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
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
            collapsed: Observer(
              builder: (BuildContext _) {
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
                        decoration: BoxDecoration(color: Theme.of(context).dividerColor.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(10)),
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
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Container buildTopBar(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton(
            elevation: 20,
            child: TextButton.icon(
              onPressed: null,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).textTheme.bodyLarge!.color),
              label: Text(feedListSortToString(feedStore.settingsStore.sort), style: Theme.of(context).textTheme.bodyLarge),
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
                const PopupMenuItem(value: 0, child: Text("All Articles")),
                const PopupMenuItem(value: 1, child: Text("Today")),
                const PopupMenuItem(value: 2, child: Text("Unread")),
                const PopupMenuItem(value: 3, child: Text("Read")),
                const PopupMenuItem(value: 4, child: Text("Summarized")),
                const PopupMenuItem(value: 5, child: Text("Downloaded")),
                const PopupMenuItem(value: 6, child: Text("Bookmarked")),
              ];
            },
          ),
          TextButton.icon(
            onPressed: () {
              bool allRead = feedStore.feedItems.every((item) => item.read);
              if (allRead) {
                feedStore.markAllAsRead(false);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Marked all as unread!"),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        feedStore.markAllAsRead(true);
                        setState(() {});
                      },
                    ),
                  ),
                );
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
    );
  }
}
