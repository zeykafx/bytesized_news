import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opml/opml.dart';
import '../../models/feed_model.dart';

class CuratedFeeds extends StatefulWidget {
  const CuratedFeeds({super.key});

  @override
  State<CuratedFeeds> createState() => _CuratedFeedsState();
}

class _CuratedFeedsState extends State<CuratedFeeds> {
  List<FeedCategory> feedCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeedCategories();
  }

  Future<void> _loadFeedCategories() async {
    try {
      final List<String> feedFiles = [
        'Android Development.opml',
        'Android.opml',
        'Apple.opml',
        'Architecture.opml',
        'Beauty.opml',
        'Books.opml',
        'Business & Economy.opml',
        'Cars.opml',
        'Cricket.opml',
        'DIY.opml',
        'Fashion.opml',
        'Food.opml',
        'Football.opml',
        'Funny.opml',
        'Gaming.opml',
        'History.opml',
        'Interior design.opml',
        'Movies.opml',
        'Music.opml',
        'News.opml',
        'Personal finance.opml',
        'Photography.opml',
        'Programming.opml',
        'Science.opml',
        'Space.opml',
        'Sports.opml',
        'Startups.opml',
        'Tech.opml',
        'Television.opml',
        'Tennis.opml',
        'Travel.opml',
        'UI - UX.opml',
        'Web Development.opml',
        'iOS Development.opml',
      ];

      List<FeedCategory> categories = [];

      for (String fileName in feedFiles) {
        try {
          final String opmlContent = await rootBundle.loadString('assets/feeds/$fileName');
          final OpmlDocument opmlDoc = OpmlDocument.parse(opmlContent);

          List<FeedModel> feeds = [];
          for (var outline in opmlDoc.body) {
            if (outline.xmlUrl != null && outline.xmlUrl!.isNotEmpty) {
              feeds.add(FeedModel.fromOpmlOutline(outline));
            }
          }

          if (feeds.isNotEmpty) {
            String categoryName = fileName.replaceAll('.opml', '');
            categories.add(FeedCategory(name: categoryName, feeds: feeds));
          }
        } catch (e) {
          print('Error loading $fileName: $e');
        }
      }

      setState(() {
        feedCategories = categories;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading feed categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curated Feeds'),
      ),
      body: ListView.builder(
        itemCount: feedCategories.length,
        itemBuilder: (context, index) {
          final category = feedCategories[index];
          return ExpansionTile(
            title: Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('${category.feeds.length} feeds'),
            children: category.feeds.map((feed) {
              return ListTile(
                title: Text(feed.text.isNotEmpty ? feed.text : feed.title),
                subtitle: feed.description.isNotEmpty
                    ? Text(
                        feed.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: const Icon(Icons.rss_feed),
                onTap: () {
                  // TODO: Handle feed tap
                  print('Tapped on feed: ${feed.text}');
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
