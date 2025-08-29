import 'dart:async';
import 'package:bytesized_news/AI/ai_utils.dart';
import 'package:bytesized_news/background/life_cycle_event_handler.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/reading_stats/reading_stats.dart';
import 'package:bytesized_news/utils/utils.dart';
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
import 'package:isar_community/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String htmlContent = "";

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
    ".*.outbrain.com/.*",
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

  @observable
  ReadingStats readingStat = ReadingStats();

  @observable
  bool showArchiveButton = false;

  @observable
  bool hasAlert = false;
  @observable
  bool shortAlert = false;

  @observable
  String alertMessage = "";

  @observable
  ObservableList<String> readerModeHistory = <String>[].asObservable();

  @observable
  String currentUrl = "";

  @observable
  bool showHnButton = false;

  int imageDepthLimit = 30;
  @computed
  bool get hasImageInArticle {
    if (htmlContent.isEmpty || feedItem.imageUrl.isEmpty) return false;
    Uri imageUri = Uri.parse(feedItem.imageUrl);

    // check if the cover image path is present
    // we only check for the path because it will be the smallest representation of the url without any query params
    // which would make the check below not match
    // E.g., with the following imageUrl: https://www.motherjones.com/wp-content/uploads/2025/08/20250818_carbon-economy_2000px.png?w=1200&h=630&crop=1
    // The path will be /wp-content/uploads/2025/08/20250818_carbon-economy_2000px.png
    // And the image url in the article is: https://www.motherjones.com/wp-content/uploads/2025/08/20250818_carbon-economy_2000px.png?w=990
    // -> So we can see that if we checked for the imageUrl, it would fail and display the image twice.
    if (htmlContent.contains(imageUri.path)) return true;

    // search for img tags in the first part of the content
    final firstPart = htmlContent.length > imageDepthLimit * 50 ? htmlContent.substring(0, imageDepthLimit * 50) : htmlContent;

    // use regex to find img tags and check if they're not author-related
    final imgTagRegex = RegExp(r'<(img|picture|video)[^>]*>', caseSensitive: false);
    final imgTags = imgTagRegex.allMatches(firstPart);

    for (final match in imgTags) {
      final imgTag = match.group(0)!.toLowerCase();
      // we skip author images, avatars, profile pics, etc.
      if (imgTag.contains(RegExp('author')) ||
          imgTag.contains(RegExp("author_profile_images")) ||
          imgTag.contains(RegExp('authors')) ||
          imgTag.contains(RegExp('avatar')) ||
          imgTag.contains(RegExp('profile')) ||
          imgTag.contains(RegExp('byline'))) {
        continue;
      }

      return true;
    }

    return false;
  }

  @action
  Future<void> init(FeedItem item, BuildContext context, SettingsStore setStore, AuthStore authStore) async {
    settingsStore = setStore;
    this.authStore = authStore;
    aiUtils = AiUtils(authStore, settingsStore);

    showReaderMode = settingsStore.useReaderModeByDefault;
    hideSummary = settingsStore.showAiSummaryOnLoad;
    showArchiveButton = settingsStore.alwaysShowArchiveButton;

    dbUtils = DbUtils(isar: isar);

    feedItem = item;
    isBookmarked = feedItem.bookmarked;
    feedItemSummarized = feedItem.summarized;
    currentUrl = feedItem.url;

    webviewInit();

    if (!feedItem.downloaded) {
      htmlContent = await feedItem.fetchHtmlContent(feedItem.url);
      // storeHtmlPageInFeedItem(htmlContent);
      await compareReaderModeLengthToPageHtml(context);
    } else {
      htmlContent = feedItem.htmlContent ?? "No Content";
      await compareReaderModeLengthToPageHtml(context);
    }

    checkPaywallOrBotBlock();
    await readingStat.startReadingStory(feedItem);

    if (settingsStore.fetchAiSummaryOnLoad && showReaderMode) {
      await summarizeArticle(context);
    }

    detectHackerNews();

    _registerLifecycleCallbacks();

    initialized = true;
  }

  @action
  void webviewInit() {
    // for each Ad URL filter, add a Content Blocker to block its loading.
    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(
        ContentBlocker(
          trigger: ContentBlockerTrigger(urlFilter: adUrlFilter),
          action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
        ),
      );
    }

    // apply the "display: none" style to some HTML elements
    contentBlockers.add(
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
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
  }

  @action
  void getSettingsStoreValues() {
    showReaderMode = settingsStore.useReaderModeByDefault;
    hideSummary = settingsStore.showAiSummaryOnLoad;
    showArchiveButton = settingsStore.alwaysShowArchiveButton;
  }

  @action
  void dispose() {
    if (initialized) {
      endReading();
      unregisterLifecycleCallbacks();
      readingStat.forceStopTracking();
    }
  }

  @action
  Future<void> checkPaywallOrBotBlock() async {
    const List<String> detectionMessages = [
      "Access Denied",
      "403 forbidden",
      "403: Forbidden",
      "Blocked by bot protection",
      "We've detected unusual activity",
      "Please complete the security check",
      "Are you a robot?",
      "We've detected unusual activity from your computer network",
      "Human verification required",
      "paid members only",
      "Sign up for free access",
      "Sign up for access",
      "Become a paid member",
      "Become a member",
      "Become a subscriber",
      "Subscribe to continue reading",
      "This article is for subscribers only",
      "Member exclusive",
      "You've reached your free article limit",
      "Not available in your region",
      "Content blocked in your country",
      "This content is not available in your location",
      "Complete the CAPTCHA",
      "I'm not a robot",
      "Please enable JS",
      "Please enable JavaScript",
      "Please enable Cookies",
      "Please enable Javascript",
      "Please enable javascript",
      "disable your ad blocker",
      "Disable your ad blocker",
      "disable your AdBlocker",
      "disable your Adblocker",
      "disable any ad blocker",
      "Prove you're not a robot",
      "you appear to be a bot",
      "You appear to be a bot",
      "Your request has been blocked by our server's security policies",
      "reCAPTCHA",
      "hCAPTCHA",
      "Ray ID",
      "Error 403",
      "Error 429",
      "Error 451",
      "JavaScript is required",
      "Please enable JavaScript",
      "Some privacy related extensions may cause issues on x.com. Please disable them and try again",
    ];
    bool suggestArchiveArticle = false;
    for (String msg in detectionMessages) {
      if (htmlContent.contains(msg)) {
        if (kDebugMode) {
          print("Block or paywall detected, suggesting Archived article");
        }
        suggestArchiveArticle = true;
        break;
      }
    }

    if (suggestArchiveArticle) {
      showArchiveButton = true;
      alertMessage = "Paywall or block detected, click the rightmost button in the bar to fetch the archived link";
      shortAlert = true;
      hasAlert = true;
    }
  }

  @action
  void detectHackerNews() {
    if (feedItem.commentsUrl != null && feedItem.commentsUrl!.isNotEmpty) {
      showHnButton = true;
    }
    // List<String> hn = ["hnrss.org", "https://news.ycombinator.com/rss"];
    // if (feedItem.feed != null && (hn.map((url) => feedItem.feed!.link.contains(url)).isNotEmpty)) {
    //   showHnButton = true;
    // }
  }

  @action
  Future<void> openHnCommentsPage() async {
    if (feedItem.commentsUrl == null || feedItem.commentsUrl!.isEmpty) {
      return;
    }

    Uri uri = Uri.parse(feedItem.commentsUrl!);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch ${feedItem.commentsUrl}');
    }
  }

  @action
  Future<void> openUrlInReaderMode(String url, {bool replaceItemContent = true}) async {
    loading = true;
    // readerModeHistory.add(currentUrl);

    htmlContent = await feedItem.fetchHtmlContent(url);
    // we may not always want to replace the item's content in the db, e.g., if we nagivate to a link
    if (replaceItemContent) {
      feedItem.downloaded = true;
      await dbUtils.updateItemInDb(feedItem);
    }
    loading = false;
  }

  @action
  Future<void> goBackInReaderHistory() async {
    htmlContent = await feedItem.fetchHtmlContent(readerModeHistory.removeLast());
  }

  @action
  Future<bool> getArchivedArticle({bool fromError = false}) async {
    loading = true;
    if (!fromError) {
      alertMessage = "Fetching archived article...";
      shortAlert = true;
      hasAlert = true;
    }
    var (bool archived, String archiveLink) = await getArchiveUrl(feedItem.url);
    if (archived) {
      openUrlInReaderMode(archiveLink);
      alertMessage = "Showing archived page.";
      shortAlert = true;
      hasAlert = true;
      return true;
    }
    if (!fromError) {
      // don't show the alert if the call to this function is from the error in compareReaderModeLengthToPageHTML, because that already has an alertMsg
      alertMessage = "No archived result found.";
      shortAlert = true;
      hasAlert = true;
    }

    loading = false;
    return false;
  }

  @action
  Future<void> compareReaderModeLengthToPageHtml(BuildContext context) async {
    Dio dio = Dio();

    try {
      // fetch the page's html
      Response res = await dio.get(feedItem.url);

      Map headers = res.headers.map;
      handlePdfDocs(headers);

      dom.Document doc = html_parser.parse(res.data);
      if (doc.body == null) {
        return;
      }

      if (kDebugMode) {
        print("Ratio webpage to reader: ${doc.body!.innerHtml.length / htmlContent.length}");
      }
      if ((doc.body!.innerHtml.length / htmlContent.length) > 250 && settingsStore.autoSwitchReaderTooShort) {
        alertMessage = "Reader view's article length is much shorter than the web page's, switching to it now. Change this behavior in settings.";
        hasAlert = true;
        showReaderMode = false;
        return;
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      if (err is DioError) {
        if (err.response?.statusCode == 403) {
          alertMessage = "Paywall or blocked article, fetching archived version...";
          hasAlert = true;
          shortAlert = true;
          if (await getArchivedArticle(fromError: true)) {
            showReaderMode = true;
            alertMessage = "The article was paywalled or blocked the request, showing the archived page now";
            hasAlert = true;
            return;
          }
        }
      }
      alertMessage = "The article was paywalled or blocked the request, but no archived result was found, showing the webpage now.";
      hasAlert = true;
      showReaderMode = false;
    }

    return;
  }

  void handlePdfDocs(Map<dynamic, dynamic> headers) {
    if (headers.keys.contains("content-type") || headers.keys.contains("Content-Type")) {
      if (headers["content-type"].contains("application/pdf")) {
        if (kDebugMode) {
          print("Document is PDF");
        }
        showReaderMode = false;
        alertMessage = "PDF Documents are shown in the webview";
        hasAlert = true;
        shortAlert = true;
      }
    }
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
        'padding': '12px 8px 30px 8px !important', // top, right, bottom, left
        "font-size": "1.1em",
        'text-align': textAlignString(settingsStore.textAlignment).toLowerCase(), // other values: 'left', 'right', 'center'
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
        'margin-top': '8px',
        'margin-bottom': '8px',
        // "text-align": "justify",
      };
    }

    if (element.className == "top-text") {
      return {'font-size': '14px', "line-height": "0.4", 'color': '#${Theme.of(context).dividerColor.toARGB32().toRadixString(16).substring(2)}'};
    }
    if (element.className == "small") {
      return {
        // 'font-size': '14px',
        'color': '#${Theme.of(context).dividerColor.toARGB32().toRadixString(16).substring(2)}',
      };
    }

    if (element.className == "tiny") {
      return {'font-size': '0.8em', 'color': '#${Theme.of(context).dividerColor.toARGB32().toRadixString(16).substring(2)}', 'text-align': 'right'};
    }

    switch (element.localName) {
      case 'h1':
        return {'font-size': '1.7em', 'font-weight': '700', 'text-align': "left"};
      case 'h2':
        return {'font-size': '1.25em', 'font-weight': '700', 'text-align': "left"};
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return {'font-size': '1.0em', 'font-weight': '700'};
      case 'img':
        return {'border-radius': '8px'};
      case "image":
        return {'border-radius': '8px'};
      case 'figure':
      case 'video':
      case 'iframe':
        return {'max-width': '100% !important', 'height': 'auto', 'margin': '0 auto', 'display': 'block'};
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
        return {'color': '#${Theme.of(context).colorScheme.primary.toARGB32().toRadixString(16).substring(2)}', 'text-decoration': 'none'};

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
          'padding': '0 8px',
        };
      case 'td':
        return {
          'padding': '0 8px',
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'border-collapse': 'collapse',
        };
      case 'th':
        return {
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.toARGB32().toRadixString(16).substring(2)}',
          'border-collapse': 'collapse',
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
  Future<void> summarizeArticle(BuildContext context, {bool longSummaryAccepted = false}) async {
    if (!authStore.initialized) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error, try again in a few seconds."), duration: Duration(seconds: 5)));
      return;
    }

    hideBar = false;

    if (aiLoading || feedItem.summarized) {
      return;
    }

    dom.Document document = parse(htmlContent);
    String docText = document.body!.text;

    if (authStore.userTier == Tier.premium) {
      // check firestore for existing summary (This doesn't count towards the user's summaries)
      // only check if the user is premium
      var existingSummary = await firestore.collection("summaries").where("url", isEqualTo: feedItem.url).get();

      if (existingSummary.docs.isNotEmpty) {
        if (kDebugMode) {
          print("Summary found in Firestore");
        }
        String summary = existingSummary.docs.first.get("summary");
        feedItem.aiSummary = summary;
        feedItem.summarized = true;
        await dbUtils.updateItemInDb(feedItem);
        feedItemSummarized = true;
        // evaluateSummary(docText, summary, context);
        return;
      }
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
      alertMessage = "You can only request a summary every $summariesIntervalSeconds seconds, slow down (or disable auto summary creation in the settings.)";
      hasAlert = true;

      return;
    }

    if (docText.length < 500) {
      if (kDebugMode) {
        print(docText.length);
      }
      alertMessage = "Article too short to summarize.";
      hasAlert = true;
      return;
    } else if (docText.length > 30000 && !longSummaryAccepted) {
      String summaryCount = (docText.length / 15000).toStringAsFixed(0);
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text("Confirm summary for long article"),
            content: Text("This article is very long, do you really want to summarize it? It will use $summaryCount summary credits."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  return;
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  return summarizeArticle(context, longSummaryAccepted: true);
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );
    }

    if (docText.length > 30000 && !longSummaryAccepted) {
      return;
    }

    if (kDebugMode) {
      print("Sending ${docText.length} characters to AI for summarization");
    }

    aiLoading = true;
    try {
      String summary = await aiUtils.summarize(docText, feedItem);
      feedItem.aiSummary = summary;
      feedItem.summarized = true;
      await dbUtils.updateItemInDb(feedItem);
      feedItemSummarized = true;
      // evaluateSummary(docText, summary, context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      alertMessage = e.toString().replaceAll("Error: ", "");
      hasAlert = true;
    }

    aiLoading = false;
  }

  @action
  Future<void> evaluateSummary(String article, String summary, BuildContext context) async {
    var (bool useSummary, double score) = await aiUtils.evaluateSummary(article, summary);
    if (kDebugMode) {
      print("Evaluated summary: $useSummary, with score $score");
    }
    if (!useSummary) {
      if (kDebugMode) {
        print("Not using summary!");
      }
      alertMessage = "The summary for this article was not factually correct, try again later.";
      hasAlert = true;

      feedItem.aiSummary = "";
      authStore.lastSummaryDate = DateTime.now().toUtc();
      feedItem.summarized = false;
      await dbUtils.updateItemInDb(feedItem);
      feedItemSummarized = false;
    }
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
                  child: Card.filled(
                    child: IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @action
  void endReading() {
    if (kDebugMode) {
      print("Ending Reading: ${readingStat.reading}");
    }
    if (initialized) {
      readingStat.endReading(feedItem);
    }
  }


  void _registerLifecycleCallbacks() {
    lifecycleEventHandler.addBackgroundCallback(handleAppPaused);
    lifecycleEventHandler.addForegroundCallback(handleAppResumed);
  }

  void unregisterLifecycleCallbacks() {
    lifecycleEventHandler.removeBackgroundCallback(handleAppPaused);
    lifecycleEventHandler.removeForegroundCallback(handleAppResumed);
  }

  void handleAppPaused() {
    if (initialized) {
      readingStat.handleAppPaused();
    }
  }

  void handleAppResumed() {
    if (initialized) {
      readingStat.handleAppResumed();
    }
  }

  @action
  void shareArticle(BuildContext context) {
    final params = ShareParams(uri: Uri.parse(feedItem.url));

    SharePlus.instance.share(params);
  }

  // @action
  // void searchInArticle(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, Function dialogSetState) {
  //           return AlertDialog(
  //             insetPadding: EdgeInsets.all(8),
  //             contentPadding: EdgeInsets.all(8),
  //             title: const Text("Search"),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Confirm"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   ).then((_) {});
  // }

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
