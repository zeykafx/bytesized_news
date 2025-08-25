import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/feed_view/widgets/feed_story_tile.dart';
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

  String currentSort = "by_date_desc";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  Future<void> sortButtonOnChanged(String? item) async {
    loading = true;
    currentSort = item ?? "by_date_desc";

    if (item == "by_date_desc") {
      widget.feedStore.searchResults.sort((a, b) => a.publishedDate.isBefore(b.publishedDate) ? 1 : -1);
    } else if (item == "by_date_asc") {
      widget.feedStore.searchResults.sort((a, b) => a.publishedDate.isBefore(b.publishedDate) ? -1 : 1);
    }
    loading = false;
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
              ),
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
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.feedStore.searchResults.length} results",
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        DropdownButton<String>(
                          borderRadius: BorderRadius.circular(12),
                          dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
                          underline: const SizedBox.shrink(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          iconEnabledColor: Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          iconSize: 20,
                          value: currentSort,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: const Icon(Icons.sort_rounded),
                          ),
                          items: [
                            DropdownMenuItem<String>(value: "by_date_desc", child: Text("Sort by date descending")),
                            DropdownMenuItem<String>(value: "by_date_asc", child: Text("Sort by date ascending")),
                          ],
                          onChanged: (String? item) => sortButtonOnChanged(item),
                        ),
                      ],
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: FeedStoryTile(
                              feedStore: widget.feedStore,
                              item: item,
                            ).animate().fade(),
                          );
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
