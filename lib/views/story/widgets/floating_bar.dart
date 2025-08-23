import 'dart:math';
import 'package:bytesized_news/views/story/story.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FloatingBar extends StatelessWidget {
  const FloatingBar({super.key, required this.storyStore, required this.widget});

  final StoryStore storyStore;
  final Story widget;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Observer(
          builder: (context) {
            return AnimatedSlide(
              offset: storyStore.hideBar ? Offset(0, 1.8) : Offset(0, 0),
              duration: 300.ms,
              curve: Curves.easeInOutQuad,
              child: AnimatedOpacity(
                opacity: storyStore.hideBar ? 0.7 : 1,
                duration: 150.ms,
                curve: Curves.easeInOutQuad,
                child: Card.outlined(
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedSize(
                      duration: 300.ms,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              spacing: 3,
                              children: [
                                // READER MODE
                                IconButton(
                                  onPressed: () {
                                    storyStore.toggleReaderMode();
                                  },
                                  tooltip: storyStore.showReaderMode ? "Disable reader mode" : "Enable reader mode",
                                  icon: Icon(storyStore.showReaderMode ? Icons.web_asset_rounded : Icons.menu_book_rounded),
                                ),

                                // RELOAD
                                if (!storyStore.showReaderMode) ...[
                                  IconButton(
                                    onPressed: () {
                                      storyStore.controller?.reload();
                                    },
                                    tooltip: "Refresh web page",
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],

                                // BACK
                                if (!storyStore.showReaderMode || storyStore.readerModeHistory.isNotEmpty) ...[
                                  IconButton(
                                    onPressed: () {
                                      if (!storyStore.showReaderMode) {
                                        if (storyStore.canGoBack) {
                                          storyStore.controller?.goBack();
                                        }
                                      } else {
                                        storyStore.goBackInReaderHistory();
                                      }
                                    },
                                    tooltip: "Go back",
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: (storyStore.showReaderMode)
                                          ? (storyStore.readerModeHistory.isNotEmpty ? null : Colors.grey.withValues(alpha: 0.5))
                                          : (storyStore.canGoBack ? null : Colors.grey.withValues(alpha: 0.5)),
                                    ),
                                  ),
                                ],
                                if (!storyStore.showReaderMode) ...[
                                  // FORWARD
                                  IconButton(
                                    onPressed: () {
                                      if (storyStore.canGoForward) {
                                        storyStore.controller?.goForward();
                                      }
                                    },
                                    tooltip: "Go forward",
                                    icon: Icon(Icons.arrow_forward_ios, color: storyStore.canGoForward ? null : Colors.grey.withValues(alpha: 0.5)),
                                  ),
                                ],

                                storyStore.showReaderMode
                                    ? const SizedBox.shrink()
                                    : storyStore.feedItemSummarized
                                    ? IconButton(
                                        onPressed: storyStore.hideAiSummary,
                                        icon: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Align(
                                              alignment: Alignment.topRight,
                                              widthFactor: 2,
                                              heightFactor: 3,
                                              child: Icon(LucideIcons.sparkles, size: 14),
                                            ),
                                            Icon(storyStore.hideSummary ? Icons.visibility : Icons.visibility_off),
                                          ],
                                        ),
                                        tooltip: storyStore.hideSummary ? "Show AI Summary" : "Hide AI Summary",
                                      )
                                    : IconButton(
                                        onPressed: storyStore.aiLoading
                                            ? null
                                            : () {
                                                if (!storyStore.aiLoading) {
                                                  storyStore.summarizeArticle(context);
                                                }
                                              },
                                        icon: const Icon(LucideIcons.sparkles),
                                        tooltip: "Summarize Article",
                                      ),

                                // BOOKMARK
                                Stack(
                                  children: [
                                    // circle like when held behind the bookmark icon if it's bookmarked
                                    if (storyStore.isBookmarked) ...[
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],

                                    IconButton(
                                      isSelected: storyStore.isBookmarked,
                                      onPressed: () {
                                        storyStore.bookmarkItem();
                                        widget.feedItem.bookmarked = storyStore.isBookmarked;
                                      },
                                      icon: Icon(storyStore.isBookmarked ? Icons.bookmark_added : Icons.bookmark_add),
                                    ),
                                  ],
                                ),

                                // Share button
                                if (storyStore.settingsStore.showShareButton)
                                  IconButton(icon: Icon(Icons.share_rounded), onPressed: () => storyStore.shareArticle(context)),

                                // HN COMMENTS BUTTON
                                storyStore.showHnButton && storyStore.settingsStore.showCommentsButton
                                    ? IconButton(
                                        onPressed: () {
                                          storyStore.openHnCommentsPage();
                                        },
                                        tooltip: "Open Comments",
                                        icon: Icon(Icons.comment_sharp),
                                      )
                                    : const SizedBox.shrink(),

                                // READER MODE
                                storyStore.showArchiveButton
                                    ? IconButton(
                                        onPressed: () {
                                          storyStore.getArchivedArticle();
                                        },
                                        tooltip: "Search Archive.org for the article to bypass the paywall/block",
                                        icon: Icon(Icons.archive_rounded),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),

                            // summary in the bottom bar (only shown when using the webview)
                            AnimatedCrossFade(
                              duration: 150.ms,
                              firstCurve: Curves.easeInOutQuad,
                              secondCurve: Curves.easeInOutQuad,
                              sizeCurve: Curves.easeOutQuad,
                              crossFadeState: storyStore.hideSummary && storyStore.feedItemSummarized && !storyStore.showReaderMode
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Container(
                                constraints: BoxConstraints(maxWidth: min(MediaQuery.of(context).size.width * 0.9, 700), maxHeight: 300),
                                child: Card.outlined(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5), width: 1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25), // slightly less radius to fit the radius of the container
                                    ),
                                  ),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SingleChildScrollView(
                                      child: SelectableText(
                                        storyStore.feedItem.aiSummary,
                                        // style: mediaQuery.size.width > 600 ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              secondChild: const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
