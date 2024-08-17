import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:isar/isar.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/rss_feed.dart';

class AddFeed extends StatefulWidget {
  Function getFeeds;

  AddFeed({super.key, required this.getFeeds});

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  late Isar isar;
  late DbUtils dbUtils;
  TextEditingController feedLinkController = TextEditingController();
  TextEditingController feedNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
    dbUtils = DbUtils(isar: isar);
  }

  Future<void> addFeedToDb(Feed feed) async {
    await dbUtils.addFeed(feed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Feed"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              clipBehavior: Clip.hardEdge,
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
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
                          bool validLink = false;

                          Dio dio = Dio();

                          String feedLink = feedLinkController.text;
                          String feedName = feedNameController.text;

                          Response res;
                          try {
                            res = await dio.get(feedLink);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid RSS/ATOM feed")));
                            return;
                          }

                          RssFeed rssFeed;
                          AtomFeed atomFeed;
                          try {
                            rssFeed = RssFeed.parse(res.data);
                          } catch (e) {
                            try {
                              atomFeed = AtomFeed.parse(res.data);
                            } catch (e) {
                              validLink = false;
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid RSS/ATOM feed")));
                              return;
                            }
                          }
                          validLink = true;

                          if (feedName.isEmpty) {
                            addFeedToDb(await Feed.createFeed(feedLink));
                          } else {
                            addFeedToDb(Feed(feedName, feedLink));
                          }
                          if (kDebugMode) {
                            print("Adding feed to db: $feedLink");
                          }
                          await widget.getFeeds();

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully added feed!")));
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
    );
  }
}
