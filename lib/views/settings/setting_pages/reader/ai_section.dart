import 'package:bytesized_news/views/auth/auth_store.dart';
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
        return SettingsSection(
          title: "Artificial Intelligence",
          onlySection: false,
          children: [
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
                Text("AI PROVIDER SETTINGS"),
              ],
            ),
          ],
        );
      },
    );
  }
}
