import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ReaderModeSection extends StatefulWidget {
  const ReaderModeSection({super.key});

  @override
  State<ReaderModeSection> createState() => _ReaderModeSectionState();
}

class _ReaderModeSectionState extends State<ReaderModeSection> {
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
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "Reader Mode",
          onlySection: false,
          children: [
            // Download read articles
            SwitchListTile(
              title: const Text("Download read articles"),
              subtitle: const Text("Save text & images for offline reading after opening the reader mode"),

              value: settingsStore.downloadReadPosts,
              onChanged: (value) {
                settingsStore.downloadReadPosts = value;
              },
            ),

            // USE READER MODE BY DEFAULT
            SwitchListTile(
              title: const Text("Use Reader Mode by default"),
              subtitle: const Text("Text only version of the article"),

              value: settingsStore.useReaderModeByDefault,
              onChanged: (value) {
                settingsStore.setUseReaderModeByDefault(value);
              },
            ),

            // Switch to webview if reader mode is too short
            SwitchListTile(
              title: const Text("Auto switch to web page"),
              subtitle: const Text("if reader article is too short"),
              value: settingsStore.autoSwitchReaderTooShort,
              onChanged: (value) {
                settingsStore.autoSwitchReaderTooShort = value;
              },
            ),

            // Show share button in bar
            SwitchListTile(
              title: const Text("Show Share button in bar"),
              value: settingsStore.showShareButton,
              onChanged: (value) {
                settingsStore.showShareButton = value;
              },
            ),

            SwitchListTile(
              title: const Text("Show Comments button in bar"),
              subtitle: const Text("Opens the comments web page (if available)"),
              value: settingsStore.showCommentsButton,
              onChanged: (value) {
                settingsStore.showCommentsButton = value;
              },
            ),

            // Always show the archive button
            SwitchListTile(
              title: const Text("Always show archive.org button"),
              subtitle: Text(
                "Bypass more bot protections & paywalls. ${settingsStore.alwaysShowArchiveButton ? "Enabled: button will always shown in the bar" : "Disabled: will be shown only when a paywall is detected"}",
              ),
              value: settingsStore.alwaysShowArchiveButton,
              onChanged: (value) {
                settingsStore.alwaysShowArchiveButton = value;
              },
            ),
          ],
        );
      },
    );
  }
}
