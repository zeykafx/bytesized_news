import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

class BsbFeedButton extends StatefulWidget {
  final dynamic elem;
  final FeedStore feedStore;
  const BsbFeedButton({super.key, this.elem, required this.feedStore});

  @override
  State<BsbFeedButton> createState() => _BsbFeedButtonState();
}

class _BsbFeedButtonState extends State<BsbFeedButton> {
  late SettingsStore settingsStore;
  late FeedStore feedStore;
  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    feedStore = widget.feedStore;
    // authStore = context.read<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    var elem = widget.elem;

    if (elem.runtimeType == Feed) {
      Feed feed = elem;

      bool isCurrentSortFeed = settingsStore.sort == FeedListSort.feed && settingsStore.sortFeed != null && settingsStore.sortFeed?.name == feed.name;
      return Card.outlined(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isCurrentSortFeed ? Theme.of(context).colorScheme.primaryFixedDim : Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: isCurrentSortFeed ? 3 : 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: IconButton(
          onPressed: () async {
            // sort for this feed
            settingsStore.setSortFeed(feed);
            settingsStore.setSortFeedName(feed.name);
            await feedStore.changeSort(FeedListSort.feed);
            await feedStore.fetchItems();
          },
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 1),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(imageUrl: feed.iconUrl, width: 25, height: 25),
          ),
        ),
      );
    } else {
      FeedGroup feedGroup = elem;

      bool isCurrentSortFeedGroup =
          settingsStore.sort == FeedListSort.feedGroup && settingsStore.sortFeedGroup != null && settingsStore.sortFeedGroup?.name == feedGroup.name;
      return Card.outlined(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isCurrentSortFeedGroup ? Theme.of(context).colorScheme.primaryFixedDim : Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: isCurrentSortFeedGroup ? 3 : 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: IconButton(
          onPressed: () async {
            // sort for this feed group
            settingsStore.setSortFeedGroup(feedGroup);
            settingsStore.setSortFeedGroupName(feedGroup.name);
            await feedStore.changeSort(FeedListSort.feedGroup);
            await feedStore.fetchItems();
          },
          icon: feedGroup.feeds.isEmpty
              ? const Icon(
                  LucideIcons.folder,
                  size: 15,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...feedGroup.feeds.take(2).map(
                          (feed) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(imageUrl: feed.iconUrl, width: 17, height: 17),
                          ),
                        ),
                    if (feedGroup.feeds.length > 2) ...[
                      const SizedBox(width: 5),
                      Text(
                        "+${feedGroup.feeds.length - 2}",
                        style: TextStyle(color: Theme.of(context).dividerColor),
                      ),
                    ],
                  ],
                ),
        ),
      );
    }
  }
}
