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
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.feedItem.title),
          actions: [
            IconButton(
              onPressed: () {
                storyStore.controller.reload();
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                storyStore.controller.canGoBack().then((value) {
                  if (value) {
                    storyStore.controller.goBack();
                  }
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: () {
                storyStore.controller.canGoForward().then((value) {
                  if (value) {
                    storyStore.controller.goForward();
                  }
                });
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        body: BottomSheetBar(
          controller: storyStore.bsbController,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          backdropColor: Theme.of(context).colorScheme.surface,
          locked: storyStore.isLocked,
          body: Center(
            child: Stack(
              children: [
                storyStore.loading ? LinearProgressIndicator(value: storyStore.progress / 100) : const SizedBox(),
                storyStore.initialized ? WebViewWidget(controller: storyStore.controller) : const CircularProgressIndicator(),
              ],
            ),
          ),
          expandedBuilder: (ScrollController _) {
            return const Placeholder();
          },
          collapsed: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  storyStore.controller.canGoBack().then((value) {
                    if (value) {
                      storyStore.controller.goBack();
                    }
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    storyStore.controller.canGoBack().then((value) {
                      if (value) {
                        storyStore.controller.goBack();
                      }
                    });
                  },
                  icon: const Icon(Icons.replay)),
              IconButton(
                  onPressed: () {
                    storyStore.bsbController.expand();
                  },
                  icon: const Icon(Icons.arrow_upward)),
            ],
          ),
        ),
      );
    });
  }
}
