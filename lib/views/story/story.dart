import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';

class Story extends StatefulWidget {
  final FeedItem feedItem;

  const Story({super.key, required this.feedItem});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final StoryStore storyStore = StoryStore();

  @override
  void initState() {
    storyStore.init(widget.feedItem, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // cannot pop this page by default, but if we popped from some way (such as the navigator), we can pop this page
      canPop: false,
      onPopInvokedWithResult: (bool popped, dynamic result) {
        // if we popped, return directly to avoid reopening the current widget but clearing the history (odd behavior)
        if (popped) {
          return;
        }

        // if we can go back, go back, otherwise pop the page
        if (storyStore.canGoBack) {
          storyStore.controller.goBack();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Observer(builder: (_) {
            return Text("${storyStore.feedItem.title} - ${storyStore.feedItem.feedName}");
          }),
        ),
        body: BottomSheetBar(
          controller: storyStore.bsbController,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          backdropColor: Theme.of(context).colorScheme.surface,
          locked: storyStore.isLocked,
          body: Observer(builder: (_) {
            return Center(
              child: Stack(
                children: [
                  storyStore.loading ? LinearProgressIndicator(value: storyStore.progress / 100) : const SizedBox(),
                  storyStore.initialized ? WebViewWidget(controller: storyStore.controller) : const CircularProgressIndicator(),
                ],
              ),
            );
          }),
          expandedBuilder: (ScrollController _) {
            return const Placeholder();
          },
          collapsed: Observer(builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // RELOAD
                IconButton(
                  onPressed: () {
                    storyStore.controller.reload();
                  },
                  icon: const Icon(Icons.refresh),
                ),
                // BACK

                IconButton(
                  onPressed: () {
                    if (storyStore.canGoBack) {
                      storyStore.controller.goBack();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: storyStore.canGoBack ? null : Colors.grey.withOpacity(0.5),
                  ),
                ),

                // FORWARD
                IconButton(
                  onPressed: () {
                    if (storyStore.canGoForward) {
                      storyStore.controller.goForward();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: storyStore.canGoForward ? null : Colors.grey.withOpacity(0.5),
                  ),
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
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
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
              ],
            );
          }),
        ),
      ),
    );
  }
}
