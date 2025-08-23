import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/sections/settings_section.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
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
          children: [
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
          ],
        );
      },
    );
  }
}
