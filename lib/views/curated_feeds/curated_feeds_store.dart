import 'package:bytesized_news/models/curatedFeed/curated_feed.dart';
import 'package:bytesized_news/models/curatedFeed/curated_feed_category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobx/mobx.dart';
import 'package:opml/opml.dart';

part 'curated_feeds_store.g.dart';

class CuratedFeedsStore = _CuratedFeedsStore with _$CuratedFeedsStore;

abstract class _CuratedFeedsStore with Store {
  String curatedFeedsPath = "assets/feeds";
  List<String> curatedFeedsFilenames = ["curated_feeds.xml"];

  @observable
  List<CuratedFeedCategory> curatedCategories = [];

  @observable
  bool loading = false;

  @action
  Future<void> readCuratedFeeds(BuildContext context) async {
    loading = true;
    try {
      for (String filename in curatedFeedsFilenames) {
        String fileContent = await rootBundle.loadString("$curatedFeedsPath/$filename");

        OpmlDocument opml = OpmlDocument.parse(fileContent);

        for (OpmlOutline outline in opml.body) {
          // get category name
          String categoryName = "";
          if (outline.text != null) {
            categoryName = outline.text!;
          } else if (outline.title != null) {
            categoryName = outline.title!;
          }

          // get all the feeds in the category
          List<CuratedFeed> categoryFeeds = [];
          for (OpmlOutline child in outline.children!) {
            if (child.xmlUrl != null) {
              CuratedFeed feed = CuratedFeed(title: child.title ?? "Unnamed feed", link: child.xmlUrl!);
              categoryFeeds.add(feed);
            }
          }

          // create the category and add it to the list of curated categories of feeds
          CuratedFeedCategory category = CuratedFeedCategory(
            name: categoryName,
            curatedFeeds: categoryFeeds,
          );
          curatedCategories.add(category);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    } finally {
      loading = false;
    }
  }
}
