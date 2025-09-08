import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feed_group/feed_group.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_manager/edit_feed.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FeedTile extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final FeedStore feedStore;
  final Feed feed;
  final Function wrappedGetFeeds;
  final Function wrappedGetFeedGroups;
  final Function wrappedGetPinnedFeedsOrFeedGroups;
  final bool isInPinnedList;

  const FeedTile({
    super.key,
    required this.feedManagerStore,
    required this.feed,
    required this.feedStore,
    required this.wrappedGetFeeds,
    required this.wrappedGetFeedGroups,
    required this.wrappedGetPinnedFeedsOrFeedGroups,
    required this.isInPinnedList,
  });

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  late FeedManagerStore feedManagerStore;
  late FeedStore feedStore;

  @override
  void initState() {
    super.initState();
    feedManagerStore = widget.feedManagerStore;
    feedStore = widget.feedStore;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Card.filled(
          color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: widget.feed.iconUrl,
                fit: BoxFit.contain,
                width: 30,
                height: 30,
              ),
            ),
            title: Text(widget.feed.name, overflow: TextOverflow.ellipsis),
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            visualDensity: VisualDensity.compact,
            selected: feedManagerStore.selectionMode && feedManagerStore.selectedFeeds.contains(widget.feed),
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.8),
            onLongPress: () => feedManagerStore.handleFeedTileLongPress(widget.feed),
            onTap: () {
              // Read the selection more BEFORE handling the selection logic (if we tap while selectionMode is on...)
              // We don't want to enter the edit feed page when tapping on the last selected item
              // (which turns off selection mode)
              bool selectionMode = feedManagerStore.selectionMode;

              feedManagerStore.handleFeedTileTap(widget.feed);

              if (!selectionMode) {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => EditFeed(
                          feed: widget.feed,
                          feedManagerStore: feedManagerStore,
                        ),
                      ),
                    )
                    .then((_) {
                      setState(() {});
                    });
              }
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                !feedManagerStore.selectionMode
                    ? PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          // if (widget.isInPinnedList) ...[
                          //   const PopupMenuItem(
                          //     value: "up",
                          //     child: Row(
                          //       children: [
                          //         Icon(Icons.arrow_upward),
                          //         SizedBox(width: 5),
                          //         Text("Move Up"),
                          //       ],
                          //     ),
                          //   ),
                          //   const PopupMenuItem(
                          //     value: "down",
                          //     child: Row(
                          //       children: [
                          //         Icon(Icons.arrow_downward),
                          //         SizedBox(width: 5),
                          //         Text("Move Down"),
                          //       ],
                          //     ),
                          //   ),
                          // ],
                          PopupMenuItem(
                            value: "pin",
                            child: Row(
                              children: [
                                widget.feed.isPinned ? const Icon(Icons.push_pin) : const Icon(Icons.push_pin_outlined),
                                const SizedBox(width: 5),
                                Text(widget.feed.isPinned ? "Unpin Feed" : "Pin Feed"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "edit",
                            child: Row(
                              children: [
                                const Icon(Icons.edit),
                                const SizedBox(width: 5),
                                Text("Edit"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "add_to_group",
                            child: Row(
                              children: [
                                Icon(LucideIcons.folder_plus),
                                SizedBox(width: 5),
                                Text("Add to Group"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 5),
                                Text("Delete"),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == "up") {
                            int newIndex = widget.feed.pinnedPosition - 1;
                            await feedManagerStore.reorderPinnedFeedsOrFeedGroups(widget.feed.pinnedPosition, newIndex);
                            // await widget.wrappedGetFeedGroups();
                            await widget.wrappedGetPinnedFeedsOrFeedGroups();
                            setState(() {});
                          } else if (value == "down") {
                            int newIndex = widget.feed.pinnedPosition + 1;
                            await feedManagerStore.reorderPinnedFeedsOrFeedGroups(widget.feed.pinnedPosition, newIndex);
                            await widget.wrappedGetPinnedFeedsOrFeedGroups();
                            setState(() {});
                          }
                          if (value == "pin") {
                            if (widget.feed.isPinned) {
                              // UNPIN
                              await feedManagerStore.pinOrUnpinItem(
                                widget.feed,
                                false,
                                toggleSelection: false,
                              );
                              await widget.wrappedGetPinnedFeedsOrFeedGroups();
                            } else {
                              // PIN ITEM
                              await feedManagerStore.pinOrUnpinItem(
                                widget.feed,
                                true,
                                toggleSelection: false,
                              );
                              await widget.wrappedGetPinnedFeedsOrFeedGroups();
                              setState(() {});
                            }
                          } else if (value == "edit") {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => EditFeed(
                                      feed: widget.feed,
                                      feedManagerStore: feedManagerStore,
                                    ),
                                  ),
                                )
                                .then((_) async {
                                  // await widget.wrappedGetFeedGroups();
                                  // await widget.wrappedGetPinnedFeedsOrFeedGroups();

                                  setState(() {});
                                });
                          } else if (value == "add_to_group") {
                            if (!feedManagerStore.areFeedGroupsSelected) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  List<FeedGroup> selectedFeedGroups = [];
                                  return StatefulBuilder(
                                    builder: (context, Function dialogSetState) {
                                      return AlertDialog(
                                        title: const Text("Add Feeds to Feed Group(s)"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (feedStore.feedGroups.isEmpty) ...[
                                              const Text("No Groups to select!"),
                                            ],
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
                                                            ...feedGroup.feeds
                                                                .take(3)
                                                                .map(
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
                                            ),
                                          ],
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
                                              feedManagerStore.addSelectedFeed(widget.feed);
                                              await feedManagerStore.addFeedsToFeedGroup(selectedFeedGroups);
                                              feedManagerStore.setSelectedFeed([]);
                                              Navigator.of(context).pop();

                                              await widget.wrappedGetFeedGroups();
                                              // update the ui to update the feed groups
                                              setState(() {});
                                            },
                                            child: const Text("Confirm"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ).then((_) {});
                            }
                          } else if (value == "delete") {
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
                                        feedManagerStore.selectedFeeds.add(widget.feed);
                                        await feedManagerStore.handleDelete(toggleSelection: false);
                                        await widget.wrappedGetFeeds();
                                        await widget.wrappedGetFeedGroups();
                                        // setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )
                    : const SizedBox(),
                Visibility(
                  visible: feedManagerStore.selectionMode,
                  child: feedManagerStore.selectedFeeds.contains(widget.feed) ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.circle_outlined),
                ),
                if (widget.isInPinnedList) ...[
                  ReorderableDragStartListener(index: feedStore.pinnedFeedsOrFeedGroups.indexOf(widget.feed), child: Icon(Icons.drag_indicator)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
