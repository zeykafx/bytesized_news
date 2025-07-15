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
  final StoryStore storyStore = StoryStore();
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();

    // PlatformInAppWebViewController.debugLoggingSettings.enabled = false;

    storyStore.init(widget.feedItem, context, settingsStore, authStore);

    super.initState();
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
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Observer(builder: (_) {
            return Text("$parsedTitle - ${storyStore.feedItem.feedName}");
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StorySettings(
                      storyStore: storyStore,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Observer(builder: (_) {
          return Center(
            child: Stack(
              children: [
                storyStore.initialized
                    ? Stack(
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
                                    await launchUrl(
                                      uri,
                                    );
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
                          ],
                          if (storyStore.showReaderMode) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: storyStore.settingsStore.horizontalPadding),
                              child: SelectableRegion(
                                focusNode: FocusNode(),
                                selectionControls: MaterialTextSelectionControls(),
                                child: Center(
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 800),
                                    child: NotificationListener<ScrollNotification>(
                                      onNotification: storyStore.notificationListener,
                                      child: HtmlWidget(
                                        key: storyStore.htmlWidgetKey,
                                        '''
                                        <div class="bytesized_news_html_content">
                                           ${storyStore.htmlContent.split(" ").take(100).join(" ").contains(storyStore.feedItem.title) ? "" : "<h1>${storyStore.feedItem.title}</h1>"}
                                             <p>Feed: <a href="${storyStore.feedItem.feed?.link}">${storyStore.feedItem.feedName}</a></p>
                                             ${storyStore.htmlContent.split(" ").take(100).join(" ").contains(storyStore.feedItem.authors.join("|")) ? "" : "<p>Author${storyStore.feedItem.authors.length > 1 ? "s" : ""}: ${storyStore.feedItem.authors.join(", ")}</p>"}
                                             <p> Published: ${formatTime(storyStore.feedItem.publishedDate.millisecondsSinceEpoch)}</p>
                                             <p class="grey">Reading Time: ${storyStore.feedItem.estReadingTimeMinutes} minutes</p>
                                  
                                                 ${/* TODO: Tweak; if there is an image early in the article, don't show our image */ storyStore.htmlContent.split(" ").take(150).join(" ").contains("img") ? "" : '<img src="${storyStore.feedItem.imageUrl}" alt="Cover Image"/>'}
                                  
                                                   ${storyStore.hideSummary && storyStore.feedItemSummarized ? '''<div class="ai_container">
                                                    <h2>Summary</h2>
                                                    <p>
                                                    ${storyStore.feedItem.aiSummary.split('\n').map((String part) {
                                            return "<p>$part</p>";
                                          }).join("")}
                                                    </p>
                                                    <p class="tiny">Summarized by LLama 3.1</p>
                                                    </div>''' : ""}
                                  
                                                 ${storyStore.feedItem.htmlContent}
                                                 Source: <a href="${storyStore.feedItem.url}">${storyStore.feedItem.url}</a>
                                              </div>
                                              ''',
                                        renderMode: RenderMode.listView,
                                        textStyle: fontFamilyToGoogleFontTextStyle(settingsStore.fontFamily).copyWith(
                                          fontSize: settingsStore.fontSize,
                                          fontWeight: widthToWeight(settingsStore.textWidth),
                                        ),
                                        customStylesBuilder: (element) => storyStore.buildStyle(context, element),
                                        onTapImage: (ImageMetadata imageData) {
                                          storyStore.showImage(imageData.sources.firstOrNull!.url, context);
                                        },
                                        onTapUrl: (String? url) async {
                                          if (url == null) {
                                            return false;
                                          }
                                          Uri uri = Uri.parse(url);
                                          if (!await launchUrl(uri)) {
                                            throw Exception('Could not launch $url');
                                          }
                                          return true;
                                        },
                                        customWidgetBuilder: (html.Element e) {
                                          if (!e.innerHtml.contains("img") || !e.innerHtml.contains("image") || !e.innerHtml.contains("picture")) {
                                            return null;
                                          }
                                  
                                          String imgSrc = "";
                                          if (e.attributes case {'src': final String src}) {
                                            imgSrc = src;
                                          }
                                  
                                          if (imgSrc.isEmpty) {
                                            return null;
                                          }
                                  
                                          return CachedNetworkImage(
                                            imageUrl: imgSrc,
                                            cacheKey: imgSrc,
                                            cacheManager: DefaultCacheManager(),
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
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
                      )
                    : const LinearProgressIndicator(),

                // floating bar
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AnimatedSlide(
                      offset: storyStore.hideBar ? Offset(0, 0.6) : Offset(0, 0),
                      duration: 150.ms,
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
                            side: BorderSide(
                              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    spacing: 5,
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
                                      if (!storyStore.showReaderMode) ...[
                                        IconButton(
                                          onPressed: () {
                                            if (storyStore.canGoBack) {
                                              storyStore.controller?.goBack();
                                            }
                                          },
                                          tooltip: "Go back",
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: storyStore.canGoBack ? null : Colors.grey.withValues(alpha: 0.5),
                                          ),
                                        ),

                                        // FORWARD
                                        IconButton(
                                          onPressed: () {
                                            if (storyStore.canGoForward) {
                                              storyStore.controller?.goForward();
                                            }
                                          },
                                          tooltip: "Go forward",
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: storyStore.canGoForward ? null : Colors.grey.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],

                                      storyStore.feedItemSummarized
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
                                              onPressed: () {
                                                storyStore.summarizeArticle(context);
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
                                    ],
                                  ),
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
                                          side: BorderSide(
                                            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                                            width: 1,
                                          ),
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
                  ),
                ),
                if (!storyStore.showReaderMode) ...[
                  storyStore.loading ? LinearProgressIndicator(value: storyStore.progress / 100) : const SizedBox(),
                ],
                storyStore.aiLoading
                    ? const LinearProgressIndicator().animate().fadeIn().animate(onPlay: (controller) => controller.repeat()).shimmer(
                        duration: const Duration(milliseconds: 1500),
                        colors: [
                          const Color(0xBFFFFF00),
                          const Color(0xBF00FF00),
                          const Color(0xBF00FFFF),
                          const Color(0xBF0033FF),
                          const Color(0xBFFF00FF),
                          const Color(0xBFFF0000),
                          const Color(0xBFFFFF00),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
