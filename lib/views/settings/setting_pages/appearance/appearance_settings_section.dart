import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsSection extends StatefulWidget {
  const AppearanceSettingsSection({super.key});

  @override
  State<AppearanceSettingsSection> createState() => _AppearanceSettingsSectionState();
}

class _AppearanceSettingsSectionState extends State<AppearanceSettingsSection> {
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
          title: "Look & Feed",
          onlySection: true,
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

            Text('TODO: color stuff'),
          ],
        );
      },
    );
  }
}
