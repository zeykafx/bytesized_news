import 'package:bytesized_news/models/curatedFeed/curated_feed.dart';
import 'package:bytesized_news/models/curatedFeed/curated_feed_category.dart';
import 'package:bytesized_news/views/curated_feeds/curated_feeds_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CuratedFeedsView extends StatefulWidget {
  final BuildContext context;
  const CuratedFeedsView({super.key, required this.context});

  @override
  State<CuratedFeedsView> createState() => _CuratedFeedsViewState();
}

class _CuratedFeedsViewState extends State<CuratedFeedsView> {
  CuratedFeedsStore curatedFeedsStore = CuratedFeedsStore();

  @override
  void initState() {
    curatedFeedsStore.readCuratedFeeds(widget.context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Curated Feeds")),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                if (curatedFeedsStore.loading) ...[
                  const Center(child: LinearProgressIndicator()),
                ],
                if (curatedFeedsStore.curatedCategories.isEmpty) ...[
                  const Text("Failed to load curated categories!"),
                ],
                Expanded(
                  child: ListView.builder(
                    itemCount: curatedFeedsStore.curatedCategories.length,
                    itemBuilder: (context, idx) {
                      CuratedFeedCategory category = curatedFeedsStore.curatedCategories[idx];
                      return ExpansionTile(
                        title: Text(category.name),
                        enableFeedback: true,
                        initiallyExpanded: true,
                        children: [
                          for (CuratedFeed feed in category.curatedFeeds) Text(feed.title),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
