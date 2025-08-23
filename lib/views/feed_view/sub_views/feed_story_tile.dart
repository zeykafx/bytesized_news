import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/feed_view/feed_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/story/story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

class FeedStoryTile extends StatefulWidget {
  final FeedItem item;
  final FeedStore feedStore;
  final bool isSuggestion;
  const FeedStoryTile({super.key, required this.item, required this.feedStore, this.isSuggestion = false});

  @override
  State<FeedStoryTile> createState() => _FeedStoryTileState();
}

class _FeedStoryTileState extends State<FeedStoryTile> {
  String parsedTitle = "";
  late SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();

    if (!widget.item.read && settingsStore.markAsReadOnScroll) {
      widget.item.read = true;
      widget.feedStore.dbUtils.updateItemInDb(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.feed == null) {
      // If the feed is null, we can't display the item properly
      return const SizedBox.shrink();
    }

    // Parse the title from html (it might be html escaped)
    dom.Document doc = parse(widget.item.title);
    if (doc.body != null) {
      parsedTitle = parse(doc.body!.text).documentElement!.text;
    } else {
      parsedTitle = widget.item.title;
    }

    Color cardColor;
    if (widget.isSuggestion) {
      cardColor = Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3);
    } else if (widget.item.bookmarked) {
      cardColor = Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.8);
      // } else if (widget.item.downloaded) {
      //   cardColor = Theme.of(context).colorScheme.primaryFixedDim.withValues(alpha: 0.3);
    } else if (Theme.of(context).brightness == Brightness.dark) {
      cardColor = Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2);
    } else {
      cardColor = Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.2);
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: widget.isSuggestion
          ? OverflowBox(maxHeight: 315, maxWidth: 350, alignment: Alignment.center, child: buildCard(cardColor, context))
          : buildCard(cardColor, context),
    );
  }

  Widget buildCard(Color cardColor, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardColor,
        child: Center(
          child: SelectableRegion(
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: InkWell(
              onTap: () => handleTap(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 0,
                children: [
                  if (widget.isSuggestion) ...[
                    widget.item.imageUrl.isNotEmpty
                        ? Center(
                            child: Container(
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: widget.item.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, str, obj) => Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox(height: 200, width: 350, child: const Icon(Icons.rss_feed_rounded)),
                                ),

                                width: 350,
                                height: 200,
                              ),
                            ),
                          )
                        : widget.item.feed != null && widget.item.feed!.iconUrl.isNotEmpty && !widget.item.feed!.iconUrl.endsWith("svg")
                        ? Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: widget.item.feed!.iconUrl,
                              height: 200,
                              width: 350,
                              fit: BoxFit.cover,
                              errorWidget: (context, str, obj) => SizedBox(height: 200, width: 350, child: const Icon(Icons.rss_feed_rounded)),
                            ),
                          )
                        : SizedBox(height: 200, width: 350, child: const Icon(Icons.rss_feed_rounded)),
                  ],

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      // contentPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              parsedTitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: widget.isSuggestion ? 2 : 4,
                              style: TextStyle(fontSize: (widget.isSuggestion || settingsStore.storyTilesMinimalStyle) ? 13 : 14),
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (!settingsStore.storyTilesMinimalStyle && !widget.isSuggestion) ...[
                            widget.item.imageUrl.isNotEmpty && !widget.item.imageUrl.endsWith("svg")
                                ? Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.item.imageUrl,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, str, obj) => const SizedBox.shrink(),
                                      height: 72,
                                      width: 128,
                                    ),
                                  )
                                : widget.item.feed != null && widget.item.feed!.iconUrl.isNotEmpty && !widget.item.feed!.iconUrl.endsWith("svg")
                                ? Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: CachedNetworkImage(imageUrl: widget.item.feed!.iconUrl, height: 72, width: 128, fit: BoxFit.fitWidth),
                                  )
                                : SizedBox(height: 72, width: 128, child: const Icon(LucideIcons.rss)),
                            const SizedBox(width: 5),
                          ],
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // widget.item.summarized ? Text("Summary: ${widget.item.aiSummary}") : Text(widget.item.description.split("\n").first),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Chip(
                                label: Text(
                                  widget.item.feed != null && widget.item.feed!.name.length > 15
                                      ? "${widget.item.feed!.name.substring(0, 15)}..."
                                      : widget.item.feed!.name,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                avatar: widget.item.feed != null && widget.item.feed!.iconUrl.isNotEmpty && !widget.item.feed!.iconUrl.endsWith("svg")
                                    ? Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                                        clipBehavior: Clip.hardEdge,
                                        child: CachedNetworkImage(imageUrl: widget.item.feed!.iconUrl, width: 15, height: 15, fit: BoxFit.cover),
                                      )
                                    : const Icon(LucideIcons.rss),
                                elevation: 0,
                                side: const BorderSide(width: 0, color: Colors.transparent),
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(width: 0, color: Colors.black),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),

                              if (widget.item.downloaded && !widget.isSuggestion) ...[
                                const SizedBox(width: 10),
                                Icon(LucideIcons.download, color: Theme.of(context).dividerColor, size: 15),
                              ],

                              if (widget.item.fetchedInBg != null && widget.item.fetchedInBg!) ...[
                                const SizedBox(width: 5),
                                Icon(Icons.sync, color: Theme.of(context).dividerColor, size: 12),
                              ],

                              if (widget.item.bookmarked) ...[
                                const SizedBox(width: 10),
                                Icon(LucideIcons.bookmark_check, color: Theme.of(context).dividerColor, size: 15),
                              ],

                              // star icon to show if the item has been summarized by AI or not
                              if (widget.item.summarized && !widget.isSuggestion) ...[
                                const SizedBox(width: 10),
                                Icon(LucideIcons.sparkles, color: Theme.of(context).dividerColor, size: 15),
                              ],
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                formatTime(widget.item.publishedDate.millisecondsSinceEpoch),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: Theme.of(context).dividerColor,
                                  fontSize: settingsStore.storyTilesMinimalStyle || widget.isSuggestion ? 12 : null,
                                ),
                              ),
                              PopupMenuButton(
                                elevation: 20,
                                icon: const Icon(Icons.more_vert),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer, width: 0.3),
                                ),
                                padding: EdgeInsets.zero,
                                onSelected: (int index) {
                                  switch (index) {
                                    case 0:
                                      {
                                        widget.feedStore.toggleItemRead(widget.item, toggle: true);
                                        // have to use setState because mobx doesn't detect changes in complex objects (at least the way I set things up)
                                        setState(() {});
                                        break;
                                      }
                                    case 1:
                                      {
                                        widget.feedStore.downloadItem(widget.item, toggle: true);
                                        setState(() {});
                                        break;
                                      }
                                    case 2:
                                      {
                                        widget.feedStore.toggleItemBookmarked(widget.item, toggle: true);
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
                                          const Padding(padding: EdgeInsets.only(left: 10), child: Icon(Icons.check, size: 19)),
                                          Padding(padding: const EdgeInsets.only(left: 20), child: Text(widget.item.read ? "Mark as Unread" : "Mark as Read")),
                                        ],
                                      ),
                                    ),
                                    // Download
                                    PopupMenuItem(
                                      value: 1,
                                      child: Wrap(
                                        children: [
                                          Padding(padding: const EdgeInsets.only(left: 10), child: Icon(LucideIcons.download, size: 19)),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text(widget.item.downloaded ? "Remove from downloads" : "Add to downloads"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // BOOKMARK
                                    PopupMenuItem(
                                      value: 2,
                                      child: Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Icon(widget.item.bookmarked ? Icons.bookmark_added : Icons.bookmark_add, size: 19),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text(widget.item.bookmarked ? "Remove from bookmarks" : "Add to bookmarks"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      textColor: widget.item.read ? Theme.of(context).dividerColor : Theme.of(context).textTheme.bodyMedium?.color,
                      dense: widget.isSuggestion,
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

  void handleTap(BuildContext context) {
    widget.feedStore.toggleItemRead(widget.item);
    // force update the state to change the list tile's color to gray
    setState(() {});

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Story(feedItem: widget.item))).then((_) async {
      // update the sort after the story view is popped,
      // this is done so that the story that was just viewed is removed if we are in the unread sort
      widget.feedStore.changeSort(widget.feedStore.settingsStore.sort);

      // update the state of the list items after the story view is popped
      // this is done because if the item was bookmarked while in the story view, we want to show that in the list
      setState(() {});

      // await feedStore.fetchItems();
    });
  }
}
