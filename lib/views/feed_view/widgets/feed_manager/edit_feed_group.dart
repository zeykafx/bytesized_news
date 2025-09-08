import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feed_group/feed_group.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EditFeedGroup extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final FeedGroup feedGroup;

  const EditFeedGroup({super.key, required this.feedGroup, required this.feedManagerStore});

  @override
  State<EditFeedGroup> createState() => _EditFeedGroupState();
}

class _EditFeedGroupState extends State<EditFeedGroup> {
  late FeedManagerStore feedManagerStore;

  bool selectionMode = false;
  List<Feed> selectedFeeds = [];

  late TextEditingController feedGroupNameController;

  @override
  void initState() {
    super.initState();
    feedManagerStore = widget.feedManagerStore;

    feedGroupNameController = TextEditingController(text: widget.feedGroup.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Feed Group"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: feedManagerStore.feedStore.settingsStore.maxWidth),
          child: Card.filled(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
            margin: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit ${widget.feedGroup.name}",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(height: 20),

                          TextField(
                            controller: feedGroupNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feed Group Name",
                            ),
                          ),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${widget.feedGroup.feeds.length} ${widget.feedGroup.feeds.length > 1 ? "Feeds" : "Feed"}",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // all feeds
                          ...widget.feedGroup.feeds.map((feed) {
                            return Card.outlined(
                              color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.4),
                              clipBehavior: Clip.hardEdge,
                              child: ListTile(
                                leading: CachedNetworkImage(imageUrl: feed.iconUrl, width: 20, height: 20),
                                title: Text(feed.name),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    !selectionMode
                                        ? PopupMenuButton(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: "remove",
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.remove_circle_outline),
                                                    SizedBox(width: 5),
                                                    Text("Remove from Group"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onSelected: (value) async {
                                              if (value == "remove") {
                                                // show dialog to confirm deletion
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text("Remove from Group?"),
                                                      content: const Text("Are you sure you want to remove the selected items from this group?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            widget.feedGroup.feeds.remove(feed);
                                                            widget.feedGroup.feedUrls = widget.feedGroup.feedUrls
                                                                .where((String feedUrl) => feed.link != feedUrl)
                                                                .toList();
                                                            // used as an update method for the feed group in the db
                                                            await feedManagerStore.dbUtils.addFeedGroup(widget.feedGroup);
                                                            setState(() {
                                                              selectionMode = false;
                                                              selectedFeeds.clear();
                                                            });
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(content: Text("Successfully removed feeds from Feed Group!")),
                                                            );
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Remove"),
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
                                      visible: selectionMode,
                                      child: selectedFeeds.contains(feed) ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.circle_outlined),
                                    ),
                                  ],
                                ),
                                selected: selectionMode && selectedFeeds.contains(feed),
                                selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
                                onLongPress: () {
                                  if (!selectionMode) {
                                    setState(() {
                                      selectionMode = true;
                                    });
                                  }
                                  if (!selectedFeeds.contains(feed)) {
                                    setState(() {
                                      selectedFeeds.add(feed);
                                    });
                                  } else {
                                    setState(() {
                                      selectedFeeds.remove(feed);
                                    });
                                    if (selectedFeeds.isEmpty) {
                                      setState(() {
                                        selectionMode = false;
                                      });
                                    }
                                  }
                                },
                                onTap: () {
                                  if (!selectionMode) {
                                    setState(() {
                                      selectionMode = true;
                                    });
                                  }
                                  if (selectionMode && !selectedFeeds.contains(feed)) {
                                    // addSelectedFeed(feed);
                                    setState(() {
                                      selectedFeeds.add(feed);
                                    });
                                  } else if (selectionMode) {
                                    setState(() {
                                      selectedFeeds.remove(feed);
                                    });
                                    if (selectedFeeds.isEmpty) {
                                      setState(() {
                                        selectionMode = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // floating button bar at the bottom of the screen
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card.outlined(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.8),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (selectionMode) ...[
                              // CANCEL SELECTION
                              Expanded(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.cancel_outlined),
                                  label: const Text("Cancel"),
                                  onPressed: () {
                                    setState(() {
                                      selectionMode = false;
                                      selectedFeeds.clear();
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(),
                              ),

                              // DELETE FEED/FEED GROUP
                              Expanded(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  label: const Text(
                                    "Remove from Group",
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () async {
                                    // show dialog to confirm deletion
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Remove from Group?"),
                                          content: const Text("Are you sure you want to remove the selected items from this group?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                widget.feedGroup.feeds.removeWhere((feed) => selectedFeeds.contains(feed));
                                                widget.feedGroup.feedUrls = widget.feedGroup.feedUrls
                                                    .where((String feedUrl) => !selectedFeeds.map((feed) => feed.link).contains(feedUrl))
                                                    .toList();
                                                // used as an update method for the feed group in the db
                                                await feedManagerStore.dbUtils.addFeedGroup(widget.feedGroup);
                                                setState(() {
                                                  selectionMode = false;
                                                  selectedFeeds.clear();
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Successfully removed feeds from Feed Group!")),
                                                );
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Remove"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                            if (!selectionMode) ...[
                              // SAVE CHANGES
                              Expanded(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.save_outlined),
                                  label: const Text("Save Changes"),
                                  onPressed: () async {
                                    if (feedGroupNameController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feed Group Name cannot be empty")));
                                      return;
                                    }
                                    widget.feedGroup.name = feedGroupNameController.text;

                                    // feedGroup.feedNames.remove(feed.name);
                                    // feedGroup.feeds.removeWhere((f) => f.name == feed.name);
                                    // await dbUtils.addFeedsToFeedGroup(feedGroup);

                                    // used as an update method for the feed group in the db
                                    await feedManagerStore.dbUtils.addFeedGroup(widget.feedGroup);
                                    await feedManagerStore.feedSync.updateFirestoreFeedGroups();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully updated Feed Group!")));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
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
  }
}
