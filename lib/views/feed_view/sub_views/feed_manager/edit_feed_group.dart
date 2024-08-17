import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../models/feed/feed.dart';

class EditFeedGroup extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final FeedGroup feedGroup;

  const EditFeedGroup({super.key, required this.feedGroup, required this.feedManagerStore});

  @override
  State<EditFeedGroup> createState() => _EditFeedGroupState();
}

class _EditFeedGroupState extends State<EditFeedGroup> {
  late FeedManagerStore feedManagerStore;

  late FeedGroup feedGroup;

  bool selectionMode = false;
  List<Feed> selectedFeeds = [];

  late TextEditingController feedGroupNameController;

  @override
  void initState() {
    super.initState();
    feedManagerStore = widget.feedManagerStore;
    feedGroup = widget.feedGroup;

    feedGroupNameController = TextEditingController(text: feedGroup.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Feed Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: feedGroupNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feed Group Name",
                            ),
                          ),
                        ),
                        const Divider(),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${feedGroup.feeds.length} ${feedGroup.feeds.length > 1 ? "Feeds" : "Feed"}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        // all feeds
                        ...feedGroup.feeds.map((feed) {
                          return Card.outlined(
                            color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                            clipBehavior: Clip.hardEdge,
                            child: ListTile(
                              leading: CachedNetworkImage(imageUrl: feed.iconUrl, width: 20, height: 20),
                              title: Text(feed.name),
                              trailing: selectionMode
                                  ? selectedFeeds.contains(feed)
                                      ? const Icon(Icons.check_circle_rounded)
                                      : const Icon(Icons.circle_outlined)
                                  : null,
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
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // floating button bar at the bottom of the screen
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Card.outlined(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (selectionMode) ...[
                        // CANCEL SELECTION
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectionMode = false;
                              selectedFeeds.clear();
                            });
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text("Cancel"),
                        ),

                        const SizedBox(
                          height: 25,
                          child: VerticalDivider(),
                        ),

                        // DELETE FEED/FEED GROUP
                        TextButton.icon(
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
                                        feedGroup.feeds.removeWhere((feed) => selectedFeeds.contains(feed));
                                        feedGroup.feedNames.removeWhere((feedName) => selectedFeeds.map((feed) => feed.name).contains(feedName));
                                        // used as an update method for the feed group in the db
                                        await feedManagerStore.dbUtils.addFeedGroup(feedGroup);
                                        setState(() {
                                          selectionMode = false;
                                          selectedFeeds.clear();
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(content: Text("Successfully removed feeds from Feed Group!")));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Remove"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          label: const Text("Remove from Group"),
                        ),
                      ],
                      if (!selectionMode) ...[
                        // SAVE CHANGES
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () async {
                              if (feedGroupNameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feed Group Name cannot be empty")));
                                return;
                              }
                              feedGroup.name = feedGroupNameController.text;

                              // feedGroup.feedNames.remove(feed.name);
                              // feedGroup.feeds.removeWhere((f) => f.name == feed.name);
                              // await dbUtils.addFeedsToFeedGroup(feedGroup);

                              // used as an update method for the feed group in the db
                              await feedManagerStore.dbUtils.addFeedGroup(feedGroup);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully updated Feed Group!")));
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.save_outlined),
                            label: const Text("Save Changes"),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}