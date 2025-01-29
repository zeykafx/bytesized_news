import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/profile.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_search.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_story_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
        title: const Text("News"),
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
      floatingActionButton: Observer(builder: (context) {
        return Visibility(
          visible: feedStore.showScrollToTop && !feedStore.isExpanded,
          child: FloatingActionButton.small(
            onPressed: feedStore.scrollToTop,
            child: const Icon(Icons.arrow_upward),
          ),
        );
      }),
      body: Observer(builder: (context) {
        return BottomSheetBar(
          controller: feedStore.bsbController,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          borderRadiusExpanded: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerLow
              .withValues(alpha: 1),
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
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withValues(alpha: 0.2),
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                  label: Text(
                                    feedListSortToString(
                                        feedStore.settingsStore.sort),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                onSelected: (int value) {
                                  switch (value) {
                                    case 0:
                                      {
                                        feedStore
                                            .changeSort(FeedListSort.byDate);
                                        break;
                                      }
                                    case 1:
                                      {
                                        feedStore
                                            .changeSort(FeedListSort.today);
                                        break;
                                      }
                                    case 2:
                                      {
                                        feedStore
                                            .changeSort(FeedListSort.unread);
                                        break;
                                      }
                                    case 3:
                                      {
                                        feedStore.changeSort(FeedListSort.read);
                                        break;
                                      }
                                    case 4:
                                      {
                                        feedStore.changeSort(
                                            FeedListSort.bookmarked);
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
                                      child: Text("Bookmarked"),
                                    ),
                                  ];
                                }),
                            TextButton.icon(
                              onPressed: () {
                                bool allRead = feedStore.feedItems
                                    .every((item) => item.read);
                                if (allRead) {
                                  feedStore.markAllAsRead(false);
                                  setState(() {});
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        const Text("Marked all as unread!"),
                                    action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          feedStore.markAllAsRead(true);
                                          setState(() {});
                                        }),
                                  ));
                                } else {
                                  List<FeedItem> unreadItems = feedStore
                                      .feedItems
                                      .where((item) => !item.read)
                                      .toList();
                                  feedStore.markAllAsRead(true);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text("Marked all as read!"),
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          feedStore.markAllAsRead(false,
                                              unreadItems: unreadItems);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              label: Text(
                                  feedStore.feedItems.any((item) => !item.read)
                                      ? "Mark all as read"
                                      : "Mark as unread"),
                              icon:
                                  const Icon(Icons.playlist_add_check_rounded),
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
                              if (feedStore.feedItems.isEmpty &&
                                  !feedStore.loading) ...[
                                const Center(child: Text("No stories loaded")),
                              ],
                              Expanded(
                                child: ListView.builder(
                                    itemCount: feedStore.feedItems.length +
                                        (feedStore.settingsStore.sort ==
                                                    FeedListSort.byDate &&
                                                feedStore.suggestedFeedItems
                                                    .isNotEmpty
                                            ? 1
                                            : 0),
                                    cacheExtent: 300,
                                    controller: feedStore.scrollController,
                                    addRepaintBoundaries: false,
                                    addAutomaticKeepAlives: false,
                                    itemBuilder: (context, idx) {
                                      if (feedStore
                                              .suggestedFeedItems.isNotEmpty &&
                                          feedStore.settingsStore.sort ==
                                              FeedListSort.byDate &&
                                          idx == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0,
                                            vertical: 10.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                              SizedBox(
                                                height: 140,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: feedStore
                                                        .suggestedFeedItems
                                                        .length,
                                                    cacheExtent: 300,
                                                    addRepaintBoundaries: false,
                                                    addAutomaticKeepAlives:
                                                        false,
                                                    itemBuilder:
                                                        (context, idx) {
                                                      FeedItem item = feedStore
                                                              .suggestedFeedItems[
                                                          idx];

                                                      return SizedBox(
                                                        width: 350,
                                                        child: FeedStoryTile(
                                                          feedStore: feedStore,
                                                          item: item,
                                                          isSuggestion: true,
                                                        ),
                                                      )
                                                          .animate(
                                                              delay: Duration(
                                                                  milliseconds:
                                                                      idx *
                                                                          100))
                                                          .fadeIn();
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ).animate().fadeIn().then().shimmer(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          curve: Curves.easeInOutSine,
                                          colors: [
                                            const Color(0x00FFFF00),
                                            const Color(0xBFFFFF00),
                                            const Color(0xBF00FF00),
                                            const Color(0xBF00FFFF),
                                            const Color(0xBF0033FF),
                                            const Color(0xBFFF00FF),
                                            const Color(0xBFFF0000),
                                            const Color(0xBFFFFF00),
                                            // const Color(0xFFFF00),
                                          ],
                                        );
                                      }

                                      int index = feedStore
                                              .suggestedFeedItems.isNotEmpty
                                          ? idx - 1
                                          : idx;
                                      FeedItem item =
                                          feedStore.feedItems[index];

                                      return FeedStoryTile(
                                        feedStore: feedStore,
                                        item: item,
                                      );
                                      // .animate(
                                      //     delay: Duration(
                                      //         milliseconds: idx * 100))
                                      // .fadeIn();
                                    }),
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
              wrappedGetPinnedFeedsOrFeedGroups:
                  wrappedGetPinnedFeedsOrFeedGroups,
              scrollController: controller,
            );
          },
          height: 85,
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
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
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
                              color: settingsStore.sort != FeedListSort.feed &&
                                      settingsStore.sort !=
                                          FeedListSort.feedGroup
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryFixedDim
                                  : Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.5),
                              width: settingsStore.sort != FeedListSort.feed &&
                                      settingsStore.sort !=
                                          FeedListSort.feedGroup
                                  ? 3
                                  : 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await feedStore.changeSort(FeedListSort.byDate);
                              await feedStore.fetchItems();
                            },
                            icon: const Icon(Icons.all_inbox_rounded),
                          ),
                        ),

                        ...feedStore.pinnedFeedsOrFeedGroups.map((elem) {
                          if (elem.runtimeType == Feed) {
                            Feed feed = elem;

                            bool isCurrentSortFeed =
                                settingsStore.sort == FeedListSort.feed &&
                                    settingsStore.sortFeed != null &&
                                    settingsStore.sortFeed?.name == feed.name;
                            return Card.outlined(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: isCurrentSortFeed
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryFixedDim
                                      : Theme.of(context)
                                          .dividerColor
                                          .withValues(alpha: 0.5),
                                  width: isCurrentSortFeed ? 3 : 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  // sort for this feed
                                  settingsStore.setSortFeed(feed);
                                  settingsStore.setSortFeedName(feed.name);
                                  await feedStore.changeSort(FeedListSort.feed);
                                  await feedStore.fetchItems();
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                      imageUrl: feed.iconUrl,
                                      width: 25,
                                      height: 25),
                                ),
                              ),
                            );
                          } else {
                            FeedGroup feedGroup = elem;

                            bool isCurrentSortFeedGroup =
                                settingsStore.sort == FeedListSort.feedGroup &&
                                    settingsStore.sortFeedGroup != null &&
                                    settingsStore.sortFeedGroup?.name ==
                                        feedGroup.name;
                            return Card.outlined(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: isCurrentSortFeedGroup
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryFixedDim
                                      : Theme.of(context)
                                          .dividerColor
                                          .withValues(alpha: 0.5),
                                  width: isCurrentSortFeedGroup ? 3 : 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  // sort for this feed group
                                  settingsStore.setSortFeedGroup(feedGroup);
                                  settingsStore
                                      .setSortFeedGroupName(feedGroup.name);
                                  await feedStore
                                      .changeSort(FeedListSort.feedGroup);
                                  await feedStore.fetchItems();
                                },
                                icon: feedGroup.feeds.isEmpty
                                    ? const Icon(
                                        LucideIcons.folder,
                                        size: 15,
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ...feedGroup.feeds.take(2).map(
                                                (feed) => Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: CachedNetworkImage(
                                                      imageUrl: feed.iconUrl,
                                                      width: 17,
                                                      height: 17),
                                                ),
                                              ),
                                          if (feedGroup.feeds.length > 2) ...[
                                            const SizedBox(width: 5),
                                            Text(
                                              "+${feedGroup.feeds.length - 2}",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .dividerColor),
                                            ),
                                          ],
                                        ],
                                      ),
                              ),
                            );
                          }
                        }),
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
