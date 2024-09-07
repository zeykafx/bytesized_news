import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/edit_feed_group.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FeedGroupTile extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final FeedStore feedStore;
  final FeedGroup feedGroup;
  final Function wrappedGetFeeds;
  final Function wrappedGetFeedGroups;
  final Function wrappedGetPinnedFeedsOrFeedGroups;
  final Function updateParentState;
  final bool isInPinnedList;

  const FeedGroupTile({
    super.key,
    required this.feedManagerStore,
    required this.feedGroup,
    required this.feedStore,
    required this.wrappedGetFeeds,
    required this.wrappedGetFeedGroups,
    required this.wrappedGetPinnedFeedsOrFeedGroups,
    required this.updateParentState,
    required this.isInPinnedList,
  });

  @override
  State<FeedGroupTile> createState() => _FeedGroupTileState();
}

class _FeedGroupTileState extends State<FeedGroupTile> {
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
    return Observer(builder: (context) {
      return Card.filled(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        clipBehavior: Clip.hardEdge,
        child: Center(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            visualDensity: VisualDensity.compact,
            dense: true,
            leading: widget.feedGroup.feeds.isEmpty
                ? const Icon(
                    LucideIcons.folder,
                    size: 15,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.feedGroup.feeds.take(2).map(
                            (feed) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(imageUrl: feed.iconUrl, width: 17, height: 17),
                            ),
                          ),
                      if (widget.feedGroup.feeds.length > 2) ...[
                        const SizedBox(width: 5),
                        Text(
                          "+${widget.feedGroup.feeds.length - 2}",
                          style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.feedGroup.name),
                Text(
                  "${widget.feedGroup.feeds.length} feed${widget.feedGroup.feeds.length == 1 ? "" : "s"}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
            selected: feedManagerStore.selectionMode && feedManagerStore.selectedFeedGroups.contains(widget.feedGroup),
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
            onLongPress: () => feedManagerStore.handleFeedGroupLongPress(widget.feedGroup),
            onTap: () => feedManagerStore.handleFeedGroupTap(widget.feedGroup),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                !feedManagerStore.selectionMode
                    ? PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          if (widget.isInPinnedList) ...[
                            const PopupMenuItem(
                              value: "up",
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_upward),
                                  SizedBox(width: 5),
                                  Text("Move Up"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "down",
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_downward),
                                  SizedBox(width: 5),
                                  Text("Move Down"),
                                ],
                              ),
                            ),
                          ],
                          PopupMenuItem(
                            value: "pin",
                            child: Row(
                              children: [
                                widget.feedGroup.isPinned ? const Icon(Icons.push_pin) : const Icon(Icons.push_pin_outlined),
                                const SizedBox(width: 5),
                                Text(widget.feedGroup.isPinned ? "Unpin Feed Group" : "Pin Feed Group"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "edit",
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined),
                                SizedBox(width: 5),
                                Text("Edit"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "add_feeds",
                            child: Row(
                              children: [
                                Icon(Icons.rss_feed_outlined),
                                SizedBox(width: 5),
                                Text("Add Feeds"),
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
                            int newIndex = widget.feedGroup.pinnedPosition - 1;
                            await feedManagerStore.reorderPinnedFeedsOrFeedGroups(widget.feedGroup.pinnedPosition, newIndex);
                            await widget.wrappedGetPinnedFeedsOrFeedGroups();
                            setState(() {});
                          } else if (value == "down") {
                            int newIndex = widget.feedGroup.pinnedPosition + 1;
                            await feedManagerStore.reorderPinnedFeedsOrFeedGroups(widget.feedGroup.pinnedPosition, newIndex);
                            await widget.wrappedGetPinnedFeedsOrFeedGroups();
                            setState(() {});
                          } else if (value == "pin") {
                            if (widget.feedGroup.isPinned) {
                              // UNPIN
                              await feedManagerStore.pinOrUnpinItem(
                                widget.feedGroup,
                                false,
                                toggleSelection: false,
                              );
                              await widget.wrappedGetPinnedFeedsOrFeedGroups();
                            } else {
                              // PIN ITEM
                              await feedManagerStore.pinOrUnpinItem(
                                widget.feedGroup,
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
                                builder: (context) => EditFeedGroup(
                                  feedGroup: widget.feedGroup,
                                  feedManagerStore: feedManagerStore,
                                ),
                              ),
                            )
                                .then((_) async {
                              await widget.wrappedGetFeedGroups();
                              await widget.wrappedGetPinnedFeedsOrFeedGroups();

                              setState(() {});
                            });
                          } else if (value == "add_feeds") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  List<Feed> selectedFeeds = [];
                                  return StatefulBuilder(builder: (context, Function dialogSetState) {
                                    return AlertDialog(
                                      title: const Text("Add Feeds to this Feed Group"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (feedStore.feeds.isEmpty) ...[
                                              const Text("No feeds to select!"),
                                            ],

                                            // SELECTABLE FEED GROUPS
                                            ...feedStore.feeds.map(
                                              (Feed feed) => Card.outlined(
                                                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                                                clipBehavior: Clip.hardEdge,
                                                child: ListTile(
                                                  leading: CachedNetworkImage(imageUrl: feed.iconUrl, width: 20, height: 20),
                                                  title: Text(feed.name),
                                                  trailing:
                                                      selectedFeeds.contains(feed) ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.circle_outlined),
                                                  onTap: () {
                                                    if (selectedFeeds.contains(feed)) {
                                                      dialogSetState(() {
                                                        selectedFeeds.remove(feed);
                                                      });
                                                    } else {
                                                      dialogSetState(() {
                                                        selectedFeeds.add(feed);
                                                      });
                                                    }
                                                  },
                                                  selected: selectedFeeds.contains(feed),
                                                  selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                                                ),
                                              ),
                                            )
                                          ],
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
                                            await feedManagerStore.addSelectedFeedsToAFeedGroup(selectedFeeds, widget.feedGroup);
                                            Navigator.of(context).pop();
                                            // // update the ui to update the feed groups
                                            setState(() {});
                                          },
                                          child: const Text("Confirm"),
                                        ),
                                      ],
                                    );
                                  });
                                }).then((_) {});
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
                                        feedManagerStore.selectedFeedGroups.add(widget.feedGroup);
                                        await feedManagerStore.handleDelete(toggleSelection: false);
                                        // await widget.wrappedGetFeeds();
                                        // await widget.wrappedGetFeedGroups();
                                        await widget.wrappedGetPinnedFeedsOrFeedGroups();
                                        widget.updateParentState();
                                        // setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Delete"),
                                    )
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
                  child: feedManagerStore.selectedFeedGroups.contains(widget.feedGroup)
                      ? const Icon(Icons.check_circle_rounded)
                      : const Icon(Icons.circle_outlined),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
