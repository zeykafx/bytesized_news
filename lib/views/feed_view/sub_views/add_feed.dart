import 'package:bytesized_news/AI/ai_utils.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/rss_feed.dart';

class AddFeed extends StatefulWidget {
  final Function getFeeds;
  final Function getItems;

  const AddFeed({super.key, required this.getFeeds, required this.getItems});

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  late Isar isar;
  late DbUtils dbUtils;
  late AiUtils aiUtils;
  TextEditingController feedLinkController = TextEditingController();
  TextEditingController feedNameController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
    dbUtils = DbUtils(isar: isar);
    AuthStore authStore = context.read<AuthStore>();
    aiUtils = AiUtils(authStore);
  }

  Future<void> addFeedToDb(Feed feed) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fetching categories for feed, please wait..."),
      ),
    );
    loading = true;
    // List<String> categories = await aiUtils.getFeedCategories(feed);
    loading = false;

    // feed.categories = categories;
    await dbUtils.addFeed(feed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Feed"),
      ),
      body: Column(
        children: [
          if (loading) LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "Add a new feed",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        // feed link input
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "Feed Link",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // hintText: "Feed Link",
                            labelText: "Feed Link",
                          ),
                          controller: feedLinkController,
                        ),

                        const SizedBox(height: 20),

                        // feed name input
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "Feed Name (Optional)",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Feed Name",
                          ),
                          controller: feedNameController,
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.tonal(
                            onPressed: () async {
                              Dio dio = Dio();

                              String feedLink = feedLinkController.text;
                              String feedName = feedNameController.text;

                              Response res;
                              try {
                                res = await dio.get(feedLink);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid link")));
                                return;
                              }

                              try {
                                AtomFeed.parse(res.data);
                              } catch (e) {
                                try {
                                  RssFeed.parse(res.data);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid RSS/ATOM feed")));
                                  return;
                                }
                              }

                              if (feedName.isEmpty) {
                                Feed? feed = await Feed.createFeed(feedLink);
                                if (feed == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid feed link.")));
                                }
                                await addFeedToDb(feed!);
                              } else {
                                Feed? feed = await Feed.createFeed(feedLink, feedName: feedName);
                                if (feed == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid feed link.")));
                                }
                                await addFeedToDb(feed!);
                              }
                              if (kDebugMode) {
                                print("Adding feed to db: $feedLink");
                              }
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully added feed!")));

                              await widget.getFeeds();
                              await widget.getItems();
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 2),
                                Text("Add feed"),
                              ],
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
        ],
      ),
    );
  }
}
