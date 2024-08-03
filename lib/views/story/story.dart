import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:flutter/foundation.dart';
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

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    storyStore.feedItem = widget.feedItem;

    storyStore.bsbController.addListener(onBsbChanged);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            storyStore.progress = progress;
          },
          onPageStarted: (String url) {
            storyStore.loading = true;
          },
          onPageFinished: (String url) {
            storyStore.loading = false;
          },
          onHttpError: (HttpResponseError error) {
            if (kDebugMode) {
              print("Error when fetching page: ${error.response?.statusCode}");
            }
            if (error.response == null || error.response?.statusCode == 404) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to open article"),
                  duration: Duration(seconds: 30),
                ),
              );
            }

          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.feedItem.url));
  }

  void onBsbChanged() {
    if (storyStore.bsbController.isCollapsed && !storyStore.isCollapsed) {
      setState(() {
        storyStore.isCollapsed = true;
        storyStore.isExpanded = false;
      });
    } else if (storyStore.bsbController.isExpanded && !storyStore.isExpanded) {
      setState(() {
        storyStore.isCollapsed = false;
        storyStore.isExpanded = true;
      });
    }
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
                controller.reload();
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                controller.canGoBack().then((value) {
                  if (value) {
                    controller.goBack();
                  }
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: () {
                controller.canGoForward().then((value) {
                  if (value) {
                    controller.goForward();
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
                storyStore.loading
                    ? LinearProgressIndicator(value: storyStore.progress / 100)
                    : const SizedBox(),
                WebViewWidget(controller: controller),
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
                  controller.canGoBack().then((value) {
                    if (value) {
                      controller.goBack();
                    }
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    controller.canGoBack().then((value) {
                      if (value) {
                        controller.goBack();
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
