import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/AI/ai_util.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:readability/readability.dart' as readability;

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
  bool showReaderMode = false;

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
  BottomSheetBarController bsbController = BottomSheetBarController();

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
  AiUtils aiUtils = AiUtils();

  @observable
  bool feedItemSummarized = false;

  @observable
  bool aiLoading = false;

  @observable
  bool hideSummary = false;

  @observable
  late AnimationController animationController;

  @action
  Future<void> init(FeedItem item, BuildContext context, SettingsStore setStore, AuthStore authStore) async {
    settingsStore = setStore;
    this.authStore = authStore;

    dbUtils = DbUtils(isar: isar);

    feedItem = item;
    isBookmarked = feedItem.bookmarked;
    feedItemSummarized = feedItem.summarized;

    htmlContent = await fetchPageHtml();

    bsbController.addListener(onBsbChanged);

    animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 150),
    );

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
  }

  @action
  Future<String> fetchPageHtml() async {
    final result = await readability.parseAsync(feedItem.url);
    return result.content!;
  }

  @action
  Map<String, String>? buildStyle(BuildContext context, dom.Element element) {
    if (element.className == 'bytesized_news_html_content') {
      return {
        'line-height': '1.5',
        'background-color': '#${Theme.of(context).scaffoldBackgroundColor.value.toRadixString(16).substring(2)}',
        'width': 'auto',
        'height': 'auto',
        'margin': '0',
        'word-wrap': 'break-word', // other values 'break-word', 'keep-all', 'normal'
        'padding': '12px 18px !important',
        // 'text-align': "justify" // other values: 'left', 'right', 'center'
      };
    }

    if (element.className == "ai_container") {
      // card line container for the AI summary
      return {
        'background-color': '#${Theme.of(context).colorScheme.surfaceContainer.value.toRadixString(16).substring(2)}',
        'padding': '0px 10px 5px 10px !important',
        'margin': '0',
        'border-radius': '8px',
        'box-shadow': '0 0 8px 0 rgba(0,0,0,0.1)',
        'margin-top': '10px',
        'margin-bottom': '10px',
      };
    }

    switch (element.localName) {
      case 'h1':
        return {'font-size': '1.5em', 'font-weight': '700'};
      case 'h2':
        return {'font-size': '1.25em', 'font-weight': '700'};
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return {'font-size': '1.0em', 'font-weight': '700'};
      case 'img':
      case 'figure':
      case 'video':
      case 'iframe':
        return {
          'max-width': '100% !important',
          'height': 'auto',
          'margin': '0 auto',
          'display': 'block',
        };
      case "figcaption":
        return {
          'font-size': '0.8em',
          'color': '#${Theme.of(context).textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
          'text-align': 'left',
        };
      case 'a':
        return {
          'color': '#${Theme.of(context).colorScheme.primary.value.toRadixString(16).substring(2)}',
          // 'text-decoration': 'none',
        };

      case 'blockquote':
        return {'margin': '0', 'padding': '0 0 0 16px', 'border-left': '4px solid #9e9e9e'};
      case 'pre':
        return {'white-space': 'pre-wrap', 'word-break': 'break-all'};

      case 'table':
        return {
          'width': '100% !important',
          'table-layout': 'fixed',
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
          'border-collapse': 'collapse',
          'padding': '0 8px'
        };
      case 'td':
        return {
          'padding': '0 8px',
          'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
          'border-collapse': 'collapse'
        };
      case 'th':
        return {'border': '1px solid #${Theme.of(context).textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}', 'border-collapse': 'collapse'};
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
    if (authStore.userTier == Tier.free) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This feature is only available to premium users"),
          duration: Duration(seconds: 5),
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

    String htmlValue = htmlContent;

    if (aiLoading || feedItem.summarized) {
      return;
    }

    dom.Document document = parse(htmlValue);

    aiLoading = true;

    try {
      feedItem.aiSummary = await aiUtils.summarizeWithFirebase(feedItem, document.body!.text);
      feedItem.summarized = true;
      await dbUtils.updateItemInDb(feedItem);
      feedItemSummarized = true;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll("Exception: ", ""),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
    // feedItem.aiSummary = await aiUtils.summarize(document.body!.text, feedItem);
    // feedItem.summarized = true;
    // await dbUtils.updateItemInDb(feedItem);

    // feedItemSummarized = true;
    aiLoading = false;
  }

  @action
  Future<void> onLoadStart(InAppWebViewController controller, WebUri? url) async {
    loading = true;
  }

  @action
  void toggleReaderMode() {
    showReaderMode = !showReaderMode;
  }

  @action
  void hideAiSummary() {
    hideSummary = !hideSummary;
    animationController.toggle();
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

  @action
  void bookmarkItem() {
    feedItem.bookmarked = !feedItem.bookmarked;
    isBookmarked = feedItem.bookmarked;
    dbUtils.updateItemInDb(feedItem);
  }
}
