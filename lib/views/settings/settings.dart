import 'dart:typed_data';

import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/opml/opml.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GeneralSettings(),
                        ImportExportSection(),
                        AboutSection(),
                      ],
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

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
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
          ListTile(
            title: const Text(
              "Use Reader Mode by Default",
            ),
            trailing: Switch(
              value: settingsStore.useReaderModeByDefault,
              onChanged: (value) {
                settingsStore.setUseReaderModeByDefault(value);
              },
            ),
          ),

          // SHOW AI SUMMARY ON WEB PAGE LOAD
          ListTile(
            title: const Text(
              "Show AI Summary on Web Page Load",
            ),
            trailing: Switch(
              value: settingsStore.showAiSummaryOnLoad,
              onChanged: (value) {
                settingsStore.setShowAiSummaryOnLoad(value);
              },
            ),
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

  Isar isar = Isar.getInstance()!;
  late DbUtils dbUtils;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    dbUtils = DbUtils(isar: isar);
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
            settingsStore.loading = true;

            // open file picker
            final FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ["opml", "xml"],
            );
            if (result != null) {
              String fileContent = await result.files.first.xFile.readAsString();
              // get feeds from opml file
              var (List<Feed> feeds, List<FeedGroup> feedGroups) = await OpmlUtils().getFeedsFromOpmlFile(fileContent);

              settingsStore.loading = false;
              if (kDebugMode) {
                print("Importing feeds: ${feeds.map((el) => el.name)}");
              }

              List<Feed> loneFeeds = feeds.where((Feed feed) => feedGroups.every((FeedGroup feedGroup) => !feedGroup.feedNames.contains(feed.name))).toList();

              // show dialog to confirm import, add the selected feeds to the db
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Import OPML file"),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Do you want to import ${feeds.length} feeds?"),
                              const SizedBox(height: 5),
                              ...feedGroups.map((feedGroup) => ListTile(
                                    title: Text("Group: ${feedGroup.name}"),
                                    subtitle: Text(feedGroup.feedNames.join(", ")),
                                  )),
                              // feeds that are not in a group
                              ...loneFeeds.map((feed) => ListTile(
                                    title: Text("Feed: ${feed.name}"),
                                  )),
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
                            onPressed: () {
                              for (Feed feed in feeds) {
                                dbUtils.addFeed(feed);
                              }
                              for (FeedGroup feedGroup in feedGroups) {
                                dbUtils.addFeedGroup(feedGroup);
                              }

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
                      ));
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

            if (!await FlutterFileDialog.isPickDirectorySupported()) {
              throw Exception("Pick directory is not supported on this platform");
            }

            final DirectoryLocation? pickedDirectory = await FlutterFileDialog.pickDirectory();

            if (pickedDirectory != null) {
              final filePath = await FlutterFileDialog.saveFileToDirectory(
                directory: pickedDirectory,
                data: Uint8List.fromList(xml.codeUnits),
                mimeType: "text/xml",
                fileName: "bytesized_news_export.xml",
                replace: true,
              );
            }

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
                title: const Text(
                  "Bytesized News",
                ),
                subtitle: Text("Version: ${snapshot.data?.version}\nBuild: ${snapshot.data?.buildNumber}"),
              ),
              ListTile(
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
