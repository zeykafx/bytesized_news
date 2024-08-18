import 'package:bytesized_news/main.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/add_feed.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_group_tile.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'edit_feed_group.dart';

class FeedManager extends StatefulWidget {
  final FeedStore feedStore;
  final Function wrappedGetFeeds;
  final Function wrappedGetFeedGroups;
  final Function wrappedGetItems;
  final Function wrappedGetPinnedFeedsOrFeedGroups;
  final ScrollController scrollController;

  const FeedManager({
    super.key,
    required this.feedStore,
    required this.wrappedGetFeeds,
    required this.wrappedGetFeedGroups,
    required this.wrappedGetItems,
    required this.wrappedGetPinnedFeedsOrFeedGroups,
    required this.scrollController,
  });

  @override
  State<FeedManager> createState() => _FeedManagerState();
}

class _FeedManagerState extends State<FeedManager> {
  late FeedStore feedStore;
  FeedManagerStore feedManagerStore = FeedManagerStore();

  @override
  void initState() {
    super.initState();
    feedStore = widget.feedStore;
    feedManagerStore.init(feedStore: feedStore);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool popped, dynamic result) {
        // if we are currently selecting things, get out of the selection mode and reset the selected feeds, otherwise collapse the bsb
        if (feedManagerStore.selectionMode) {
          feedManagerStore.toggleSelectionMode();
          feedManagerStore.selectedFeeds.clear();
          feedManagerStore.selectedFeedGroups.clear();
        } else {
          feedStore.bsbController.collapse();
        }
      },
      child: Observer(builder: (_) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          // search bar
                          // ...

                          // add feed button, new feed group button
                          Card.outlined(
                            color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // ADD FEED BUTTON
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => AddFeed(
                                            getFeeds: widget.wrappedGetFeeds,
                                            getItems: widget.wrappedGetItems,
                                          ),
                                        ),
                                      )
                                          .then((_) async {
                                        await widget.wrappedGetFeeds();
                                        await widget.wrappedGetItems();
                                        setState(() {});
                                      });
                                    },
                                    label: const Text("Add Feed"),
                                    icon: const Icon(LucideIcons.rss),
                                  ),
                                ),

                                // CREATE FEED GROUP BUTTON
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () => feedManagerStore.createFeedGroupDialog(context),
                                    label: const Text("Create Feed Group"),
                                    icon: const Icon(LucideIcons.folder_plus),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (feedStore.pinnedFeedsOrFeedGroups.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 15, right: 8, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "Pinned: ${feedStore.pinnedFeedsOrFeedGroups.length.toString()}",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // pinned feeds/feed groups
                            ...feedStore.pinnedFeedsOrFeedGroups.map((element) {
                              if (element.runtimeType == Feed) {
                                Feed feed = element;

                                return FeedTile(
                                  key: ValueKey(feed.id),
                                  feedManagerStore: feedManagerStore,
                                  feedStore: feedStore,
                                  feed: feed,
                                  wrappedGetFeedGroups: widget.wrappedGetFeedGroups,
                                  wrappedGetFeeds: widget.wrappedGetFeeds,
                                  wrappedGetPinnedFeedsOrFeedGroups: widget.wrappedGetPinnedFeedsOrFeedGroups,
                                  isInPinnedList: true,
                                );
                              } else {
                                FeedGroup feedGroup = element;

                                return FeedGroupTile(
                                  key: ValueKey(feedGroup.id + 1000),
                                  feedManagerStore: feedManagerStore,
                                  feedStore: feedStore,
                                  feedGroup: feedGroup,
                                  wrappedGetPinnedFeedsOrFeedGroups: widget.wrappedGetPinnedFeedsOrFeedGroups,
                                  wrappedGetFeedGroups: widget.wrappedGetFeedGroups,
                                  wrappedGetFeeds: widget.wrappedGetFeeds,
                                  isInPinnedList: true,
                                );
                              }
                            }),
                          ],

                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 15, right: 8, bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Feeds: ${feedStore.feeds.length.toString()}",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // all feeds and feed groups
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // FeedGroups

                              GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: mediaQuery.size.width > 500 ? 3.5 : 3,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  ...feedStore.feedGroups.map((FeedGroup feedGroup) {
                                    return FeedGroupTile(
                                      feedManagerStore: feedManagerStore,
                                      feedStore: feedStore,
                                      feedGroup: feedGroup,
                                      wrappedGetPinnedFeedsOrFeedGroups: widget.wrappedGetPinnedFeedsOrFeedGroups,
                                      wrappedGetFeedGroups: widget.wrappedGetFeedGroups,
                                      wrappedGetFeeds: widget.wrappedGetFeeds,
                                      isInPinnedList: false,
                                    );
                                  }),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              // feeds
                              ...feedStore.feeds.map((feed) {
                                return FeedTile(
                                  feedManagerStore: feedManagerStore,
                                  feedStore: feedStore,
                                  feed: feed,
                                  wrappedGetFeedGroups: widget.wrappedGetFeedGroups,
                                  wrappedGetFeeds: widget.wrappedGetFeeds,
                                  wrappedGetPinnedFeedsOrFeedGroups: widget.wrappedGetPinnedFeedsOrFeedGroups,
                                  isInPinnedList: false,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // floating button bar at the bottom of the screen
                  Visibility(
                    visible: feedManagerStore.selectionMode,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: mediaQuery.size.width > 600 ? 30 : 5),
                        child: Card.outlined(
                          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                          child: OverflowBar(
                            overflowAlignment: OverflowBarAlignment.center,
                            children: [
                              // CANCEL SELECTION
                              TextButton.icon(
                                onPressed: () {
                                  feedManagerStore.selectionMode = false;
                                  feedManagerStore.selectedFeeds.clear();
                                  feedManagerStore.selectedFeedGroups.clear();
                                },
                                icon: const Icon(Icons.cancel_outlined, size: 17),
                                label: const Text("Cancel"),
                              ),

                              // const SizedBox(
                              //   height: 25,
                              //   child: VerticalDivider(),
                              // ),

                              if (feedManagerStore.areFeedsSelected &&
                                  !feedManagerStore.areFeedGroupsSelected &&
                                  feedManagerStore.selectedFeeds.length == 1) ...[
                                // PIN FEED
                                TextButton.icon(
                                  onPressed: () async {
                                    if (feedManagerStore.selectedFeeds.first.isPinned) {
                                      // UNPIN
                                      await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeeds.first, false);
                                      await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                      setState(() {});
                                    } else {
                                      // PIN ITEM
                                      await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeeds.first, true);
                                      await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                      setState(() {});
                                    }
                                  },
                                  icon: feedManagerStore.selectedFeeds.first.isPinned
                                      ? const Icon(Icons.push_pin, size: 17)
                                      : const Icon(Icons.push_pin_outlined, size: 17),
                                  label: Text(feedManagerStore.selectedFeeds.first.isPinned ? "Unpin" : "Pin"),
                                ),

                                // const SizedBox(
                                //   height: 25,
                                //   child: VerticalDivider(),
                                // ),
                              ],

                              if (!feedManagerStore.areFeedsSelected &&
                                  feedManagerStore.areFeedGroupsSelected &&
                                  feedManagerStore.selectedFeedGroups.length == 1) ...[
                                // PIN FEED
                                TextButton.icon(
                                  onPressed: () async {
                                    if (feedManagerStore.selectedFeedGroups.first.isPinned) {
                                      // UNPIN
                                      await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeedGroups.first, false);
                                      await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                      setState(() {});
                                    } else {
                                      // PIN ITEM
                                      await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeedGroups.first, true);
                                      await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                      setState(() {});
                                    }
                                  },
                                  icon: feedManagerStore.selectedFeedGroups.first.isPinned
                                      ? const Icon(Icons.push_pin, size: 17)
                                      : const Icon(Icons.push_pin_outlined, size: 17),
                                  label: Text(feedManagerStore.selectedFeedGroups.first.isPinned ? "Unpin" : "Pin"),
                                ),

                                // const SizedBox(
                                //   height: 25,
                                //   child: VerticalDivider(),
                                // ),
                              ],

                              // EDIT FEED GROUP
                              if (feedManagerStore.areFeedGroupsSelected &&
                                  !feedManagerStore.areFeedsSelected &&
                                  feedManagerStore.selectedFeedGroups.length == 1) ...[
                                TextButton.icon(
                                  onPressed: () {
                                    feedManagerStore.toggleSelectionMode();

                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => EditFeedGroup(
                                          feedGroup: feedManagerStore.selectedFeedGroups.first,
                                          feedManagerStore: feedManagerStore,
                                        ),
                                      ),
                                    )
                                        .then((_) async {
                                      feedManagerStore.selectedFeeds.clear();
                                      feedManagerStore.selectedFeedGroups.clear();

                                      await widget.wrappedGetFeedGroups();
                                      await widget.wrappedGetPinnedFeedsOrFeedGroups();

                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.edit_outlined, size: 17),
                                  label: const Text("Edit"),
                                ),
                                // const SizedBox(
                                //   height: 25,
                                //   child: VerticalDivider(),
                                // ),
                              ],

                              if (feedManagerStore.areFeedsSelected && feedManagerStore.selectedFeeds.isNotEmpty) ...[
                                // ADD TO GROUP
                                TextButton.icon(
                                  onPressed: () {
                                    if (!feedManagerStore.areFeedGroupsSelected) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            List<FeedGroup> selectedFeedGroups = [];
                                            return StatefulBuilder(builder: (context, Function dialogSetState) {
                                              return AlertDialog(
                                                title: const Text("Add Feeds to Feed Group(s)"),
                                                content: Container(
                                                  constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.5),
                                                  child: SingleChildScrollView(
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        // SELECTABLE FEED GROUPS
                                                        ...feedStore.feedGroups.map(
                                                          (FeedGroup feedGroup) => Card.outlined(
                                                            color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                                                            clipBehavior: Clip.hardEdge,
                                                            child: ListTile(
                                                              leading: feedGroup.feeds.isEmpty
                                                                  ? const Icon(
                                                                      LucideIcons.folder,
                                                                      size: 15,
                                                                    )
                                                                  : Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        ...feedGroup.feeds.take(3).map(
                                                                              (feed) => CachedNetworkImage(imageUrl: feed.iconUrl, width: 12, height: 12),
                                                                            ),
                                                                      ],
                                                                    ),
                                                              title: Text(feedGroup.name),
                                                              trailing: selectedFeedGroups.contains(feedGroup)
                                                                  ? const Icon(Icons.check_circle_rounded)
                                                                  : const Icon(Icons.circle_outlined),
                                                              onTap: () {
                                                                if (selectedFeedGroups.contains(feedGroup)) {
                                                                  dialogSetState(() {
                                                                    selectedFeedGroups.remove(feedGroup);
                                                                  });
                                                                } else {
                                                                  dialogSetState(() {
                                                                    selectedFeedGroups.add(feedGroup);
                                                                  });
                                                                }
                                                              },
                                                              selected: selectedFeedGroups.contains(feedGroup),
                                                              selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await feedManagerStore.addFeedsToFeedGroup(selectedFeedGroups);
                                                      feedManagerStore.setSelectedFeed([]);
                                                      feedManagerStore.toggleSelectionMode();
                                                      Navigator.of(context).pop();
                                                      // update the ui to update the feed groups
                                                      setState(() {});
                                                    },
                                                    child: const Text("Confirm"),
                                                  ),
                                                ],
                                              );
                                            });
                                          }).then((_) {
                                        // widget.wrappedGetFeedGroups();
                                        // setState(() {});
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    LucideIcons.folder_plus,
                                    size: 17,
                                    color: feedManagerStore.areFeedGroupsSelected ? Theme.of(context).dividerColor.withOpacity(0.6) : null,
                                  ),
                                  label: Text(
                                    "Group",
                                    style: TextStyle(
                                      color: feedManagerStore.areFeedGroupsSelected ? Theme.of(context).dividerColor.withOpacity(0.6) : null,
                                    ),
                                  ),
                                ),

                                // const SizedBox(
                                //   height: 25,
                                //   child: VerticalDivider(),
                                // ),
                              ],

                              // DELETE FEED/FEED GROUP
                              TextButton.icon(
                                onPressed: () async {
                                  // show dialog to confirm deletion
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Delete?"),
                                        content: const Text("Are you sure you want to delete the selected items?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await feedManagerStore.handleDelete();
                                              await widget.wrappedGetFeeds();
                                              await widget.wrappedGetFeedGroups();
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Delete"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 17,
                                  color: (feedManagerStore.selectedFeedGroups.isNotEmpty || feedManagerStore.selectedFeeds.isNotEmpty)
                                      ? null
                                      : Theme.of(context).dividerColor.withOpacity(0.5),
                                ),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: (feedManagerStore.selectedFeedGroups.isNotEmpty || feedManagerStore.selectedFeeds.isNotEmpty)
                                        ? null
                                        : Theme.of(context).dividerColor.withOpacity(0.5),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
