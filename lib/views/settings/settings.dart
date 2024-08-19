import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GeneralSettings(),
                AboutSection(),
              ],
            ),
          ),
        ),
      ),
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
