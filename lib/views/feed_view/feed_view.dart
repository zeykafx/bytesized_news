import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/profile.dart';
import 'package:bytesized_news/views/feed_view/sub_views/add_feed.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager.dart';
import 'package:bytesized_news/views/story/story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          borderRadiusExpanded: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Theme.of(context).colorScheme.surfaceContainerLow.withOpacity(1),
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
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    // this is needed to make the refresh indicator work all the time (because when there isn't enough items
                    // or if the screen is too tall the list wouldn't be scrollable thus not refreshable)
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (feedStore.loading) ...[
                                const Center(child: LinearProgressIndicator()),
                              ],
                              if (feedStore.feedItems.isEmpty && !feedStore.loading) ...[
                                const Center(child: Text("No stories loaded")),
                              ],
                              // some trickery to get the index of each element as well as the item
                              // this is used to animate each card fading in with a delay.
                              ...feedStore.feedItems
                                  .asMap()
                                  .map(
                                    (idx, item) => MapEntry(
                                      idx,
                                      Card(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                        elevation: 0,
                                        color: !item.bookmarked
                                            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2)
                                            : Theme.of(context).brightness == Brightness.dark
                                                ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4)
                                                : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
                                        child: SelectableRegion(
                                          focusNode: FocusNode(),
                                          selectionControls: MaterialTextSelectionControls(),
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    item.title,
                                                    style: const TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                item.imageUrl.isNotEmpty
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        child: CachedNetworkImage(
                                                          imageUrl: item.imageUrl,
                                                          fit: BoxFit.cover,
                                                          height: 72,
                                                          width: 128,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // item.summarized ? Text("Summary: ${item.aiSummary}") : Text(item.description.split("\n").first),
                                                Row(
                                                  children: [
                                                    Chip(
                                                      label: Text(
                                                        item.feedName.length > 20 ? "${item.feedName.substring(0, 20)}..." : item.feedName,
                                                        style: const TextStyle(fontSize: 10),
                                                      ),
                                                      avatar: item.feed!.iconUrl.isNotEmpty
                                                          ? CachedNetworkImage(
                                                              imageUrl: item.feed!.iconUrl,
                                                              width: 15,
                                                              height: 15,
                                                            )
                                                          : const Icon(LucideIcons.rss),
                                                      elevation: 0,
                                                      side: const BorderSide(width: 0, color: Colors.transparent),
                                                      padding: const EdgeInsets.all(0),
                                                      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                                                      visualDensity: VisualDensity.compact,
                                                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                                      shape: const RoundedRectangleBorder(
                                                        side: BorderSide(width: 0, color: Colors.transparent),
                                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                                      ),
                                                    ),

                                                    if (item.bookmarked) ...[
                                                      const SizedBox(width: 10),
                                                      Icon(
                                                        LucideIcons.bookmark_check,
                                                        color: Theme.of(context).dividerColor,
                                                        size: 15,
                                                      )
                                                    ],

                                                    // star icon to show if the item has been summarized by AI or not
                                                    if (item.summarized) ...[
                                                      const SizedBox(width: 10),
                                                      Icon(
                                                        LucideIcons.sparkles,
                                                        color: Theme.of(context).dividerColor,
                                                        size: 15,
                                                      )
                                                    ],
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      formatTime(item.publishedDate.millisecondsSinceEpoch),
                                                      style: TextStyle(color: Theme.of(context).dividerColor),
                                                    ),
                                                    PopupMenuButton(
                                                      elevation: 20,
                                                      icon: const Icon(Icons.more_vert),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer, width: 0.3),
                                                      ),
                                                      onSelected: (int index) {
                                                        switch (index) {
                                                          case 0:
                                                            {
                                                              feedStore.toggleItemRead(idx, toggle: true);
                                                              // have to use setState because mobx doesn't detect changes in complex objects (at least the way I set things up)
                                                              setState(() {});
                                                              break;
                                                            }
                                                          case 1:
                                                            {
                                                              feedStore.toggleItemBookmarked(idx, toggle: true);
                                                              setState(() {});
                                                              break;
                                                            }
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext context) {
                                                        return [
                                                          // MARK AS READ/UNREAD
                                                          PopupMenuItem(
                                                            value: 0,
                                                            child: Wrap(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets.only(left: 10),
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    size: 19,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 20),
                                                                  child: Text(item.read ? "Mark as Unread" : "Mark as Read"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // BOOKMARK
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child: Wrap(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10),
                                                                  child: Icon(
                                                                    item.bookmarked ? Icons.bookmark_added : Icons.bookmark_add,
                                                                    size: 19,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 20),
                                                                  child: Text(item.bookmarked ? "Remove from bookmarks" : "Add to bookmarks"),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ];
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            textColor: item.read ? Theme.of(context).dividerColor : Theme.of(context).textTheme.bodyMedium?.color,
                                            onTap: () {
                                              feedStore.toggleItemRead(idx);
                                              // force update the state to change the list tile's color to gray
                                              setState(() {});
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) => Story(
                                                    feedItem: item,
                                                  ),
                                                ),
                                              )
                                                  .then((_) {
                                                // update the sort after the story view is popped,
                                                // this is done so that the story that was just viewed is removed if we are in the unread sort
                                                feedStore.changeSort(feedStore.settingsStore.sort);

                                                // update the state of the list items after the story view is popped
                                                // this is done because if the item was bookmarked while in the story view, we want to show that in the list
                                                setState(() {});
                                              });
                                            },
                                            dense: false,
                                          ),
                                        ),
                                      ).animate(delay: Duration(milliseconds: idx * 100)).fadeIn(),
                                    ),
                                  )
                                  .values,
                            ],
                          ),
                        ),
                      ],
                    ),
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
          height: 80,
          collapsed: Observer(builder: (BuildContext _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // little handle
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // all feeds button
                      Card.outlined(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: settingsStore.sort != FeedListSort.feed && settingsStore.sort != FeedListSort.feedGroup
                                ? Theme.of(context).colorScheme.primaryFixedDim
                                : Theme.of(context).dividerColor.withOpacity(0.5),
                            width: settingsStore.sort != FeedListSort.feed && settingsStore.sort != FeedListSort.feedGroup ? 3 : 1,
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
                              settingsStore.sort == FeedListSort.feed && settingsStore.sortFeed != null && settingsStore.sortFeed?.name == feed.name;
                          return Card.outlined(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: isCurrentSortFeed ? Theme.of(context).colorScheme.primaryFixedDim : Theme.of(context).dividerColor.withOpacity(0.5),
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
                              icon: CachedNetworkImage(imageUrl: elem.iconUrl, width: 25, height: 25),
                            ),
                          );
                        } else {
                          FeedGroup feedGroup = elem;

                          bool isCurrentSortFeedGroup = settingsStore.sort == FeedListSort.feedGroup &&
                              settingsStore.sortFeedGroup != null &&
                              settingsStore.sortFeedGroup?.name == feedGroup.name;
                          return Card.outlined(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: isCurrentSortFeedGroup ? Theme.of(context).colorScheme.primaryFixedDim : Theme.of(context).dividerColor.withOpacity(0.5),
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
                                settingsStore.setSortFeedGroupName(feedGroup.name);
                                await feedStore.changeSort(FeedListSort.feedGroup);
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
                                        ...feedGroup.feeds.take(3).map(
                                              (feed) => CachedNetworkImage(imageUrl: feed.iconUrl, width: 17, height: 17),
                                            ),
                                      ],
                                    ),
                            ),
                          );
                        }
                      }),
                    ],
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
