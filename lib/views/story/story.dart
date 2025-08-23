// ignore: unnecessary_import
import 'dart:math';
import 'dart:ui';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:bytesized_news/views/story/sub_views/story_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Story extends StatefulWidget {
  final FeedItem feedItem;

  const Story({super.key, required this.feedItem});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  late SettingsStore settingsStore;
  late AuthStore authStore;
  StoryStore storyStore = StoryStore();
  final GlobalKey webViewKey = GlobalKey();
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();

    // PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
    reactionDisposer = reaction((_) => storyStore.hasAlert, (bool hasAlert) {
      // if there is an alert to show, show it in a snackbar
      if (hasAlert) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(storyStore.alertMessage),
            duration: Duration(seconds: storyStore.shortAlert ? 3 : 10),
            // showCloseIcon: !storyStore.shortAlert,
          ),
        );
        storyStore.hasAlert = false;
        storyStore.shortAlert = false;
        storyStore.alertMessage = "";
      }
    });

    storyStore.init(widget.feedItem, context, settingsStore, authStore);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    storyStore.dispose();
    reactionDisposer();
  }

  @override
  Widget build(BuildContext context) {
    dom.Document doc = parse(storyStore.feedItem.title);
    String parsedTitle = parse(doc.body!.text).documentElement!.text;

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
          if (storyStore.controller != null) storyStore.controller?.goBack();
        } else {
          storyStore.dispose();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Observer(
            builder: (_) {
              return Text("$parsedTitle - ${storyStore.feedItem.feed?.name}");
            },
          ),
          actions: [
            // IconButton(icon: Icon(Icons.search_rounded), onPressed: () => storyStore.searchInArticle(context)),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => StorySettings(storyStore: storyStore))).then((_) {
                  storyStore.getSettingsStoreValues();
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Stack(
            children: [
              Observer(
                builder: (context) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (!storyStore.showReaderMode) ...[
                        InAppWebView(
                          key: webViewKey,
                          initialUrlRequest: URLRequest(url: WebUri(storyStore.feedItem.url)),
                          initialSettings: storyStore.settings,
                          onWebViewCreated: (controller) {
                            storyStore.controller = controller;
                          },
                          onScrollChanged: storyStore.webviewScrollListener,
                          onPermissionRequest: (controller, request) async {
                            return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
                          },
                          shouldOverrideUrlLoading: (controller, navigationAction) async {
                            var uri = navigationAction.request.url!;

                            if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                              if (await canLaunchUrl(uri)) {
                                // Launch the App
                                await launchUrl(uri);
                                // and cancel the request
                                return NavigationActionPolicy.CANCEL;
                              }
                            }

                            return NavigationActionPolicy.ALLOW;
                          },
                          onLoadStart: storyStore.onLoadStart,
                          onLoadStop: storyStore.onLoadStop,
                          onProgressChanged: storyStore.onProgressChanged,
                        ),
                        const SizedBox(height: 15),
                      ],
                      if (storyStore.showReaderMode) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: storyStore.settingsStore.horizontalPadding),
                          child: SelectableRegion(
                            focusNode: FocusNode(),
                            selectionControls: MaterialTextSelectionControls(),
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: storyStore.settingsStore.storyReaderMaxWidth),
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: storyStore.notificationListener,
                                  child: HtmlWidget(
                                    key: storyStore.htmlWidgetKey,
                                    '''
                                        <div class="bytesized_news_html_content">
                                           ${storyStore.htmlContent.split(" ").take(50).join(" ").contains(storyStore.feedItem.title) ? "" : "<h1>${storyStore.feedItem.title}</h1>"}
                                             <p class="top-text">${storyStore.feedItem.feed?.name} | ${formatTime(storyStore.feedItem.publishedDate.millisecondsSinceEpoch)}</p>
                                             ${storyStore.htmlContent.split(" ").take(100).join(" ").contains(storyStore.feedItem.authors.join("|")) ? "" : "<p class='top-text'> ${storyStore.feedItem.authors.join(", ")}</p>"}
                                             <p class="top-text">${storyStore.feedItem.estReadingTimeMinutes} minute read</p>

                                                 ${ /* TODO: Tweak; if there is an image early in the article, don't show our image */ storyStore.hasImageInArticle ? "" : '<img src="${storyStore.feedItem.imageUrl}" alt="Cover Image"/>'}

                                                   <div class='ai_container'></div>

                                                 ${storyStore.feedItem.htmlContent ?? "Loading..."}
                                                 Source: <a href="${storyStore.feedItem.url}">${storyStore.feedItem.url}</a>
                                              </div>
                                              ''',
                                    renderMode: RenderMode.listView,
                                    textStyle: fontFamilyToGoogleFontTextStyle(
                                      settingsStore.fontFamily,
                                    ).copyWith(fontSize: settingsStore.fontSize, fontWeight: widthToWeight(settingsStore.textWidth)),
                                    customStylesBuilder: (element) => storyStore.buildStyle(context, element),
                                    onTapImage: (ImageMetadata imageData) {
                                      storyStore.showImage(imageData.sources.firstOrNull!.url, context);
                                    },
                                    onTapUrl: (String? url) async {
                                      if (url == null) {
                                        return false;
                                      }
                                      Uri uri = Uri.parse(url);
                                      // if (storyStore.showReaderMode && settingsStore.openLinksInReaderMode) {
                                      //   storyStore.openUrlInReaderMode(url, replaceItemContent: false);
                                      // } else
                                      if (!await launchUrl(uri)) {
                                        throw Exception('Could not launch $url');
                                      }
                                      return true;
                                    },
                                    customWidgetBuilder: (html.Element e) {
                                      if (e.className == "ai_container") {
                                        return SummaryCard(settingsStore: settingsStore, storyStore: storyStore).animate().fadeIn(duration: 300.ms);
                                      }

                                      // if (!e.innerHtml.contains("img") && !e.innerHtml.contains("image") && !e.innerHtml.contains("picture")) {
                                      //   return null;
                                      // }

                                      String imgSrc = "";
                                      if (e.attributes case {'src': final String src}) {
                                        imgSrc = src;
                                      }

                                      if (imgSrc.isEmpty) {
                                        return null;
                                      }

                                      // Extract width and height from HTML attributes
                                      double? width;
                                      double? height;

                                      if (e.attributes.containsKey('width')) {
                                        width = double.tryParse(e.attributes['width']!);
                                      }

                                      if (e.attributes.containsKey('height')) {
                                        height = double.tryParse(e.attributes['height']!);
                                      }

                                      // calculate aspect ratio and detect problematic dimensions
                                      double? aspectRatio;
                                      bool hasReliableDimensions = false;

                                      if (width != null && height != null && width > 0 && height > 0) {
                                        aspectRatio = width / height;
                                        // consider dimensions unreliable if aspect ratio is too extreme or if it's a profile image
                                        hasReliableDimensions = aspectRatio >= 0.1 && aspectRatio <= 10.0;
                                      }

                                      Widget imageWidget = InkWell(
                                        onTap: () async {
                                          storyStore.showImage(imgSrc, context);
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: imgSrc,
                                          cacheKey: imgSrc,
                                          cacheManager: DefaultCacheManager(),
                                          placeholder: (context, url) => SizedBox(width: 100, height: 10, child: LinearProgressIndicator()),
                                          errorWidget: (context, url, error) => const SizedBox.shrink(),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.contain,
                                          fadeInCurve: Curves.easeInQuad,
                                          fadeInDuration: 400.ms,
                                        ),
                                      );

                                      if (hasReliableDimensions && width! <= 400) {
                                        // og dimensions for images with reasonable dimensions
                                        imageWidget = Container(
                                          constraints: BoxConstraints(
                                            maxWidth: width,
                                            maxHeight: 400, // cap height to prevent extremely tall images
                                          ),
                                          child: imageWidget,
                                        );
                                      } else {
                                        // for large images or unreliable dimensions, use responsive sizing
                                        imageWidget = Container(
                                          constraints: BoxConstraints(
                                            maxHeight: 300, // max height for article images
                                          ),
                                          child: imageWidget,
                                        );
                                      }

                                      return Center(
                                        child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: imageWidget),
                                      );
                                    },
                                    enableCaching: true,
                                    buildAsync: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

              FloatingBar(storyStore: storyStore, widget: widget),
              Observer(
                builder: (context) {
                  if (!storyStore.initialized) {
                    return const LinearProgressIndicator();
                  }

                  if (!storyStore.showReaderMode && storyStore.loading) {
                    return LinearProgressIndicator(value: storyStore.progress / 100);
                  }

                  if (storyStore.aiLoading) {
                    return const LinearProgressIndicator()
                        .animate()
                        .fadeIn()
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          duration: const Duration(milliseconds: 1500),
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.inversePrimary,
                            Theme.of(context).colorScheme.primary,
                          ],
                        );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.settingsStore,
    required this.storyStore,
  });

  final SettingsStore settingsStore;
  final StoryStore storyStore;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(12);

    return Observer(
      builder: (context) {
        if (storyStore.authStore.userTier != Tier.premium) {
          return SizedBox.shrink();
        }

        return AnimatedCrossFade(
          crossFadeState: !storyStore.feedItemSummarized ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: 250.ms,
          firstCurve: Curves.easeOutCubic,
          secondCurve: Curves.easeOutCubic,
          sizeCurve: Curves.easeOutCubic,
          firstChild: buildButtonCard(context, borderRadius),
          secondChild: buildSummaryCard(context, borderRadius),
        );
      },
    );
  }

  Card buildButtonCard(BuildContext context, BorderRadius borderRadius) {
    return Card.filled(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: !storyStore.aiLoading
              ? () {
                  if (!storyStore.aiLoading) {
                    storyStore.summarizeArticle(context);
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child:
                  Text(
                        storyStore.aiLoading ? "Loading..." : "Summarize",
                        style:
                            fontFamilyToGoogleFontTextStyle(
                              settingsStore.fontFamily,
                            ).copyWith(
                              fontSize: ((settingsStore.fontSize ?? 16) * 0.9),
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      )
                      .animate(target: storyStore.aiLoading ? 1 : 0, onPlay: (controller) => controller.repeat())
                      .shimmer(
                        duration: const Duration(milliseconds: 1500),
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.inversePrimary,
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Card buildSummaryCard(BuildContext context, BorderRadius borderRadius) {
    return Card.filled(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ExpansionTile(
          enableFeedback: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          initiallyExpanded: settingsStore.showAiSummaryOnLoad,
          title: Text(
            "Summary",
            style:
                fontFamilyToGoogleFontTextStyle(
                  settingsStore.fontFamily,
                ).copyWith(
                  fontSize: ((settingsStore.fontSize ?? 16) * 1.1),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          children: [
            ...storyStore.feedItem.aiSummary.split("\n").map((line) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  line,
                  style:
                      fontFamilyToGoogleFontTextStyle(
                        settingsStore.fontFamily,
                      ).copyWith(
                        fontSize: settingsStore.fontSize,
                        fontWeight: widthToWeight(settingsStore.textWidth),
                        height: settingsStore.lineHeight,
                      ),
                ),
              );
            }),
            const SizedBox(height: 5),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Generated content, verify important information.",
                style:
                    fontFamilyToGoogleFontTextStyle(
                      settingsStore.fontFamily,
                    ).copyWith(
                      fontSize: ((settingsStore.fontSize ?? 16) * 0.7),
                      fontWeight: widthToWeight(settingsStore.textWidth),
                      height: settingsStore.lineHeight,
                      color: Theme.of(context).dividerColor,
                    ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

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

                                !storyStore.showReaderMode && storyStore.feedItemSummarized
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
                                IconButton(icon: Icon(Icons.share_rounded), onPressed: () => storyStore.shareArticle(context)),

                                // HN COMMENTS BUTTON
                                storyStore.showHnButton
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
