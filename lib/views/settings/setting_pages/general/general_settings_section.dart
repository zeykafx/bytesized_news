import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/keywords_bottom_sheet.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

class GeneralSettingsSection extends StatefulWidget {
  const GeneralSettingsSection({super.key});

  @override
  State<GeneralSettingsSection> createState() => _GeneralSettingsSectionState();
}

class _GeneralSettingsSectionState extends State<GeneralSettingsSection> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;
  late DbUtils dbUtils;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
    dbUtils = DbUtils(isar: Isar.getInstance()!);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "Feed",
          onlySection: false,
          children: [
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
