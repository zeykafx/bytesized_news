import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/sub_views/feed_manager/feed_manager_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class FeedGroupTile extends StatefulWidget {
  final FeedManagerStore feedManagerStore;
  final FeedGroup feedGroup;

  const FeedGroupTile({super.key, required this.feedManagerStore, required this.feedGroup});

  @override
  State<FeedGroupTile> createState() => _FeedGroupTileState();
}

class _FeedGroupTileState extends State<FeedGroupTile> {
  late FeedGroup feedGroup;
  late FeedManagerStore feedManagerStore;

  @override
  void initState() {
    super.initState();
    feedGroup = widget.feedGroup;
    feedManagerStore = widget.feedManagerStore;
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: feedGroup.feeds.isEmpty
            ? const Icon(
                LucideIcons.folder,
                size: 15,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...feedGroup.feeds.take(3).map(
                        (feed) => CachedNetworkImage(imageUrl: feed.iconUrl, width: 12, height: 12),
                      ),
                ],
              ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedGroup.name),
            Text(
              "${feedGroup.feeds.length} feed${feedGroup.feeds.length == 1 ? "" : "s"}",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ],
        ),
        trailing: feedManagerStore.selectionMode
            ? feedManagerStore.selectedFeedGroups.contains(feedGroup)
                ? const Icon(Icons.check_circle_rounded)
                : const Icon(Icons.circle_outlined)
            : null,
        selected: feedManagerStore.selectionMode && feedManagerStore.selectedFeedGroups.contains(feedGroup),
        selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
        onLongPress: () => feedManagerStore.handleFeedGroupLongPress(feedGroup),
        onTap: () => feedManagerStore.handleFeedGroupTap(feedGroup),
      ),
    );
  }
}
