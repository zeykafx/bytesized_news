import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/widgets/custom_provider_settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AiSection extends StatefulWidget {
  const AiSection({super.key});

  @override
  State<AiSection> createState() => _AiSectionState();
}

class _AiSectionState extends State<AiSection> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;
  final BorderRadius borderRadius = BorderRadius.circular(12);
  ExpansibleController expansibleController = ExpansibleController();

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
        bool aiEnabled = (authStore.userTier == Tier.premium) || settingsStore.enableCustomAiProvider;
        return SettingsSection(
          title: "Artificial Intelligence",
          onlySection: false,
          children: [
            // suggest articles
            SwitchListTile(
              title: const Text("Suggest articles"),
              subtitle: Text(
                "Suggest unread articles from the past day based on your preferences. Suggestions are fetched every 10 minutes after fetching new articles",
              ),
              value: aiEnabled ? settingsStore.suggestionEnabled : false,
              onChanged: aiEnabled
                  ? (value) {
                      settingsStore.suggestionEnabled = value;
                    }
                  : null,
            ),

            // SHOW AI SUMMARY ON STORY PAGE LOAD
            SwitchListTile(
              title: const Text("Show Summary on page load"),
              subtitle: !aiEnabled ? Text("Available with premium") : null,
              value: aiEnabled ? settingsStore.showAiSummaryOnLoad : false,
              onChanged: aiEnabled
                  ? (value) {
                      settingsStore.setShowAiSummaryOnLoad(value);
                    }
                  : null,
            ),

            // FETCH AI SUMMARY ON STORY PAGE LOAD
            SwitchListTile(
              title: const Text("Generate Summary on page load"),
              subtitle: !aiEnabled ? Text("Available with premium") : null,
              value: aiEnabled ? settingsStore.fetchAiSummaryOnLoad : false,
              onChanged: aiEnabled
                  ? (value) {
                      settingsStore.setFetchAiSummaryOnLoad(value);
                    }
                  : null,
            ),

            ListTile(
              title: const Text("Summary length (in paragraphs)"),
              subtitle: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    SizedBox(width: 35, child: Text(settingsStore.summaryLength.toStringAsFixed(0))),
                    Expanded(
                      child: Slider(
                        year2023: false,
                        label: settingsStore.summaryLength.toStringAsFixed(0),
                        value: settingsStore.summaryLength.toDouble(),
                        min: 1.0,
                        max: 4.0,
                        divisions: 3,
                        onChanged: (newVal) {
                          settingsStore.summaryLength = newVal.toInt();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BYOK settings
            ExpansionTile(
              enableFeedback: true,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 12, top: 0),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              initiallyExpanded: settingsStore.enableCustomAiProvider,
              showTrailingIcon: false,
              title: SwitchListTile(
                title: const Text("Use a custom AI Provider"),
                subtitle: Text("Bring your own API key"),
                value: settingsStore.enableCustomAiProvider,
                onChanged: (value) {
                  settingsStore.enableCustomAiProvider = value;
                  if (value) {
                    expansibleController.expand();
                  } else {
                    expansibleController.collapse();
                  }
                },
              ),
              controller: expansibleController,
              children: [
                CustomProviderSettings(),
              ],
            ),
          ],
        );
      },
    );
  }
}
