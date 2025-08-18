import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/feed_sync/feed_sync.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/opml/opml.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_section.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

class ImportExportSection extends StatefulWidget {
  const ImportExportSection({super.key});

  @override
  State<ImportExportSection> createState() => _ImportExportSectionState();
}

class _ImportExportSectionState extends State<ImportExportSection> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;

  Isar isar = Isar.getInstance()!;
  late DbUtils dbUtils;
  late FeedSync feedSync;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
    dbUtils = DbUtils(isar: isar);
    feedSync = FeedSync(isar: isar, authStore: authStore);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: "Import/Export",
      children: [
        // import OPML file
        ListTile(
          leading: const Icon(LucideIcons.import),
          title: const Text("Import OPML file"),
          onTap: () async {
            List<Feed> dbFeeds = await dbUtils.getFeeds();
            settingsStore.loading = true;

            // open file picker
            final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["opml", "xml"]);
            if (result != null && result.files.isNotEmpty) {
              String fileContent = await result.files.first.xFile.readAsString();
              // get feeds from opml file
              var (List<Feed> feeds, List<FeedGroup> feedGroups) = await OpmlUtils().getFeedsFromOpmlFile(fileContent);

              settingsStore.loading = false;
              if (kDebugMode) {
                print("Importing feeds: ${feeds.map((el) => el.name)}");
              }

              // filter out feeds that are already imported
              feeds.removeWhere((Feed feed1) {
                return dbFeeds.where((Feed feed2) => feed1.link == feed2.link).isNotEmpty;
              });

              // filter out feedGroups with no new feeds
              feedGroups.removeWhere((FeedGroup feedGroup) {
                return feedGroup.feedUrls.every((feedUrl) => dbFeeds.any((feed) => feed.link == feedUrl));
              });

              // filter out feedgroups that already exist in the db
              feedGroups.removeWhere((FeedGroup feedGroup) {
                return dbFeeds.any((feed) => feedGroups.any((fg) => fg.name == feedGroup.name && fg.feedUrls.contains(feed.link)));
              });

              if (feeds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nothing new to import!")));
                return;
              }

              List<Feed> loneFeeds = feeds.where((Feed feed) => feedGroups.every((FeedGroup feedGroup) => !feedGroup.feedUrls.contains(feed.link))).toList();

              // show dialog to confirm import, add the selected feeds to the db
              showDialog(
                context: context,
                builder: (context) {
                  List<Feed> selectedFeeds = List.of(loneFeeds);
                  List<FeedGroup> selectedFeedGroups = List.of(feedGroups);

                  return StatefulBuilder(
                    builder: (context, dialogSetState) {
                      return AlertDialog(
                        title: const Text("Import OPML file"),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Do you want to import ${feeds.length} feeds?"),
                              const SizedBox(height: 5),
                              ...feedGroups.map(
                                (feedGroup) => ListTile(
                                  title: Text("Group: ${feedGroup.name}"),
                                  subtitle: Text(feedGroup.feeds.map((locFeed) => locFeed.name).join(", ")),
                                  selected: selectedFeedGroups.contains(feedGroup),
                                  onTap: () {
                                    listTileOnTap(dialogSetState, selectedFeedGroups, feedGroup);
                                  },
                                  trailing: Checkbox(
                                    value: selectedFeedGroups.contains(feedGroup),
                                    onChanged: (value) {
                                      listTileCheckboxOnChanged(dialogSetState, value, selectedFeedGroups, feedGroup);
                                    },
                                  ),
                                ),
                              ),

                              // feeds that are not in a group
                              ...loneFeeds.map(
                                (feed) => ListTile(
                                  title: Text("Feed: ${feed.name}"),
                                  selected: selectedFeeds.contains(feed),
                                  onTap: () {
                                    loneFeedOnTap(dialogSetState, selectedFeeds, feed);
                                  },
                                  trailing: Checkbox(
                                    value: selectedFeeds.contains(feed),
                                    onChanged: (value) {
                                      loneFeedCheckboxOnChanged(dialogSetState, value, selectedFeeds, feed);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await doImport(selectedFeeds, selectedFeedGroups, feeds, context);
                            },
                            child: const Text("Import"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            } else {
              settingsStore.loading = false;
            }
          },
        ),

        ListTile(
          leading: const Icon(LucideIcons.folder_input),
          title: const Text("Export feeds to OPML file"),
          onTap: () async {
            await doExport(context);
          },
        ),
      ],
    );
  }

  Future<void> doExport(BuildContext context) async {
    String xml = await OpmlUtils().exportToFile();

    // if (!await FlutterFileDialog.isPickDirectorySupported()) {
    //   throw Exception("Pick directory is not supported on this platform");
    // }

    // final DirectoryLocation? pickedDirectory = await FlutterFileDialog.pickDirectory();
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'bytesized_news_export.xml',
      type: FileType.custom,
      allowedExtensions: [".xml", ".opml"],
      bytes: Uint8List.fromList(xml.codeUnits),
    );

    if (outputFile == null) {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cancelled export.")));
    }
    // if (pickedDirectory != null) {
    //   await FlutterFileDialog.saveFileToDirectory(
    //     directory: pickedDirectory,
    //     data: Uint8List.fromList(xml.codeUnits),
    //     mimeType: "text/xml",
    //     fileName: "bytesized_news_export.xml",
    //     replace: true,
    //   );
    // }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Exported feeds to OPML file")));
  }

  Future<void> doImport(List<Feed> selectedFeeds, List<FeedGroup> selectedFeedGroups, List<Feed> feeds, BuildContext context) async {
    for (Feed feed in selectedFeeds) {
      await dbUtils.addFeed(feed);
    }
    for (FeedGroup feedGroup in selectedFeedGroups) {
      // add the feeds for the feedGroup
      for (String feedUrl in feedGroup.feedUrls) {
        Feed feed = feeds.firstWhere((feed) => feed.link == feedUrl);
        await dbUtils.addFeed(feed);
      }

      await dbUtils.addFeedGroup(feedGroup);
    }

    feedSync.updateFirestoreFeedsAndFeedGroups();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Imported feeds from OPML file")));
  }

  void loneFeedCheckboxOnChanged(StateSetter dialogSetState, bool? value, List<Feed> selectedFeeds, Feed feed) {
    dialogSetState(() {
      if (value!) {
        selectedFeeds.add(feed);
      } else {
        selectedFeeds.remove(feed);
      }
    });
  }

  void loneFeedOnTap(StateSetter dialogSetState, List<Feed> selectedFeeds, Feed feed) {
    dialogSetState(() {
      if (selectedFeeds.contains(feed)) {
        selectedFeeds.remove(feed);
      } else {
        selectedFeeds.add(feed);
      }
    });
  }

  void listTileCheckboxOnChanged(StateSetter dialogSetState, bool? value, List<FeedGroup> selectedFeedGroups, FeedGroup feedGroup) {
    dialogSetState(() {
      if (value!) {
        selectedFeedGroups.add(feedGroup);
      } else {
        selectedFeedGroups.remove(feedGroup);
      }
    });
  }

  void listTileOnTap(StateSetter dialogSetState, List<FeedGroup> selectedFeedGroups, FeedGroup feedGroup) {
    dialogSetState(() {
      if (selectedFeedGroups.contains(feedGroup)) {
        selectedFeedGroups.remove(feedGroup);
      } else {
        selectedFeedGroups.add(feedGroup);
      }
    });
  }
}
