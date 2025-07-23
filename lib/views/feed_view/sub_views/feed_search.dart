import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_story_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FeedSearch extends StatefulWidget {
  final FeedStore feedStore;
  const FeedSearch({
    super.key,
    required this.feedStore,
  });

  @override
  State<FeedSearch> createState() => _FeedSearchState();
}

class _FeedSearchState extends State<FeedSearch> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        toolbarHeight: kToolbarHeight + 20,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Theme.of(context).colorScheme.surfaceContainer),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Search Article',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) async {
                    await widget.feedStore.searchFeedItems(value);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Observer(
        builder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5.0,
                    ),
                    child: Text(
                      "${widget.feedStore.searchResults.length} results",
                      style: TextStyle(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: ListView.builder(
                        itemCount: widget.feedStore.searchResults.length,
                        addAutomaticKeepAlives: false,
                        itemBuilder: (context, idx) {
                          FeedItem item = widget.feedStore.searchResults.elementAt(idx);
                          return FeedStoryTile(
                            feedStore: widget.feedStore,
                            item: item,
                          ).animate().fade();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
