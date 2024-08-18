import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedTile extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final Feed feed;

  const FeedTile({super.key, required this.feedManagerStore, required this.feed});

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  late Feed feed;
  late FeedManagerStore feedManagerStore;

  @override
  void initState() {
    super.initState();
    feed = widget.feed;
    feedManagerStore = widget.feedManagerStore;
  }

  @override
  Widget build(BuildContext context) {
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
        onLongPress: () => feedManagerStore.handleFeedTileLongPress(feed),
        onTap: () => feedManagerStore.handleFeedTileTap(feed),
      ),
    );
  }
}
