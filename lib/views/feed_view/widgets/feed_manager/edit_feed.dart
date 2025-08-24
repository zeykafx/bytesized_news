import 'package:bytesized_news/views/feed_view/widgets/feed_manager/feed_manager_store.dart';
import 'package:flutter/material.dart';

import '../../../../models/feed/feed.dart';

class EditFeed extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final Feed feed;

  const EditFeed(
      {super.key, required this.feed, required this.feedManagerStore});

  @override
  State<EditFeed> createState() => _EditFeedState();
}

class _EditFeedState extends State<EditFeed> {
  late FeedManagerStore feedManagerStore;

  late TextEditingController feedNameController;
  late TextEditingController feedLinkController;

  @override
  void initState() {
    super.initState();
    feedManagerStore = widget.feedManagerStore;

    feedNameController = TextEditingController(text: widget.feed.name);
    feedLinkController = TextEditingController(text: widget.feed.link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Feed"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: feedNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feed Name",
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: feedLinkController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feed Link",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // floating button bar at the bottom of the screen
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 70, left: 20, right: 20, top: 10),
                    child: Card.outlined(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SAVE CHANGES
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () async {
                                if (feedNameController.text.isEmpty ||
                                    feedLinkController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Feed Name or Feed Link cannot be empty"),
                                    ),
                                  );
                                  return;
                                }
                                widget.feed.name = feedNameController.text;
                                widget.feed.link = feedLinkController.text;

                                // used as an update method for the feed group in the db
                                await feedManagerStore.dbUtils
                                    .addFeed(widget.feed);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Successfully updated Feed!"),
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.save_outlined),
                              label: const Text("Save Changes"),
                            ),
                          ),
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
    );
  }
}
