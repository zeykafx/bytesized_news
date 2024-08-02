import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';

class Story extends StatefulWidget {
  final FeedItem feedItem;

  const Story({super.key, required this.feedItem});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  late WebViewController controller;
  bool loading = false;
  int progress = 0;

  bool isLocked = true;
  bool isCollapsed = true;
  bool isExpanded = false;
  final bsbController = BottomSheetBarController();

  @override
  void initState() {
    super.initState();

    bsbController.addListener(onBsbChanged);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loading = false;
            });
          },
          onHttpError: (HttpResponseError error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to open article"),
                duration: Duration(seconds: 30),
              ),
            );
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.feedItem.url));
  }

  void onBsbChanged() {
    if (bsbController.isCollapsed && !isCollapsed) {
      setState(() {
        isCollapsed = true;
        isExpanded = false;
      });
    } else if (bsbController.isExpanded && !isExpanded) {
      setState(() {
        isCollapsed = false;
        isExpanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        controller: bsbController,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        backdropColor: Theme.of(context).colorScheme.surface,
        locked: isLocked,
        body: Center(
          child: Stack(
            children: [
              loading
                  ? LinearProgressIndicator(value: progress / 100)
                  : const SizedBox(),
              WebViewWidget(controller: controller),
            ],
          ),
        ),
        expandedBuilder: (ScrollController) {
          return Placeholder();
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
                  bsbController.expand();
                },
                icon: const Icon(Icons.arrow_upward)),
          ],
        ),
        // body: Center(
        //   child: Stack(
        //     children: [
        //       loading ? LinearProgressIndicator(value: progress / 100) : const SizedBox(),
        //       WebViewWidget(controller: controller),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
