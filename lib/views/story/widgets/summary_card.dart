import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
              child: AnimatedCrossFade(
                crossFadeState: storyStore.aiLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: 200.ms,
                firstChild: Text(
                  "Summarize",
                  style:
                      fontFamilyToGoogleFontTextStyle(
                        settingsStore.fontFamily,
                      ).copyWith(
                        fontSize: ((settingsStore.fontSize ?? 16) * 0.9),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                secondChild:
                    Text(
                          "Loading...",
                          style:
                              fontFamilyToGoogleFontTextStyle(
                                settingsStore.fontFamily,
                              ).copyWith(
                                fontSize: ((settingsStore.fontSize ?? 16) * 0.9),
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
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
            // split the summary based on the paragraphs and add padding between each paragraph
            ...storyStore.feedItem.aiSummary.split("\n").map((line) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
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
