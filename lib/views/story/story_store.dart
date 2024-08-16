import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:bytesized_news/AI/ai_util.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';

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

  void init(FeedItem item, BuildContext context, SettingsStore setStore, AuthStore authStore) {
    settingsStore = setStore;
    this.authStore = authStore;

    dbUtils = DbUtils(isar: isar);

    feedItem = item;
    isBookmarked = feedItem.bookmarked;
    feedItemSummarized = feedItem.summarized;

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

    String? htmlValue = await controller?.evaluateJavascript(source: "window.document.getElementsByTagName('html')[0].outerHTML;");

    if (aiLoading || htmlValue == null || feedItem.summarized) {
      return;
    }

    dom.Document document = parse(htmlValue);

    aiLoading = true;

    try {
      feedItem.aiSummary = await aiUtils.summarizeWithFirebase(feedItem);
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
