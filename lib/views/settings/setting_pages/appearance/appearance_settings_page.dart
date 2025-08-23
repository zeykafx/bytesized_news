import 'package:bytesized_news/views/settings/setting_pages/appearance/appearance_settings_section.dart';
import 'package:bytesized_news/views/settings/shared/settings_page.dart';
import 'package:flutter/material.dart';

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(
        title: "Appearance",
        isMainView: false,
        sections: [
          const AppearanceSettingsSection(),
        ],
      ),
    );
  }
}
