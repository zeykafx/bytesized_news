import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/feed_sync/feed_sync.dart';
import 'package:bytesized_news/main.dart' show taskName;
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/opml/opml.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/keywords_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workmanager/workmanager.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Observer(builder: (context) {
        return SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: settingsStore.loading,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const GeneralSettings(),
                          // if (!Platform.isIOS) ...[
                          const BackgroundSyncSection(),
                          // ],
                          const ImportExportSection(),
                          const AboutSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return SettingsSection(
        title: "General",
        children: [
          // DARK MODE
          ListTile(
            title: const Text(
              "Dark Mode",
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SegmentedButton(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: darkModeNames
                    .map(
                      (option) => ButtonSegment(
                        value: option,
                        label: Text(
                          option,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                selected: {darkModeNames[settingsStore.darkMode.index]},
                onSelectionChanged: (selection) async {
                  settingsStore.setDarkMode(
                    DarkMode.values[darkModeNames.indexOf(selection.first)],
                  );
                },
              ),
            ),
          ),

          // USE READER MODE BY DEFAULT
          SwitchListTile(
            title: const Text(
              "Use Reader Mode by default",
            ),
            value: settingsStore.useReaderModeByDefault,
            onChanged: (value) {
              settingsStore.setUseReaderModeByDefault(value);
            },
          ),

          // SHOW AI SUMMARY ON STORY PAGE LOAD
          SwitchListTile(
            title: const Text(
              "Show Summary on page load",
            ),
            subtitle: authStore.userTier != Tier.premium ? Text("Available with premium") : null,
            value: authStore.userTier == Tier.premium ? settingsStore.showAiSummaryOnLoad : false,
            onChanged: authStore.userTier == Tier.premium
                ? (value) {
                    settingsStore.setShowAiSummaryOnLoad(value);
                  }
                : null,
          ),

          // FETCH AI SUMMARY ON STORY PAGE LOAD
          SwitchListTile(
            title: const Text(
              "Generate Summary on page load",
            ),
            subtitle: authStore.userTier != Tier.premium ? Text("Available with premium") : null,
            value: authStore.userTier == Tier.premium ? settingsStore.fetchAiSummaryOnLoad : false,
            onChanged: authStore.userTier == Tier.premium
                ? (value) {
                    settingsStore.setFetchAiSummaryOnLoad(value);
                  }
                : null,
          ),

          // Muted keywords
          KeywordsBottomSheet(
              title: "Mute title keywords from feed",
              getKeywords: () => settingsStore.mutedKeywords,
              additionCallback: (String text) {
                settingsStore.mutedKeywords = [
                  ...settingsStore.mutedKeywords,
                  text.toLowerCase(),
                ];
              },
              removalCallback: (int index) {
                settingsStore.mutedKeywords = [
                  ...settingsStore.mutedKeywords..removeAt(index),
                ];
              }),

          ListTile(
            title: Text("Delete articles older than"),
            trailing: DropdownButton(
                items: KeepArticlesLength.values.map((arLen) {
                  return DropdownMenuItem<String>(
                    value: keepArticlesLengthString(arLen),
                    child: Text(keepArticlesLengthString(arLen)),
                  );
                }).toList(),
                onChanged: (String? value) {
                  settingsStore.keepArticles = KeepArticlesLength.values[keepArticlesLengthValues.indexOf(value!)];
                },
                value: keepArticlesLengthString(settingsStore.keepArticles)),
          ),

          // Mark as Read On Scroll (toggle)
          SwitchListTile(
            title: const Text(
              "Mark as read on scroll",
            ),
            value: settingsStore.markAsReadOnScroll,
            onChanged: (value) {
              settingsStore.markAsReadOnScroll = value;
            },
          ),

          // Story tiles minimal mode
          SwitchListTile(
            title: const Text(
              "Minimal story tiles",
            ),
            value: settingsStore.storyTilesMinimalStyle,
            onChanged: (value) {
              settingsStore.storyTilesMinimalStyle = value;
            },
          ),
        ],
      );
    });
  }
}

class BackgroundSyncSection extends StatefulWidget {
  const BackgroundSyncSection({super.key});

  @override
  State<BackgroundSyncSection> createState() => _BackgroundSyncSectionState();
}

class _BackgroundSyncSectionState extends State<BackgroundSyncSection> {
  late final SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
  }

  Future<void> updateBackgroundTask() async {
    await Workmanager().cancelAll();
    // await Workmanager().cancelByUniqueName(taskName);

    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: settingsStore.backgroundFetchInterval.value,
      // initialDelay: Duration(minutes: 30),
      constraints: Constraints(
        // Connected or metered mark the task as requiring internet
        networkType: NetworkType.connected,
        requiresDeviceIdle: settingsStore.requireDeviceIdleForBgFetch,
        requiresBatteryNotLow: settingsStore.skipBgSyncOnLowBattery,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return SettingsSection(
        title: "Background Sync",
        children: [
          // background sync interval
          ListTile(
            title: Text("Background sync interval"),
            trailing: DropdownButton(
                items: BackgroundFetchInterval.values.map((bgSyncInt) {
                  return DropdownMenuItem<String>(
                    value: backgroundFetchIntervalString(bgSyncInt),
                    child: Text(backgroundFetchIntervalString(bgSyncInt)),
                  );
                }).toList(),
                onChanged: (String? value) {
                  settingsStore.backgroundFetchInterval = BackgroundFetchInterval.values[backgroundFetchIntervalValues.indexOf(value!)];
                  updateBackgroundTask();
                },
                value: backgroundFetchIntervalString(settingsStore.backgroundFetchInterval)),
          ),

          // Skip Background sync when low on battery (toggle)
          SwitchListTile(
            title: const Text(
              "Skip sync when low on battery",
            ),
            value: settingsStore.skipBgSyncOnLowBattery,
            onChanged: (value) {
              settingsStore.skipBgSyncOnLowBattery = value;
              updateBackgroundTask();
            },
          ),

          // Require device to be idle for bg sync (toggle)
          SwitchListTile(
            title: const Text(
              "Require device to be idle for background sync",
            ),
            value: settingsStore.requireDeviceIdleForBgFetch,
            onChanged: (value) {
              settingsStore.requireDeviceIdleForBgFetch = value;
              updateBackgroundTask();
            },
          ),
        ],
      );
    });
  }
}

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
    feedSync = FeedSync(isar: isar);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: "Import/Export",
      children: [
        // import OPML file
        ListTile(
          leading: const Icon(LucideIcons.import),
          title: const Text(
            "Import OPML file",
          ),
          onTap: () async {
            List<Feed> dbFeeds = await dbUtils.getFeeds();
            settingsStore.loading = true;

            // open file picker
            final FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ["opml", "xml"],
            );
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Nothing new to import!"),
                  ),
                );
                return;
              }

              List<Feed> loneFeeds = feeds.where((Feed feed) => feedGroups.every((FeedGroup feedGroup) => !feedGroup.feedUrls.contains(feed.link))).toList();

              // show dialog to confirm import, add the selected feeds to the db
              showDialog(
                  context: context,
                  builder: (context) {
                    List<Feed> selectedFeeds = List.of(loneFeeds);
                    List<FeedGroup> selectedFeedGroups = List.of(feedGroups);

                    return StatefulBuilder(builder: (context, dialogSetState) {
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
                                    dialogSetState(() {
                                      if (selectedFeedGroups.contains(feedGroup)) {
                                        selectedFeedGroups.remove(feedGroup);
                                      } else {
                                        selectedFeedGroups.add(feedGroup);
                                      }
                                    });
                                  },
                                  trailing: Checkbox(
                                    value: selectedFeedGroups.contains(feedGroup),
                                    onChanged: (value) {
                                      dialogSetState(() {
                                        if (value!) {
                                          selectedFeedGroups.add(feedGroup);
                                        } else {
                                          selectedFeedGroups.remove(feedGroup);
                                        }
                                      });
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
                                    dialogSetState(() {
                                      if (selectedFeeds.contains(feed)) {
                                        selectedFeeds.remove(feed);
                                      } else {
                                        selectedFeeds.add(feed);
                                      }
                                    });
                                  },
                                  trailing: Checkbox(
                                    value: selectedFeeds.contains(feed),
                                    onChanged: (value) {
                                      dialogSetState(() {
                                        if (value!) {
                                          selectedFeeds.add(feed);
                                        } else {
                                          selectedFeeds.remove(feed);
                                        }
                                      });
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

                              feedSync.updateFirestoreFeedsAndFeedGroups(authStore);

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Imported feeds from OPML file"),
                                ),
                              );
                            },
                            child: const Text("Import"),
                          ),
                        ],
                      );
                    });
                  });
            } else {
              settingsStore.loading = false;
            }
          },
        ),

        ListTile(
          leading: const Icon(LucideIcons.folder_input),
          title: const Text("Export feeds to OPML file"),
          onTap: () async {
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cancelled export."),
                ),
              );
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

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Exported feeds to OPML file"),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("Error loading package info");
          }
          return SettingsSection(
            title: "About",
            children: [
              ListTile(
                  leading: const Icon(LucideIcons.sparkles),
                  title: const Text(
                    "Bytesized News",
                  ),
                  subtitle: Text("Version: ${snapshot.data?.version}\nBuild: ${snapshot.data?.buildNumber}"),
                  trailing: const Text('View Licences'),
                  onTap: () {
                    showLicensePage(context: context);
                  }),
              ListTile(
                leading: const Icon(LucideIcons.github),
                title: const Text(
                  "Source Code",
                ),
                subtitle: const Wrap(
                  children: [
                    Text("You can find the source code of this app and the backend at "),
                    Text("github.com/zeykafx/bytesized_news", style: TextStyle(color: Colors.blue)),
                  ],
                ),
                onTap: () {
                  // open the paypal link
                  launchUrlString("https://github.com/zeykafx/bytesized_news");
                },
                trailing: const Icon(Icons.open_in_new),
              ),
              ListTile(
                leading: const Icon(Icons.laptop),
                title: const Text(
                  "Made by Corentin Detry",
                ),
                subtitle: const Wrap(
                  children: [
                    Text("If you like this app, you can support me at "),
                    Text("paypal.me/zeykafx", style: TextStyle(color: Colors.blue)),
                  ],
                ),
                onTap: () {
                  // open the paypal link
                  launchUrlString("https://paypal.me/zeykafx");
                },
                trailing: const Icon(Icons.open_in_new),
              ),
            ],
          );
        });
  }
}

// code from https://github.com/ReVanced/revanced-manager/blob/main/lib/ui/widgets/settingsView/settings_section.dart#L3

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 10.0, left: 20.0),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
  }
}
