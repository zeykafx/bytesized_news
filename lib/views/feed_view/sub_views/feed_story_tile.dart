import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/story/story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:time_formatter/time_formatter.dart';

class FeedStoryTile extends StatefulWidget {
  final FeedItem item;
  final FeedStore feedStore;
  final bool isSuggestion;
  const FeedStoryTile({
    super.key,
    required this.item,
    required this.feedStore,
    this.isSuggestion = false,
  });

  @override
  State<FeedStoryTile> createState() => _FeedStoryTileState();
}

class _FeedStoryTileState extends State<FeedStoryTile> {
  String parsedTitle = "";

  @override
  Widget build(BuildContext context) {
    // Parse the title from html (it might be html escaped)
    dom.Document doc = parse(widget.item.title);
    parsedTitle = parse(doc.body!.text).documentElement!.text;

    Color cardColor;
    if (widget.isSuggestion) {
      cardColor =
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3);
    } else if (!widget.item.bookmarked) {
      cardColor = Theme.of(context)
          .colorScheme
          .secondaryContainer
          .withValues(alpha: 0.2);
    } else if (Theme.of(context).brightness == Brightness.dark) {
      cardColor =
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4);
    } else {
      cardColor = Theme.of(context)
          .colorScheme
          .secondaryContainer
          .withValues(alpha: 0.8);
    }

    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 0,
      color: cardColor,
      child: Center(
        child: SelectableRegion(
          focusNode: FocusNode(),
          selectionControls: MaterialTextSelectionControls(),
          child: ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.isSuggestion && parsedTitle.length > 80
                        ? "${parsedTitle.substring(0, 80)}..."
                        : parsedTitle,
                    style: TextStyle(fontSize: widget.isSuggestion ? 13 : 15),
                  ),
                ),
                const SizedBox(width: 10),
                widget.item.imageUrl.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl: widget.item.imageUrl,
                          fit: BoxFit.cover,
                          height: 72,
                          width: 128,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // widget.item.summarized ? Text("Summary: ${widget.item.aiSummary}") : Text(widget.item.description.split("\n").first),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      label: Text(
                        widget.item.feedName.length > 15
                            ? "${widget.item.feedName.substring(0, 15)}..."
                            : widget.item.feedName,
                        style: const TextStyle(fontSize: 10),
                      ),
                      avatar: widget.item.feed!.iconUrl.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                  imageUrl: widget.item.feed!.iconUrl,
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.cover),
                            )
                          : const Icon(LucideIcons.rss),
                      elevation: 0,
                      side:
                          const BorderSide(width: 0, color: Colors.transparent),
                      padding: const EdgeInsets.all(0),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.2),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),

                    if (widget.item.bookmarked) ...[
                      const SizedBox(width: 10),
                      Icon(
                        LucideIcons.bookmark_check,
                        color: Theme.of(context).dividerColor,
                        size: 15,
                      )
                    ],

                    // star icon to show if the item has been summarized by AI or not
                    if (widget.item.summarized) ...[
                      const SizedBox(width: 10),
                      Icon(
                        LucideIcons.sparkles,
                        color: Theme.of(context).dividerColor,
                        size: 15,
                      )
                    ],
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatTime(
                          widget.item.publishedDate.millisecondsSinceEpoch),
                      style: TextStyle(color: Theme.of(context).dividerColor),
                    ),
                    PopupMenuButton(
                      elevation: 20,
                      icon: const Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            width: 0.3),
                      ),
                      onSelected: (int index) {
                        switch (index) {
                          case 0:
                            {
                              widget.feedStore
                                  .toggleItemRead(widget.item, toggle: true);
                              // have to use setState because mobx doesn't detect changes in complex objects (at least the way I set things up)
                              setState(() {});
                              break;
                            }
                          case 1:
                            {
                              widget.feedStore.toggleItemBookmarked(widget.item,
                                  toggle: true);
                              setState(() {});
                              break;
                            }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          // MARK AS READ/UNREAD
                          PopupMenuItem(
                            value: 0,
                            child: Wrap(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.check,
                                    size: 19,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(widget.item.read
                                      ? "Mark as Unread"
                                      : "Mark as Read"),
                                ),
                              ],
                            ),
                          ),
                          // BOOKMARK
                          PopupMenuItem(
                            value: 1,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(
                                    widget.item.bookmarked
                                        ? Icons.bookmark_added
                                        : Icons.bookmark_add,
                                    size: 19,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(widget.item.bookmarked
                                      ? "Remove from bookmarks"
                                      : "Add to bookmarks"),
                                ),
                              ],
                            ),
                          )
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
            textColor: widget.item.read
                ? Theme.of(context).dividerColor
                : Theme.of(context).textTheme.bodyMedium?.color,
            onTap: () {
              widget.feedStore.toggleItemRead(widget.item);
              // force update the state to change the list tile's color to gray
              setState(() {});

              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => Story(
                    feedItem: widget.item,
                  ),
                ),
              )
                  .then((_) async {
                // update the sort after the story view is popped,
                // this is done so that the story that was just viewed is removed if we are in the unread sort
                widget.feedStore
                    .changeSort(widget.feedStore.settingsStore.sort);

                // update the state of the list items after the story view is popped
                // this is done because if the item was bookmarked while in the story view, we want to show that in the list
                setState(() {});

                // await feedStore.fetchItems();
              });
            },
            dense: widget.isSuggestion,
          ),
        ),
      ),
    );
  }
}
