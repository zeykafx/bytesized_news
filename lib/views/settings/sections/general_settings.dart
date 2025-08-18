import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/keywords_bottom_sheet.dart';
import 'package:bytesized_news/views/settings/settings_section.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "General",
          children: [
            // DARK MODE
            ListTile(
              title: const Text("Dark Mode"),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SegmentedButton(
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  segments: darkModeNames
                      .map(
                        (option) => ButtonSegment(
                          value: option,
                          label: Text(option, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  selected: {darkModeNames[settingsStore.darkMode.index]},
                  onSelectionChanged: (selection) async {
                    settingsStore.setDarkMode(DarkMode.values[darkModeNames.indexOf(selection.first)]);
                  },
                ),
              ),
            ),

            // USE READER MODE BY DEFAULT
            SwitchListTile(
              title: const Text("Use Reader Mode by default"),
              value: settingsStore.useReaderModeByDefault,
              onChanged: (value) {
                settingsStore.setUseReaderModeByDefault(value);
              },
            ),

            // Switch to webview if reader mode is too short
            SwitchListTile(
              title: const Text("Auto switch to webview if reader article is too short"),
              value: settingsStore.autoSwitchReaderTooShort,
              onChanged: (value) {
                settingsStore.autoSwitchReaderTooShort = value;
              },
            ),

            // SHOW AI SUMMARY ON STORY PAGE LOAD
            SwitchListTile(
              title: const Text("Show Summary on page load"),
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
              title: const Text("Generate Summary on page load"),
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
                settingsStore.mutedKeywords = [...settingsStore.mutedKeywords, text.toLowerCase()];
              },
              removalCallback: (int index) {
                settingsStore.mutedKeywords = [...settingsStore.mutedKeywords..removeAt(index)];
              },
            ),

            ListTile(
              title: Text("Delete articles older than"),
              trailing: DropdownButton(
                items: KeepArticlesLength.values.map((arLen) {
                  return DropdownMenuItem<String>(value: keepArticlesLengthString(arLen), child: Text(keepArticlesLengthString(arLen)));
                }).toList(),
                onChanged: (String? value) {
                  settingsStore.keepArticles = KeepArticlesLength.values[keepArticlesLengthValues.indexOf(value!)];
                },
                value: keepArticlesLengthString(settingsStore.keepArticles),
              ),
            ),

            // Mark as Read On Scroll (toggle)
            SwitchListTile(
              title: const Text("Mark as read on scroll"),
              value: settingsStore.markAsReadOnScroll,
              onChanged: (value) {
                settingsStore.markAsReadOnScroll = value;
              },
            ),

            // Story tiles minimal mode
            SwitchListTile(
              title: const Text("Minimal story tiles"),
              value: settingsStore.storyTilesMinimalStyle,
              onChanged: (value) {
                settingsStore.storyTilesMinimalStyle = value;
              },
            ),
          ],
        );
      },
    );
  }
}
