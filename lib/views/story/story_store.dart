import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/feedItem/feedItem.dart';

part 'story_store.g.dart';

class StoryStore = _StoryStore with _$StoryStore;

abstract class _StoryStore with Store {
  @observable
  FeedItem? feedItem;

  @observable
  int progress = 0;

  @observable
  bool loading = false;

  @observable
  bool isLocked = true;

  @observable
  bool isCollapsed = true;

  @observable
  bool isExpanded = false;

  @observable
  BottomSheetBarController bsbController = BottomSheetBarController();

  @observable
  WebViewController controller = WebViewController();

  @observable
  bool initialized = false;

  void init(FeedItem item, BuildContext context) {
    feedItem = item;
    bsbController.addListener(onBsbChanged);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            progress = progress;
          },
          onPageStarted: (String url) {
            loading = true;
          },
          onPageFinished: (String url) {
            loading = false;
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
      ..loadRequest(Uri.parse(feedItem!.url));
    initialized = true;
  }

  @action
  void onBsbChanged() {
    if (bsbController.isCollapsed && !isCollapsed) {
      isCollapsed = true;
      isExpanded = false;
    } else if (bsbController.isExpanded && !isExpanded) {
      isCollapsed = false;
      isExpanded = true;
    }
  }
}
