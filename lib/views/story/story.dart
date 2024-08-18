import 'package:bytesized_news/main.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
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

    PlatformInAppWebViewController.debugLoggingSettings.enabled = false;

    storyStore.init(widget.feedItem, context, settingsStore, authStore);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
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
          storyStore.controller?.goBack();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Observer(builder: (_) {
            return Text("${storyStore.feedItem.title} - ${storyStore.feedItem.feedName}");
          }),
        ),
        body: BottomSheetBar(
          controller: storyStore.bsbController,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          backdropColor: Theme.of(context).colorScheme.surface,
          locked: storyStore.isLocked,
          body: Observer(builder: (_) {
            return Center(
              child: Stack(
                children: [
                  storyStore.loading ? LinearProgressIndicator(value: storyStore.progress / 100) : const SizedBox(),
                  storyStore.initialized
                      ? Stack(
                          children: [
                            InAppWebView(
                              key: webViewKey,
                              initialUrlRequest: URLRequest(url: WebUri(storyStore.feedItem.url)),
                              initialSettings: storyStore.settings,
                              onWebViewCreated: (controller) {
                                storyStore.controller = controller;
                              },
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
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
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
                                  storyStore.feedItemSummarized
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            color: Theme.of(context).colorScheme.surface,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              elevation: 0,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: SelectableText(
                                                  storyStore.feedItem.aiSummary,
                                                  style: mediaQuery.size.width > 600
                                                      ? Theme.of(context).textTheme.bodyMedium
                                                      : Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ),
                                            ),
                                          ).animate().fadeIn().then().shimmer(
                                            duration: const Duration(milliseconds: 1200),
                                            curve: Curves.easeInOutSine,
                                            colors: [
                                              const Color(0x00FFFF00),
                                              const Color(0xBFFFFF00),
                                              const Color(0xBF00FF00),
                                              const Color(0xBF00FFFF),
                                              const Color(0xBF0033FF),
                                              const Color(0xBFFF00FF),
                                              const Color(0xBFFF0000),
                                              const Color(0xBFFFFF00),
                                              // const Color(0xFFFF00),
                                            ],
                                          ),
                                        ).animate(controller: storyStore.animationController).slideY(
                                            begin: 2,
                                            end: 0,
                                            curve: Curves.easeInOutSine,
                                            duration: const Duration(milliseconds: 500),
                                          )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            );
          }),
          expandedBuilder: (ScrollController _) {
            return const SizedBox();
          },
          collapsed: Observer(builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // RELOAD
                IconButton(
                  onPressed: () {
                    storyStore.controller?.reload();
                  },
                  icon: const Icon(Icons.refresh),
                ),
                // BACK

                IconButton(
                  onPressed: () {
                    if (storyStore.canGoBack) {
                      storyStore.controller?.goBack();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: storyStore.canGoBack ? null : Colors.grey.withOpacity(0.5),
                  ),
                ),

                // FORWARD
                IconButton(
                  onPressed: () {
                    if (storyStore.canGoForward) {
                      storyStore.controller?.goForward();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: storyStore.canGoForward ? null : Colors.grey.withOpacity(0.5),
                  ),
                ),

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
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
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
            );
          }),
        ),
      ),
    );
  }
}
