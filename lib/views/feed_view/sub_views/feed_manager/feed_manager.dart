import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/curated_feeds/curated_feeds.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/add_feed.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/edit_feed.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_group_tile.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
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

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return PopScope(
      canPop: feedStore.isExpanded ? false : true,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  // main content
                  Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      physics: feedManagerStore.isReordering ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // little handle
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 3),
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // add feed button, new feed group button
                          Card.outlined(
                            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.1),
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
                                        // MaterialPageRoute(
                                        //   builder: (context) => AddFeed(
                                        //     getFeeds: widget.wrappedGetFeeds,
                                        //     getItems: widget.wrappedGetItems,
                                        //   ),
                                        MaterialPageRoute(
                                          builder: (context) => CuratedFeeds(),
                                        ),
                                      )
                                          .then((_) async {
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

                          // pinned feeds/feed groups
                          if (feedStore.pinnedFeedsOrFeedGroups.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 15, right: 8, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Text(
                                        "Pinned:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        feedStore.pinnedFeedsOrFeedGroups.length.toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Tooltip(
                                    message: feedManagerStore.pinnedListExpanded ? "Hide the pinned feeds" : "Expand the pinned feeds",
                                    child: IconButton(
                                      icon: Icon(
                                        feedManagerStore.pinnedListExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 25,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: feedManagerStore.handlePinnedExpandedButtonTap,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              switchInCurve: Curves.easeOutQuad,
                              switchOutCurve: Curves.easeInQuad,
                              transitionBuilder: (child, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                );
                              },
                              child: feedManagerStore.pinnedListExpanded
                                  ? ReorderableListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      dragStartBehavior: DragStartBehavior.down,
                                      onReorderStart: (_) {
                                        widget.feedStore.scrollController.jumpTo(0);
                                        feedStore.bsbController.expand();

                                        feedStore.isLocked = true;
                                        feedManagerStore.isReordering = true;
                                      },
                                      onReorderEnd: (_) {
                                        feedManagerStore.isReordering = false;
                                        feedStore.isLocked = false;
                                        feedStore.bsbController.expand();
                                        widget.feedStore.scrollController.jumpTo(0);
                                      },
                                      onReorder: feedManagerStore.reorderPinnedFeedsOrFeedGroups,
                                      buildDefaultDragHandles: true,
                                      children: [
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
                                              updateParentState: updateState,
                                              isInPinnedList: true,
                                            );
                                          }
                                        }),
                                      ],
                                    )
                                  : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Divider(thickness: 0.1),
                            ),
                          ],

                          // all feeds and feed groups
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 5,
                                  children: [
                                    Text(
                                      "Feeds:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      feedStore.feeds.length.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Tooltip(
                                  message: "Swap between list and grid mode",
                                  child: IconButton(
                                      icon: Icon(
                                        feedManagerStore.isList ? LucideIcons.layout_grid : LucideIcons.layout_list,
                                        size: 18,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        feedManagerStore.isList = !feedManagerStore.isList;
                                      }),
                                )
                              ],
                            ),
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // FeedGroups
                              GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: mediaQuery.size.width > 700 ? 6 : 3,
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
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
                                      updateParentState: updateState,
                                      isInPinnedList: false,
                                    );
                                  }),
                                ],
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // TODO: use animated fractionally sized thingy
                              GridView.count(
                                crossAxisCount: feedManagerStore.isList ? 1 : 2,
                                childAspectRatio: mediaQuery.size.width > 700 ? (feedManagerStore.isList ? 14 : 7) : (feedManagerStore.isList ? 8 : 4.3),
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  // Feeds
                                  ...feedStore.feeds.map((feed) {
                                    return FeedTile(
                                      feedManagerStore: feedManagerStore,
                                      feedStore: feedStore,
                                      feed: feed,
                                      wrappedGetFeedGroups: widget.wrappedGetFeedGroups,
                                      wrappedGetFeeds: widget.wrappedGetFeeds,
                                      wrappedGetPinnedFeedsOrFeedGroups: widget.wrappedGetPinnedFeedsOrFeedGroups,
                                      isInPinnedList: false,
                                    )
                                        .animate(value: feedManagerStore.isList ? 1 : 0)
                                        .fade(curve: Curves.easeInOutQuad)
                                        .animate(value: feedManagerStore.isList ? 0 : 1)
                                        .fade(curve: Curves.easeInOutQuad);
                                  }),
                                ],
                              ),

                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // floating button bar at the bottom of the screen
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSlide(
                      duration: 200.ms,
                      curve: Curves.easeInOutQuad,
                      offset: feedManagerStore.selectionMode ? Offset(0, 0) : Offset(0, 2),
                      child: AnimatedSize(
                        duration: 100.ms,
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: mediaQuery.size.width > 600 ? 30 : 15),
                          child: Card.outlined(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // CANCEL SELECTION
                                    IconButton(
                                      onPressed: () {
                                        feedManagerStore.selectionMode = false;
                                        feedManagerStore.selectedFeeds.clear();
                                        feedManagerStore.selectedFeedGroups.clear();
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        size: 25,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      // label: const Text("Cancel"),
                                    ),

                                    // PIN FEED
                                    if (feedManagerStore.areFeedsSelected && !feedManagerStore.areFeedGroupsSelected
                                        // && feedManagerStore.selectedFeeds.length == 1
                                        ) ...[
                                      TextButton.icon(
                                        onPressed: () async {
                                          feedManagerStore.selectedFeeds.forEach((Feed selectedFeed) async {
                                            // PIN OR UNPIN
                                            await feedManagerStore.pinOrUnpinItem(selectedFeed, !selectedFeed.isPinned, toggleSelection: false);
                                            await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                            setState(() {});
                                          });

                                          feedManagerStore.selectedFeeds.clear();
                                          feedManagerStore.selectedFeedGroups.clear();
                                          feedManagerStore.toggleSelectionMode();

                                          // if (feedManagerStore.selectedFeeds.first.isPinned) {
                                          //   // UNPIN
                                          //   await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeeds.first, false);
                                          //   await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                          //   setState(() {});
                                          // } else {
                                          //   // PIN ITEM
                                          //   await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeeds.first, true);
                                          //   await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                          //   setState(() {});
                                          // }
                                        },
                                        icon: feedManagerStore.selectedFeeds.first.isPinned
                                            ? const Icon(Icons.push_pin, size: 15)
                                            : const Icon(Icons.push_pin_outlined, size: 15),
                                        label: Text(feedManagerStore.selectedFeeds.first.isPinned ? "Unpin" : "Pin"),
                                      ),
                                    ],

                                    // PIN FEED GROUP
                                    if (!feedManagerStore.areFeedsSelected && feedManagerStore.areFeedGroupsSelected
                                        // && feedManagerStore.selectedFeedGroups.length == 1
                                        ) ...[
                                      TextButton.icon(
                                        onPressed: () async {
                                          feedManagerStore.selectedFeedGroups.forEach((FeedGroup selectedFeedGroup) async {
                                            // PIN OR UNPIN
                                            await feedManagerStore.pinOrUnpinItem(selectedFeedGroup, !selectedFeedGroup.isPinned, toggleSelection: false);
                                            await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                            setState(() {});
                                          });

                                          feedManagerStore.selectedFeeds.clear();
                                          feedManagerStore.selectedFeedGroups.clear();
                                          feedManagerStore.toggleSelectionMode();

                                          // if (feedManagerStore.selectedFeedGroups.first.isPinned) {
                                          //   // UNPIN
                                          //   await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeedGroups.first, false);
                                          //   await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                          //   setState(() {});
                                          // } else {
                                          //   // PIN ITEM
                                          //   await feedManagerStore.pinOrUnpinItem(feedManagerStore.selectedFeedGroups.first, true);
                                          //   await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                          //   setState(() {});
                                          // }
                                        },
                                        icon: feedManagerStore.selectedFeedGroups.first.isPinned
                                            ? const Icon(Icons.push_pin, size: 15)
                                            : const Icon(Icons.push_pin_outlined, size: 15),
                                        label: Text(feedManagerStore.selectedFeedGroups.first.isPinned ? "Unpin" : "Pin"),
                                      ),
                                    ],

                                    // EDIT FEED
                                    if (feedManagerStore.areFeedsSelected && !feedManagerStore.areMoreThanOneFeedGroupsSelected) ...[
                                      TextButton.icon(
                                        onPressed: () {
                                          feedManagerStore.toggleSelectionMode();

                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) => EditFeed(
                                                feed: feedManagerStore.selectedFeeds.first,
                                                feedManagerStore: feedManagerStore,
                                              ),
                                            ),
                                          )
                                              .then((_) async {
                                            feedManagerStore.selectedFeeds.clear();
                                            feedManagerStore.selectedFeedGroups.clear();

                                            setState(() {});
                                          });
                                        },
                                        icon: const Icon(Icons.edit_outlined, size: 15),
                                        label: const Text("Edit"),
                                      ),
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
                                        icon: const Icon(Icons.edit_outlined, size: 15),
                                        label: const Text("Edit"),
                                      ),
                                    ],

                                    // ADD TO GROUP
                                    if (feedManagerStore.areFeedsSelected && feedManagerStore.selectedFeeds.isNotEmpty) ...[
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
                                                                  color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.1),
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
                                                                    selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
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
                                                }).then((_) {});
                                          }
                                        },
                                        icon: Icon(
                                          LucideIcons.folder_plus,
                                          size: 15,
                                          color: feedManagerStore.areFeedGroupsSelected ? Theme.of(context).dividerColor.withValues(alpha: 0.6) : null,
                                        ),
                                        label: Text(
                                          "Group",
                                          style: TextStyle(
                                            color: feedManagerStore.areFeedGroupsSelected ? Theme.of(context).dividerColor.withValues(alpha: 0.6) : null,
                                          ),
                                        ),
                                      ),
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
                                        size: 15,
                                        color: (feedManagerStore.selectedFeedGroups.isNotEmpty || feedManagerStore.selectedFeeds.isNotEmpty)
                                            ? null
                                            : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                                      ),
                                      label: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: (feedManagerStore.selectedFeedGroups.isNotEmpty || feedManagerStore.selectedFeeds.isNotEmpty)
                                              ? null
                                              : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
