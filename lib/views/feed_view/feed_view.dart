import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/profile.dart';
import 'package:bytesized_news/views/story/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
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
                  builder: (context) => const Settings(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Observer(builder: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            feedStore.getItems();
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
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Text("Marked all as read!"),
                                    action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          feedStore.markAllAsRead(false, unreadItems: unreadItems);
                                          setState(() {});
                                        }),
                                  ));
                                }
                              },
                              label: Text(feedStore.feedItems.any((item) => !item.read) ? "Mark all as read" : "Mark as unread"),
                              icon: const Icon(Icons.playlist_add_check_rounded),
                            ),
                          ],
                        ),
                      ),
                      Skeletonizer(
                        enabled: feedStore.loading,
                        child: Container(
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
                                            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4)
                                            : Theme.of(context).colorScheme.secondaryContainer,
                                        child: SelectableRegion(
                                          focusNode: FocusNode(),
                                          selectionControls: MaterialTextSelectionControls(),
                                          child: ListTile(
                                            title: Text("${item.title} - ${item.feed?.name}"),
                                            subtitle: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                item.summarized ? Text("Summary: ${item.aiSummary}") : Text(item.description.split("\n").first),
                                                Text(
                                                  formatTime(item.publishedDate.millisecondsSinceEpoch),
                                                  style: TextStyle(color: Theme.of(context).dividerColor),
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
                                                // update the sort after the story view is popped
                                                feedStore.changeSort(feedStore.settingsStore.sort);
                                                // update the state of the list items after the story view is popped
                                                // this is done because if the item was bookmarked while in the story view, we want to show that in the list
                                                setState(() {});
                                              });
                                            },
                                            dense: true,
                                            trailing: PopupMenuButton(
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
                                          ),
                                        ),
                                      ).animate(delay: Duration(milliseconds: idx * 100)).fadeIn(),
                                    ),
                                  )
                                  .values,
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
        );
      }),
    );
  }
}