import 'package:bytesized_news/AI/ai_utils.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:photo_view/photo_view.dart';

part 'story_store.g.dart';

class StoryStore = _StoryStore with _$StoryStore;

abstract class _StoryStore with Store {
  Isar isar = Isar.getInstance()!;
  late SettingsStore settingsStore;
  late AuthStore authStore;

  @observable
  late DbUtils dbUtils;

  @observable
  late FeedItem feedItem;

  @observable
  late String htmlContent;

  @observable
  late bool showReaderMode;

  @observable
  bool isBookmarked = false;

  @observable
  bool canGoForward = false;

  @observable
  bool canGoBack = false;

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
  InAppWebViewController? controller;

  @observable
  bool initialized = false;

  @observable
  List<String> adUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.zedo.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.teads.tv/.*",
    ".*.outbrain.com/.*"
  ];

  @observable
  List<ContentBlocker> contentBlockers = [];

  @observable
  late InAppWebViewSettings settings;

  @observable
  late AiUtils aiUtils;

  @observable
  bool feedItemSummarized = false;

  @observable
  bool aiLoading = false;

  @observable
  late bool hideSummary;

  @observable
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @observable
  UniqueKey htmlWidgetKey = UniqueKey();

  @observable
  bool hideBar = false;

  @observable
  int webviewLastScrollY = 0;

  @action
  Future<void> init(FeedItem item, BuildContext context, SettingsStore setStore, AuthStore authStore) async {
    settingsStore = setStore;
    this.authStore = authStore;
    aiUtils = AiUtils(authStore);

    showReaderMode = settingsStore.useReaderModeByDefault;
    hideSummary = settingsStore.showAiSummaryOnLoad;

    dbUtils = DbUtils(isar: isar);

    feedItem = item;
    isBookmarked = feedItem.bookmarked;
    feedItemSummarized = feedItem.summarized;

    if (!feedItem.downloaded) {
      htmlContent = await feedItem.fetchHtmlContent();
      // storeHtmlPageInFeedItem(htmlContent);
      await compareReaderModeLengthToPageHtml(context);
    } else {
      htmlContent = feedItem.htmlContent!;
    }

    // for each Ad URL filter, add a Content Blocker to block its loading.
    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(
        ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          ),
        ),
      );
    }

    // apply the "display: none" style to some HTML elements
    contentBlockers.add(
      ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(type: ContentBlockerActionType.CSS_DISPLAY_NONE, selector: ".banner, .banners, .ads, .ad, .advert"),
      ),
    );

    settings = InAppWebViewSettings(
      allowsInlineMediaPlayback: true,
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      iframeAllowFullscreen: true,
      contentBlockers: contentBlockers,
      algorithmicDarkeningAllowed: true,
      forceDark: settingsStore.darkMode == DarkMode.system
          ? ForceDark.AUTO
          : settingsStore.darkMode == DarkMode.dark
              ? ForceDark.ON
              : ForceDark.OFF,
    );

    initialized = true;

    if (settingsStore.fetchAiSummaryOnLoad && showReaderMode) {
      await summarizeArticle(context);
    }
  }

  // @action
  // void storeHtmlPageInFeedItem(String content) {
  //   feedItem.htmlContent = content;
  //   feedItem.downloaded = true;
  //   dbUtils.updateItemInDb(feedItem);
  // }

  // @action
  // Future<String> fetchPageHtml() async {
  //   final Article result = await readability.parseAsync(feedItem.url);

  //   int wordCount = result.content!.split(" ").length;

  //   if (feedItem.imageUrl.isEmpty && result.imageUrl != null && result.imageUrl!.isNotEmpty) {
  //     feedItem.imageUrl = result.imageUrl!;
  //     dbUtils.updateItemInDb(feedItem);
  //   }

  //   estReadingTime = Duration(minutes: (wordCount / readingSpeed).toInt());
  //   return result.content!.split("\n").toSet().join("\n");
  // }

  @action
  Future<void> compareReaderModeLengthToPageHtml(BuildContext context) async {
    Dio dio = Dio();

    // fetch the page's html
    Response res = await dio.get(feedItem.url);
    dom.Document doc = html_parser.parse(res.data);
    if (doc.body == null) {
      return;
    }

    if (kDebugMode) {
      print("Ratio webpage to reader: ${doc.body!.innerHtml.length / htmlContent.length}");
    }
    if ((doc.body!.innerHtml.length / htmlContent.length) > 150) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The reader view seems to have a much shorter article than the web page's full length, switching to the web page now."),
      ));
      showReaderMode = false;
      return;
    }
    return;
  }

  @action
  Map<String, String>? buildStyle(BuildContext context, dom.Element element) {
    if (element.className == 'bytesized_news_html_content') {
      return {
        'line-height': settingsStore.lineHeight.toString(),
        'background-color': '#${Theme.of(context).scaffoldBackgroundColor.toARGB32().toRadixString(16).substring(2)}',
        'width': 'auto',
        'height': 'auto',
        'margin': '0',
        'word-wrap': 'break-word', // other values 'break-word', 'keep-all', 'normal'
        'padding': '12px 8px !important',
        "font-size": "1.1em",
        'text-align': textAlignString(settingsStore.textAlignment).toLowerCase() // other values: 'left', 'right', 'center'
      };
    }

    if (element.className == "ai_container") {
      // card line container for the AI summary
      return {
        'background-color':
            '#${Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.primaryContainer.toARGB32().toRadixString(16).substring(2) : Theme.of(context).colorScheme.secondaryContainer.toARGB32().toRadixString(16).substring(2)}',
        'padding': '0px 10px 0px 10px !important',
        'margin': '0',
        'border-radius': '8px',
        'box-shadow': '0 0 8px 0 rgba(0,0,0,0.1)',
        'margin-top': '8px',
        'margin-bottom': '8px',
        // "text-align": "justify",
      };
    }

    if (element.className == "small") {
      return {
        // 'font-size': '14px',
        'color': '#${Theme.of(context).dividerColor.toARGB32().toRadixString(16).substring(2)}',
      };
    }

    if (element.className == "tiny") {
      return {
        'font-size': '0.8em',
        'color': '#${Theme.of(context).dividerColor.toARGB32().toRadixString(16).substring(2)}',
        'text-align': 'right',
      };
    }

    switch (element.localName) {
      case 'h1':
        return {'font-size': '1.5em', 'font-weight': '700', 'text-align': "left"};
      case 'h2':
        return {'font-size': '1.25em', 'font-weight': '700', 'text-align': "left"};
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return {'font-size': '1.0em', 'font-weight': '700'};
      case 'img':
        return {
          'border-radius': '8px',
        };
      case "image":
        return {
          'border-radius': '8px',
        };
      case 'figure':
      case 'video':
      case 'iframe':
        return {
          'max-width': '100% !important',
          'height': 'auto',
          'margin': '0 auto',
          'display': 'block',
        };
      case "caption":
        return {
          'font-size': '0.8em',
          'color': '#${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'text-align': 'left',
        };
      case "figcaption":
        return {
          'font-size': '0.8em',
          'color': '#${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'text-align': 'left',
        };
      case 'a':
        return {
          'color': '#${Theme.of(context).colorScheme.primary.toARGB32().toRadixString(16).substring(2)}',
          'text-decoration': 'none',
        };

      case 'blockquote':
        return {'margin': '0', 'padding': '0 0 0 16px', 'border-left': '4px solid #9e9e9e'};
      case 'pre':
        return {'white-space': 'pre-wrap', 'word-break': 'break-all'};

      case 'table':
        return {
          'width': '100% !important',
          'table-layout': 'fixed',
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'border-collapse': 'collapse',
          'padding': '0 8px'
        };
      case 'td':
        return {
          'padding': '0 8px',
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'border-collapse': 'collapse'
        };
      case 'th':
        return {
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'border-collapse': 'collapse'
        };
      default:
    }
    return null;
  }

  @action
  Future<void> onProgressChanged(InAppWebViewController controller, int prog) async {
    progress = prog;
  }

  @action
  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url) async {
    loading = false;
    canGoBack = await controller.canGoBack();
    canGoForward = await controller.canGoForward();
  }

  @action
  Future<void> summarizeArticle(BuildContext context) async {
    if (!authStore.initialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error, try again in a few seconds."),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    hideBar = false;

    if (aiLoading || feedItem.summarized) {
      return;
    }

    // check firestore for existing summary (This doesn't count towards the user's summaries)
    var existingSummary = await firestore.collection("summaries").where("url", isEqualTo: feedItem.url).get();

    if (existingSummary.docs.isNotEmpty) {
      if (kDebugMode) {
        print("Summary found in Firestore");
      }
      feedItem.aiSummary = existingSummary.docs.first.get("summary");
      feedItem.summarized = true;
      await dbUtils.updateItemInDb(feedItem);
      feedItemSummarized = true;
      return;
    }

    if (kDebugMode) {
      print("SUMMARIES LEFT: ${authStore.summariesLeftToday}");
      print("Last summary difference in seconds: ${DateTime.now().toUtc().difference(authStore.lastSummaryDate!).inSeconds}");
    }

    // Only create summary every summariesIntervalSeconds seconds max
    if (DateTime.now().toUtc().difference(authStore.lastSummaryDate!).inSeconds <= summariesIntervalSeconds) {
      if (kDebugMode) {
        print("Fetching summaries too fast");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You can only request a summary every $summariesIntervalSeconds seconds, slow down (or disable auto summary creation in the settings.)",
          ),
          duration: const Duration(seconds: 10),
        ),
      );
      return;
    }

    // String? htmlValue;
    // if (!showReaderMode) {
    //   htmlValue = await controller?.evaluateJavascript(source: "window.document.getElementsByTagName('html')[0].outerHTML;");
    // } else {
    //   htmlValue = htmlContent;
    // }

    dom.Document document = parse(htmlContent);
    String docText = document.body!.text;

    if (docText.length > 15000) {
      // docText = docText.substring(0, 15000);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This webpage is very long, sumarization will take more than 1 credit (according to the size)."),
          duration: Duration(seconds: 5),
        ),
      );
    }

    if (kDebugMode) {
      print("Sending ${docText.length} characters to AI for summarization");
    }

    aiLoading = true;
    try {
      var (String summary, int summariesLeft) = await aiUtils.summarize(docText, feedItem);
      feedItem.aiSummary = summary;
      authStore.summariesLeftToday = summariesLeft;
      authStore.lastSummaryDate = DateTime.now().toUtc();
      feedItem.summarized = true;
      await dbUtils.updateItemInDb(feedItem);
      feedItemSummarized = true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll("Exception: ", ""),
          ),
          duration: const Duration(seconds: 10),
        ),
      );
    }

    if (kDebugMode) {
      print("Received summary from cloud function");
    }
    aiLoading = false;
  }

  @action
  Future<void> onLoadStart(InAppWebViewController controller, WebUri? url) async {
    loading = true;
  }

  @action
  void toggleReaderMode() {
    hideBar = false;
    showReaderMode = !showReaderMode;
    if (showReaderMode && controller != null) {
      controller?.dispose();
      controller = null;
      canGoBack = false;
      canGoForward = false;
    }
  }

  @action
  void hideAiSummary() {
    hideBar = false;
    hideSummary = !hideSummary;
  }

  @action
  void bookmarkItem() {
    hideBar = false;
    feedItem.bookmarked = !feedItem.bookmarked;
    isBookmarked = feedItem.bookmarked;
    dbUtils.updateItemInDb(feedItem);
  }

  @action
  void showImage(String imageUrl, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                PhotoView(imageProvider: CachedNetworkImageProvider(imageUrl)),
                Positioned(
                  top: 0,
                  right: 10,
                  child: IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @action
  bool notificationListener(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        notification.metrics.pixels > 200 &&
        !hideBar &&
        notification.dragDetails != null &&
        notification.dragDetails!.delta.dy < -1) {
      hideBar = true;
    }
    if (notification.metrics.pixels < 200 && hideBar) {
      hideBar = false;
    }
    if (notification is ScrollUpdateNotification &&
        notification.metrics.pixels > 200 &&
        notification.dragDetails != null &&
        notification.dragDetails!.delta.dy > 1) {
      hideBar = false;
    }

    return false;
  }

  @action
  void webviewScrollListener(InAppWebViewController controller, int x, int y) {
    if (y > 200 && !hideBar && webviewLastScrollY - y < -1) {
      hideBar = true;
      webviewLastScrollY = y;
      hideSummary = false;
    }
    if (y < 200 && hideBar) {
      hideBar = false;
    }
    if (y > 200 && webviewLastScrollY - y > 1) {
      hideBar = false;
      webviewLastScrollY = y;
      hideSummary = false;
    }
    webviewLastScrollY = y;
  }
}
