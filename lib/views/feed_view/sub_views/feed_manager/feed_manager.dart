import 'package:bytesized_news/main.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/add_feed.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FeedManager extends StatefulWidget {
  final FeedStore feedStore;
  final Function wrappedGetFeeds;
  final Function wrappedGetFeedGroups;

  const FeedManager({super.key, required this.feedStore, required this.wrappedGetFeeds, required this.wrappedGetFeedGroups});

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool popped, dynamic result) {
        // if we are currently selecting things, get out of the selection mode and reset the selected feeds, otherwise collapse the bsb
        // TODO DO THE SAME FOR FEED GROUPS
        if (feedManagerStore.selectionMode) {
          feedManagerStore.toggleSelectionMode();
          feedManagerStore.setSelectedFeed([]);
        } else {
          feedStore.bsbController.collapse();
        }
      },
      child: Observer(builder: (_) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // search bar
                      // ...

                      // add feed button, new feed group button
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => AddFeed(
                                    getFeeds: widget.wrappedGetFeeds,
                                  ),
                                ),
                              )
                                  .then((_) async {
                                await widget.wrappedGetFeeds();

                                setState(() {});
                              });
                            },
                            label: const Text("Add Feed"),
                            icon: const Icon(LucideIcons.rss),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController feedGroupNameController = TextEditingController();
                                    return AlertDialog(
                                      title: const Text("Create Feed Group"),
                                      content: TextField(
                                        controller: feedGroupNameController,
                                        autocorrect: true,
                                        enableSuggestions: true,
                                        textCapitalization: TextCapitalization.words,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Feed Group Name",
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
                                          onPressed: () {
                                            feedStore.createFeedGroup(feedGroupNameController.text, context);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Create"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            label: const Text("Create Feed Group"),
                            icon: const Icon(LucideIcons.folder_plus),
                          ),
                        ],
                      ),

                      const Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      // pinned feeds/feed groups
                      // ...

                      // all feeds and feed groups
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // FeedGroups

                          GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            shrinkWrap: true,
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              ...feedStore.feedGroups.map((elem) {
                                return Card.outlined(
                                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                                  clipBehavior: Clip.hardEdge,
                                  child: ListTile(
                                    leading: elem.feeds.isEmpty
                                        ? const Icon(
                                            LucideIcons.folder,
                                            size: 15,
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ...elem.feeds.take(3).map(
                                                    (feed) => CachedNetworkImage(imageUrl: feed.iconUrl, width: 12, height: 12),
                                                  ),
                                            ],
                                          ),
                                    title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(elem.name),
                                        Text(
                                          "${elem.feeds.length} feed${elem.feeds.length == 1 ? "" : "s"}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).dividerColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: feedManagerStore.selectionMode
                                        ? feedManagerStore.selectedFeedGroups.contains(elem)
                                            ? const Icon(Icons.check_circle_rounded)
                                            : const Icon(Icons.circle_outlined)
                                        : null,
                                    selected: feedManagerStore.selectionMode && feedManagerStore.selectedFeedGroups.contains(elem),
                                    selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
                                    onLongPress: () {
                                      if (!feedManagerStore.selectionMode) {
                                        feedManagerStore.toggleSelectionMode();
                                      }
                                      if (!feedManagerStore.selectedFeedGroups.contains(elem)) {
                                        feedManagerStore.addSelectedFeedGroup(elem);
                                      } else {
                                        feedManagerStore.removeSelectedFeedGroup(elem);
                                        if (feedManagerStore.selectedFeedGroups.isEmpty && feedManagerStore.selectedFeeds.isEmpty) {
                                          feedManagerStore.toggleSelectionMode();
                                        }
                                      }
                                    },
                                    onTap: () {
                                      if (feedManagerStore.selectionMode && !feedManagerStore.selectedFeedGroups.contains(elem)) {
                                        feedManagerStore.addSelectedFeedGroup(elem);
                                      } else if (feedManagerStore.selectionMode) {
                                        feedManagerStore.removeSelectedFeedGroup(elem);
                                        if (feedManagerStore.selectedFeedGroups.isEmpty && feedManagerStore.selectedFeeds.isEmpty) {
                                          feedManagerStore.toggleSelectionMode();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // feeds
                          ...feedStore.feeds.map((feed) {
                            return Card.outlined(
                              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                              clipBehavior: Clip.hardEdge,
                              child: ListTile(
                                leading: CachedNetworkImage(imageUrl: feed.iconUrl, width: 20, height: 20),
                                title: Text(feed.name),
                                trailing: feedManagerStore.selectionMode
                                    ? feedManagerStore.selectedFeeds.contains(feed)
                                        ? const Icon(Icons.check_circle_rounded)
                                        : const Icon(Icons.circle_outlined)
                                    : null,
                                selected: feedManagerStore.selectionMode && feedManagerStore.selectedFeeds.contains(feed),
                                selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
                                onLongPress: () {
                                  if (!feedManagerStore.selectionMode) {
                                    feedManagerStore.toggleSelectionMode();
                                  }
                                  if (!feedManagerStore.selectedFeeds.contains(feed)) {
                                    feedManagerStore.addSelectedFeed(feed);
                                  } else {
                                    feedManagerStore.removeSelectedFeed(feed);
                                    if (feedManagerStore.selectedFeeds.isEmpty && feedManagerStore.selectedFeedGroups.isEmpty) {
                                      feedManagerStore.toggleSelectionMode();
                                    }
                                  }
                                },
                                onTap: () {
                                  if (feedManagerStore.selectionMode && !feedManagerStore.selectedFeeds.contains(feed)) {
                                    feedManagerStore.addSelectedFeed(feed);
                                  } else if (feedManagerStore.selectionMode) {
                                    feedManagerStore.removeSelectedFeed(feed);
                                    if (feedManagerStore.selectedFeeds.isEmpty && feedManagerStore.selectedFeedGroups.isEmpty) {
                                      feedManagerStore.toggleSelectionMode();
                                    }
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                // floating button bar at the bottom of the screen
                Visibility(
                  visible: feedManagerStore.selectionMode,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Card.outlined(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // PIN FEED
                            TextButton.icon(
                              onPressed: () {
                                // TODO
                              },
                              icon: const Icon(Icons.push_pin_outlined),
                              label: const Text("Pin"),
                            ),

                            const SizedBox(
                              height: 25,
                              child: VerticalDivider(),
                            ),

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
                                            content: Column(
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
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  feedManagerStore.addFeedsToFeedGroup(selectedFeedGroups);
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
                                      });
                                }
                              },
                              icon: Icon(
                                LucideIcons.folder_plus,
                                color: feedManagerStore.areFeedGroupsSelected ? Theme.of(context).dividerColor.withOpacity(0.6) : null,
                              ),
                              label: Text(
                                "Add to group",
                                style: TextStyle(
                                  color: feedManagerStore.areFeedGroupsSelected ? Theme.of(context).dividerColor.withOpacity(0.6) : null,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 25,
                              child: VerticalDivider(),
                            ),

                            // DELETE FEED/FEED GROUP
                            TextButton.icon(
                              onPressed: () async {
                                await feedManagerStore.handleDelete();
                                setState(() {});
                                widget.wrappedGetFeeds();
                                widget.wrappedGetFeedGroups();
                              },
                              icon: const Icon(Icons.delete_outline),
                              label: const Text("Delete"),
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
        );
      }),
    );
  }
}
