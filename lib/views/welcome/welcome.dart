import 'package:bytesized_news/views/curated_feeds/curated_feeds_view.dart';
import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final PageController pageController = PageController();
  int currentPage = 0;
  final int pageCount = 4;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextSlide() {
    if (currentPage < pageCount - 1) {
      pageController.nextPage(duration: 300.ms, curve: Curves.decelerate);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (BuildContext context) => const FeedView()));
    }
  }

  void prevSlide() {
    if (currentPage > 0) {
      pageController.previousPage(duration: 300.ms, curve: Curves.decelerate);
    }
  }

  void skip() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (BuildContext context) => const FeedView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // skip
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: skip,
                  child: const Text('Skip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ),

            // slides
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: [buildIntroSlide(), buildPricingSlide(), buildAIDisclaimerSlide(), buildCuratedFeedsSlide()],
              ),
            ),

            // slide indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pageCount, (index) {
                  return AnimatedSize(
                    duration: 500.ms,
                    curve: Curves.easeOutQuad,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentPage == index ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    duration: 100.ms,
                    opacity: currentPage > 0 ? 1 : 0,
                    child: TextButton(onPressed: currentPage > 0 ? prevSlide : null, child: const Text('Previous')),
                  ),

                  FilledButton.tonal(
                    onPressed: nextSlide,
                    child: Text(currentPage == pageCount - 1 ? 'Get Started' : 'Next', style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIntroSlide() {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_rounded, size: 90, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text('Welcome to Bytesized News', style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(
                'Bytesized News is a modern, smart RSS reader with lots of curated sources, instant summaries, and news suggestions based on your interests.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).dividerColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPricingSlide() {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium_rounded, size: 90, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text('Premium Features', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 15),
              Text(
                'All of the local features of the app are free. All features that incur server costs are premium features. One-time payment.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).dividerColor),

                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card.filled(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.flash_on_rounded, color: Theme.of(context).colorScheme.onSecondaryContainer),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "• Feed Syncing\n• Instant article summarization\n• Personalized news suggestions\n• And more...",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAIDisclaimerSlide() {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_rounded, size: 60, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text('Generative AI Disclaimer', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 15),
              Text(
                'The premium features use generative AI. LLMs are notorious for their hallucinations; please double-check all important information found in summaries.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).dividerColor),

                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCuratedFeedsSlide() {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rss_feed_rounded, size: 60, color: Theme.of(context).colorScheme.primary),

              Text('Add curated feeds', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),

              Text(
                'Bytesized News has a list of curated sources available for you to add right now.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).dividerColor),
                textAlign: TextAlign.center,
              ),

              FilledButton.tonal(
                child: const Text("Follow sources"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CuratedFeedsView(context: context, getFeeds: () => null, getItems: () => null),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
