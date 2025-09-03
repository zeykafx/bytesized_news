import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_manager/feed_manager_store.dart';
import 'package:flutter/material.dart';

class EditFeed extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final Feed feed;

  const EditFeed({super.key, required this.feed, required this.feedManagerStore});

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
                        spacing: 20,
                        children: [
                          Text(
                            "Edit ${widget.feed.name}",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          TextField(
                            controller: feedNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feed Name",
                            ),
                          ),

                          TextField(
                            controller: feedLinkController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feed Link",
                            ),
                          ),

                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("Always open in webview"),
                            subtitle: const Text(
                              "When enabled, the story reader will not attempt to parse and simplify the webpage, it will directly open the webview",
                            ),
                            value: widget.feed.alwaysOpenInWebview,
                            onChanged: (value) {
                              setState(() {
                                widget.feed.alwaysOpenInWebview = value;
                              });
                            },
                          ),
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
                            // SAVE CHANGES
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () async {
                                  if (feedNameController.text.isEmpty || feedLinkController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Feed Name or Feed Link cannot be empty"),
                                      ),
                                    );
                                    return;
                                  }
                                  widget.feed.name = feedNameController.text;
                                  widget.feed.link = feedLinkController.text;

                                  // used as an update method for the feed group in the db
                                  await feedManagerStore.dbUtils.addFeed(widget.feed);
                                  await feedManagerStore.feedSync.updateFirestoreFeeds();
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
      ),
    );
  }
}
