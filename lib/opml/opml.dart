import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:isar/isar.dart';
import 'package:opml/opml.dart';

class OpmlUtils {
  Future<(List<Feed>, List<FeedGroup>)> getFeedsFromOpmlFile(String fileContent) async {
    List<Feed> feeds = [];
    List<FeedGroup> feedGroups = [];

    OpmlDocument opml = OpmlDocument.parse(fileContent);
    for (OpmlOutline outline in opml.body) {
      // handle groups
      if (outline.children != null && outline.children!.isNotEmpty) {
        String groupName = "";
        if (outline.text != null) {
          groupName = outline.text!;
        } else if (outline.title != null) {
          groupName = outline.title!;
        }

        FeedGroup feedGroup = FeedGroup(groupName);

        for (OpmlOutline child in outline.children!) {
          if (child.xmlUrl != null) {
            Feed feed = await Feed.createFeed(child.xmlUrl!, feedName: child.text ?? "");
            feeds.add(feed);
            feedGroup.feedNames = feedGroup.feedNames + [feed.name];
            feedGroup.feeds.add(feed);
          }
        }

        feedGroups.add(feedGroup);
      }

      // handle feeds that are not in a group
      if (outline.xmlUrl != null) {
        Feed feed = await Feed.createFeed(outline.xmlUrl!, feedName: outline.text ?? "");
        feeds.add(feed);
      }
    }

    return (feeds, feedGroups);
  }

  Future<String> exportToFile() async {
    Isar isar = Isar.getInstance()!;
    DbUtils dbUtils = DbUtils(isar: isar);
    List<Feed> feeds = await dbUtils.getFeeds();
    List<FeedGroup> feedGroups = await dbUtils.getFeedGroups(feeds);

    final OpmlHead head = OpmlHeadBuilder().title('Bytesized News Export').build();
    final List<OpmlOutline> body = <OpmlOutline>[];

    for (FeedGroup feedGroup in feedGroups) {
      OpmlOutlineBuilder outlineBuilder = OpmlOutlineBuilder().text(feedGroup.name).title(feedGroup.name);

      for (Feed feed in feedGroup.feeds) {
        outlineBuilder.addChild(
          OpmlOutlineBuilder().type("rss").text(feed.name).title(feed.name).xmlUrl(feed.link).build(),
        );
      }
      body.add(
        outlineBuilder.build(),
      );
    }

    // add feeds that are not in a group
    for (Feed feed in feeds) {
      if (feedGroups.every((element) => !element.feedNames.contains(feed.name))) {
        body.add(
          OpmlOutlineBuilder().type("rss").text(feed.name).title(feed.name).xmlUrl(feed.link).build(),
        );
      }
    }

    final OpmlDocument opml = OpmlDocument(
      head: head,
      body: body,
    );

    final String xml = opml.toXmlString(pretty: true);
    return xml;
  }
}
